Return-Path: <linux-kernel-owner+w=401wt.eu-S1760505AbXH1TrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760505AbXH1TrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbXH1Tq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:46:59 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:63877 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbXH1Tq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:46:58 -0400
Date: Tue, 28 Aug 2007 12:46:36 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>, ak@suse.de,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: nmi_watchdog=2 regression in 2.6.21
Message-ID: <20070828194636.GB2814@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <1186531609.22044.50.camel@imap.mvista.com> <20070808142059.GF30805@atjola.homenet> <20070827175431.GD784@frankl.hpl.hp.com> <1188237331.2435.255.camel@dhcp193.mvista.com> <20070827225555.GI784@frankl.hpl.hp.com> <1188256074.2435.272.camel@dhcp193.mvista.com> <20070828091217.GA1645@frankl.hpl.hp.com> <1188311684.2435.288.camel@dhcp193.mvista.com> <20070828170556.GI1645@frankl.hpl.hp.com> <1188325835.2435.317.camel@dhcp193.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188325835.2435.317.camel@dhcp193.mvista.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel,

On Tue, Aug 28, 2007 at 11:30:35AM -0700, Daniel Walker wrote:
> 
> Here is some output from my boot log,
> 
> md: raid1 personality registered for level 1
> device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
> ip_tables: (C) 2000-2006 Netfilter Core Team
> TCP cubic registered
> NET: Registered protocol family 1
> NET: Registered protocol family 17
> Testing NMI watchdog ... CPU#0: NMI appears to be stuck (0->0)!
> CPU#1: NMI appears to be stuck (0->0)!
> CPU#2: NMI appears to be stuck (0->0)!
> CPU#3: NMI appears to be stuck (0->0)!
> Starting balanced_irq
> <hangs>
> 
> So it does appear to make it out of the check_nmi_watchdog() function
> even tho there is a problem with the watchdog .. "Starting balance_irq"
> is in balanced_irq_init(). It usually hangs at this spot , but with
> initcall_debug on it once hung a little further down ..

I think I found the problem. As I suspected, it seems there is an assymetry
between the 1st end 2nd counter (just like what they have on P6 core). Yet
for architectural perfmon v1, this restriction is supposed to be lifted.

Unfortunately, a quick look at the errata document at
http://download.intel.com/design/mobile/SPECUPDT/30922212.pdf

for Core Duo shows bugs A49 as 'nofix':
  Core Duo processor has a bug which renders the enable bit (22) of
  PERFEVTSEL1 inoperative. The processor behaves like former P6 cores,
  the enable bit of PERFEVTSEL0 controls the activation of both counters

That explains why you get the 'NMI stuck' message when using PERFEVTSEL1.
I suspect when using PERFEVTSEL0, then NMI watchdog is not stuck. So it
is possible that in case NMI is stuck the code does not cleanly shutdown the
NMI interrupt and you get some spurious NMI interrupt later in the boot at
you are stuck because you are holding a lock. We need to look at the error
path of check_nmi_watchdog(). I glance through it and could not find the place
where the APIC vector is cleared.

> It seems like there might be some other interrupt going off too early,
> that causes the system to hang..
> 
> As you can see from the log above, this system is a quad.. Two physical
> cpus each with two cores.
> 

-- 

-Stephane
