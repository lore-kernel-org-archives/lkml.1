Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbYJEWdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbYJEWdW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 18:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755170AbYJEWdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 18:33:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:57095 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085AbYJEWdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 18:33:14 -0400
Date: Sun, 5 Oct 2008 15:33:06 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       agk@redhat.com, mbroz@redhat.com, chris@arachsys.com
Subject: Re: [PATCH 2/3] Fix fsync livelock
Message-ID: <20081005153306.7e644c9f@infradead.org>
In-Reply-To: <Pine.LNX.4.64.0810051814060.23248@hs20-bc2-1.build.redhat.com>
References: <20080911101616.GA24064@agk.fab.redhat.com>
	<Pine.LNX.4.64.0809221705480.15511@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0809231817390.11559@hs20-bc2-1.build.redhat.com>
	<20080923154905.50d4b0fa.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0809231902010.19496@hs20-bc2-1.build.redhat.com>
	<20080923164623.ce82c1c2.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0809241451320.18811@hs20-bc2-1.build.redhat.com>
	<20081001225404.4e973465.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0810051814060.23248@hs20-bc2-1.build.redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Oct 2008 18:14:50 -0400 (EDT)
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Fix starvation in memory management.
> 
> The bug happens when one process is doing sequential buffered writes
> to a block device (or file) and another process is attempting to
> execute sync(), fsync() or direct-IO on that device (or file). This
> syncing process will wait indefinitelly, until the first writing
> process finishes.
> 
> For example, run these two commands:
> dd if=/dev/zero of=/dev/sda1 bs=65536 &
> dd if=/dev/sda1 of=/dev/null bs=4096 count=1 iflag=direct
> 
> The bug is caused by sequential walking of address space in
> write_cache_pages and wait_on_page_writeback_range: if some other
> process is constantly making dirty and writeback pages while these
> functions run, the functions will wait on every new page, resulting in
> indefinite wait.

are you sure?
isn't the right fix to just walk the file pages only once?
