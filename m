Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbXFVKFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbXFVKFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 06:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbXFVKFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 06:05:42 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:58238 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbXFVKFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 06:05:40 -0400
Date: Fri, 22 Jun 2007 03:02:38 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       Andi Kleen <ak@suse.de>, mingo@elte.hu, linux-kernel@vger.kernel.org,
       levon@movementarian.org, perfmon@napali.hpl.hp.com,
       oprofile-list@lists.sourceforge.net, wcohen@redhat.com,
       akpm@linux-foundation.org
Subject: Re: [perfmon] Re: [PATCH 1/2] Separate the performance counter allocation from the LAPIC NMI watchdog
Message-ID: <20070622100238.GB28541@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070618103214.GA12045@atjola.homenet> <200706201431.44014.ak@suse.de> <20070620124959.GB24906@frankl.hpl.hp.com> <200706201501.02582.ak@suse.de> <20070620183315.GA3251@atjola.homenet> <20070620215933.GE26200@frankl.hpl.hp.com> <20070621083645.GA26740@frankl.hpl.hp.com> <20070622071354.GA20506@atjola.homenet>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070622071354.GA20506@atjola.homenet>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn,

You have the following registers to consider (for P4/Core):

#define MSR_IA32_PEBS_ENABLE            0x000003f1
#define MSR_CORE_PERF_FIXED_CTR0        0x00000309
#define MSR_CORE_PERF_FIXED_CTR1        0x0000030a
#define MSR_CORE_PERF_FIXED_CTR2        0x0000030b
#define MSR_CORE_PERF_FIXED_CTR_CTRL    0x0000038d
#define MSR_CORE_PERF_GLOBAL_STATUS     0x0000038e
#define MSR_CORE_PERF_GLOBAL_CTRL       0x0000038f
#define MSR_CORE_PERF_GLOBAL_OVF_CTRL   0x00000390


With Barcelona, you'll also have to consider:

#define MSR_AMD64_IBSFETCHCTL           0xc0011030
#define MSR_AMD64_IBSFETCHLINAD         0xc0011031
#define MSR_AMD64_IBSFETCHPHYSAD        0xc0011032
#define MSR_AMD64_IBSOPCTL              0xc0011033
#define MSR_AMD64_IBSOPRIP              0xc0011034
#define MSR_AMD64_IBSOPDATA             0xc0011035
#define MSR_AMD64_IBSOPDATA2            0xc0011036
#define MSR_AMD64_IBSOPDATA3            0xc0011037
#define MSR_AMD64_IBSDCLINAD            0xc0011038
#define MSR_AMD64_IBSDCPHYSAD           0xc0011039
#define MSR_AMD64_IBSCTL                0xc001103A

I think you could organize by groups with a bitmap 
per group and some sorted linked list to keep track
of all of them.


On Fri, Jun 22, 2007 at 09:13:54AM +0200, Bj?rn Steinbrink wrote:
> Hi Stephane,
> 
> On 2007.06.21 01:36:45 -0700, Stephane Eranian wrote:
> > Bjorn,
> > 
> > 
> > On Wed, Jun 20, 2007 at 02:59:33PM -0700, Stephane Eranian wrote:
> > > Bjorn,
> > > 
> > > I ran into one issue related with the new allocator.
> 
> Should be the same with 2.6.21 and earlier, the "new" allocator should
> do exactly the samething, it just fixes the breakage introduced in the
> post-2.6.21 cleanup.
> 
> > > In the case of a Core 2 Duo processor, the PMU implements more
> > > than just basic counters. In particular it supports fixed counters
> > > and PEBS where both use another set of MSRs. Those are not within
> > > a 66 bit distance from MSR_ARCH_PERFMON_EVNTSEL0. Thus the allocator
> > > fails with an assertion.
> 
> How far away are they?
> 
> > > 
> > > I do know that perfmon is the only consumer of those extended 
> > > features TODAY. Yet I think we need to define the allocator such
> > > that it can work with other "distant" MSRs as well.
> > > 
> > 
> > I think that a workaround for this issue could be for the allocator
> > to grant the requests for registers outside of the range, i.e., register
> > that it does not see/manage.
> 
> That would also allow multiple subsystems to use them at the same time.
> And whoever adds the second user of those MSRs might not be aware of the
> just-grant-it policy of the allocator. And bugs that arise due to such
> problems will probably become a real PITA to track down.
> 
> Unfortunately, I don't see any elegant solution to this atm, and of
> course making your code simply circumvent the allocator isn't an option
> either.
> 
> Thanks,
> Björn
> 
> -------------------------------------------------------------------------
> This SF.net email is sponsored by DB2 Express
> Download DB2 Express C - the FREE version of DB2 express and take
> control of your XML. No limits. Just data. Click to get it now.
> http://sourceforge.net/powerbar/db2/
> _______________________________________________
> oprofile-list mailing list
> oprofile-list@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/oprofile-list

-- 

-Stephane
