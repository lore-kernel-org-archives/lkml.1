Return-Path: <linux-kernel-owner+w=401wt.eu-S1757935AbZKJToC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbZKJToC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 14:44:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757912AbZKJToB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 14:44:01 -0500
Received: from smtp.outflux.net ([198.145.64.163]:47321 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757579AbZKJToA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 14:44:00 -0500
Date: Tue, 10 Nov 2009 11:43:04 -0800
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
Message-ID: <20091110194304.GW5129@outflux.net>
References: <4ADD1E03.4070200@zytor.com>
 <20091020045513.GU5394@outflux.net>
 <20091109221015.GB5129@outflux.net>
 <4AF8A2C0.5080700@zytor.com>
 <20091110154956.GF5129@outflux.net>
 <4AF9991B.20400@zytor.com>
 <20091110165738.GH5129@outflux.net>
 <4AF99F0C.2050806@zytor.com>
 <20091110174622.GK5129@outflux.net>
 <4AF9B6AD.8020505@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF9B6AD.8020505@zytor.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 10:53:33AM -0800, H. Peter Anvin wrote:
> On 11/10/2009 09:46 AM, Kees Cook wrote:
> > 
> > The kernel as-is does not set nx_enabled for 64-bit, so this message is
> > skipped completely:
> > 
> >         if (nx_enabled)
> >                 printk(KERN_INFO "NX (Execute Disable) protection: active\n");
> > 
> > The only time this printk is shown is on 32-bit with PAE (with NX).
> > There is no "else" currently.
> > 
> 
> The structure you have is:
> 
> 	if (nx_enabled)
> 	else if (cpu_has_pae)
> 
> The test for cpu_has_pae is unconditional (you only #ifdef the message)
> -- in fact, this should cause a compile-time error on 64 bits:
> 
> #undef  cpu_has_pae
> #define cpu_has_pae             ___BUG___

This is fun.  CONFIG_X86_PAE isn't defined for 64-bit, and using
cpu_has_pae on 64-bit is considered a bug.  :)

Here is the matrix of what I want to see reported about NX at boot time.
How do you recommend this be implemented?

kernel  cpu -> |              CPU has PAE              |  CPU lacks PAE  |
   |           |       CPU has NX  | CPU lacks NX      |                 |
   V           +-------------------+-------------------+-----------------+
32-bit non-PAE | missing in kernel | missing in kernel |    no message   |
               +-------------------+-------------------+-----------------+
32-bit PAE     | active *          | missing in CPU    |    no message   |
               +-------------------+-------------------+-----------------+
64-bit         | active            | missing in CPU    |    impossible   |
               +-------------------+-------------------+-----------------+
The box with the "*" is the only message currently reported by the kernel.


this looks ugly, but does it:

#if defined(CONFIG_X86_32)
	else if (cpu_has_pae)
#else
	else
#endif
#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
		/* PAE kernel, PAE CPU, without NX */
		printk(KERN_NOTICE "Notice: NX (Execute Disable) protection "
		       "missing in CPU or disabled in BIOS!\n");
#else
		/* 32bit non-PAE kernel, PAE CPU */
		printk(KERN_NOTICE "Notice: NX (Execute Disable) protection "
		       "cannot be enabled: non-PAE kernel!\n");
#endif


-- 
Kees Cook
Ubuntu Security Team
