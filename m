Return-Path: <linux-kernel-owner+w=401wt.eu-S1763250AbYCFUMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763250AbYCFUMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 15:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbYCFUMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 15:12:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751645AbYCFUMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 15:12:12 -0500
Date: Thu, 6 Mar 2008 12:11:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: mingo@elte.hu, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, bunk@kernel.org, gregkh@suse.de
Subject: Re: 2.6.25-rc3-git3: Reported regressions from 2.6.24
Message-Id: <20080306121127.42ac0682.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0803062054110.8669@axis700.grange>
References: <200803030316.07165.rjw@sisk.pl>
	<20080306072704.GA28518@elte.hu>
	<Pine.LNX.4.64.0803062054110.8669@axis700.grange>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2008 20:55:25 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> On Thu, 6 Mar 2008, Ingo Molnar wrote:
> 
> > 
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10123
> > > Subject		: No power-off / reboot with 2.6.25-rcX (up to -rc3) kernels
> > > Submitter	: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > Date		: 2008-02-27 08:15
> > 
> > Guennadi bisected this down to:
> > 
> >   commit fd7d1ced29e5beb88c9068801da7a362606d8273
> >   PCI: make pci_bus a struct device
> > 
> > and it's suspected that Andrew's poweroff problems might be related as 
> > well. Guennadi, Andrew, find below a manual revert of this change - does 
> > it make any difference?
> 
> Yes, this patch fixes both startup warnings and lets the system reboot and 
> power off again!

Ingo's revert doesn't fix my machine-wont-power-off regression.


Reminder: what _does_ fix it is:

a) CONFIG_DETECT_SOFTLOCKUP=n or

b) This:

--- a/kernel/softlockup.c~softlockup-workaround
+++ a/kernel/softlockup.c
@@ -289,6 +289,7 @@ cpu_callback(struct notifier_block *nfb,
 	case CPU_DEAD_FROZEN:
 		p = per_cpu(watchdog_task, hotcpu);
 		per_cpu(watchdog_task, hotcpu) = NULL;
+		msleep(1);
 		kthread_stop(p);
 		break;
 #endif /* CONFIG_HOTPLUG_CPU */
_


this one is unrelated to Greg's patch, I think.  It's a timing thing.
