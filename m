Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbYANNGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbYANNGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 08:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbYANNGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 08:06:12 -0500
Received: from smtprelay13.ispgateway.de ([80.67.29.43]:36841 "EHLO
	smtprelay13.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbYANNGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 08:06:10 -0500
X-Greylist: delayed 512 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jan 2008 08:06:10 EST
Message-ID: <478B5CAF.6010605@ladisch.de>
Date: Mon, 14 Jan 2008 13:59:27 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Andrew Paprocki <andrew@ishiboo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: HPET timer broken using 2.6.23.13 / nanosleep() hangs
References: <76366b180801130310x57f24cc8s641d3ccb2415524c@mail.gmail.com>
In-Reply-To: <76366b180801130310x57f24cc8s641d3ccb2415524c@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: 006495
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Paprocki wrote:
> I started debugging a problem I was having with my sky2 network driver
> under 2.6.23.13. The investigation led me to find that the HPET timer
> wasn't working at all, causing the sky2 driver to not work properly.
> Simple example:
>
> am2:/sys/devices/system/clocksource/clocksource0# echo hpet > current_clocksource
> am2:/sys/devices/system/clocksource/clocksource0# time sleep 1
> <hangs indefinetly...>
>
> Running strace shows it blocked on nanosleep(). I'm building the
> kernel with the processor type set to Athalon64. I've built it with
> and without SMP and high-res timers enabled and I get the same result.
> My previous 2.6.18-4 kernel works because it does not install HPET as
> the default timer. The same behavior occurs in 2.6.24-rc7 git head.
> I've attached the config/dmesg below.
>
> Under 2.6.18-4 (Debian stock kernel):
>
> ACPI: HPET id: 0x10b9a201 base: 0xfed00000
> hpet0: at MMIO 0xfed00000 (virtual 0xf8800000), IRQs 2, 8, 0, 0
> hpet0: 4 32-bit timers, 14318180 Hz
> Using HPET for base-timer
> hpet_resources: 0xfed00000 is busy
> Time: tsc clocksource has been installed.
>
> Under 2.6.23.13 w/ SMP:
>
> ACPI: HPET 37FE7400, 0038 (r1 RS690  AWRDACPI 42302E31 AWRD       98)
> ACPI: HPET id: 0x10b9a201 base: 0xfed00000
> Time: tsc clocksource has been installed.
> Clocksource tsc unstable (delta = 500013666 ns)
> Time: hpet clocksource has been installed.

The lines prefixed with "hpet0:" are missing; apparently, hpet_alloc()
was never called because hpet_reserve_platform_timers() is disabled
because CONFIG_HPET is not set.  Try enabling this option.  (CONFIG_HPET
is in the "Character Devices" kernel config menu.)

That this option would be required to get the platform HPET code to work
seems like a bug.


Regards,
Clemens
