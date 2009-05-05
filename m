Return-Path: <linux-kernel-owner+w=401wt.eu-S1759016AbZEEXM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759016AbZEEXM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 19:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbZEEXMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 19:12:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35529 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690AbZEEXMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 19:12:48 -0400
Subject: Re: [PATCH 1/3] powerpc, Makefile: Make it possible to safely
	select CONFIG_FRAME_POINTER
From: Steven Rostedt <srostedt@redhat.com>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <299D7402-29D3-4602-8F42-58FDF034DEC5@kernel.crashing.org>
References: <20090502001329.GA11549@oksana.dev.rtsoft.ru>
	 <20090502001421.GA9342@oksana.dev.rtsoft.ru>
	 <68B2EF73-0FD2-41F9-966B-9A54965AFBA6@kernel.crashing.org>
	 <1241316249.4243.22.camel@localhost.localdomain>
	 <6A6BE346-925C-4F73-ABFA-C6110070F071@kernel.crashing.org>
	 <1241530382.11379.12.camel@localhost.localdomain>
	 <299D7402-29D3-4602-8F42-58FDF034DEC5@kernel.crashing.org>
Content-Type: text/plain
Organization: Red Hat
Date: Tue, 05 May 2009 19:11:20 -0400
Message-Id: <1241565080.11379.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2009-05-05 at 15:51 +0200, Segher Boessenkool wrote:
> >>> When we add "-pg" to gcc, it automatically causes frame pointers  
> >>> to be
> >>> used.
> >>
> >> Nope, it does no such thing.
> >
> > Well, mcount is expected to be able to get to not just who called
> > mcount, but also the parent of that function. The way mcount is
> > implemented does not let you do that. If mcount was the first thing to
> > be called in a function, then it would have been perfect. We could get
> > to the caller, its parent, and even the parameters. But unfortunately,
> > mcount is called after the stack is set up. Thus, without frame  
> > pointers
> > (the way to find a previous frame) there's no way (on some archs) to
> > find the parent. Nor can we figure out the parameters, which really
> > sucks.
> 
> Yes, and this is (supposedly) why GCC does not like seeing -pg and
> -fomit-frame-pointer at the same time -- because that cannot work
> *on some architectures*.  These are the same architectures that
> do not enable -fomit-frame-pointer automatically at -O.
> 
> >> NO_NO_OMIT_FRAME_POINTER ?  Or better, just never use -fno-o-f-p,
> >> I don't see why you would ever need it.
> >
> > Because on x86_64 it gives better back traces. x86_64 has no way to  
> > get
> > to the previous frames without it. There's code to use other debug
> > metadata to get back tracing, but for uses of things like the stack
> > tracer, we need to be able to use the actual stack frames.
> >
> > As you said above, -fomit-frame-pointer is default when we  
> > optimize, and
> > that is how the kernel is built. If we optimize on x86_64 and do  
> > not use
> > -fno-omit-frame-pointer, the stack tracer is useless.
> 
> No.  -fomit-frame-pointer is only the default when optimising on
> archs/ABIs where it doesn't hinder debugging and -pg and all that
> goodness; specifically, you do not get it by default on x86, not
> at any optimisation level.


OK, so what's the status with this patch series?

I don't want to pull it in unless I have an ack from Sam, and now
there's issues with having -fno-omit-frame-pointer. Should we add a
patch instead that simply removes that?

If we eliminate the -fno-omit-frame-pointer, would that solve the PPC
problem? And would it cause any other issues with other archs?

-- Steve


