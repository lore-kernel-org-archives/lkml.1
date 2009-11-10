Return-Path: <linux-kernel-owner+w=401wt.eu-S1758013AbZKJUDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbZKJUDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 15:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757941AbZKJUDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 15:03:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53123 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757908AbZKJUDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 15:03:33 -0500
Message-ID: <4AF9C627.1070206@zytor.com>
Date: Tue, 10 Nov 2009 11:59:35 -0800
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
References: <4ADD1E03.4070200@zytor.com> <20091020045513.GU5394@outflux.net> <20091109221015.GB5129@outflux.net> <4AF8A2C0.5080700@zytor.com> <20091110154956.GF5129@outflux.net> <4AF9991B.20400@zytor.com> <20091110165738.GH5129@outflux.net> <4AF99F0C.2050806@zytor.com> <20091110174622.GK5129@outflux.net> <4AF9B6AD.8020505@zytor.com> <20091110194304.GW5129@outflux.net>
In-Reply-To: <20091110194304.GW5129@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2009 11:43 AM, Kees Cook wrote:
> 
> This is fun.  CONFIG_X86_PAE isn't defined for 64-bit, and using
> cpu_has_pae on 64-bit is considered a bug.  :)
> 

Yeah, it's somewhat obnoxious.  This stuff is a result of the 32- and
64-bit code evolving separately for too long.  All of this could and
should be cleaned up, but it takes a long time.

Either way, you can use the explicit form:

	boot_cpu_has(X86_FEATURE_PAE)

just fine, on any platform.  However, the only case for which this can
be false is for the non-PAE kernel, since the PAE kernels (32 or 64
bits) cannot boot without it.  I have personally never liked the
cpu_has_* shorthand macros, but they're occasionally useful for things
that have to be handled specially on 64 bits.  Unfortunately they have
spread and people seem to think they're the only way.

> Here is the matrix of what I want to see reported about NX at boot time.
> How do you recommend this be implemented?
> 
> kernel  cpu -> |              CPU has PAE              |  CPU lacks PAE  |
>    |           |       CPU has NX  | CPU lacks NX      |                 |
>    V           +-------------------+-------------------+-----------------+
> 32-bit non-PAE | missing in kernel | missing in kernel |    no message   |
>                +-------------------+-------------------+-----------------+
> 32-bit PAE     | active *          | missing in CPU    |    no message   |
>                +-------------------+-------------------+-----------------+
> 64-bit         | active            | missing in CPU    |    impossible   |
>                +-------------------+-------------------+-----------------+
> The box with the "*" is the only message currently reported by the kernel.

The last column should actually be "no message", "impossible", "impossible".

I also think "missing in kernel" is misleading in the 32-bit non-PAE,
no-NX case (as it would imply that another kernel could do something),
and I *really* fail to see why it is in any way different from the "CPU
lacks PAE" case -- which also means no NX.  "Unavailable in CPU" seems
to beat everything.

So the logic that makes sense would be:

if (!cpu_has_nx) {
	/* If the CPU can't do it... */
	printk(KERN_INFO "cpu: NX protection unavailable in CPU\n");
} else  {
#if defined(CONFIG_X86_32) && !defined(CONFIG_X86_PAE)
	/* Non-PAE kernel: NX unavailable */
	printk(KERN_NOTICE "cpu: NX protection missing in kernel\n");
#else
	printk(KERN_INFO "cpu: NX protection active\n");
#endif
}
