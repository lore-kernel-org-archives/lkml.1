Return-Path: <linux-kernel-owner+w=401wt.eu-S1761029AbYEILtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761029AbYEILtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 07:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbYEILtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 07:49:03 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:37012 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbYEILtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 07:49:00 -0400
Subject: Re: IRQ affinities (was: boot cgroup questions)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Jackson <pj@sgi.com>
Cc: maxk@qualcomm.com, menage@google.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080509061727.5057de1f.pj@sgi.com>
References: <47D73086.2030008@qualcomm.com>
	 <6599ad830803111827n1cb8e2c7i47c2ef3f3bb58995@mail.gmail.com>
	 <47D7411E.1000009@qualcomm.com>
	 <6599ad830803111936jd940deam8584bc971c3b6f41@mail.gmail.com>
	 <47D74595.4080100@qualcomm.com>
	 <6599ad830803112009y18d9e43ft8e3fc4a551d891da@mail.gmail.com>
	 <20080311235939.1ebee8e3.pj@sgi.com> <47D81FE1.6030205@qualcomm.com>
	 <20080312135746.89456f2a.pj@sgi.com> <47D82AD2.1070108@qualcomm.com>
	 <20080312143253.3dd72c7f.pj@sgi.com> <47D83858.4030806@qualcomm.com>
	 <20080312153712.bc5df7a1.pj@sgi.com> <47D8593A.6040503@qualcomm.com>
	 <20080312183059.6716d630.pj@sgi.com> <47D87BE5.4010702@qualcomm.com>
	 <20080313020300.92244956.pj@sgi.com> <47FE5655.10900@qualcomm.com>
	 <20080414133902.7878cfce.pj@sgi.com> <1210329926.13978.224.camel@twins>
	 <20080509061727.5057de1f.pj@sgi.com>
Content-Type: text/plain
Date: Fri, 09 May 2008 13:48:58 +0200
Message-Id: <1210333738.13978.246.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-09 at 06:17 -0500, Paul Jackson wrote:
> Peter wrote:
> > That's a new feature; and its quite common that new features require
> > code changes.
> 
> It's common for new features to require code changes to take advantage
> of the new features.
> 
> It's less desirable that taking advantage of such new features breaks
> existing, basically unrelated, code.
> 
> My gut sense is that, in a misguided effort to find a "simple" answer
> to irq distribution, we (well, y'all) are trying to attach this
> feature to cpusets or cgroups.
> 
> Let me ask a different question:
> 
>   What solutions would you (Max, Peter, Ingo, lurkers, ...) be
>   suggesting for this 'IRQ affinity' problem if cpusets and
>   cgroups didn't exist in any form whatsoever?
> 
> The answer to that question might help me contribute to this discussion
> in another way ... it might help me understand better what we're really
> trying to do here.  You guys were proposing mechanisms that don't fit
> my architecture sense of cpusets, but I was having problems figuring out
> what are the essential underlying requirements, independent of choice
> of mechanism.
> 
> Perhaps by describing one or two possible alternative, cpuset-free,
> mechanisms that come more or less close to meeting our needs, I will
> glean a better understanding of these elusive requirements, and can
> better contribute to the discussion of design trade offs facing us.
> 
> So could you describe some possible cpuset-free solutions?  If they are
> flawed in some critical way, that's ok, just point out said flaw(s).
> Either way, this could help illuminate what's needed here.
> 
> It might be, once I better understand the requirements, possible
> solutions and their tradeoffs, that I come to agree that cpusets or
> cgroups present the best mechanism, given the tradeoffs and what's
> needed.  Or it might be we find a better way to meet our needs.
> 
> Actually, if for no other reason than to bring any lurkers up to speed,
> if you (Max or Peter, likely) wanted to describe, from the beginning,
> what this discussion is about, that would be good too.  I doubt anyone
> outside of three or four of us even recalls that long discussion of
> February and March, 2008.


I see two use-cases:

 - Isolation
 - NUMA node devices

With isolation you want to move all of you 'normal' system tasks off to
side of your machine and use the other side for 'special - rt' tasks.

For IRQs this means that you want to move all the 'normal' IRQs along
with the 'normal' tasks, and move the special IRQs into the rt side.

Of course you can do this by setting IRQ affinities one by one, but
being able to group the IRQs seems a sensible thing to me.

One thing here is that we'd like to also provide a default group for new
IRQs, so that when a new device appears its not allowed into the
'special' side of your machine.

This is what Max focussed on, and provides a binary devision of your
machine: special and not special.


Now I was thinking that if we generalize this whole thing it might be
useful for other purposes such as IRQ placement near the nodes that host
the device and/or the application using them.


So what we'd end up with is named affinity groups that contain (unique)
IRQs. 


