Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbZFGHBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbZFGHBr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 03:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbZFGHBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 03:01:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:5803 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbZFGHBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 03:01:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lyjMXYfwNfrLEGmqWJW3GjcIIy2Iw3HVI7vWKRp+uqgrUAbJIDTbaGONdf9Aw5q+DX
         D96wcFRMGqcVttoBTFKzzIroeI2XJWvaRNEzDi9xxK5j1fJ3D9xCso56fnjlr9PiHWqm
         jq4Kfg/s+WEt0cImHVrxTz5tvDrWNnKvauAEA=
Date: Sun, 7 Jun 2009 11:01:36 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix dummy apic read/write warning
Message-ID: <20090607070136.GA4547@lenovo>
References: <20090606073737.GA3163@elte.hu> <4A2AEAC6.8060404@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2AEAC6.8060404@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Yinghai Lu - Sat, Jun 06, 2009 at 03:16:38PM -0700]
| ingo got
| [    0.000000] Using APIC driver default
| [    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
| [    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
| [    0.000000] APIC: disable apic facility
| [    0.000000] ------------[ cut here ]------------
| [    0.000000] WARNING: at arch/x86/kernel/apic/apic.c:254 native_apic_read_dummy+0x2d/0x3b()
| [    0.000000] Hardware name: HP OmniBook PC
| 
| we have wrong check in dummy read and write.
| [we only test on system that have APIC with "disableapic"...]
| 
| Signed-off-by: yinghai Lu <yinghai@kernel.org>
| 
| ---
|  arch/x86/kernel/apic/apic.c |    4 ++--
|  1 file changed, 2 insertions(+), 2 deletions(-)
| 
| Index: linux-2.6/arch/x86/kernel/apic/apic.c
| ===================================================================
| --- linux-2.6.orig/arch/x86/kernel/apic/apic.c
| +++ linux-2.6/arch/x86/kernel/apic/apic.c
| @@ -246,12 +246,12 @@ static int modern_apic(void)
|   */
|  static void native_apic_write_dummy(u32 reg, u32 v)
|  {
| -	WARN_ON_ONCE((cpu_has_apic || !disable_apic));
| +	WARN_ON_ONCE((cpu_has_apic && !disable_apic));
|  }
|  
|  static u32 native_apic_read_dummy(u32 reg)
|  {
| -	WARN_ON_ONCE((cpu_has_apic || !disable_apic));
| +	WARN_ON_ONCE((cpu_has_apic && !disable_apic));
|  	return 0;
|  }
|  
| 

No Yinghai, this is wrong. native_apic_write_dummy is not
admissible to be called after apic->write has been NOP'ified.

If a site calls for apic->write after apic_disable() it's
a plain *bug* in caller. So we should continute warning if
cpu_has_apic _or_ !disable_apic.

Though since for SMP compiled kernel we still rely on
apic->read the snippet is to be changed to (cpu_has_apic && !disable_apic)
indeed.

	-- Cyrill
