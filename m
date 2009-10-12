Return-Path: <linux-kernel-owner+w=401wt.eu-S1757640AbZJLSdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640AbZJLSdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757566AbZJLSdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:33:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:34753 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757549AbZJLSdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:33:18 -0400
X-Authenticated: #31060655
X-Provags-ID: V01U2FsdGVkX1+mvH4HS9CmlMNy7RKAn0POcCO8gcv131H+0LG9k8
	AJD6hM8HxUI3fH
Message-ID: <4AD3763C.70307@gmx.net>
Date: Mon, 12 Oct 2009 20:32:28 +0200
From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081213 SUSE/1.1.14-1.1 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: David Woodhouse <dwmw2@infradead.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] panic.c: export panic_on_oops
References: <20091012113758.GB11035@elte.hu>	<20091012140149.6789efab@marrow.netinsight.se>	<20091012120951.GA16799@elte.hu>	<20091012142714.56362465@marrow.netinsight.se>	<20091012123210.GB22766@elte.hu>	<20091012140821.5dfa1598@lxorguk.ukuu.org.uk>	<20091012132503.GD25464@elte.hu>	<1255354342.30919.17.camel@macbook.infradead.org>	<20091012142634.GB4565@elte.hu>	<1255358181.9111.14.camel@macbook.infradead.org> <20091012151431.GC14004@elte.hu>
In-Reply-To: <20091012151431.GC14004@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.10.2009 17:14, Ingo Molnar wrote:
> * David Woodhouse <dwmw2@infradead.org> wrote:
>   
>> On Mon, 2009-10-12 at 16:26 +0200, Ingo Molnar wrote:
>>     
>>> Not if the failure is say a s2ram hang that requires a power cycle. 
>>> Also there are certain classes of bugs that only occur on cold boot. 
>>> Plus there's the "need to unplug the battery to revive the system" 
>>> class of bugs (but they are rare).
>>>       
>> So you need to build in enough ECC to cope with the decay which 
>> happens when RAM isn't being refreshed for a few seconds... :)
>>     
>
> [ hey, i think you should line up with BIOS writers at that wall ;-) ]
>   

Not all of us x86 firmware writers are evil.


>>> So i think the MTD / flash stuff is powerful.
>>>       
>> Yeah, definitely. I was just pointing out that we can actually do a 
>> lot better on today's commodity hardware too.
>>     
>
> I wish it worked on any of the 10+ x86 systems i have. Is there anyone 
> who'd be interested in exploring whether warm BIOS reboots work 
> _anywhere_?
>   

AFAIK memory clearing is default off in coreboot for non-ECC RAM and
default on for ECC RAM (to avoid parity errors on read, but that can
probably be worked around). Unless I'm mistaken, the SeaBIOS BIOS
compatibility layer on top of coreboot doesn't erase RAM at all, so
contents can survive.
No idea about classic AMI/Award/Phoenix/Insyde/whatever BIOS, though.


> A simple patch with a new (default-off) CONFIG_DEBUG_ feature that just 
> puts a signature into a predictable spot in RAM, switches the reboot 
> method over to warm reboot (reboot=w) and prints some friendly "yay, 
> this BIOS rocks!" message if the signature is still there after a reboot 
> and not zeroed out.
>
> If that works _anywhere_ we could complete it: we could cache the dmesg 
> buffer address (__log_buf[]) across reboots (and maybe the printk tail 
> offset (log_end)), and that would be an _excellent_ debuggability 
> feature for a large class of otherwise undebuggable crashes ...
>
> We could use that to preserve a kernel function trace (or a branch 
> execution hardware trace using BTS on Intel CPUs) across crashes, etc. 
> etc.
>   

Since we're discussing log buffers anyway, does it make sense to have
this feature interact with the coreboot log buffer which is passed on to
the OS (no official patches for that one, yet)? Basically, coreboot has
its own log buffer where it stores the hardware init diagnostic messages
(very similar to the Linux kernel message buffer) and it could make
sense to use the same memory area for both purposes (if you can deal
with coreboot messages being absent after a kernel Oops).

Thoughts?

Regards,
Carl-Daniel

-- 
Developer quote of the week: 
"We are juggling too many chainsaws and flaming arrows and tigers."

