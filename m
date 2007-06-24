Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbXFXMoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbXFXMoE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 08:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755167AbXFXMnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 08:43:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35722 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873AbXFXMnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 08:43:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
Date: Sun, 24 Jun 2007 14:50:39 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>, linux-kernel@vger.kernel.org,
       ak@suse.de
References: <20070606231642.GH13751@tree.beaverton.ibm.com> <20070623165841.1c8f705c.akpm@linux-foundation.org> <m1abuq89ke.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1abuq89ke.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706241450.40595.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 24 June 2007 02:45, Eric W. Biederman wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > On Sun, 24 Jun 2007 01:54:52 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> >
> >> On Wednesday, 20 June 2007 00:08, Siddha, Suresh B wrote:
> >> > On Tue, Jun 19, 2007 at 01:49:30PM -0700, Darrick J. Wong wrote:
> >> > > 
> >> > > This fixes the problem!  Hurrah!
> >> > 
> >> > Great!  Andrew, please include the appended patch in -mm.
> >> > 
> >> > ----
> >> > Subject: [patch] x86_64, irq: use mask/unmask and proper locking in
> > fixup_irqs
> >> > From: Suresh Siddha <suresh.b.siddha@intel.com>
> >> > 
> >> > Force irq migration path during cpu offline, is not using proper
> >> > locks and irq_chip mask/unmask routines. This will result in
> >> > some races(especially the device generating the interrupt can see
> >> > some inconsistent state, resulting in issues like stuck irq,..).
> >> > 
> >> > Appended patch fixes the issue by taking proper lock and
> >> > encapsulating irq_chip set_affinity() with a mask() before and an
> >> > unmask() after.
> >> > 
> >> > This fixes a MSI irq stuck issue reported by Darrick Wong.
> >> > 
> >> > There are several more general bugs in this area(irq migration in the
> >> > process context). For example,
> >> > 
> >> > 1. Possibility of missing edge triggered irq.
> >> > 2. Reliable method of migrating level triggered irq in the process context.
> >> > 
> >> > We plan to look and close these in the near future.
> >> 
> >> This patch breaks hibernation on my Turion 64 X2 - based testbox (HPC nx6325).
> >> 
> >> _cpu_down() just hangs as though there were a deadlock in there, 100% of the
> >> time.
> >> 
> >
> > Thanks, I dropped it.
> 
> Hmm.  It looks like Siddha sent the wrong version of the patch.
> The working tested version had an additional test to ensure
> the mask and unmask methods were implemented.
> 
> i.e.
> +		if (irq_desc[irq].chip->mask)
> +			irq_desc[irq].chip->mask(irq);
> and
> 
> +		if (irq_desc[irq].chip->unmask)
> +			irq_desc[irq].chip->unmask(irq);
> +
> 
> Siddha think you can resend the correct version.
> 
> Rafael.  Think you can add those two ifs and see if you test bed box
> works?

Yes, that helps.

For reference I'm appending the complete patch that I have tested.

Greetings,
Rafael


---
 arch/x86_64/kernel/irq.c |   32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

Index: linux-2.6.22-rc5/arch/x86_64/kernel/irq.c
===================================================================
--- linux-2.6.22-rc5.orig/arch/x86_64/kernel/irq.c	2007-06-24 14:28:33.000000000 +0200
+++ linux-2.6.22-rc5/arch/x86_64/kernel/irq.c	2007-06-24 14:31:11.000000000 +0200
@@ -144,17 +144,43 @@ void fixup_irqs(cpumask_t map)
 
 	for (irq = 0; irq < NR_IRQS; irq++) {
 		cpumask_t mask;
+		int break_affinity = 0;
+		int set_affinity = 1;
+
 		if (irq == 2)
 			continue;
 
+		/* interrupt's are disabled at this point */
+		spin_lock(&irq_desc[irq].lock);
+
+		if (!irq_has_action(irq) ||
+		    cpus_equal(irq_desc[irq].affinity, map)) {
+			spin_unlock(&irq_desc[irq].lock);
+			continue;
+		}
+
 		cpus_and(mask, irq_desc[irq].affinity, map);
-		if (any_online_cpu(mask) == NR_CPUS) {
-			printk("Breaking affinity for irq %i\n", irq);
+		if (cpus_empty(mask)) {
+			break_affinity = 1;
 			mask = map;
 		}
+
+		if (irq_desc[irq].chip->mask)
+			irq_desc[irq].chip->mask(irq);
+
 		if (irq_desc[irq].chip->set_affinity)
 			irq_desc[irq].chip->set_affinity(irq, mask);
-		else if (irq_desc[irq].action && !(warned++))
+		else if (!(warned++))
+			set_affinity = 0;
+
+		if (irq_desc[irq].chip->unmask)
+			irq_desc[irq].chip->unmask(irq);
+
+		spin_unlock(&irq_desc[irq].lock);
+
+		if (break_affinity && set_affinity)
+			printk("Broke affinity for irq %i\n", irq);
+		else if (!set_affinity)
 			printk("Cannot set affinity for irq %i\n", irq);
 	}
 
