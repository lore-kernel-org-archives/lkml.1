Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbYGTWO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbYGTWO4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 18:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbYGTWOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 18:14:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:38173 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbYGTWOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 18:14:46 -0400
Date: Sun, 20 Jul 2008 15:14:07 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Simon Arlott <simon@fire.lp0.eu>, Daniel Walker <dwalker@mvista.com>,
       Rene Herman <rene.herman@keyaccess.nl>
Subject: [patch 4/4] fastboot: remove "wait for all devices before mounting
 root" delay
Message-ID: <20080720151407.5e972840@infradead.org>
In-Reply-To: <20080720151140.4aa7c682@infradead.org>
References: <20080720151140.4aa7c682@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 20 Jul 2008 13:12:16 -0700
Subject: [PATCH] fastboot: remove "wait for all devices before mounting root" delay

In the non-initrd case, we wait for all devices to finish their
probing before we try to mount the rootfs.
In practice, this means that we end up waiting 2 extra seconds for
the PS/2 mouse probing even though the root holding device has been
ready since a long time.

The previous two patches in this series made the RAID autodetect code
do it's own "wait for probing to be done" code, and added
"wait and retry" functionality in case the root device isn't actually
available.

These two changes should make it safe to remove the delay itself,
and this patch does this. On my test laptop, this reduces the boot time
by 2 seconds (kernel time goes from 3.9 to 1.9 seconds).

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 init/do_mounts.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index a1de1bf..c984fab 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -364,9 +364,11 @@ void __init prepare_namespace(void)
 		ssleep(root_delay);
 	}
 
+#ifndef CONFIG_FASTBOOT
 	/* wait for the known devices to complete their probing */
 	while (driver_probe_done() != 0)
 		msleep(100);
+#endif
 
 	md_run_setup();
 
-- 
1.5.5.1

