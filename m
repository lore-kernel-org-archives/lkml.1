Return-Path: <linux-kernel-owner+w=401wt.eu-S1757413AbYJIWDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbYJIWDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 18:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbYJIWDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 18:03:37 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:39179 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753348AbYJIWDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 18:03:36 -0400
Subject: Re: [PATCH] Re: x86_32 tsc/pit and hrtimers
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Jeff Hansen <x@jeffhansen.com>
Cc: Chris Snook <csnook@redhat.com>, Alok kataria <alokkataria1@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0810091517200.28336@ren>
References: <Pine.LNX.4.64.0810071640110.25661@ren>
	 <48ED1728.5060708@redhat.com> <Pine.LNX.4.64.0810081542300.14815@ren>
	 <48ED2A89.3000902@redhat.com> <Pine.LNX.4.64.0810081554380.14982@ren>
	 <alpine.LFD.2.00.0810090910510.3237@apollo>  <48EE4FC4.7070902@redhat.com>
	 <alpine.LFD.2.00.0810092118100.3271@apollo>
	 <Pine.LNX.4.64.0810091344250.24851@ren>
	 <alpine.LFD.2.00.0810092152410.3271@apollo>
	 <35f686220810091345h253d71e8s4fe9d7ea8e636ccc@mail.gmail.com>
	 <48EE71A9.2010907@redhat.com>  <Pine.LNX.4.64.0810091517200.28336@ren>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 09 Oct 2008 15:03:36 -0700
Message-Id: <1223589816.32639.35.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-09 at 14:18 -0700, Jeff Hansen wrote:
> [X86] Add tsc=stable option for marking TSC as stable
> 
> This enables legacy hardware or VMs without HPET, LAPIC, or ACPI
> timers to enter high-resolution timer mode.
> 
> Signed-off-by: Jeff Hansen <jhansen@cardaccess-inc.com>
> ---
>   Documentation/kernel-parameters.txt |    4 ++++
>   arch/x86/kernel/tsc_32.c            |   12 +++++++++++-
>   arch/x86/kernel/tsc_64.c            |    9 +++++++++
>   3 files changed, 24 insertions(+), 1 deletions(-)

Hi Jeff,

I see that these changes are not for the mainline tree. Do you plan to
do something of this sought for mainline (.28/tip) ?

My comments below are mainly for generalizing this stuff, don't know how
useful these (my comments) will be for 26.5


> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 9611505..8488074 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2084,6 +2084,10 @@ and is between 256 and 4096 characters. It is defined in the file
>                         Format:
>                         <io>,<irq>,<dma>,<dma2>,<sb_io>,<sb_irq>,<sb_dma>,<mpu_io>,<mpu_irq>
> 
> +       tsc=            [X86-32,X86-64]
> +                       tsc=stable: Mark TSC clocksource as stable, enabling
> +                               high-resolution timer mode on older hardware.
> +
>         turbografx.map[2|3]=    [HW,JOY]
>                         TurboGraFX parallel port interface
>                         Format:
> diff --git a/arch/x86/kernel/tsc_32.c b/arch/x86/kernel/tsc_32.c
> index 65b7063..f6e8f71 100644
> --- a/arch/x86/kernel/tsc_32.c
> +++ b/arch/x86/kernel/tsc_32.c
> @@ -49,6 +49,17 @@ static int __init tsc_setup(char *str)
> 
>   __setup("notsc", tsc_setup);
> 
> +static struct clocksource clocksource_tsc;
> +
> +static int __init tscx_setup(char *str)
> +{
> +       if (!strcmp(str, "stable"))
> +               clocksource_tsc.flags &= ~CLOCK_SOURCE_MUST_VERIFY;

Should we add a flag here instead, say tsc_reliable ? or whatever else
you want to call that. 

Also, there is code in check_geode_tsc_reliable which too sets this flag
for the TSC clocksource. 
Maybe you can just set the tsc_reliable flag from tscx_setup and
check_geode_tsc_reliable, and then check "tsc_reliable" value and set
the verify flag in init_tsc_clocksource. 

Thanks,
Alok



