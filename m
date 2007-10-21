Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540AbXJUUzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbXJUUzu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 16:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbXJUUzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 16:55:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45187 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751385AbXJUUzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 16:55:43 -0400
Date: Sun, 21 Oct 2007 13:55:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Artem.Bityutskiy@nokia.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: forcing write-back from FS - again
Message-Id: <20071021135526.57db7519.akpm@linux-foundation.org>
In-Reply-To: <471BB45D.8070509@nokia.com>
References: <471BB45D.8070509@nokia.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Oct 2007 23:19:41 +0300 Artem Bityutskiy <Artem.Bityutskiy@nokia.com> wrote:

> Hi Andrew,
> 
> some time ago we were talking about doing write-back from inside a file-system 
> (http://marc.info/?l=linux-kernel&m=119097117713616&w=2). You said that I'm not 
> the only person who needs this, because the same thing is needed for delayed 
> allocation.
> 
> The problem is that if we initiate write-back from prepare_write() and we are 
> having a dirty page lock, we deadlock in write_cache_pages() which tries to 
> lock the same page.
> 
> You suggested to enhance struct writeback_control and put page that should be 
> skipped.
> 
> ...
>
> but it does not dot actually work, because if we have two processes forcing 
> write-back from write_page(), they will mutually deadlock (A waits in 
> write_cache_pages() on a page B has locked, B waits on inode or page A has locked).

Yeah, I was just thinking that as I read this ;)
 
> So this way is not ok, do you have any other ideas?
> 
> We could mark page clean temporarily before doing write-back, and mark it dirty 
> again, but this seems to be inefficient (although I'm not sure, need to dig 
> these functions deeper, but they _seem_ to traverse the radix tree and change 
> tags, so marking one page dirty may need to change many tags, but again, I did 
> not really dig tis yet).
> 
> I'd appreciate any suggestions. Thanks!

We could just skip locked pages altogether in writeback.  Perhaps in
WB_SYNC_NONE mode, or perhaps add a new flag in writeback_control to select
this behaviour.

It _should_ be the case that the number of locked-and-dirty pages which
writeback encounters is very small, so skipping locked pages during
writeback-for-memory-flushing won't have any significant effect.  The first
step should be to add a new /proc/vmstat field to count these pages and
then do broad testing (especially on blocksize<pagesize filesystems) to
confirm the theory.

We'll still need to synchronously lock the page in
writeback-for-data-integrity mode though.

