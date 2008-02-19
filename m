Return-Path: <linux-kernel-owner+w=401wt.eu-S1761445AbYBSLXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761445AbYBSLXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 06:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbYBSLWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 06:22:48 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45880 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759141AbYBSLWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 06:22:47 -0500
Date: Tue, 19 Feb 2008 10:37:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: kernel list <linux-kernel@vger.kernel.org>, jikos@suse.cz,
       Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: tsc breaks atkbd suspend
Message-ID: <20080219093738.GA1423@elf.ucw.cz>
References: <20080218133852.GA1573@elf.ucw.cz> <alpine.LFD.1.00.0802181515070.7583@apollo.tec.linutronix.de> <20080218143757.GB1960@elf.ucw.cz> <alpine.LFD.1.00.0802181545090.7583@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802181545090.7583@apollo.tec.linutronix.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

This is wrong:

#ifdef CONFIG_X86_TSC
static int __init tsc_setup(char *str)
{
        printk(KERN_WARNING "notsc: Kernel compiled with
CONFIG_X86_TSC, "
                                "cannot disable TSC.\n");
        return 1;
}
#else
/*
 * disable flag for tsc. Takes effect by clearing the TSC cpu flag
 * in cpu/common.c
 */
static int __init tsc_setup(char *str)
{
        setup_clear_cpu_cap(X86_FEATURE_TSC);
        return 1;
}
#endif

...even if kernel is compiled with X86_TSC, we do disable it in case
it is unstable:

#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86_TSC)
                /* TSC halts in C2, so notify users */
                if (tsc_halts_in_c(ACPI_STATE_C2))
                        mark_tsc_unstable("possible TSC halt in C2");
#endif

...so the commandline option should work, too.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
