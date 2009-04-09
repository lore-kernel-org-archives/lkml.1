Return-Path: <linux-kernel-owner+w=401wt.eu-S1759351AbZDIEcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351AbZDIEcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 00:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbZDIEby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 00:31:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42215 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbZDIEby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 00:31:54 -0400
Date: Thu, 9 Apr 2009 06:30:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Huang Weiyi <weiyi.huang@gmail.com>, mingo@redhat.com, hpa@zytor.com,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] x86: remove dupilcated #include
Message-ID: <20090409043053.GG20692@elte.hu>
References: <1239009605-1796-1-git-send-email-weiyi.huang@gmail.com> <20090408122121.GB18581@elte.hu> <20090408135803.GA21624@uranus.ravnborg.org> <20090408141228.GD12931@elte.hu> <20090408184305.GA332@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408184305.GA332@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > > 
> > > I assume you are aware that when you minimize the # of include 
> > > file in the various .c files, then you implicitly add dependency 
> > > on the includes the individual .h files have.
> > 
> > Yes. Look at the commit -tip that does the above change (also 
> > attached below):
> > 
> >   a2bcd47: x86/mm: further cleanups of fault.c's include file section
> > 
> > that commit uncovered a masked-until-then dependency bug in one of 
> > the x86 include files.
> 
> We have plenty of header files that needs other header files to be
> included in order to build.
> 
> I tried to do a simple build check with a i386 defconfig.
> It revealed that the appended list of header files did not build.
> 
> What I did was to create a simple:
> 
> module.h.c file containing:
> #include <linux/module.h>
> 
> And then I used kbuild to build the file,
> adding "obj-y += module.h.o" to Kbuild.
> 
> I did so for all header files in include/linux/
> and result was that 172 header files failed to build.
> 
> Some of these was expected since they are not supposed to be
> included direct. But the rest should build have
> build with no errors?
> 
> I can automate the above included some way to say which header files
> we should NOT build.
> But eliminating the includes that are not needed is a bigger challenge
> and also the biggest win :-(
> Is it worthwhile to make the header files buildable alone?

I think it is definitely worthwile, for a couple of reasons:

 - a data type definition that does not even build if included in a 
   .c file is broken, almost by definition. If it happens to build 
   in its current include file environment that's just a hidden bug, 
   nothing more.

 - having such a check would simplify header dependency hell removal 
   efforts _immensely_. I could remove a suspect looking #include 
   line from a header and build with your check - that would be a
   pretty good mechanism to drive header file simplification
   efforts. (Human review goes only so far and it has failed to
   reach its goal in the past 15 years, as it only addressed the
   most obvious excesses.)

If we are too broken right now then maybe make it only available to 
someone explicitly interested in it, via make 
CONFIG_DEBUG_HEADER_DEPENDENCIES=y or so?

	Ingo
