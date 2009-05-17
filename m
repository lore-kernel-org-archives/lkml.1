Return-Path: <linux-kernel-owner+w=401wt.eu-S1755804AbZEQACv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbZEQACv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 20:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbZEQACl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 20:02:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753725AbZEQACl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 20:02:41 -0400
Date: Sat, 16 May 2009 17:01:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: 2.6.30-rc6: Reported regressions from 2.6.29
In-Reply-To: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
Message-ID: <alpine.LFD.2.01.0905161644350.3301@localhost.localdomain>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 16 May 2009, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13326
> Subject		: Null pointer dereference in rtc-cmos driver
> Submitter	: Ozan Çağlayan <ozan@pardus.org.tr>
> Date		: 2009-05-14 16:16 (3 days old)
> References	: http://marc.info/?l=linux-kernel&m=124231783704696&w=4

Ok, I'm of two minds on this one.

The thing that triggers it is a module that is both a module _and_ 
compiled in (ie the same kernel compiled twice, and the stale module kept 
around). I can see how it happens, and we should react more gracefully to 
it, but at the same time I can't really bring myself to care deeply.

What is going on is that the cmos-rtc.c driver does this:

	#ifdef  CONFIG_PNP
	        pnp_register_driver(&cmos_pnp_driver);
	#endif

	        if (!cmos_rtc.dev)
	                retval = platform_driver_probe(&cmos_platform_driver,
                                               cmos_platform_probe);

	        if (retval == 0)
	                return 0;

	#ifdef  CONFIG_PNP
	        pnp_unregister_driver(&cmos_pnp_driver);
	#endif
	        return retval;

and what happens is that the pnp_register_driver fails when the module 
calls it (because the built-in driver already exists under the same name):

	[   10.428691] Error: Driver 'rtc_cmos' is already registered, aborting...

but the driver doesn't really care whether that succeeded or not, but then 
the platform_driver_probe fails (because the thing is already in use), so 
then it ends up unregistering something that never got registered in the 
first place.

I think this is strictly speaking a bug in driver_unregister(), which is 
too fragile. If you unregister a drivert that wasn't registered, we 
shouldn't oops. 

But we could certainly do it at the rtc-cmos.c level too, and just not 
unregister it if the registration failed. My gut feel is that we should 
aim for the core driver helpers to be less fragile, though - we'll always 
have driver bugs.

Greg?

			Linus
