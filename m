Return-Path: <linux-kernel-owner+w=401wt.eu-S1758795AbXH1UWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795AbXH1UWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 16:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759002AbXH1UV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 16:21:57 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:65347 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756181AbXH1UVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 16:21:55 -0400
Date: Tue, 28 Aug 2007 13:21:35 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: B.Steinbrink@gmx.de
Cc: dwalker@mvista.com, ak@suse.de, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: nmi_watchdog=2 regression in 2.6.21
Message-ID: <20070828202135.GC2814@frankl.hpl.hp.com>
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

Bjorn,

It looks like we need to revisit the patch that makes the NMI
watchdog use the 2nd counter (PERFREVTSEL1/PMC1) for architectural
perfmon.

The Intel Core Duo processor has a bug (AE49) with the enable bit of the 2nd
counter not working. The Core 2 Duo/Quad processors also implement architectural
perfmon but they do not have the bug. Furthermore, they implement PEBS which
requires the use of the 1st counter.

I think we need to distinguish the 2 situtations. For Core Duo use the 1st counter,
for other architectural perfmon processor use the 2nd. That means we cannot simply
rely on X86_FEATURE_ARCH_PERFMON we need to check family/model number.

Thanks.


On Tue, Aug 28, 2007 at 11:30:35AM -0700, Daniel Walker wrote:
> On Tue, 2007-08-28 at 10:05 -0700, Stephane Eranian wrote:
> > Daniel,
> > 
> > On Tue, Aug 28, 2007 at 07:34:44AM -0700, Daniel Walker wrote:
> > > On Tue, 2007-08-28 at 02:12 -0700, Stephane Eranian wrote:
> > > > Daniel,
> > > > 
> > > > On Mon, Aug 27, 2007 at 04:07:54PM -0700, Daniel Walker wrote:
> > > > > On Mon, 2007-08-27 at 15:55 -0700, Stephane Eranian wrote:
> > > > > 
> > > > > > Yet the model name looks strange. So we need to run one more test,
> > > > > > as the fam/model is not enough. What we need to check is whether or
> > > > > > not this processor implements architectural perfmon or not.
> > > > > > 
> > > > > > Could you please compile and run the attached program and send me 
> > > > > > the output?
> > > > > 
> > > > > The output below is all the output ..
> > > > > 
> > > > > eax=0x7280201: version=1  num_cnt=2
> > > > > 
> > > > Then you have a Core Duo processor and the commit from Bjorn should
> > > > fix the problem. If it does not, then there is something else wrong.
> > > > Unfortunately, I do not have a Core Duo machine to try and reproduce.
> > > 
> > > There must be something else wrong, cause the problem persists .. As I
> > > said in past emails to Bjorn, I tested his commit in git, as well as the
> > > latest git all with the same issue (as well as bisecting git)..
> > > 
> > > If the hardware is buggy then we need some way to determine that..
> > > 
> > Could you instrument check_nmi_watchdog() to verify that you terminate
> > this function? Normally there is a safety mechanism in there.
> > 
> > Another  possibility is that you get flooded with NMI interrupts and
> > do not make forward progress.
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
> 
> It seems like there might be some other interrupt going off too early,
> that causes the system to hang..
> 
> As you can see from the log above, this system is a quad.. Two physical
> cpus each with two cores.
> 
> Daniel

-- 

-Stephane
