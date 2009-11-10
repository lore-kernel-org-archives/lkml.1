Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbZKJV1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbZKJV1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 16:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758233AbZKJV1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 16:27:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57550 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877AbZKJV1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 16:27:20 -0500
Message-ID: <4AF9D98A.90808@zytor.com>
Date: Tue, 10 Nov 2009 13:22:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Kees Cook <kees.cook@canonical.com>
CC: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Jan Beulich <jbeulich@novell.com>, Vegard Nossum <vegardno@ifi.uio.no>,
       Yinghai Lu <yinghai@kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] [x86] detect and report lack of NX protections
References: <20091109221015.GB5129@outflux.net> <4AF8A2C0.5080700@zytor.com> <20091110154956.GF5129@outflux.net> <4AF9991B.20400@zytor.com> <20091110165738.GH5129@outflux.net> <4AF99F0C.2050806@zytor.com> <20091110174622.GK5129@outflux.net> <4AF9B6AD.8020505@zytor.com> <20091110194304.GW5129@outflux.net> <4AF9C627.1070206@zytor.com> <20091110205544.GZ5129@outflux.net>
In-Reply-To: <20091110205544.GZ5129@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2009 12:55 PM, Kees Cook wrote:
>> > I also think "missing in kernel" is misleading in the 32-bit non-PAE,
>> > no-NX case (as it would imply that another kernel could do something),
> Well, I think thinking that even if they turned on the flag in the BIOS,
> the non-PAE kernel couldn't do anything about it anyway.  But, from your
> example, I see you went with "missing in kernel" anyway.

No, I didn't: in my example, the CPU checks have higher priority than
the kernel feature check.

>> So the logic that makes sense would be:
>>
>> if (!cpu_has_nx) {
> 
> cpu_has_nx is not the same as nx_enabled (due to disable_nx).  Also, why
> doesn't set_nx() use cpu_has_nx?  It seems like it does the check
> manually?  Should that be cleaned up?

Yes, it should be.  set_nx() and check_efer() are doing the same thing,
except in different ways, and they are - IMO - *both* doing something
dumb -- although check_efer() is saner.

Anyway, I forgot the last case, which is NX disabled manually
(disable_nx).  It probably makes sense to make it the lowest priority
message.

if (!cpu_has_nx) {
	/* If the CPU can't do it... */
	printk(KERN_INFO "cpu: NX protection unavailable in CPU\n");
} else  {
#if defined(CONFIG_X86_32) && !defined(CONFIG_X86_PAE)
	/* Non-PAE kernel: NX unavailable */
	printk(KERN_NOTICE "cpu: NX protection not supported by kernel\n");
#else
	if (disable_nx)
		printk(KERN_INFO "cpu: NX protection disabled by kernel command line
option\n");
	else
		printk(KERN_INFO "cpu: NX protection active\n");
#endif
}


> How about this?  (Along with the nx_enabled setting in set_nx() for the
> 64-bit and 32-bit+PAE case.)

No, it gives the wrong message for the manually disabled case.

	-hpa
