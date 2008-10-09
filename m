Return-Path: <linux-kernel-owner+w=401wt.eu-S1758084AbYJIJGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbYJIJGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 05:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbYJIJG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 05:06:27 -0400
Received: from mail.openmoko.org ([88.198.124.205]:39646 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbYJIJG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 05:06:26 -0400
X-Greylist: delayed 1561 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Oct 2008 05:06:26 EDT
Message-ID: <48EDC2FD.60809@warmcat.com>
Date: Thu, 09 Oct 2008 09:38:21 +0100
From: Andy Green <andy@warmcat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080919)
MIME-Version: 1.0
To: Eric Miao <eric.y.miao@gmail.com>
CC: Jon Smirl <jonsmirl@gmail.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Toggling GPIO at 38Khz
References: <9e4733910810072043m6c69f3bdv104bd32928fe64ae@mail.gmail.com> <f17812d70810072340n6cb9bd21w1fcf73b56b4f8dff@mail.gmail.com>
In-Reply-To: <f17812d70810072340n6cb9bd21w1fcf73b56b4f8dff@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Miao wrote:

> This isn't easy, 38KHz is quite a high frequency, I'd prefer to
> use an interrupt or fiq based on a accurate clock event source,
> but that will have impact on the system anyway.

Many SoC can elevate PWM interrupt to FIQ.  It's definitely possible to
run a FIQ ISR at >50kHz on a slow system; you'd need 2 x the actual
modulation frequency on the PWM though in order to be able to put it on
and off in one cycle.

Then with the PWM regulating the clock rate, you will definitely get
consistent overall timing, and with FIQ service you will get very low
jitter on individual clock issue.  In the meanwhile the CPU will
continue servicing interrupts and running foreground code normally in
the cycles left inbetween FIQ service, so it is pretty friendly.

I have an implementation for sc32442 on Openmoko Freerunner kernel that
allows a FIQ ISR written in C, I wrote it to implement HDQ (1-bit
battery protocol that is time based) just using a GPIO and no hardware.
 I'm interested in making this more general for ARM to allow wider use
of FIQ stuff and try to get it upstream, but because FIQ itself has some
"special needs" I am not sure what changes are needed to make it more
palatable.

The main guts of it are here:

http://git.openmoko.org/?p=kernel.git;a=blob;f=arch/arm/mach-s3c2440/fiq_c_isr.h;h=e92b103cdfbf115947df5acb4312ef9fc39e1f6e;hb=andy-tracking
http://git.openmoko.org/?p=kernel.git;a=blob;f=arch/arm/mach-s3c2440/fiq_c_isr.c;h=c47d1630081f69dcb82a52a3db18765b10f35384;hb=andy-tracking

...and the FIQ ISR we use with those wrappers is here:

http://git.openmoko.org/?p=kernel.git;a=blob;f=arch/arm/mach-s3c2440/mach-gta02.c;h=cdf2a33b553157208457d1139307c83591d14704;hb=andy-tracking#l136

-Andy

