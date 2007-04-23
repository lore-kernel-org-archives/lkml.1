Return-Path: <linux-kernel-owner+w=401wt.eu-S1161369AbXDWLIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161369AbXDWLIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 07:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161373AbXDWLIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 07:08:22 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:46770 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161369AbXDWLIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 07:08:21 -0400
Message-ID: <462C9375.5030901@linux.vnet.ibm.com>
Date: Mon, 23 Apr 2007 16:37:33 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 1.5.0.5 (X11/20060728)
MIME-Version: 1.0
To: menage@google.com
CC: akpm@linux-foundation.org, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, vatsa@in.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
Subject: Re: [PATCH 0/7] Containers (V8): Generic Process Containers
References: <20070406233221.989528000@menage.corp.google.com>
In-Reply-To: <20070406233221.989528000@menage.corp.google.com>
Content-Type: multipart/mixed;
 boundary="------------080409020304030505050101"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080409020304030505050101
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Paul,

In [patch 3/7] Containers (V8): Add generic multi-subsystem API to
containers, you have forcefully enabled interrupt in
container_init_subsys() with spin_unlock_irq() which breaks on PPC64.


> +static void container_init_subsys(struct container_subsys *ss) {
> +	int retval;
> +	struct list_head *l;
> +	printk(KERN_ERR "Initializing container subsys %s\n",
> ss->name);
> +
> +	/* Create the top container state for this subsystem */
> +	ss->root = &rootnode;
> +	retval = ss->create(ss, dummytop);
> +	BUG_ON(retval);
> +	init_container_css(ss, dummytop);
> +
> +	/* Update all container groups to contain a subsys
> +	 * pointer to this state - since the subsystem is
> +	 * newly registered, all tasks and hence all container
> +	 * groups are in the subsystem's top container. */
> +	spin_lock_irq(&container_group_lock);
> +	l = &init_container_group.list;
> +	do {
> +		struct container_group *cg =
> +			list_entry(l, struct container_group, list);
> +		cg->subsys[ss->subsys_id] =
> dummytop->subsys[ss->subsys_id];
> +		l = l->next;
> +	} while (l != &init_container_group.list);
> +	spin_unlock_irq(&container_group_lock);

Interrupt gets enabled here and on PPC64, the kernel takes a pending
decrementer and crashes because it is too early to handle them.

Use of irqsave and restore routines would fix the problem.
I have included the fix along with minor Kconfig correction.

Also your 3/7 patch did not showup on LKML.

--Vaidy

> +
> +	need_forkexit_callback |= ss->fork || ss->exit;

--------------080409020304030505050101
Content-Type: text/x-patch;
 name="container-irq-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="container-irq-fix.patch"

Index: linux-2.6.20/kernel/container.c
===================================================================
--- linux-2.6.20.orig/kernel/container.c
+++ linux-2.6.20/kernel/container.c
@@ -1638,6 +1638,7 @@ int container_is_descendant(const struct
 
 static void container_init_subsys(struct container_subsys *ss) {
 	int retval;
+	unsigned long flags;
 	struct list_head *l;
 	printk(KERN_ERR "Initializing container subsys %s\n", ss->name);
 
@@ -1651,7 +1652,7 @@ static void container_init_subsys(struct
 	 * pointer to this state - since the subsystem is
 	 * newly registered, all tasks and hence all container
 	 * groups are in the subsystem's top container. */
-	spin_lock_irq(&container_group_lock);
+	spin_lock_irqsave(&container_group_lock, flags);
 	l = &init_container_group.list;
 	do {
 		struct container_group *cg =
@@ -1659,7 +1660,7 @@ static void container_init_subsys(struct
 		cg->subsys[ss->subsys_id] = dummytop->subsys[ss->subsys_id];
 		l = l->next;
 	} while (l != &init_container_group.list);
-	spin_unlock_irq(&container_group_lock);
+	spin_unlock_irqrestore(&container_group_lock, flags);
 
 	need_forkexit_callback |= ss->fork || ss->exit;
 
Index: linux-2.6.20/init/Kconfig
===================================================================
--- linux-2.6.20.orig/init/Kconfig
+++ linux-2.6.20/init/Kconfig
@@ -239,8 +239,13 @@ config IKCONFIG_PROC
 	  through /proc/config.gz.
 
 config CONTAINERS
-	bool
-	
+	bool "Container support"
+	help
+	  This option will let you create and manage process containers,
+	  which can be used to aggregate multiple processes, e.g. for
+	  the purposes of resource tracking.
+
+	  Say N if unsure
 
 config CPUSETS
 	bool "Cpuset support"

--------------080409020304030505050101--
