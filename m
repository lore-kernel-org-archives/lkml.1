Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbYGVUlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbYGVUlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 16:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYGVUlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 16:41:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750868AbYGVUlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 16:41:07 -0400
Date: Tue, 22 Jul 2008 13:40:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, ak@linux.intel.com,
       gregkh@suse.de, Ingo Molnar <mingo@elte.hu>,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 72/79] sysdev: Pass the attribute to the low level
 sysdev show/store function
Message-Id: <20080722134045.7f09ff29.akpm@linux-foundation.org>
In-Reply-To: <1216703983-21448-72-git-send-email-gregkh@suse.de>
References: <20080722051805.GA17373@suse.de>
	<1216703983-21448-72-git-send-email-gregkh@suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008 22:19:36 -0700
Greg Kroah-Hartman <gregkh@suse.de> wrote:

> From: Andi Kleen <andi@firstfloor.org>
> 
> This allow to dynamically generate attributes and share show/store
> functions between attributes. Right now most attributes are generated
> by special macros and lots of duplicated code. With the attribute
> passed it's instead possible to attach some data to the attribute
> and then use that in shared low level functions to do different things.
> 
> I need this for the dynamically generated bank attributes in the x86
> machine check code, but it'll allow some further cleanups.
> 
> I converted all users in tree to the new show/store prototype. It's a single
> huge patch to avoid unbisectable sections.
> 
> Runtime tested: x86-32, x86-64
> Compiled only: ia64, powerpc
> Not compile tested/only grep converted: sh, arm, avr32
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> ...
>
>  kernel/sched.c                            |    8 ++++-

This wrecks use-sysdev_class-in-schedc.patch (below), which I merged a
week ago and will now drop.

Why did this patch from Andi just turn up in linux-next now, halfway
through the merge window?  It has a commit date of July 1 yet it has
never before been sighted in linux-next.




From: Takashi Iwai <tiwai@suse.de>

The power_saving* attributes are really sysdev_class stuff, so we must
create them via sysdev_class_create_file().  The parameters of callback
functions must be also fixed.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: <Valdis.Kletnieks@vt.edu>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff -puN kernel/sched.c~use-sysdev_class-in-schedc kernel/sched.c
--- a/kernel/sched.c~use-sysdev_class-in-schedc
+++ a/kernel/sched.c
@@ -7732,31 +7732,35 @@ static ssize_t sched_power_savings_store
 }
 
 #ifdef CONFIG_SCHED_MC
-static ssize_t sched_mc_power_savings_show(struct sys_device *dev, char *page)
+static ssize_t sched_mc_power_savings_show(struct sysdev_class *cls,
+					   char *page)
 {
 	return sprintf(page, "%u\n", sched_mc_power_savings);
 }
-static ssize_t sched_mc_power_savings_store(struct sys_device *dev,
+static ssize_t sched_mc_power_savings_store(struct sysdev_class *cls,
 					    const char *buf, size_t count)
 {
 	return sched_power_savings_store(buf, count, 0);
 }
-static SYSDEV_ATTR(sched_mc_power_savings, 0644, sched_mc_power_savings_show,
-		   sched_mc_power_savings_store);
+static SYSDEV_CLASS_ATTR(sched_mc_power_savings, 0644,
+			 sched_mc_power_savings_show,
+			 sched_mc_power_savings_store);
 #endif
 
 #ifdef CONFIG_SCHED_SMT
-static ssize_t sched_smt_power_savings_show(struct sys_device *dev, char *page)
+static ssize_t sched_smt_power_savings_show(struct sysdev_class *cls,
+					    char *page)
 {
 	return sprintf(page, "%u\n", sched_smt_power_savings);
 }
-static ssize_t sched_smt_power_savings_store(struct sys_device *dev,
+static ssize_t sched_smt_power_savings_store(struct sysdv_class *cls,
 					     const char *buf, size_t count)
 {
 	return sched_power_savings_store(buf, count, 1);
 }
-static SYSDEV_ATTR(sched_smt_power_savings, 0644, sched_smt_power_savings_show,
-		   sched_smt_power_savings_store);
+static SYSDEV_CLASS_ATTR(sched_smt_power_savings, 0644,
+			 sched_smt_power_savings_show,
+			 sched_smt_power_savings_store);
 #endif
 
 int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
@@ -7765,13 +7769,13 @@ int sched_create_sysfs_power_savings_ent
 
 #ifdef CONFIG_SCHED_SMT
 	if (smt_capable())
-		err = sysfs_create_file(&cls->kset.kobj,
-					&attr_sched_smt_power_savings.attr);
+		err = sysdev_class_create_file(cls,
+					       &attr_sched_smt_power_savings);
 #endif
 #ifdef CONFIG_SCHED_MC
 	if (!err && mc_capable())
-		err = sysfs_create_file(&cls->kset.kobj,
-					&attr_sched_mc_power_savings.attr);
+		err = sysdev_class_create_file(cls,
+					       &attr_sched_mc_power_savings);
 #endif
 	return err;
 }
_

