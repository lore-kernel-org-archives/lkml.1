Return-Path: <linux-kernel-owner+w=401wt.eu-S932156AbXKOTTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156AbXKOTTw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 14:19:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758170AbXKOTTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 14:19:44 -0500
Received: from mga05.intel.com ([192.55.52.89]:42045 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756763AbXKOTTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 14:19:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,421,1188802800"; 
   d="scan'208";a="385461244"
Date: Thu, 15 Nov 2007 11:19:50 -0800
From: mark gross <mgross@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2-mm1
Message-ID: <20071115191950.GA8002@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20071113175906.497a1a6a.akpm@linux-foundation.org> <473A678C.2020507@googlemail.com> <473A76FA.4050701@googlemail.com> <20071114202959.GA21049@linux.intel.com> <20071114124008.095f307d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114124008.095f307d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 12:40:08PM -0800, Andrew Morton wrote:
> On Wed, 14 Nov 2007 12:29:59 -0800 mark gross <mgross@linux.intel.com> wrote:
> 
> > > > [  102.366932]  =======================
> > > > [  108.552031] printk: 31 messages suppressed.
> > > 
> > > 
> > > All this BUG / WARNINGS are caused by *-qos* patches. Reverting this 3 patches makes the BUGs go away :
> > > 
> > > latencyc-use-qos-infrastructure.patch
> > > pm-qos-infrastructure-and-interface.patch
> > > pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
> > > 
> > > 
> > > Gabriel
> > > 
> > > 
> > This looks like the same issue Rafael saw.
> > 
> > Try the patch in the following post:
> > 
> > http://marc.info/?l=linux-kernel&m=119265627228498&w=2
> > 
> 
> Well that's not very good.  _I_ can go fishing in my lkml archives for random
> patches but not everyone is set up to do that.  And the diff to which you
> refer gets 100% rejects against rc2-mm1 anyway.
> 
> Please prepare a tested, changelogged patch against rc2-mm1 asap.  

I'm having difficulty coming up with a .config that boots, I'll continue
working on this but the following is what I'm pretty confident will fix
the warnings.  

You should hold off until I get a system booting 2.6.24-rc2-mm1 before
taking this.

pm-qos-remove-locks-around-blocking-notifier-registration.patch

Changelog: 
Remove spin locking around blocking notifier calls that can sleep.

--mgross

Signed-off-by: mark gross <mgross@linux.intel.com>




Index: linux-2.6.24-rc2-mm1/kernel/pm_qos_params.c
===================================================================
--- linux-2.6.24-rc2-mm1.orig/kernel/pm_qos_params.c	2007-11-15 11:09:27.000000000 -0800
+++ linux-2.6.24-rc2-mm1/kernel/pm_qos_params.c	2007-11-15 11:10:08.000000000 -0800
@@ -319,13 +319,10 @@
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
@@ -341,13 +338,10 @@
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
