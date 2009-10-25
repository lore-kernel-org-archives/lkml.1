Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbZJYQxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbZJYQxb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 12:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbZJYQxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 12:53:31 -0400
Received: from smtp240.poczta.interia.pl ([217.74.64.240]:45049 "EHLO
	smtp240.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbZJYQxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 12:53:30 -0400
Message-ID: <4AE49112.8090508@interia.pl>
Date: Sun, 25 Oct 2009 17:55:30 +0000
From: =?UTF-8?B?UmFmYcWCIEJpbHNraQ==?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Krzysztof Helt <krzysztof.h1@poczta.fm>,
       cpufreq@vger.kernel.org, LKLM <linux-kernel@vger.kernel.org>,
       Rafal Bilski <rafalbilski@interia.pl>
Subject: Re: [PATCH] longhaul: select Longhaul version 2 for capable CPUs
References: <20091024172538.e2c8776b.krzysztof.h1@poczta.fm> <20091025032813.GB2475@redhat.com>
In-Reply-To: <20091025032813.GB2475@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-EMID: e284acc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Sat, Oct 24, 2009 at 05:25:38PM +0200, Krzysztof Helt wrote:
>  > From: Krzysztof Helt <krzysztof.h1@wp.pl>
>  > 
>  > There is a typo in the longhaul detection code so only Longhaul v1 or Longhaul v3
>  > is selected. The Longhaul v2 is not selected even for CPUs which are capable of.
>  > 
>  > Tested on PCChips Giga Pro board. Frequency changes work and the Longhaul v2
>  > detects that the board is not capable of changing CPU voltage.
>   
Most likely processor isn't capable of changing voltage. It is hardcoded 
in most processors.
>  > 
>  > Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
>  
> It seems we deliberately changed this two years ago, though the changelog
> is a bit sparse on details..
>
> commit 07844252ffd81ec192a62014bada1016c9703765
> Author: Rafal Bilski <rafalbilski@interia.pl>
> Date:   Sun Apr 22 12:26:04 2007 +0200
>
>     [CPUFREQ] Longhaul - Revert Longhaul ver. 2
>     
>     There is something wrong with this code. It needs more
>     testing. It is better to disable it for now because support
>     for some machines will be broken.
>     
>     Signed-off-by: Rafal Bilski <rafalbilski@interia.pl>
>     Signed-off-by: Dave Jones <davej@redhat.com>
>
>
> In hindsight, changing it to report V1 instead of V2 was the wrong thing
> to do, and we should have done something like -ENODEV with
> a printk explaining why.
>
> I've not got any old VIA CPUs/boards to test with any more, but I'm inclined
> to apply your change, but we'll have to keep an eye out for any strange
> bugs on affected systems.  Currently this driver should do nothing, as the
> longhaul v1 registers that don't exist on longhaul V2 CPUs.
Yes this register do exists on ver. 2 CPU's. It was removed later from 
"powersaver" line of
processors.
>  With this change,
> we're going to be actually doing scaling again, which may introduce instability
> on some machines, as iirc, we never did get this driver 100% stable due
> to a lot of really crappy motherboards.
>
> Perhaps we should printk a warning related to this.
> (We should definitly mention it in the Kconfig too, which I thought we already had)
>
> 	Dave
It's my fault. Commit 52a2638bff063acb28ba3355891c49cc240cc98b:
> Longhaul: add auto enabled "revid_errata" option
>
> VIA C3 Ezra-T has RevisionID equal to 1, but it needs RevisionKey to be 0
> or CPU will ignore new frequency and will continue to work at old
> frequency.  New "revid_errata" option will force RevisionKey to be set to
> 0, whatever RevisionID is.
>
> Additionaly "Longhaul" will not silently ignore unsuccessful transition.
> It will try to check if "revid_errata" or "disable_acpi_c3" options need to
> be enabled for this processor/system.
>
> Same for Longhaul ver.  2 support.  It will be disabled if none of above
> options will work.
It was permanent fix for badly programmed ver. 2 registers. What this 
commit
failed to do is to restore ver. 2 support. Probably I used wrong branch 
to create it.
One with voltage scaling enabled.
> Best case scenario (with patch apllied and v2 enabled):
>  longhaul: VIA C3 'Ezra' [C5C] CPU detected.  Longhaul v2 supported.
>  longhaul: Using northbridge support.
>  longhaul: VRM 8.5
>  longhaul: Max VID=1.350  Min VID=1.050, 13 possible voltage scales
>  longhaul: f: 300000 kHz, index: 0, vid: 1050 mV
>  [...]
>  longhaul: Voltage scaling enabled.
>  Worst case scenario:
>  longhaul: VIA C3 'Ezra-T' [C5M] CPU detected.  Powersaver supported.
>  longhaul: Using northbridge support.
>  longhaul: Using ACPI support.
>  longhaul: VRM 8.5
>  longhaul: Claims to support voltage scaling but min & max are both 1.250. Voltage scaling disabled
>  longhaul: Failed to set requested frequency!
>  longhaul: Enabling "Ignore Revision ID" option.
>  longhaul: Failed to set requested frequency!
>  longhaul: Disabling ACPI C3 support.
>  longhaul: Disabling "Ignore Revision ID" option.
>  longhaul: Failed to set requested frequency!
>  longhaul: Enabling "Ignore Revision ID" option.
Sorry.
RafaÅ‚ Bilski


----------------------------------------------------------------------
Bezp³atne konto i limit do 100 tys. Otwierasz?
>> http://link.interia.pl/f23bb

