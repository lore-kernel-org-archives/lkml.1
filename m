Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbZHYHxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbZHYHxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 03:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbZHYHxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 03:53:12 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:29046 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967AbZHYHxL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 03:53:11 -0400
X-SpamScore: -7
X-BigFish: VPS-7(z1857r34a4j8deiz1432R98dN936eM1442J14e1Ia594izz1202hzzz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KOX9WE-01-1HZ-02
X-M-MSG: 
Date: Tue, 25 Aug 2009 09:52:56 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Gautham Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir@amd.com,
       "Singh <balbir"@linux.vnet.ibm
Subject: Re: [PATCH 8/15] sched: Add parameter sched_mn_power_savings to
	control MN domain sched policy
Message-ID: <20090825075256.GC20811@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com> <20090820133914.GW29327@alberich.amd.com> <1251125778.7538.268.camel@twins> <20090824153229.GL6474@dirshya.in.ibm.com> <1251128714.7538.308.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1251128714.7538.308.camel@twins>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 25 Aug 2009 07:52:58.0324 (UTC) FILETIME=[0FF0D940:01CA2559]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 05:45:14PM +0200, Peter Zijlstra wrote:
> On Mon, 2009-08-24 at 21:02 +0530, Vaidyanathan Srinivasan wrote:
> > * Peter Zijlstra <peterz@infradead.org> [2009-08-24 16:56:18]:
> > 
> > > On Thu, 2009-08-20 at 15:39 +0200, Andreas Herrmann wrote:
> > > > Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> > > > ---
> > > 
> > > > +#ifdef CONFIG_SCHED_MN
> > > > +	if (!err && mc_capable())
> > > > +		err = sysfs_create_file(&cls->kset.kobj,
> > > > +					&attr_sched_mn_power_savings.attr);
> > > > +#endif
> > > 
> > > *sigh* another crappy sysfs file
> > > 
> > > Guys, can't we come up with anything better than sched_*_power_saving=n?
> > > 
> > > This configuration space is _way_ too large, and now it gets even
> > > crazier.
> > 
> > Hi Peter and Andreas,
> > 
> > Actually we had sched_power_savings and related simplifications, but
> > that did not really simplify the interface.
> 
> Well, I prefer a single sched_power knob that either goes on or off.

IMHO all options that are selectable at the moment have to map to that
single knob. One user might want to fill one socket for power savings
but still want to balance tasks between the internal nodes. Another
user wants to have highest possible power savings and likes to see all
threads utilized before another core is used even if the FPU/cache or
whatsoever are shared between threads on the same core.

> A user really isn't interested in exploring a 3^3 configuration space
> {PERF, POWER, POWER-WAKE-BALANCE} x {SMT, MC, MN} in order to find what
> works best.

Why not just give the average user some hints what he should select on
his machine but still let power users decide themselves what best fits
their purpose and provide means/knobs to select what they want?

> > As for this mulit-node MN stuff, Gautham had posted a better solution
> > to propagate the sched_mc flags without need for new sysfs file and
> > related changes.

> > Please take a look at: http://lkml.org/lkml/2009/3/31/137 and
> > http://lkml.org/lkml/2009/3/31/142 which actually degenerates the
> > domain.
> 
> Ah, right, that got lost in my inbox :/ Let me go read those too.
> 
> > However Andreas's requirement seem to indicate multiple nodes within
> > a single socket.  I did not yet completely understand that topology.
> > Some for of smart degeneration may save an additional tunable here.

> Yes, apparently AMD is going to put multiple nodes in a single socket,
> not sure how they do that, Andreas do these chips have multiple memory
> busses?

In contrast to current AMD processors (supporting two DRAM channels
per socket), Magny-Cours (new package type) has four DRAM channels.

> I was thinking chips were pin constrained and wouldn't add a whole
> second memory interface to the package, but what do I know...

For the two new channels of a Magny-Cours processor of course
additional pins are required.


Regards,

Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


