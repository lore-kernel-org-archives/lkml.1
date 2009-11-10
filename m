Return-Path: <linux-kernel-owner+w=401wt.eu-S1758170AbZKJU4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbZKJU4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 15:56:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758130AbZKJU4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 15:56:31 -0500
Received: from smtp.outflux.net ([198.145.64.163]:55594 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758129AbZKJU4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 15:56:30 -0500
Date: Tue, 10 Nov 2009 12:55:44 -0800
From: Kees Cook <kees.cook@canonical.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Jan Beulich <jbeulich@novell.com>, Vegard Nossum <vegardno@ifi.uio.no>,
       Yinghai Lu <yinghai@kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] [x86] detect and report lack of NX protections
Message-ID: <20091110205544.GZ5129@outflux.net>
References: <20091109221015.GB5129@outflux.net>
 <4AF8A2C0.5080700@zytor.com>
 <20091110154956.GF5129@outflux.net>
 <4AF9991B.20400@zytor.com>
 <20091110165738.GH5129@outflux.net>
 <4AF99F0C.2050806@zytor.com>
 <20091110174622.GK5129@outflux.net>
 <4AF9B6AD.8020505@zytor.com>
 <20091110194304.GW5129@outflux.net>
 <4AF9C627.1070206@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF9C627.1070206@zytor.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 11:59:35AM -0800, H. Peter Anvin wrote:
> On 11/10/2009 11:43 AM, Kees Cook wrote:
> > kernel  cpu -> |              CPU has PAE              |  CPU lacks PAE  |
> >    |           |       CPU has NX  | CPU lacks NX      |                 |
> >    V           +-------------------+-------------------+-----------------+
> > 32-bit non-PAE | missing in kernel | missing in kernel |    no message   |
> >                +-------------------+-------------------+-----------------+
> > 32-bit PAE     | active *          | missing in CPU    |    no message   |
> >                +-------------------+-------------------+-----------------+
> > 64-bit         | active            | missing in CPU    |    impossible   |
> >                +-------------------+-------------------+-----------------+
> > The box with the "*" is the only message currently reported by the kernel.
> 
> The last column should actually be "no message", "impossible", "impossible".

Ah, yes, very true.

> I also think "missing in kernel" is misleading in the 32-bit non-PAE,
> no-NX case (as it would imply that another kernel could do something),

Well, I think thinking that even if they turned on the flag in the BIOS,
the non-PAE kernel couldn't do anything about it anyway.  But, from your
example, I see you went with "missing in kernel" anyway.

> and I *really* fail to see why it is in any way different from the "CPU
> lacks PAE" case -- which also means no NX.  "Unavailable in CPU" seems
> to beat everything.

I was trying to be conservative and not have older hardware without PAE
yelling about missing features.  It seemed only worth complaining about
missing NX if PAE was possible (the class of machines without PAE being
larger than those without NX and with PAE).

> So the logic that makes sense would be:
> 
> if (!cpu_has_nx) {

cpu_has_nx is not the same as nx_enabled (due to disable_nx).  Also, why
doesn't set_nx() use cpu_has_nx?  It seems like it does the check
manually?  Should that be cleaned up?

> 	/* If the CPU can't do it... */
> 	printk(KERN_INFO "cpu: NX protection unavailable in CPU\n");
> } else  {
> #if defined(CONFIG_X86_32) && !defined(CONFIG_X86_PAE)
> 	/* Non-PAE kernel: NX unavailable */
> 	printk(KERN_NOTICE "cpu: NX protection missing in kernel\n");
> #else
> 	printk(KERN_INFO "cpu: NX protection active\n");
> #endif
> }

How about this?  (Along with the nx_enabled setting in set_nx() for the
64-bit and 32-bit+PAE case.)

        set_nx();
        if (nx_enabled) {
                printk(KERN_INFO "NX (Execute Disable) protection: active\n");
#if defined(CONFIG_X86_32) && !defined(CONFIG_X86_PAE)
        } else if (cpu_has_pae) {
                /* 32bit non-PAE kernel, PAE CPU */
                printk(KERN_NOTICE "Notice: NX (Execute Disable) protection "
                       "cannot be enabled: non-PAE kernel!\n");
#else
        } else {
                /* PAE kernel, PAE CPU, without NX */
                printk(KERN_NOTICE "Notice: NX (Execute Disable) protection "
                       "missing in CPU or disabled in BIOS!\n");
#endif
        }


-- 
Kees Cook
Ubuntu Security Team
