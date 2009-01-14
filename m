Return-Path: <linux-kernel-owner+w=401wt.eu-S1760152AbZANW7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152AbZANW7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 17:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756021AbZANW7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 17:59:05 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:53759 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662AbZANW7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 17:59:03 -0500
Date: Wed, 14 Jan 2009 23:52:01 +0100
From: Erik Ekman <erik@kryo.se>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, abelay@mit.edu, bjorn.helgaas@hp.com
Subject: Re: [PATCH -tip][RFC] pnpbios: Fix warning if no hotplug
Message-Id: <20090114235201.be211323.erik@kryo.se>
In-Reply-To: <20090114131321.78c2d088.akpm@linux-foundation.org>
References: <20090110115219.1ebb94cd.erik@kryo.se>
	<20090114131321.78c2d088.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 13:13:21 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 10 Jan 2009 11:52:19 +0100
> Erik Ekman <erik@kryo.se> wrote:
> 
> > pnpbios: Fix warning if no hotplug
> > 
> > When hotplug is turned off, I get:
> > drivers/pnp/pnpbios/core.c: In function 'pnpbios_thread_init':
> > drivers/pnp/pnpbios/core.c:578: warning: unused variable 'task'
> > 
> > Is this a good way to fix this? Or should I just a #ifdef
> > CONFIG_HOTPLUG around the task variable?
> > 
> > Signed-off-by: Erik Ekman <erik@kryo.se>
> > ---
> > diff --git a/drivers/pnp/pnpbios/core.c b/drivers/pnp/pnpbios/core.c
> > index 996f648..e706d22 100644
> > --- a/drivers/pnp/pnpbios/core.c
> > +++ b/drivers/pnp/pnpbios/core.c
> > @@ -575,8 +575,6 @@ fs_initcall(pnpbios_init);
> >  
> >  static int __init pnpbios_thread_init(void)
> >  {
> > -	struct task_struct *task;
> > -
> >  #if defined(CONFIG_PPC)
> >  	if (check_legacy_ioport(PNPBIOS_BASE))
> >  		return 0;
> > @@ -584,10 +582,13 @@ static int __init pnpbios_thread_init(void)
> >  	if (pnpbios_disabled)
> >  		return 0;
> >  #ifdef CONFIG_HOTPLUG
> > -	init_completion(&unload_sem);
> > -	task = kthread_run(pnp_dock_thread, NULL, "kpnpbiosd");
> > -	if (!IS_ERR(task))
> > -		unloading = 0;
> > +	{
> > +		struct task_struct *task;
> > +		init_completion(&unload_sem);
> > +		task = kthread_run(pnp_dock_thread, NULL, "kpnpbiosd");
> > +		if (!IS_ERR(task))
> > +			unloading = 0;
> > +	}
> >  #endif
> >  	return 0;
> >  }
> 
> Well you could just remove `task' altogether and do
> 
> 	if (!IS_ERR(kthread_run(pnp_dock_thread, NULL, "kpnpbiosd")))
> 		unloading = 0;
> 
> but
> 
> a) `unloading' doesn't actually do anything, and can be removed
> 
> b) this function shouldn't return 0 if kthread_run() failed

Thanks for the info. Here is an additional patch to remove the
unloading variable and propagate the error code.
This at least compiles with CONFIG_HOTPLUG=y.

===
pnpbios: Propagate kthread_run() error

Error code from kthread_run() is now returned in pnpbios_thread_init()
Removed variable which always was 0.

Signed-off-by: Erik Ekman <erik@kryo.se>
---
 drivers/pnp/pnpbios/core.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/pnp/pnpbios/core.c b/drivers/pnp/pnpbios/core.c
index e706d22..cfe8685 100644
--- a/drivers/pnp/pnpbios/core.c
+++ b/drivers/pnp/pnpbios/core.c
@@ -94,7 +94,6 @@ struct pnp_dev_node_info node_info;
 
 #ifdef CONFIG_HOTPLUG
 
-static int unloading = 0;
 static struct completion unload_sem;
 
 /*
@@ -158,7 +157,7 @@ static int pnp_dock_thread(void *unused)
 	int docked = -1, d = 0;
 
 	set_freezable();
-	while (!unloading) {
+	while (1) {
 		int status;
 
 		/*
@@ -586,8 +585,8 @@ static int __init pnpbios_thread_init(void)
 		struct task_struct *task;
 		init_completion(&unload_sem);
 		task = kthread_run(pnp_dock_thread, NULL, "kpnpbiosd");
-		if (!IS_ERR(task))
-			unloading = 0;
+		if (IS_ERR(task))
+			return PTR_ERR(task);
 	}
 #endif
 	return 0;

