Return-Path: <linux-kernel-owner+w=401wt.eu-S1765167AbYEHQt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765167AbYEHQt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 12:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762697AbYEHQsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 12:48:50 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:25644 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758420AbYEHQss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 12:48:48 -0400
Subject: Re: [PATCH] clocksource: shift helper
From: Daniel Walker <dwalker@mvista.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200805070557.39424.zippel@linux-m68k.org>
References: <20080501173123.444094226@mvista.com>
	 <200805070557.39424.zippel@linux-m68k.org>
Content-Type: text/plain
Date: Thu, 08 May 2008 09:48:46 -0700
Message-Id: <1210265327.17132.275.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-07 at 05:57 +0200, Roman Zippel wrote:
> Hi,
> 
> On Thursday 1. May 2008, Daniel Walker wrote:
> 
> > This is a little helper I pulled from the mips tree. I've seen a couple
> > of bogus shift values, and this helper calculates the shift. This
> > should move the shift selection away from the user, and systematically
> > pick the value base on the hz.
> >
> > I also modified the acpi_pm timer to use this new interface. The original
> > shift was 22 , and after this patch it's increased to 23. Which should make
> > the clocksource slightly more accurate, but shouldn't have much of a
> > visible effect.
> 
> What is this calculation based on?

It's based on the clocksource_hz2mult() calculation. It tests multiple
shifts until the largest workable one is found.

> Unless I miss something even 22 is far more than enough. acpi_pm has a 
> resolution of 279ns, thus the clock can't be more accurate than half of this 
> on average and increasing the shift doesn't change much directly about it.
> What the shift value does influence is the size of the adjustment step the 
> clock code can do during an update, so with shift=22 and HZ=100 the possible 
> adjustment step would be 0.008ns (freq/2^shift/ntp_hz). The problem is that 
> this value is also used for how soon the clock is being adjusted, this means 
> the clock code is constantly busy adjusting for a very small error.
> So from a clock adjustment perspective a shift value close to log2
> (freq/res/10^9/ntp_hz) (with res=1/freq and being limited to 1ns<=res<=1us) 
> would provide sufficient accuracy, while keeping the need for adjustment low, 
> this means with the above example a shift value of much more than 8 doesn't 
> improve accuracy significantly.

This seems like a problem with the current method also.. Given that
people just "select" a shift, they could pick one that is too large or
too small easily. 

The method in this patch is not very sophisticated, so we could make it
take more into account.

Daniel


