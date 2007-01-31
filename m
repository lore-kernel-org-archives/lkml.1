Return-Path: <linux-kernel-owner+w=401wt.eu-S1752119AbXAaAcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbXAaAcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 19:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbXAaAcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 19:32:18 -0500
Received: from ns.suse.de ([195.135.220.2]:50565 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096AbXAaAcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 19:32:17 -0500
Date: Wed, 31 Jan 2007 01:32:16 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@osdl.org>
Cc: Hugh Dickins <hugh@veritas.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
Subject: Re: [patch 0/9] buffered write deadlock fix
Message-ID: <20070131003215.GA7163@wotan.suse.de>
References: <20070129081905.23584.97878.sendpatchset@linux.site> <20070130125558.ae9119b0.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070130125558.ae9119b0.akpm@osdl.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 12:55:58PM -0800, Andrew Morton wrote:
> On Mon, 29 Jan 2007 11:31:37 +0100 (CET)
> Nick Piggin <npiggin@suse.de> wrote:
> 
> > The following set of patches attempt to fix the buffered write
> > locking problems 
> 
> y'know, four or five years back I fixed this bug by doing
> 
> 	current->locked_page = page;
> 
> in the write() code, and then teaching the pagefault code to avoid locking
> the same page.  Patch below.
> 
> But then evil mean Hugh pointed out that the patch is still vulnerable to
> ab/ba deadlocking so I dropped it.
> 
> But Hugh lied!  There is no ab/ba deadlock because both a and b need
> i_mutex to get into the write() path.

Not only is there still the abba deadlock on page locks, as you point
out in your next mail, but there is also an abba on page lock vs mmap_sem.

> This approach doesn't fix the writev() performance regresson which
> nobody has measured yet but which the NFS guys reported.
> 
> But I think with this fix in place we can go back to a modified version of
> the 2.6.17 filemap.c code and get that performance back, but I haven't
> thought about that.
> 
> It's a heck of a lot simpler than your patches though ;)

Ignoring the cleanup patches, the only thing mine really do is to use
get_user_pages in  generic_file_buffered_write if the destination page
is not uptodate, and use atomic copies if it is. Conceptually pretty simple.

Mine fixes the writev performance regression iff the destination page
it uptodate. More importantly, they fix 3 deadlocks in the core mm.
