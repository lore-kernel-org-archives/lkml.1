Return-Path: <linux-kernel-owner+w=401wt.eu-S932091AbZDHPXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbZDHPXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 11:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbZDHPXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 11:23:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53839 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbZDHPXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 11:23:40 -0400
Subject: Re: Cached IO Synchronization Question
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Klein <matt.klein@pikewerks.com>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <49DA7498.3050000@pikewerks.com>
References: <49DA7498.3050000@pikewerks.com>
Content-Type: text/plain
Date: Wed, 08 Apr 2009 17:23:37 +0200
Message-Id: <1239204217.4557.2590.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-06 at 14:31 -0700, Matt Klein wrote:
> (Please CC me on any responses)
> 
> Hi,
> 
> I am studying 2.6.27.21 to try to understand the IO synchronization
> model used in the Linux kernel.
> 
> I have the following question:
> 
> How are cached reads/writes synchronized? I assume they are, but I can
> not determine how it is done.
> 
> 1) do_generic_file_read calls find_get_page to get the existing page
> cache page if it exists (it uses RCU to prevent the page from being
> blown away while reading takes place). Assuming it does, it performs
> various checks to make sure the page is up to date before performing an
> atomic copy to user mode. The read path does not take the page lock.
> 
> 2) The write path takes both the inode lock and the page lock to prevent
> multiple writers. It also does an atomic copy from user mode into the
> page cache page.
> 
> From my reading of the code, the atomic copies are atomic only on a
> single processor, not across processors. Right?

Not even that ;-)

> If so, what is to prevent one CPU from starting a cached read into a
> user mode buffer while another CPU has partially copied data into the
> page cache page?

Note how do_generic_file_read() checks PageUptodate() and does a
lock_page_killable() in case its not.



