Return-Path: <linux-kernel-owner+w=401wt.eu-S1758672AbYEEMmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672AbYEEMmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 08:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbYEEMmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 08:42:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:36769 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbYEEMmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 08:42:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BtgeAJoqSs4sWBtsQGcFx7QCZpFELshI4EylBBJdvVlj/+YT0dLZ3ISU1AMd6eEMp9Ggx2IGZrH7Bgz+GaJiI3WT0yS1ybtKJ8pb7XFf4WRTLhG5/GIpkdB3WNEG7W1OsJF0nUmLBsEgxqOoXsZTg7bmWa2R3KZOb7basRPIjhY=
Message-ID: <cfd18e0f0805050542w20bee7f5v8b6125c8b399e63b@mail.gmail.com>
Date: Mon, 5 May 2008 14:42:44 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Nick Piggin" <npiggin@suse.de>
Subject: Re: MAP_POPULATE behavior change?
Cc: lkml <linux-kernel@vger.kernel.org>, mk <michael.kerrisk@gmail.com>
In-Reply-To: <20080505122316.GE5018@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4815BDF5.9070506@gmail.com> <20080505122316.GE5018@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Mon, May 5, 2008 at 2:23 PM, Nick Piggin <npiggin@suse.de> wrote:
> On Mon, Apr 28, 2008 at 02:07:17PM +0200, Michael Kerrisk wrote:

> > In 2.6.23, you had the commit below, which seems to have changed the
> > kernel-userland API.
> >
> > Am I right to understand that with this patch MAP_POPULATE now also works with
> > MAP_PRIVATE mappings?  (Formerly it only worked with MAP_SHARED mappings, but
> > some very quick testing suggests that MAP_POPULATE now also has an affect for
> > MAP_PRIVATE.)
>
> Yeah it should also set up anonymous mappings. Very observant :)

Umm -- did it not work for anonymous *shared* mappings before?  I
understood that it did.

> > Also, can you summarize the status of MAP_NONBLOCK?  Is it now a no-op?
>
> Yes, it is.

Hmm -- going back and re-reading the code, there is:

        if ((flags & MAP_POPULATE) && !(flags & MAP_NONBLOCK))
                make_pages_present(addr, addr + len);

That means that MAP_NONBLOCK makes *MAP_POPULATE* a no-op.  Was that intended?

Cheers,

Michael

> The problem is you need to walk the page tables, and it
> is fairly annoying to have to make a special case for that to be
> non blocking (after just getting rid of the ->populate special case).
>
> It is possible of course to implement. It might even be easier because
> you could pass in a NONBLOCK flag to ->fault from get_user_pages... but
> for now it is a noop.
>
> Thanks,
> Nick
>
>
> >
> > Cheers,
> >
> > Michael
> >
> > ==
> >
> > commit 54cb8821de07f2ffcd28c380ce9b93d5784b40d7
> > Author: Nick Piggin <npiggin@suse.de>
> > Date:   Thu Jul 19 01:46:59 2007 -0700
> >
> >     mm: merge populate and nopage into fault (fixes nonlinear)
> >
> >     Nonlinear mappings are (AFAIKS) simply a virtual memory concept that encodes
> >     the virtual address -> file offset differently from linear mappings.
> >
> >     ->populate is a layering violation because the filesystem/pagecache code
> >     should need to know anything about the virtual memory mapping.  The hitch here
> >     is that the ->nopage handler didn't pass down enough information (ie.  pgoff).
> >      But it is more logical to pass pgoff rather than have the ->nopage function
> >     calculate it itself anyway (because that's a similar layering violation).
> >
> >     Having the populate handler install the pte itself is likewise a nasty thing
> >     to be doing.
> >
> >     This patch introduces a new fault handler that replaces ->nopage and
> >     ->populate and (later) ->nopfn.  Most of the old mechanism is still in place
> >     so there is a lot of duplication and nice cleanups that can be removed if
> >     everyone switches over.
> >
> >     The rationale for doing this in the first place is that nonlinear mappings are
> >     subject to the pagefault vs invalidate/truncate race too, and it seemed stupid
> >     to duplicate the synchronisation logic rather than just consolidate the two.
> >
> >     After this patch, MAP_NONBLOCK no longer sets up ptes for pages present in
> >     pagecache.  Seems like a fringe functionality anyway.
> >
> >     NOPAGE_REFAULT is removed.  This should be implemented with ->fault, and no
> >     users have hit mainline yet.
> >
> >
> >
> >
> > --
> > Michael Kerrisk
> > Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> > Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
> >
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
