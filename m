Return-Path: <linux-kernel-owner+w=401wt.eu-S933809AbXKOXJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933809AbXKOXJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 18:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932208AbXKOXJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 18:09:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:45499 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106AbXKOXJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 18:09:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,422,1188802800"; 
   d="scan'208";a="205874846"
Date: Thu, 15 Nov 2007 15:01:46 -0800
From: mark gross <mgross@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] pm-qos-remove-locks-around-blocking-notifier.patch ... was
	Re: 2.6.24-rc2-mm1
Message-ID: <20071115230146.GB6395@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20071113175906.497a1a6a.akpm@linux-foundation.org> <473A678C.2020507@googlemail.com> <473A76FA.4050701@googlemail.com> <20071114202959.GA21049@linux.intel.com> <20071114124008.095f307d.akpm@linux-foundation.org> <20071115191950.GA8002@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071115191950.GA8002@linux.intel.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 11:19:50AM -0800, mark gross wrote:
> On Wed, Nov 14, 2007 at 12:40:08PM -0800, Andrew Morton wrote:
> > On Wed, 14 Nov 2007 12:29:59 -0800 mark gross <mgross@linux.intel.com> wrote:
> > 
> > > > > [  102.366932]  =======================
> > > > > [  108.552031] printk: 31 messages suppressed.
> > > > 
> > > > 
> > > > All this BUG / WARNINGS are caused by *-qos* patches. Reverting this 3 patches makes the BUGs go away :
> > > > 
> > > > latencyc-use-qos-infrastructure.patch
> > > > pm-qos-infrastructure-and-interface.patch
> > > > pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
> > > > 
> > > > 
> > > > Gabriel
> > > > 
> > > > 
> > > This looks like the same issue Rafael saw.
> > > 
> > > Try the patch in the following post:
> > > 
> > > http://marc.info/?l=linux-kernel&m=119265627228498&w=2
> > > 
> > 
> > Well that's not very good.  _I_ can go fishing in my lkml archives for random
> > patches but not everyone is set up to do that.  And the diff to which you
> > refer gets 100% rejects against rc2-mm1 anyway.
> > 
> > Please prepare a tested, changelogged patch against rc2-mm1 asap.  
> 
> 
pm-qos-remove-locks-around-blocking-notifier.patch

I have done some testing with this fix, I think it addresses all the
sleep within a held lock warnings reported.

please apply.

Changelog: 
Remove spin locking around all blocking notifier calls that can sleep.
I had to re-structure some of the code to avoid locking issues.

--mgross

Signed-off-by: mark gross <mgross@linux.intel.com>

 
Index: linux-2.6.24-rc2-mm1/kernel/pm_qos_params.c
===================================================================
--- linux-2.6.24-rc2-mm1.orig/kernel/pm_qos_params.c	2007-11-15 11:09:27.000000000 -0800
+++ linux-2.6.24-rc2-mm1/kernel/pm_qos_params.c	2007-11-15 14:10:09.000000000 -0800
@@ -135,13 +135,14 @@
 }
 
 
-
-/* assumes pm_qos_lock is held */
 static void update_target(int target)
 {
 	s32 extreme_value;
 	struct requirement_list *node;
+	unsigned long flags;
+	int call_notifier = 0;
 
+	spin_lock_irqsave(&pm_qos_lock, flags);
 	extreme_value = pm_qos_array[target]->default_value;
 	list_for_each_entry(node,
 			&pm_qos_array[target]->requirements.list, list) {
@@ -149,13 +150,16 @@
 				extreme_value, node->value);
 	}
 	if (pm_qos_array[target]->target_value != extreme_value) {
+		call_notifier = 1;
 		pm_qos_array[target]->target_value = extreme_value;
 		pr_debug(KERN_ERR "new target for qos %d is %d\n", target,
 			pm_qos_array[target]->target_value);
-		blocking_notifier_call_chain(pm_qos_array[target]->notifiers,
-			(unsigned long) pm_qos_array[target]->target_value,
-						NULL);
 	}
+	spin_unlock_irqrestore(&pm_qos_lock, flags);
+
+	if (call_notifier)
+		blocking_notifier_call_chain(pm_qos_array[target]->notifiers,
+			(unsigned long) extreme_value, NULL);
 }
 
 static int register_pm_qos_misc(struct pm_qos_object *qos)
@@ -227,8 +231,8 @@
 		spin_lock_irqsave(&pm_qos_lock, flags);
 		list_add(&dep->list,
 			&pm_qos_array[pm_qos_class]->requirements.list);
-		update_target(pm_qos_class);
 		spin_unlock_irqrestore(&pm_qos_lock, flags);
+		update_target(pm_qos_class);
 
 		return 0;
 	}
@@ -269,11 +273,10 @@
 			break;
 		}
 	}
+	spin_unlock_irqrestore(&pm_qos_lock, flags);
 	if (pending_update)
 		update_target(pm_qos_class);
 
-	spin_unlock_irqrestore(&pm_qos_lock, flags);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(pm_qos_update_requirement);
@@ -303,9 +306,9 @@
 			break;
 		}
 	}
+	spin_unlock_irqrestore(&pm_qos_lock, flags);
 	if (pending_update)
 		update_target(pm_qos_class);
-	spin_unlock_irqrestore(&pm_qos_lock, flags);
 }
 EXPORT_SYMBOL_GPL(pm_qos_remove_requirement);
 
@@ -319,13 +322,10 @@
  */
  int pm_qos_add_notifier(int pm_qos_class, struct notifier_block *notifier)
 {
-	unsigned long flags;
 	int retval;
 
-	spin_lock_irqsave(&pm_qos_lock, flags);
 	retval = blocking_notifier_chain_register(
 			pm_qos_array[pm_qos_class]->notifiers, notifier);
-	spin_unlock_irqrestore(&pm_qos_lock, flags);
 
 	return retval;
 }
@@ -341,13 +341,10 @@
  */
 int pm_qos_remove_notifier(int pm_qos_class, struct notifier_block *notifier)
 {
-	unsigned long flags;
 	int retval;
 
-	spin_lock_irqsave(&pm_qos_lock, flags);
 	retval = blocking_notifier_chain_unregister(
 			pm_qos_array[pm_qos_class]->notifiers, notifier);
-	spin_unlock_irqrestore(&pm_qos_lock, flags);
 
 	return retval;
 }
