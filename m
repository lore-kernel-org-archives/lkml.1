Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbYKNR7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbYKNR7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 12:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbYKNR7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 12:59:45 -0500
Received: from www.crouse-house.com ([199.45.160.146]:33730 "EHLO
	mail.crouse-house.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbYKNR7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 12:59:44 -0500
X-Greylist: delayed 1493 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Nov 2008 12:59:44 EST
Message-ID: <491DB6B9.7030209@cosmicpenguin.net>
Date: Fri, 14 Nov 2008 10:34:49 -0700
From: Jordan Crouse <jordan@cosmicpenguin.net>
Reply-To: jordan@cosmicpenguin.net
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Andres Salomon <dilinger@queued.net>, Takashi Iwai <tiwai@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Jeremy Katz <katzj@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jordan Crouse <jordan.crouse@amd.com>, linux-kernel@vger.kernel.org,
       dsaxena@laptop.org
Subject: Re: [PATCH] ALSA: cs5535audio: only build OLPC support if	MGEODE_LX
 is defined
References: <1226547898.13077.83.camel@aglarond.local> <s5h63msru7z.wl%tiwai@suse.de> <20081113153714.GA1520@ucw.cz> <s5h3ahvhb9w.wl%tiwai@suse.de> <20081113111428.59aa36cb@ephemeral> <20081113163802.GA1734@ucw.cz> <20081113120147.2ecde3c8@ephemeral> <20081113190339.GE17851@elte.hu> <s5hzlk3kxuf.wl%tiwai@suse.de> <20081113213852.16561ed2@ephemeral> <20081114075248.GB8397@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20081114075248.GB8397@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> HI!
> 
>>>> i've zapped this patch meanwhile:
>>>>
>>>>  1355c96: x86/olpc: make CONFIG_OLPC dependent on CONFIG_MGEODE_LX
>>>>
>>>> because it cripples the ability to run distribution kernels on the 
>>>> OLPC.
>>> OK, I reverted also all relevant changes for cs5535audio driver now.
>>> The patches are saved in topic/cs5535audio branch, though.
>>>
>>> Let's fix OLPC-geode coupling first.
>> Hm, I'd really rather prefer this to be upstream.  The patch I sent adds
>> no regressions, allows the driver to happily coexist with existing
>> stuff, and *does* add support if you configure OLPC with MGEODE_LX
>> (generic kernels don't get the additional benefits, but those configured
>> specifically for OLPC do).
> 
> Yes, but the patch is also not a good way of going forward, so it
> should not be in mainline.

For the moment, this is a reasonable intermediate solution.  I think the 
way forward will involve a great deal more work.

The driver does need to be able to twiddle the GPIO pins, and the GPIO 
pins are unique to the CS5536.  In the past, the CS5536 has been only 
associated with the Geode, and 99.99% of the kernel users in the world 
don't need Geode, so it make sense to omit specific code of this nature.
As you might expect, I'm not in the "you should be able to run an 
arbitrary kernel on the XO" crowd.

That said, its clear that people are interested in doing so - so a 
change needs to be made.  The immediate option is to turn on Geode 
support for all x86 kernels, but thats a few extra K in the kernel 
binary that nobody needs.  So we'll have to go modular.

I talked to Andres about this yesterday.  The immediately obvious 
solution would be to port the Geode GPIO support into the existing GPIO 
subsystem.  That is attractive, but it omits some of the other Geode 
goodness that might be of interest to a "standard kernel" not configured 
for MGEODE_LX (such as the Geode watchdog timer).  So, I think we should 
move most of the Geode code into a support module and remove MGEODE_LX 
checks in most places.  The distributions can build the module and put 
it in the file system, and serious Geode users such as OLPC can build it 
in to the kernel binary.

Also, while we are at it, we should be more specific and rename the 
hooks from geode_ to cs5536_, since there will soon be a system in the 
wild with a MIPS processor and a CS5536.

But needless to say, this will be a goodly amount of work and churn that 
will need some heavy testing in the OLPC kernel.  In the meantime, 
Andres' fix will make the upstream kernel happier.

Jordan


