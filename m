Return-Path: <linux-kernel-owner+w=401wt.eu-S1757787AbZCMMDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787AbZCMMDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 08:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757355AbZCMMDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 08:03:20 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:58022 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925AbZCMMDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 08:03:18 -0400
Date: Fri, 13 Mar 2009 13:03:14 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Alex Chiang <achiang@hp.com>
Cc: Greg KH <gregkh@suse.de>, Tejun Heo <tj@kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] sysfs: only allow one scheduled removal callback
 per kobj
Message-ID: <20090313130314.77dc18ed@gondolin>
In-Reply-To: <20090312220231.GC31042@ldl.fc.hp.com>
References: <20090310232027.GC25665@ldl.fc.hp.com>
	<20090311044151.GB25840@suse.de>
	<20090311070359.GF25665@ldl.fc.hp.com>
	<49B76640.6010109@kernel.org>
	<20090312002737.GB17345@ldl.fc.hp.com>
	<20090312032228.GA25419@suse.de>
	<20090312220231.GC31042@ldl.fc.hp.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009 16:02:31 -0600,
Alex Chiang <achiang@hp.com> wrote:

> From: Alex Chiang <achiang@hp.com>
> 
> sysfs: only allow one scheduled removal callback per kobj
> 
> The only way for a sysfs attribute to remove itself (without
> deadlock) is to use the sysfs_schedule_callback() interface.
> 
> Vegard Nossum discovered that a poorly written sysfs ->store
> callback can repeatedly schedule remove callbacks on the same
> device over and over, e.g.
> 
> 	$ while true ; do echo 1 > /sys/devices/.../remove ; done
> 
> If the 'remove' attribute uses the sysfs_schedule_callback API
> and also does not protect itself from concurrent accesses, its
> callback handler will be called multiple times, and will
> eventually attempt to perform operations on a freed kobject,
> leading to many problems.
> 
> Instead of requiring all callers of sysfs_schedule_callback to
> implement their own synchronization, provide the protection in
> the infrastructure.
> 
> Now, sysfs_schedule_callback will only allow one scheduled
> callback per kobject. On subsequent calls with the same kobject,
> return -EAGAIN.
> 
> This is a short term fix. The long term fix is to allow sysfs
> attributes to remove themselves directly, without any of this
> callback hokey pokey.
> 
> Cc: cornelia.huck@de.ibm.com
> Reported-by: vegard.nossum@gmail.com
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> Greg, I think this is .30 material; we're late in the -rc cycle
> now and we're changing the semantics of an API.
> 
> Cornelia, I understand your earlier point about a smaller patch
> in the caller, but I think pushing the code down into the
> infrastructure is the right thing to do. 

OK, I don't have further objections.

> Also, I wasn't brave
> enough to patch your ccwgroup_ungroup_store(), but I think you
> won't need the gdev->onoff stuff anymore in that code path.

We still need it to prevent online/offline vs. ungroup races.

While device_schedule_callback() should not be able to return -EAGAIN
on us, I'll sleep better if you could add the following snippet to your
patch:

---
 drivers/s390/cio/ccwgroup.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-2.6.orig/drivers/s390/cio/ccwgroup.c
+++ linux-2.6/drivers/s390/cio/ccwgroup.c
@@ -104,8 +104,9 @@ ccwgroup_ungroup_store(struct device *de
 	rc = device_schedule_callback(dev, ccwgroup_ungroup_callback);
 out:
 	if (rc) {
-		/* Release onoff "lock" when ungrouping failed. */
-		atomic_set(&gdev->onoff, 0);
+		if (rc != -EAGAIN)
+			/* Release onoff "lock" when ungrouping failed. */
+			atomic_set(&gdev->onoff, 0);
 		return rc;
 	}
 	return count;
