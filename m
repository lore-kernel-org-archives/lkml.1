Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbYIEWfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbYIEWfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 18:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbYIEWe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 18:34:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34066 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750971AbYIEWe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 18:34:56 -0400
Date: Fri, 5 Sep 2008 15:34:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alok Kataria <akataria@vmware.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Dan Hecht <dhecht@vmware.com>,
       Garrett Smith <garrett@vmware.com>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
In-Reply-To: <1220653095.14401.72.camel@alok-dev1>
Message-ID: <alpine.LFD.1.10.0809051522410.3117@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org>  <20080904160036.GA18382@elte.hu>  <alpine.LFD.1.10.0809040920000.3381@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809041021110.3400@nehalem.linux-foundation.org> 
 <20080904190728.59634020@lxorguk.ukuu.org.uk>  <alpine.LFD.1.10.0809041114030.3400@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809041303530.4112@nehalem.linux-foundation.org>  <20080904204305.GA29065@elte.hu> <20080904205236.GA3864@elte.hu> 
 <alpine.LFD.1.10.0809041403450.3117@nehalem.linux-foundation.org>  <20080904213350.GA15678@elte.hu> <1220653095.14401.72.camel@alok-dev1>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Sep 2008, Alok Kataria wrote:
> 
> This can happen if, in the pit_expect_msb (the one just before the 
> second read_tsc), we hit an SMI/virtualization event *after* doing the 
> 50 iterations of PIT read loop, this allows the pit_expect_msb to 
> succeed when the SMI returns.

So theoretically, on real hardware, the minimum of 50 reads will take 
100us. The 256 PTI cycles will take 214us, so in the absolute worst case, 
you can have two consecutive successful cycles despite having a 228us SMI 
(or other event) if it happens just in the middle.

Of course, then the actual _error_ on the TSC read will be just half that, 
but since there are two TSC reads - one at the beginning and one at the 
end - and if the errors of the two reads go in opposite directions, they 
can add up to 228us.

So I agree - in theory you can have a fairly big error if you hit 
everything just right. In practice, of course, even that *maximal* error 
is actually perfectly fine for TSC calibration.

So I just don't care one whit.  The fact is, fast bootup is more important 
than some crazy and totally unrealistic VM situation. The 50ms thing was 
already too long, the 250ms one is unbearable.

The thing is, you _can_ calibrate the thing more carefully _later_. Use a 
tiemr to do two events one second apart (without slowing down the boot) if 
you want to get a really good value, along with the HPET/PMTIMER 
fine-tuning. That way you should actually be able to get a _really_ 
precise thing, because you do need a long time to get precision. But that 
long time should not be in a critical path on the bootup.

			Linus
