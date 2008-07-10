Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbYGJV0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbYGJV0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 17:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbYGJV0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 17:26:08 -0400
Received: from smtp1.versatel.nl ([62.58.50.88]:37599 "EHLO smtp1.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbYGJV0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 17:26:07 -0400
Message-ID: <48768018.2070704@hhs.nl>
Date: Thu, 10 Jul 2008 23:33:12 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Milton Miller <miltonm@bga.com>
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       linuxppc-dev@ozlabs.org, Samuel Ortiz <samuel@sortiz.org>
Subject: Re: [lm-sensors] [RFC] (almost) booting allyesconfig -- please don't
 poke super-io without request_region
References: <for-27-patch1-0@bga.com>
In-Reply-To: <for-27-patch1-0@bga.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milton Miller wrote:
> After the following patch to mark the isa region busy and applying a few
> patches[1], I was able to kexec boot into an all-yes-config kernel from 
> linux-next, with the following KCONFIG_ALLCONFIG file:
> 
> # CONFIG_KALLSYMS_EXTRA_PASS is not set
> # CONFIG_CRASH_DUMP is not set
> CONFIG_PPC_EARLY_DEBUG_RTAS_CONSOLE=y
> # CONFIG_NSC_FIR is not set
> # CONFIG_SMC_IRCC_FIR is not set
> # CONFIG_ALI_FIR is not set
> # CONFIG_TCG_NSC is not set
> # CONFIG_TCG_ATMEL is not set
> # CONFIG_SENSORS_F71805F is not set
> # CONFIG_SENSORS_F71882FG is not set
> # CONFIG_SENSORS_F75375S is not set
> # CONFIG_SENSORS_IT87 is not set
> # CONFIG_SENSORS_PC87360 is not set
> # CONFIG_SENSORS_PC87427 is not set
> # CONFIG_SENSORS_DME1737 is not set
> # CONFIG_SENSORS_SMSC47M1 is not set
> # CONFIG_SENSORS_SMSC47B397 is not set
> # CONFIG_SENSORS_VT1211 is not set
> # CONFIG_SENSORS_W83627HF is not set
> # CONFIG_SENSORS_W83627EHF is not set
> 
> While the first two might not be required, and the third is just
> selecting the right platform, it would be nice to get the drivers
> to play as well as the rest of the kernel.
> 
> The drivers all are for super-io chips, either irda/FIR drivers or hwmon,
> and poke at isa ports without checking request_region.
> 

Erm,

The superio sensor drivers only poke the superio chip registers without request 
region during the probe phase, iow they try to detect the chip, using a widely 
document and standardized (part of isa pnp AFAIK) procedure on standardized ports.

Let me try to explain a bit about superio chips, they have 2 superio control 
registers (an index and data register) with which things like a manufacturer 
and device id can be read, besides these id registers they also have a set of 
registers with config for different logical devices. Once the id is matched, 
the driver knows which logical device config to read, reads a (different) isa 
base address + range from the logical device config, and then does a 
request_region on the region actually used by the logical device.

The superio control registers are thus a sort of pci configuration space if you 
want, doing a request_region on these is not such a good idea, as multiple 
drivers (for different logical devices within the superio device) may use 
these, so trying to gain exclusive access will lead to troubles.

I hope with this info about the problem space, that you maybe have a suggestion 
on howto fix this?

Regards,

Hans
> 

