Return-Path: <linux-kernel-owner+w=401wt.eu-S1765833AbXHNUuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765833AbXHNUuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 16:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757988AbXHNUuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 16:50:05 -0400
Received: from smtp104.sbc.mail.mud.yahoo.com ([68.142.198.203]:39662 "HELO
	smtp104.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755851AbXHNUuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 16:50:02 -0400
X-YMail-OSG: WFkhfgMVM1lQR8_mHbC_RGaWgPzrhO4Pqsoxl.yM2NtQeJSl
Date: Tue, 14 Aug 2007 15:49:51 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, clameter@sgi.com,
       bob.picco@hp.com, nacc@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com,
       mel@skynet.ie, akpm@linux-foundation.org,
       Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       ckrm-tech <ckrm-tech@lists.sourceforge.net>
Subject: Re: Regression in 2.6.23-rc2-mm2, mounting cpusets causes a hang
Message-ID: <20070814204951.GA2065@vino.hallyn.com>
References: <20070812152126.GA26239@linux.vnet.ibm.com> <20070813201215.GA16908@vino.hallyn.com> <1187103831.6281.24.camel@localhost> <20070814180339.GA32553@vino.hallyn.com> <1187115224.6281.40.camel@localhost> <20070814192306.GB32553@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070814192306.GB32553@vino.hallyn.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge E. Hallyn (serge@hallyn.com):
> Quoting Lee Schermerhorn (Lee.Schermerhorn@hp.com):
> > On Tue, 2007-08-14 at 13:03 -0500, Serge E. Hallyn wrote:
> > > Quoting Lee Schermerhorn (Lee.Schermerhorn@hp.com):
> > > > On Mon, 2007-08-13 at 15:12 -0500, Serge E. Hallyn wrote:
> > > > > Quoting Dhaval Giani (dhaval@linux.vnet.ibm.com):
> > > > > > Hi,
> > > > > > 
> > > > > > On mounting cpusets using containers, I have been hitting the following
> > > > > > bug.
> > > > > > 
> > > > > > 
> > > > > > -----------[ cut here ]------------
> > > > > > kernel BUG at kernel/cpuset.c:331!
> > > > <snip>
> > > > > > CONFIG_HIGHMEM=y
> > > > > > CONFIG_X86_PAE=y
> > > > > > # CONFIG_NUMA is not set
> > > > > > CONFIG_ARCH_POPULATES_NODE_MAP=y
> > > > > > CONFIG_SELECT_MEMORY_MODEL=y
> > > > > > CONFIG_FLATMEM_MANUAL=y
> > > > > > # CONFIG_DISCONTIGMEM_MANUAL is not set
> > > > > > # CONFIG_SPARSEMEM_MANUAL is not set
> > > > > > CONFIG_FLATMEM=y
> > > > > > CONFIG_FLAT_NODE_MEM_MAP=y
> > > > > > # CONFIG_SPARSEMEM_STATIC is not set
> > > > > > CONFIG_SPLIT_PTLOCK_CPUS=4
> > > > > > CONFIG_RESOURCES_64BIT=y
> > > > > > CONFIG_ZONE_DMA_FLAG=1
> > > > <snip>
> > > > > 
> > > > > Yeah, I'm seeing the same thing.  Oddly, my node_states[N_NORMAL_MEMORY]
> > > > > and node_states[N_HIGH_MEMORY] are empty, while node_states[N_ONLINE]
> > > > > contains my single cpu (on i386 kvm image).
> > > > > 
> > > > > -serge
> > > > 
> > > > Yes, you'll definitely hit that BUG if the N_HIGH_MEMORY mask is empty.
> > > > So far, I can't see how this could be, tho'.  __build_all_zonelists()
> > > > should be called for non-NUMA as well as NUMA.  It iterates over "all
> > > 
> > > Yup, and it is, and some debug statements insist that
> > > node_set_state(nid, N_HIGH_MEMORY) is being called for cpu 0,
> > > and the state is in fact being correctly set.
> > > 
> > > So it must get cleared later...
> > 
> > OK.  That helps.  I'll see what I can find...
> 
> Well apparently I lied?  I don't think it's getting cleared in node_states.
> I'm doing:
> 
> static void guarantee_online_mems(const struct cpuset *cs, nodemask_t *pmask)
> {
>         int nid=0;
>         printk(KERN_NOTICE "%s: at top, node %d is %d\n",
>                 __FUNCTION__, nid, node_state(nid, N_HIGH_MEMORY));
>         while (cs && !nodes_intersects(cs->mems_allowed,
>                                         node_states[N_HIGH_MEMORY])) {
>                 printk(KERN_NOTICE "%s: in loop\n", __FUNCTION__);
>                 cs = cs->parent;
>         }
>         if (cs) {
>                 printk(KERN_NOTICE "%s: cs was true\n", __FUNCTION__);
>                 nodes_and(*pmask, cs->mems_allowed,
>                                         node_states[N_HIGH_MEMORY]);
>         }
>         else
>         {
>                 printk(KERN_NOTICE "%s: cs was false\n", __FUNCTION__);
>                 *pmask = node_states[N_HIGH_MEMORY];
>         }
>         printk(KERN_NOTICE "%s: at bottom, node %d is %d\n",
>                 __FUNCTION__, nid, node_state(nid, N_HIGH_MEMORY));
>         printk(KERN_NOTICE "%s: at bottom, in pmask node %d is %d\n",
>                 __FUNCTION__, nid, node_isset(nid, *pmask));
>         BUG_ON(!nodes_intersects(*pmask, node_states[N_HIGH_MEMORY]));
> }
> 
> and getting:
> 
> guarantee_online_mems: in loop
> guarantee_online_mems: cs was false
> guarantee_online_mems: at bottom, node 0 is 1
> guarantee_online_mems: at bottom, in pmask node 0 is 0
> 
> 
> So I'm guess that
> 	*pmask = node_states[N_HIGH_MEMORY];
> isn't doing what it was intended to do?  That or I've got node_state()
> wrong...

Argh.

CONFIG_NODES_SHIFT was unset, so MAX_NUMNODES=1, so
node_state() and node_set_state() are dummies.

So __build_all_zonelists is using the dummy node_state() and
not actually setting node_states[N_HIGH_MEMORY], and my debug
statements were using the dumy node_state() which returns 1
if n==0  :)

Here is a patch which fixes the bug on my system.  As noted in
the patch description, there are other calls to node_set_state() in
mm/page_alloc.c which might also need to be switched to node_set(),
if this is deemed the right solution.

thanks,
-serge


>From 8cffdf9bc60af3894858bcc9412aa80938064435 Mon Sep 17 00:00:00 2001
From: sergeh@us.ibm.com <hallyn@kernel.(none)>
Date: Tue, 14 Aug 2007 13:47:51 -0700
Subject: [PATCH 1/1] memoryless: actually set node_states[N_HIGH_MEMORY]

If CONFIG_NODES_SHIFT is unset, then MAX_NUMNODES=1, and
node_set_state() does nothing.  This means that __build_all_zonelists()
does not actually set node_states[N_HIGH_MEMORY].  cpusets needs
 node_states[N_HIGH_MEMORY] to be correctly set, or it will raise a
bug when a new cpuset is created.

Switch to using node_set() in __build_all_zonelists() to
make sure it is actually set.

Note there are other calls to node_set_state() in mm/page_alloc.c,
which perhaps should also be modified.  Since this area is completely
foreign to me I thought I'd first make sure this is the right approach.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
---
 mm/page_alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1a40099..111e311 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2443,7 +2443,7 @@ static int __build_all_zonelists(void *dummy)
 
 		/* Any memory on that node */
 		if (pgdat->node_present_pages)
-			node_set_state(nid, N_HIGH_MEMORY);
+			node_set(nid, node_states[N_HIGH_MEMORY]);
 		check_for_regular_memory(pgdat);
 	}
 	return 0;
-- 
1.5.1

