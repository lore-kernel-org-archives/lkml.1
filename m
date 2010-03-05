Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab0CENzL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 08:55:11 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:33777 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab0CENzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 08:55:09 -0500
Date: Fri, 5 Mar 2010 14:55:04 +0100
From: Luc Verhaegen <libv@skynet.be>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
Message-ID: <20100305135504.GB8643@skynet.be>
References: <20100304105624.70fe845e@jbarnes-piketon> <alpine.LFD.2.00.1003041101390.3751@localhost.localdomain> <21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com> <alpine.LFD.2.00.1003041142250.3751@localhost.localdomain> <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com> <alpine.LFD.2.00.1003041554490.3751@localhost.localdomain> <1267748927.3496.6.camel@nisroch> <20100305064955.GA6453@elte.hu> <84144f021003042306w2e017efbva2be364c1c4980a7@mail.gmail.com> <20100305074407.GC19703@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100305074407.GC19703@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 08:44:07AM +0100, Ingo Molnar wrote:
> 
> Yeah. I've seen a few other bad arguments as well:
> 
>    'exploding test matrix'
> 
> This is often the result of _another_ bad technical decision: 
> over-modularization.
> 
> Xorg, mesa/libdrm and the kernel DRM drivers pretty share this signature:
> 
>  - it's developed by the same tightly knit developer base who often cross
>    between these packages. Features often need changes in each component.
> 
>  - a developer to be able to do real work has to have the latest sources
>    of all these components.
> 
>  - a user just uses whatever horizontal version cut the distro did and never
>    truly 'mixes' these components as a conscious decision.
> 
>  - distros just try to get the latest and most capable but still stable
>    version. Desperately so. Often they will create a version mix that was
>    never tested by developers in that form. They'll expose users to ABI
>    combinations that were never really intended. They have trouble
>    bootstrapping and stabilizing those essentially random combinations and
>    then have trouble applying stability and security fixes.
> 
> The thing is, if development has such characteristics then it's pretty clearly 
> not 3-4 separate projects but _one_ abstract project. [*]
> 
> So the 'exploding test matrix' is simply the result of: creating ABIs between 
> 3-4 _artificial components of the same project_ and then going through 
> developer hell living with that mistake. [**]
> 
> It's a bit as if we split up the kernel into 'microkernel' components, did a 
> VFS ABI, MM ABI, drivers ABI, scheduler ABI, networking ABI and arch ABIs, and 
> then tried to develop them as separate components.
> 
> If we did then then Linux kernel development would slow down massively while 
> in reality everyone would _still_ have to have the latest and greatest source 
> checked out to do some real development work and to be able to implement 
> features that affect the whole kernel ...
> 
> Linux would become an epic fail of historic proportions if we ever did that.
> 
> 	Ingo
> 
> [*]  I realize that it's possibly hard for Xorg to merge with mesa and the 
>      kernel for license reasons, but my technical observation still stands.
> 
> [**] I realize that modularization and many small packages were a clear 
>      advantage when we were still all downloading bits via 14.4k modems, but 
>      in this day and age of megabit connections that has become a non-issue.
>      Rampant over-modularization and the resulting loss of focus on the end
>      result (and the resulting explosion of a test matrix) is hurting us _far 
>      more_ than the disadvantages of any monolithic could ever hurt. We are 
>      seeing the proof of that all day with a 10+ MLOC kernel.

Tying kernel, libdrm, X and mesa together 1-1 is not going to help
anybody. When thinking along the same line of your reasoning, the answer 
is unifying graphics driver stacks, which requires increased 
modularization (in libdrm and mesa): one big abstract project.

All of X.org, libdrm, drm, mesa/dri, mesa/gallium, all have relatively 
stable interfaces as they are supposed to support multiple (from 3 
(libdrm) to ~50 (Xorg)) drivers. It's driver internal interfaces that 
are highly volatile, as it is easy to adjust all parts inside the same 
graphics driver stack, especially since the same developers know all 
these parts and it supports the same hw.

On top, graphics driver are special, they are as complex and diverse as 
the hardware. So, graphics driver stacks can currently have up to 7-8 
pieces spread everywhere: kernel drm driver, firmware, libdrm driver, 
Xorg driver, 2 mesa drivers, 1-2 media acceleration libraries. All 
spreading inherently unstable interfaces everywhere.

Graphics drivers will always be complex, and buggy and unstable, but we 
should try to encapsulate some of that mess in a way that makes sense.

I had a talk on FOSDEM about this which was very "warmly" received by 
some; the slides are here 
http://www.phoronix.com/scan.php?page=article&item=fosdem_2010_unification&num=1

Luc Verhaegen.
