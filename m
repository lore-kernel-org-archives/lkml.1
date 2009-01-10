Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264AbZAJG1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbZAJG1x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 01:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZAJG1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 01:27:45 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:21625 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbZAJG1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 01:27:44 -0500
X-IronPort-AV: E=Sophos;i="4.37,243,1231113600"; 
   d="scan'208";a="227217129"
From: Roland Dreier <rdreier@cisco.com>
To: Jens Axboe <jens.axboe@oracle.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] driver core: Convert '/' to '!' in dev_set_name()
References: <adaljtjog90.fsf@cisco.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 09 Jan 2009 22:27:42 -0800
In-Reply-To: <adaljtjog90.fsf@cisco.com> (Roland Dreier's message of "Fri, 09
	Jan 2009 21:57:15 -0800")
Message-ID: <adad4evoeu9.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Jan 2009 06:27:43.0203 (UTC) FILETIME=[8B521330:01C972EC]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 3ada8b7e ("block: struct device - replace bus_id with dev_name(),
dev_set_name()") deleted the code in register_disk() that changed a '/'
to a '!' in the device name when registering a disk, but dev_set_name()
does not perform this conversion.

This leads to amusing problems with disks that have '/' in their names:
for example a failure to boot with the root partition on a cciss device,
even though the kernel says it knows about the root device:

    VFS: Cannot open root device "cciss/c0d0p6" or unknown-block(0,0)
    Please append a correct "root=" boot option; here are the available partitions:
    6800        71652960 cciss/c0d0 driver: cciss
      6802               1 cciss/c0d0p2
      6805         2931831 cciss/c0d0p5
      6806        34354908 cciss/c0d0p6
    6810        71652960 cciss/c0d1 driver: cciss

Fix this by adding code to change '/' to '!' in dev_set_name() to handle
this until dev_set_name() is converted to use kobject_set_name().

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
OK, this is tested to work on my system as well.

 drivers/base/core.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 8079afc..55e5309 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -777,10 +777,16 @@ static void device_remove_class_symlinks(struct device *dev)
 int dev_set_name(struct device *dev, const char *fmt, ...)
 {
 	va_list vargs;
+	char *s;
 
 	va_start(vargs, fmt);
 	vsnprintf(dev->bus_id, sizeof(dev->bus_id), fmt, vargs);
 	va_end(vargs);
+
+	/* ewww... some of these buggers have / in the name... */
+	while ((s = strchr(dev->bus_id, '/')))
+		*s = '!';
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(dev_set_name);
