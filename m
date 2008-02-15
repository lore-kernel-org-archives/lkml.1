Return-Path: <linux-kernel-owner+w=401wt.eu-S934808AbYBOGyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934808AbYBOGyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 01:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933881AbYBOGxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 01:53:12 -0500
Received: from ns2.suse.de ([195.135.220.15]:57529 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934214AbYBOGxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 01:53:08 -0500
Date: Thu, 14 Feb 2008 22:57:46 -0800
From: Greg KH <gregkh@suse.de>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [2.6.25-rc1] System no longer powers off after shutdown
Message-ID: <20080215065746.GA8916@suse.de>
References: <200802111623.38478.elendil@planet.nl> <200802122139.14840.elendil@planet.nl> <20080212205622.GA21986@suse.de> <200802131239.14305.elendil@planet.nl> <20080213165837.GA10129@suse.de> <86802c440802141538m44d64b6as827426174874979d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440802141538m44d64b6as827426174874979d@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 03:38:13PM -0800, Yinghai Lu wrote:
> On Wed, Feb 13, 2008 at 8:58 AM, Greg KH <gregkh@suse.de> wrote:
> >
> > On Wed, Feb 13, 2008 at 12:39:13PM +0100, Frans Pop wrote:
> >  > On Tuesday 12 February 2008, Greg KH wrote:
> >  > > On Tue, Feb 12, 2008 at 09:39:14PM +0100, Frans Pop wrote:
> >  > > > On Monday 11 February 2008, Frans Pop wrote:
> >  > > > > In general 2.6.25 if looking quite good on my desktop, but there's
> >  > > > > one important issue: the system no longer powers off after shutdown.
> >  > > > > This works fine with 2.6.24.
> >  > > >
> >  > > > Don't ask me why, but bisection shows this commit to be the cause of
> >  > > > the failure to power off:
> >  > > > commit c10997f6575f476ff38442fa18fd4a0d80345f9d
> >  > > > Author: Greg Kroah-Hartman <gregkh@suse.de>
> >  > > > Date:   Thu Dec 20 08:13:05 2007 -0800
> >  > > >
> >  > > >     Kobject: convert drivers/* from kobject_unregister() to
> >  > > > kobject_put()
> >  > > >
> >  > > > Because it seemed somewhat unlikely, I have double checked this by
> >  > > > doing an extra compilation for this commit and its predecessor.
> >  > >
> >  > > What is the symptom of not powering off?
> >  >
> >  > I already noticed yesterday that there's one hunk in that commit that's not
> >  > a straight replacement:
> >  > diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> >  > index 9e102af..5efd555 100644
> >  > --- a/drivers/cpufreq/cpufreq.c
> >  > +++ b/drivers/cpufreq/cpufreq.c
> >  > @@ -1030,8 +1030,6 @@ static int __cpufreq_remove_dev (struct sys_device * sys_dev)
> >  >
> >  >         unlock_policy_rwsem_write(cpu);
> >  >
> >  > -       kobject_unregister(&data->kobj);
> >  > -
> >  >         kobject_put(&data->kobj);
> >  >
> >  >         /* we need to make sure that the underlying kobj is actually
> >  >
> >  >
> >  > So, just on the off chance, I applied the patch below and bingo, the system
> >  > powers off again. I doubt this will be the correct solution, but just in
> >  > case it is, here's my signed off. A comment why the double put is needed
> >  > would probably be good though.
> >
> >  There is a bug in the cpufreq kref logic that makes this "double put"
> >  necessary.  A real fix has already been posted to solve this issue, and
> >  I think it should be on it's way to Linus for -rc2 already.
> >
> >  Please let me know if -rc2 comes out without this needed fix.
> 
> after disable cpufreq, i got
> 
> ACPI: Preparing to enter system sleep state S5
> Disabling non-boot CPUs ...
> kvm: disabling virtualization on CPU1
> CPU 1 is now offline
> CPU1 is down
> kvm: disabling virtualization on CPU2
> CPU 2 is now offline
> ================> hang here.
> 
> but x86.git/mm could go through down all the cpus....
> 
> interesting...

I swear someone sent this patch in before.  Can you try this one below,
there seems to be an imbalance with kobject_get and _put.

thanks,

greg k-h

---
 drivers/cpufreq/cpufreq.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1006,14 +1006,6 @@ static int __cpufreq_remove_dev (struct 
 	}
 #endif
 
-
-	if (!kobject_get(&data->kobj)) {
-		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
-		cpufreq_debug_enable_ratelimit();
-		unlock_policy_rwsem_write(cpu);
-		return -EFAULT;
-	}
-
 #ifdef CONFIG_SMP
 
 #ifdef CONFIG_HOTPLUG_CPU
