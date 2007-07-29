Return-Path: <linux-kernel-owner+w=401wt.eu-S1762488AbXG2MRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762488AbXG2MRY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 08:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759345AbXG2MRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 08:17:17 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4744 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758803AbXG2MRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 08:17:16 -0400
Date: Sun, 29 Jul 2007 08:16:21 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Martin Pitt <martin.pitt@ubuntu.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jeremy@goop.org, wwoods@redhat.com,
       Ben Collins <ben.collins@ubuntu.com>
Subject: Re: [PATCH 2/3] core_pattern: allow passing of arguments to user mode helper when core_pattern is a pipe
Message-ID: <20070729121621.GB9644@hmsreliant.homelinux.net>
References: <20070727200746.GC18946@hmsreliant.homelinux.net> <20070728092355.GA5808@piware.de> <20070728134627.GA10006@hmsreliant.homelinux.net> <20070728161725.GA5836@piware.de> <20070728172142.GA10555@hmsreliant.homelinux.net> <46AC5576.2050602@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AC5576.2050602@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 02:23:10PM +0530, Aneesh Kumar K.V wrote:
> 
> 
> Neil Horman wrote:
> >On Sat, Jul 28, 2007 at 06:17:25PM +0200, Martin Pitt wrote:
> >>Hi Neil,
> >>
> >>Neil Horman [2007-07-28  9:46 -0400]:
> >>>>I just want to mention a potential problem with this: If you first
> >>>>expand the macros (from pattern to corename) and then split
> >>>>corename into an argv, then this breaks macro expansions
> >>>>containing spaces.  This mostly affects the executable name, of
> >>>>course.
> >>>>
> >>>I never intended for this core_pattern argument passing to be able
> >>>to expand macros, other than the macros specified by the
> >>>core_pattern code.  If you want it to do that, we can address that
> >>>with a later patch.
> >>No, I specifically mean the standard ones provided by
> >>format_corename(), such as %p (pid), %s (signal), or %e (executable
> >>name). I don't see a reason to provide additional functionality.
> >>
> >Ahh, well then you should have nothing to worry about, this patch expands 
> >them
> >just fine.  And none of those macros will ever have spaces in them.  I 
> >suppose
> >it would be possible for the executable name to have spaces in it, but 
> >honestly,
> >thats going rather out of your way to do something that you arguably 
> >shouldn't
> >do anyway.
> >
> >>>>In fact we considered this macro approach when doing the original
> >>>>patches in the Ubuntu kernel, but we eventually used environment
> >>>>variables because they are much easier and more robust to
> >>>>implement than doing a robust macro expansion (i. e. first split
> >>>>core_pattern into an argv and then call the macro expansion for
> >>>>each element).
> >>>>
> >>>I disagree. While it might be nice to be able to specify environment
> >>>variables as command line arguments, it would be much easier to just
> >>>let the core_pattern executable inherit the crashing processes
> >>>environment.  we don't do that currently, but we easily could.  That
> >>>way any information that the crashing process wants the dying
> >>>process to know can be inherited and vetted easily by apport (or
> >>>whatever the core_pattern points to).  I'll do a patch later for
> >>>that if you don't like it.
> >>I don't think that this will be necessary. After all, the crash
> >>handler can read all the environment from /proc/<pid>/ (and that's
> >>indeed what apport does to figure out relevant parts from the
> >>environment like the locale).
> >>
> >Agreed, /proc/<pid of crashing process>/* will be available while the 
> >helper app
> >runs.
> >
> >>It seems we misunderstood each other, I don't expect or want any new
> >>functionality in core_pattern. AN example might make it more clear:
> >>
> >I think you're correct, I misundersood you previously.  Apologies.
> >
> >>The original problem that we are trying to solve is the current
> >>behaviour of core_pattern expansion with pipes:
> >>
> >>  |/bin/crash --pid %p
> >>
> >>would try to execute the program '/bin/crash --pid 1234' instead of
> >>calling /bin/crash with ['--pid', '1234'] as argv, right? Your patch
> >>achieves the latter by splitting the formatted core dump string into
> >>an array (at spaces).
> >>
> >Yes, that is exactly correct.
> >
> >>I pointed out that this leads to problems when macro values contain
> >>spaces. This currently affects hostname (%h) (although this really
> >>should not happen in practice) and executable name (%e) (rare, but at
> >>least valid).  I. e. for an executable name "foo bar" your patch would
> >>expand
> >>
> >>  |/bin/crash %e
> >>
> >>to ['/bin/crash', 'foo', 'bar'] instead of ['/bin/crash', 'foo bar'].
> >>
> >Also correct.  Thats a pretty big corner case, and I personally don't 
> >think an
> >executable name with spaces is/should be valid anyway, but it can be done.
> >
> >>Of course this is a corner case, and personally I don't really care.
> >>I strive to keep the assumptions about the interface at a minimum, so
> >>right now Apport's only required input is the core dump itself (over
> >>stdin); signal and pid can be read from the environment, and if not
> >>present, they are read from the core dump.
> >>
> >
> >Jeremy asked that I make a patch next week to address split_argv's 
> >requirement
> >that the argc parameter be non-NULL.  I'll be fixing that next week, and 
> >what I
> >can do is further enhance it such that it ignores spaces in quoted strings,
> >which should address the case that concerns you.  I.E I can make split_argv
> >behave such that:
> >echo "|\"foo bar\" --pid %p" > /proc/sys/kernel/core_pattern
> >results in the following argv:
> >{{"foo bar"}, {"--pid"}, {"1234"}}
> >
> >Which I think handles what you are looking for.
> >
> 
> 
> One would also need to quote the expansion of %e  as Martin listed in the 
> previous mail
> So a %e should expand to \"my executable\". So that it get passed as single 
> argument.
> 
> I guess we should only do it when "|" is specified in core pattern. 
> Otherwise we would
> have core file as 
> 
> core."my exectutable" 
> 

Martin and I have already gone over this in a previous post and I think we agree
that this is enough of a corner case, and so easily worked around, that we can
address it in a later patch.

Neil

> 
> -aneesh

-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
