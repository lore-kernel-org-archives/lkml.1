Return-Path: <linux-kernel-owner+w=401wt.eu-S1030780AbXCGDHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030780AbXCGDHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 22:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030778AbXCGDHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 22:07:06 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:47142 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030783AbXCGDHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 22:07:04 -0500
X-IronPort-AV: i="4.14,256,1170662400"; 
   d="scan'208"; a="45929639:sNHT47056545"
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@stusta.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch] disable NMI watchdog by default
X-Message-Flag: Warning: May contain useful information
References: <20070305122011.GA16133@elte.hu>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 06 Mar 2007 19:06:58 -0800
In-Reply-To: <20070305122011.GA16133@elte.hu> (Ingo Molnar's message of "Mon, 5 Mar 2007 13:20:11 +0100")
Message-ID: <ada1wk1ycod.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 Mar 2007 03:06:58.0607 (UTC) FILETIME=[AB5953F0:01C76065]
Authentication-Results: sj-dkim-6; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim6002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > --- linux.orig/include/asm-x86_64/nmi.h
 > +++ linux/include/asm-x86_64/nmi.h
 > @@ -63,7 +63,7 @@ extern int setup_nmi_watchdog(char *);
 >  
 >  extern atomic_t nmi_active;
 >  extern unsigned int nmi_watchdog;
 > -#define NMI_DEFAULT	-1
 > +#define NMI_DEFAULT	0

Maybe I'm missing something obvious, but this patch doesn't seem
correct to me.  The sentiment of disabling the NMI watchdog by default
is fine, and I agree with it, but I don't think this patch does what
it says.  First of all, I have a system running a kernel with this
patch applied (v2.6.21-rc2-gc3442e2), and I see NMIs in
/proc/interrupts and "testing NMI watchdog ... OK." in the log.

And second, looking at the NMI code, it seems that this change
actually makes it impossible to turn off the NMI watchdog!  In
arch/x86_64/kernel/nmi.c, we have:

void nmi_watchdog_default(void)
{
	if (nmi_watchdog != NMI_DEFAULT)
		return;
	if (nmi_known_cpu())
		nmi_watchdog = NMI_LOCAL_APIC;
	else
		nmi_watchdog = NMI_IO_APIC;
}

so it seems changing the value of NMI_DEFAULT has no effect on this
logic, really: if nmi_watchdog is left at the default, then the kernel
chooses LAPIC or IO-APIC.  And if someone passes "nmi_watchdog=0" on
the command line, nmi_watchdog is still NMI_DEFAULT and so the same
logic triggers.

Ingo, I assume you tested this, so what am I missing?

 - R.
