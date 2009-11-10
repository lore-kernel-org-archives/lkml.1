Return-Path: <linux-kernel-owner+w=401wt.eu-S1757472AbZKJRrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbZKJRrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 12:47:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757417AbZKJRrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 12:47:08 -0500
Received: from smtp.outflux.net ([198.145.64.163]:50164 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757408AbZKJRrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 12:47:07 -0500
Date: Tue, 10 Nov 2009 09:46:22 -0800
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
Message-ID: <20091110174622.GK5129@outflux.net>
References: <4ADD1E03.4070200@zytor.com>
 <20091020045513.GU5394@outflux.net>
 <20091109221015.GB5129@outflux.net>
 <4AF8A2C0.5080700@zytor.com>
 <20091110154956.GF5129@outflux.net>
 <4AF9991B.20400@zytor.com>
 <20091110165738.GH5129@outflux.net>
 <4AF99F0C.2050806@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF99F0C.2050806@zytor.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 09:12:44AM -0800, H. Peter Anvin wrote:
> On 11/10/2009 08:57 AM, Kees Cook wrote:
> > 
> > 64-bit does not set nx_enabled to "1" by default anywhere.  And setting
> > the default to 1 in check_efer() seemed out of place to me.
> > 
> 
> If it doesn't set nx_enabled anywhere, you'll end up with the message
> 
> +	printk(KERN_NOTICE "Notice: NX (Execute Disable) protection "
> +	       "missing in CPU or disabled in BIOS!\n");
> 
> which seems obviously wrong... no?

The kernel as-is does not set nx_enabled for 64-bit, so this message is
skipped completely:

        if (nx_enabled)
                printk(KERN_INFO "NX (Execute Disable) protection: active\n");

The only time this printk is shown is on 32-bit with PAE (with NX).
There is no "else" currently.


My patch seeks to do two things:
 - report the "active" message on 64-bit (if not disabled in check_efer())
 - report "zomg NX missing" for all cases when PAE is available to the CPU.

To implement the first, the set_nx() routine for non-PAE 32-bit and all
64-bit needs to have nx_enabled set correctly (which is done in the second
set_nx() that was empty in arch/x86/mm/setup_nx.c).

To implement the second, the following logic is then added to the "if
(nx_enabled)" case in arch/x86/mm/init.c as an "else":

        else if (cpu_has_pae)
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
