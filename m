Return-Path: <linux-kernel-owner+w=401wt.eu-S1756607AbYEHUx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607AbYEHUx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 16:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762349AbYEHUva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 16:51:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53865 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760454AbYEHUv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 16:51:26 -0400
Subject: Re: [PATCH 0/13] Updated V4  - Regulator Framework
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Harald Welte <laforge@gnumonks.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       arm kernel <linux-arm-kernel@lists.arm.linux.org.uk>
In-Reply-To: <20080508063538.GC6105@prithivi.gnumonks.org>
References: <1209742841.12502.40.camel@odin>
	 <20080508063538.GC6105@prithivi.gnumonks.org>
Content-Type: text/plain
Date: Thu, 08 May 2008 21:51:27 +0100
Message-Id: <1210279887.20475.79.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-08 at 08:35 +0200, Harald Welte wrote:
> On Fri, May 02, 2008 at 04:40:41PM +0100, Liam Girdwood wrote:
> > This is an updated version of the kernel voltage & current regulator
> > framework based on comments received from version 3 of the patch series.
> > 
> > The regulator framework is designed to provide a standard kernel
> > interface to control voltage and current regulators on SoC based
> > systems.
> 
> Dear Liam,
> 
> I have reviewed your regulator framework from the point of view of the
> Openmoko GTA01 and GTA02 devices, based on members of the NXP PCF506xx
> PMU(PMIC) devices (for which I wrote the drivers). 
> 
> I believe it would fit quite nice onto this PMIC family from a different
> manufacturer.
> 
> There is one aspects of the PCF506xx that I think the current regulator
> framework doesn't (yet) cover.  I'm not sure if it was worth to add
> support for this, but let me explain:
> 
> The PCF506xx have a concept of global power management states,
> particularly important are the ON and STANDBY states in this context.
> Every regulator has a property whether it is enabled in none, one or
> both of the global power management states.
> 

Fwiw, the WM8350 and the MC13783 also have similar global states for ON
and STANDBY/HIBERNATE. I would imagine PMICs from other vendors would
have similar global states too.

> Do you think it would be worth to export something like this in the
> generic API, too?  It's probably quite hard, since there are devices
> that actually use the PCF506xx STANDBY state during suspend-to-ram, but
> other devices leave the PCF506xx in the ON state and just disable the
> individual regulators using I2C register writes.
> 

Yes I think it would be worthwhile adding this sort of functionality. I
had considered this earlier on in development but it was lower priority
for me then.

This would mean some additions to the regulator machine interface (to be
used during machine regulator setup) and regulator driver interface (to
set the values). I could add some 'standby_uV' and 'standby_mode' fields
(one for each standby state) to struct regulation_constraints. This
would define the desired voltage and regulator operating mode to be used
during the regulators STANDBY/HIBERNATE states. Hence the correct
regulator output state would be selected when the PMIC enters it's
STANDBY/HIBERNATE state (via either a I2C write or hardware signal). 

Would this suffice for your PMIC (sorry I don't have the datasheet) ?

> I think there's probably no clean way how to integrate this, since the
> question remains: who makes the decision (and manages the contraints) of
> when to transition into the STANDBY state. 

Entering the PMICs global STANDBY/HIBERNATE state usually either comes
from the hardware (e.g. button press, low battery, over temp) or a
software user request. The constraints would be set at machine init time
(along with the runtime constraints). This would work well for WM8350,
but I'm not sure for PCF506xx. 

However, entering individual regulator STANDBY/HIBERNATE states can be
more difficult and as it is quite tightly coupled to the machine (and
it's current use case or use case transition). Do you need per regulator
STANDBY/HIBERNATE control ? We already have the ability to change the
operating mode on a per regulator basis but not switch to states other
than ON and OFF.

>   Nevertheless a read-only
> sysfs attribute might still be interesting.
> 

No problem, I'll add this too. I'll try and do this tomorrow (and also
the MAINTAINERS patch) and send for review.

Cheers

Liam

