Return-Path: <linux-kernel-owner+w=401wt.eu-S1756298AbZFHR01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbZFHR01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 13:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbZFHR0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 13:26:12 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:59959 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425AbZFHR0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 13:26:09 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; CHARSET=US-ASCII
Date: Mon, 08 Jun 2009 13:25:35 -0400
From: Jody McIntyre <scjody@sun.com>
Subject: Re: [PATCH v2 05/11] md/raid5: add scribble region for buffer lists
In-reply-to: <e9c3a7c20906051219x122f443dtc7836f0c16ae9f27@mail.gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org,
       maan@systemlinux.org, linux-kernel@vger.kernel.org, yur@emcraft.com,
       hpa@zytor.com
Message-id: <20090608172535.GA28448@clouds>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
 <20090519005951.4104.27062.stgit@dwillia2-linux.ch.intel.com>
 <18983.26015.413162.445846@notabene.brown>
 <e9c3a7c20906051219x122f443dtc7836f0c16ae9f27@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 12:19:07PM -0700, Dan Williams wrote:
> One of the design goals was to prevent the occurrence of the
> softlockup watchdog events which seem to trigger on large raid6
> resyncs.  A per-cpu scheme would still require preempt_disable() while
> the calculation is active, so perhaps we just need a call to
> cond_resched() in raid5d to appease the scheduler.

FWIW we added this to the patches shipped with Lustre:

Index: linux-2.6.18-128.1.1/drivers/md/raid5.c
===================================================================
--- linux-2.6.18-128.1.1.orig/drivers/md/raid5.c
+++ linux-2.6.18-128.1.1/drivers/md/raid5.c
@@ -2987,6 +2987,8 @@ static void raid5d (mddev_t *mddev)
 		handle_stripe(sh, conf->spare_page);
 		release_stripe(sh);
 
+		cond_resched();
+
 		spin_lock_irq(&conf->device_lock);
 	}
 	PRINTK("%d stripes handled\n", handled);

I thought most of these issues were gone in more recent kernels, but we
haven't tested RAID on anything other than RHEL 4+5 extensively (Lustre
doesn't support sufficiently new kernels yet.)

Cheers,
Jody
