Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbZCQQdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbZCQQdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 12:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbZCQQdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 12:33:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753466AbZCQQdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 12:33:13 -0400
Date: Tue, 17 Mar 2009 09:28:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Jesper Krogh <jesper@krogh.cc>,
       john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.29-rc6
In-Reply-To: <20090317161322.GA25904@elte.hu>
Message-ID: <alpine.LFD.2.00.0903170919310.3082@localhost.localdomain>
References: <alpine.LFD.2.00.0903141814180.7421@localhost.localdomain> <49BD225C.4070305@krogh.cc> <alpine.LFD.2.00.0903151050070.3131@localhost.localdomain> <49BD4B2D.7000501@krogh.cc> <alpine.LFD.2.00.0903151146550.3131@localhost.localdomain>
 <49BD5C7C.2060605@krogh.cc> <49BEA1AD.1090901@krogh.cc> <alpine.LFD.2.00.0903161225210.3675@localhost.localdomain> <20090317081412.GA24115@elte.hu> <alpine.LFD.2.00.0903170831020.3082@localhost.localdomain> <20090317161322.GA25904@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Mar 2009, Ingo Molnar wrote:
> 
> That's the idea of my patch: to use not two endpoints but thousands 
> of measurement points.

Umm. Except you don't.

> By measuring more we can get a more precise result, and we also do 
> not assume anything about how much time passes between two 
> measurement points.

That's fine, but your actual code doesn't _do_ that.

> My 'delta' algorithm does not assume anything about how much time 
> passes between two measurement points - it calculates the slope and 
> keeps a rolling average of that slope.

No, you keep a very bad measure of "some kind of random average of the 
last few points", which - if I read things right:

 - lacks precision (you really need to use 'double' floating point to do 
   it well, otherwise the rounding errors will kill you). You seem to be 
   aiming for a 10-bit fixed point thing, which may or may not work if 
   done cleverly, but:

 - seems to be based on a rather weak averaging function which certainly 
   will lose data over time.

The thing is, the only _accurate_ average is the one done over long time 
distances. It's very true that your slope thing works very well over such 
long times, and you'd get accurate measurement if you did it that way, BUT 
THAT IS NOT WHAT YOU DO. You have a very tight loop, so you get very bad 
slopes, and then you use a weak averaging function to try to make them 
better, but it never does.

Also, there seems to be a fundamental bug in your PIT reading routine. My 
fast-TSC calibration only looks at the MSB of the PIT read for a very good 
reason: if you don't use the explicit LATCH command, you may be getting 
the MSB of one counter value, and then the LSB of another. So your PIT 
read can easily be off by ~256 PIT cycles. Only by caring only for the MSB 
can you do an unlatched read!

That is why pit_expect_msb() looks for the "edge" where the MSB changes, 
and never actually looks at the LSB. 

This issue may be an additional reason for your problems, although maybe 
your noise correction will be able to avoid those cases.

			Linus
