Return-Path: <linux-kernel-owner+w=401wt.eu-S1757310AbZLUVQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbZLUVQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 16:16:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757271AbZLUVQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 16:16:45 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:43988 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756274AbZLUVQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 16:16:44 -0500
Subject: Re: Wrong atime on recent kernels
From: john stultz <johnstul@us.ibm.com>
To: Petr =?UTF-8?Q?Tit=C4=9Bra?= <petr@titera.eu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4B2EB3BC.6030900@titera.eu>
References: <4B26AB7E.9020208@titera.eu>
	 <1f1b08da0912141345ia574429k8b3e2fb73fdddb30@mail.gmail.com>
	 <4B29494B.4010305@titera.eu>
	 <1261020388.7245.27.camel@localhost.localdomain>
	 <4B2A1051.9010808@century.cz>
	 <1261106021.3466.76.camel@localhost.localdomain>
	 <4B2EA55C.4030406@titera.eu>  <4B2EB3BC.6030900@titera.eu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Dec 2009 13:16:14 -0800
Message-ID: <1261430174.5293.43.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-21 at 00:31 +0100, Petr Titěra wrote: 
> Petr Titěra napsal(a):
> > john stultz napsal(a):
> >> Let me know if you find anything that helps narrow this down.
> >>
> >
> > I know its far fetched, but is there something what is preventing 
> > xtime.tv_nsec to be exactly 999999999 near the end of update_wall_time 
> > in kernel/time/timekeeping.c?
> >
> Just to follow up. I'm asking because I see a lot of files with access 
> and/or modify times near the top of thousanth of second (see 
> `/etc/sysconfig/prelink' in my example) and I thing that addition of 1 
> to xtime.tv_nsec ath the end of update_wall_time can 'owerflow' to whole 
> second.


Oof! Yikes.

Yea, the sub-nanosecond rounding fix we added quite awhile back indeed
opens a hole where xtime.tv_nsec could be exactly 1sec. Good eye!

Of course, most of the timekeeping accessors handle this properly by
normalizing the timespec before returning, so its likely just users of
current_kernel_time() and direct accessors of xtime that might be bitten
here. 

And this probably was obscured before because the xtime_cache() was
normalized. Did you verify that reverting that patch I pointed you to
resolves the issue? If not, please do, so we can get this fixed up.

Now I'm a little baffled why you see it all the time on your boxes. For
this to trigger, you have to have an interrupt in the last ns of a
second, and then the window for these odd filesystem stamps is only open
for 1-10ms.

Sigh. Once we get the last of the non GENERIC_TIME arches converted to
arch_gettimeoffset, we can kill all of those rounding hacks and just
manage the sub-nanosecond portion sanely. I'm looking forward to that
day!


So again, Bravo on catching this!

thanks
-john

