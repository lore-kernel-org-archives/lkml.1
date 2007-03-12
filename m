Return-Path: <linux-kernel-owner+w=401wt.eu-S1752413AbXCLVMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbXCLVMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 17:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbXCLVMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 17:12:05 -0400
Received: from MAIL.13thfloor.at ([213.145.232.33]:42665 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbXCLVME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 17:12:04 -0400
Date: Mon, 12 Mar 2007 22:11:11 +0100
From: Herbert Poetzl <herbert@13thfloor.at>
To: Pavel Emelianov <xemul@sw.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kirill Korotaev <dev@sw.ru>,
       containers@lists.osdl.org, menage@google.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/7] RSS controller core
Message-ID: <20070312211111.GB21258@MAIL.13thfloor.at>
Mail-Followup-To: Pavel Emelianov <xemul@sw.ru>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kirill Korotaev <dev@sw.ru>, containers@lists.osdl.org,
	menage@google.com, linux-kernel@vger.kernel.org
References: <45ED7DEC.7010403@sw.ru> <45ED80E1.7030406@sw.ru> <20070306140036.4e85bd2f.akpm@linux-foundation.org> <45F3F581.9030503@sw.ru> <20070311045111.62d3e9f9.akpm@linux-foundation.org> <20070312010039.GC21861@MAIL.13thfloor.at> <45F51709.1010409@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F51709.1010409@sw.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 12:02:01PM +0300, Pavel Emelianov wrote:
> >>> Maybe you have some ideas how we can decide on this?
> >> We need to work out what the requirements are before we can 
> >> settle on an implementation.
> > 
> > Linux-VServer (and probably OpenVZ):
> > 
> >  - shared mappings of 'shared' files (binaries 
> >    and libraries) to allow for reduced memory
> >    footprint when N identical guests are running
> 
> This is done in current patches.

nice, but the question was about _requirements_
(so your requirements are?)

> >  - virtual 'physical' limit should not cause
> >    swap out when there are still pages left on
> >    the host system (but pages of over limit guests
> >    can be preferred for swapping)
> 
> So what to do when virtual physical limit is hit?
> OOM-kill current task?

when the RSS limit is hit, but there _are_ enough
pages left on the physical system, there is no
good reason to swap out the page at all

 - there is no benefit in doing so (performance
   wise, that is)

 - it actually hurts performance, and could
   become a separate source for DoS

what should happen instead (in an ideal world :)
is that the page is considered swapped out for
the guest (add guest penality for swapout), and 
when the page would be swapped in again, the guest
takes a penalty (for the 'virtual' page in) and
the page is returned to the guest, possibly kicking
out (again virtually) a different page

> >  - accounting and limits have to be consistent
> >    and should roughly represent the actual used
> >    memory/swap (modulo optimizations, I can go
> >    into detail here, if necessary)
> 
> This is true for current implementation for
> booth - this patchset ang OpenVZ beancounters.
> 
> If you sum up the physpages values for all containers
> you'll get the exact number of RAM pages used.

hmm, including or excluding the host pages?

> >  - OOM handling on a per guest basis, i.e. some
> >    out of memory condition in guest A must not
> >    affect guest B
> 
> This is done in current patches.

> Herbert, did you look at the patches before
> sending this mail or do you just want to
> 'take part' in conversation w/o understanding
> of hat is going on?

again, the question was about requirements, not
your patches, and yes, I had a look at them _and_
the OpenVZ implementations ...

best,
Herbert

PS: hat is going on? :)

> > HTC,
> > Herbert
> > 
> >> Sigh.  Who is running this show?   Anyone?
> >>
> >> You can actually do a form of overcommittment by allowing multiple
> >> containers to share one or more of the zones. Whether that is
> >> sufficient or suitable I don't know. That depends on the requirements,
> >> and we haven't even discussed those, let alone agreed to them.
> >>
> >> _______________________________________________
> >> Containers mailing list
> >> Containers@lists.osdl.org
> >> https://lists.osdl.org/mailman/listinfo/containers
> > 
