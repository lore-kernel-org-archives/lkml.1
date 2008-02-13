Return-Path: <linux-kernel-owner+w=401wt.eu-S1764634AbYBMLj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764634AbYBMLj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 06:39:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755612AbYBMLjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 06:39:17 -0500
Received: from hpsmtp-eml14.KPNXCHANGE.COM ([213.75.38.114]:32678 "EHLO
	hpsmtp-eml14.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754816AbYBMLjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 06:39:16 -0500
From: Frans Pop <elendil@planet.nl>
To: Greg KH <gregkh@suse.de>
Subject: Re: [2.6.25-rc1] System no longer powers off after shutdown
Date: Wed, 13 Feb 2008 12:39:13 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <200802111623.38478.elendil@planet.nl> <200802122139.14840.elendil@planet.nl> <20080212205622.GA21986@suse.de>
In-Reply-To: <20080212205622.GA21986@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802131239.14305.elendil@planet.nl>
X-OriginalArrivalTime: 13 Feb 2008 11:39:15.0021 (UTC) FILETIME=[0F5E27D0:01C86E35]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2008, Greg KH wrote:
> On Tue, Feb 12, 2008 at 09:39:14PM +0100, Frans Pop wrote:
> > On Monday 11 February 2008, Frans Pop wrote:
> > > In general 2.6.25 if looking quite good on my desktop, but there's
> > > one important issue: the system no longer powers off after shutdown.
> > > This works fine with 2.6.24.
> >
> > Don't ask me why, but bisection shows this commit to be the cause of
> > the failure to power off:
> > commit c10997f6575f476ff38442fa18fd4a0d80345f9d
> > Author: Greg Kroah-Hartman <gregkh@suse.de>
> > Date:   Thu Dec 20 08:13:05 2007 -0800
> >
> >     Kobject: convert drivers/* from kobject_unregister() to
> > kobject_put()
> >
> > Because it seemed somewhat unlikely, I have double checked this by
> > doing an extra compilation for this commit and its predecessor.
>
> What is the symptom of not powering off?

I already noticed yesterday that there's one hunk in that commit that's not
a straight replacement:
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 9e102af..5efd555 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1030,8 +1030,6 @@ static int __cpufreq_remove_dev (struct sys_device * sys_dev)

        unlock_policy_rwsem_write(cpu);

-       kobject_unregister(&data->kobj);
-
        kobject_put(&data->kobj);

        /* we need to make sure that the underlying kobj is actually


So, just on the off chance, I applied the patch below and bingo, the system
powers off again. I doubt this will be the correct solution, but just in
case it is, here's my signed off. A comment why the double put is needed
would probably be good though.

Signed-off-by: Frans Pop <elendil@planet.nl>

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 64926aa..9dbaac6 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1058,6 +1058,7 @@ static int __cpufreq_remove_dev (struct sys_device * sys_dev)
 	unlock_policy_rwsem_write(cpu);
 
 	kobject_put(&data->kobj);
+	kobject_put(&data->kobj);
 
 	/* we need to make sure that the underlying kobj is actually
 	 * not referenced anymore by anybody before we proceed with
