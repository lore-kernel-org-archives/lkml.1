Return-Path: <linux-kernel-owner+w=401wt.eu-S1759393AbZE0Eb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393AbZE0Eb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 00:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbZE0EbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 00:31:19 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54284 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbZE0EbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 00:31:19 -0400
Message-ID: <4A1CC20B.1020907@jp.fujitsu.com>
Date: Wed, 27 May 2009 13:31:07 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 19/31] x86: MCE: Default to panic timeout for machine
 checks v2
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org> <23417423c34ad949f53ebc947af8d18672a79a40.1243381848.git.ak@linux.intel.com> <347567c2ace55b336b1a43a67323ff8b86b80243.1243381848.git.ak@linux.intel.com> <3e29698799ad2c02429613323897a6e61a0a7d01.1243381848.git.ak@linux.intel.com> <34082fc262bae2f910f1a940622173445aea72cd.1243381848.git.ak@linux.intel.com> <c3a768c37edad55939c6f9391001fb95e658ffe6.1243381848.git.ak@linux.intel.com> <37501061dc5d5581fefcaff92c2606e39cc61913.1243381848.git.ak@linux.intel.com> <10e478c24139e29e7e74529edd694858ec2fb7ea.1243381848.git.ak@linux.intel.com> <a541b2bc620d04dd777acd27a37f564ec757fe8b.1243381848.git.ak@linux.intel.com> <abfc8311c5aff38314860d82db449c6c62e9e34d.1243381848.git.ak@linux.intel.com> <b55d8c3d2842ee10f4b06f17cc2658f81b4f7b4e.1243381848.git.ak@linux.intel.com> <7efad2e5492abb8f94577a81c2ca397a968064d7.1243381848.git.ak@linux.intel.com> <0f7e10122c48b7988b1676be5e7fc75f2c561215.1243381848.git.ak@linux.intel.com
 >
In-Reply-To: <0f7e10122c48b7988b1676be5e7fc75f2c561215.1243381848.git.ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Fatal machine checks can be logged to disk after boot, but only if
> the system did a warm reboot. That's unfortunately difficult with the
> default panic behaviour, which waits forever and the admin has to
> press the power button because modern systems usually miss a reset button.
> This clears the machine checks in the registers and make
> it impossible to log them.
> 
> This patch changes the default for machine check panic to always
> reboot after 30s. Then the mce can be successfully logged after
> reboot.
> 
> I believe this will improve machine check experience for any
> system running the X server.
> 
> This is dependent on successfull boot logging of MCEs. This currently
> only works on Intel systems, on AMD there are quite a lot of systems
> around which leave junk in the machine check registers after boot,
> so it's disabled here. These systems will continue to default
> to endless waiting panic.
> 
> v2: Only force panic timeout when it's shorter (H.Seto)
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---

I suppose the original intention is overwrite the panic_timeout 0 to 30.

> @@ -240,6 +243,8 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
>  		printk(KERN_EMERG "Some CPUs didn't answer in synchronization\n");
>  	if (exp)
>  		printk(KERN_EMERG "Machine check: %s\n", exp);
> +	if (mce_panic_timeout < panic_timeout)
> +		panic_timeout = mce_panic_timeout;
>  	panic(msg);
>  }
>  
> @@ -1100,6 +1105,8 @@ static void mce_cpu_quirks(struct cpuinfo_x86 *c)
>  	}
>  	if (monarch_timeout < 0)
>  		monarch_timeout = 0;
> +	if (mce_bootlog != 0)
> +		mce_panic_timeout = 30;
>  }
>  
>  static void __cpuinit mce_ancient_init(struct cpuinfo_x86 *c)

It seems it doesn't work.

I made a incremental patch for this fix.  Please consider applying.


Thanks,
H.Seto

