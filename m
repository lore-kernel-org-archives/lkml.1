Return-Path: <linux-kernel-owner+w=401wt.eu-S1752142AbYEEMX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbYEEMX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 08:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751413AbYEEMXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 08:23:18 -0400
Received: from mail.suse.de ([195.135.220.2]:57179 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbYEEMXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 08:23:18 -0400
Date: Mon, 5 May 2008 14:23:16 +0200
From: Nick Piggin <npiggin@suse.de>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, mk <michael.kerrisk@gmail.com>
Subject: Re: MAP_POPULATE behavior change?
Message-ID: <20080505122316.GE5018@wotan.suse.de>
References: <4815BDF5.9070506@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4815BDF5.9070506@gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 02:07:17PM +0200, Michael Kerrisk wrote:
> Hey Nick,
> 
> Ping!
> 
> Cheers,
> 
> Michael
> 
> 
> -------- Original Message --------
> Subject: MAP_POPULATE behavior change?
> Date: Tue, 22 Apr 2008 15:16:19 +0200
> From: Michael Kerrisk <mtk.manpages@gmail.com>
> To: Nick Piggin <npiggin@suse.de>
> CC: lkml <linux-kernel@vger.kernel.org>, mk <michael.kerrisk@gmail.com>
> 
> Hi Nick,
> 
> In 2.6.23, you had the commit below, which seems to have changed the
> kernel-userland API.
> 
> Am I right to understand that with this patch MAP_POPULATE now also works with
> MAP_PRIVATE mappings?  (Formerly it only worked with MAP_SHARED mappings, but
> some very quick testing suggests that MAP_POPULATE now also has an affect for
> MAP_PRIVATE.)

Yeah it should also set up anonymous mappings. Very observant :)

 
> Also, can you summarize the status of MAP_NONBLOCK?  Is it now a no-op?

Yes, it is. The problem is you need to walk the page tables, and it
is fairly annoying to have to make a special case for that to be
non blocking (after just getting rid of the ->populate special case).

It is possible of course to implement. It might even be easier because
you could pass in a NONBLOCK flag to ->fault from get_user_pages... but
for now it is a noop.

Thanks,
Nick

> 
> Cheers,
> 
> Michael
> 
> ==
> 
> commit 54cb8821de07f2ffcd28c380ce9b93d5784b40d7
> Author: Nick Piggin <npiggin@suse.de>
> Date:   Thu Jul 19 01:46:59 2007 -0700
> 
>     mm: merge populate and nopage into fault (fixes nonlinear)
> 
>     Nonlinear mappings are (AFAIKS) simply a virtual memory concept that encodes
>     the virtual address -> file offset differently from linear mappings.
> 
>     ->populate is a layering violation because the filesystem/pagecache code
>     should need to know anything about the virtual memory mapping.  The hitch here
>     is that the ->nopage handler didn't pass down enough information (ie.  pgoff).
>      But it is more logical to pass pgoff rather than have the ->nopage function
>     calculate it itself anyway (because that's a similar layering violation).
> 
>     Having the populate handler install the pte itself is likewise a nasty thing
>     to be doing.
> 
>     This patch introduces a new fault handler that replaces ->nopage and
>     ->populate and (later) ->nopfn.  Most of the old mechanism is still in place
>     so there is a lot of duplication and nice cleanups that can be removed if
>     everyone switches over.
> 
>     The rationale for doing this in the first place is that nonlinear mappings are
>     subject to the pagefault vs invalidate/truncate race too, and it seemed stupid
>     to duplicate the synchronisation logic rather than just consolidate the two.
> 
>     After this patch, MAP_NONBLOCK no longer sets up ptes for pages present in
>     pagecache.  Seems like a fringe functionality anyway.
> 
>     NOPAGE_REFAULT is removed.  This should be implemented with ->fault, and no
>     users have hit mainline yet.
> 
> 
> 
> 
> -- 
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
> 
