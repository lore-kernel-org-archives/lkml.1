Return-Path: <linux-kernel-owner+w=401wt.eu-S1763631AbXF1Ot7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763631AbXF1Ot7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 10:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762792AbXF1OtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 10:49:23 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:43596 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761970AbXF1OtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 10:49:22 -0400
Subject: [PATCH 2.6.22-rc6-mm1] compile error when CONFIG_DM_NETLINK is not
	defined
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Mike Anderson <andmike@us.ibm.com>,
       Alasdair G Kergon <agk@redhat.com>
In-Reply-To: <20070628034321.38c9f12b.akpm@linux-foundation.org>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 28 Jun 2007 09:49:17 -0500
Message-Id: <1183042157.9880.9.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-28 at 03:43 -0700, Andrew Morton wrote:
> -agk-dm-dm-use-singlethread-workqueues.patch
> +agk-dm-dm-use-singlethread-workqueues.patch
> +agk-dm-dm-snapshot-fix-invalidation-deadlock.patch
> +agk-dm-dm-snapshot-permit-invalid-activation.patch
> +agk-dm-dm-raid1-clear-region-outside-spinlock.patch
> +agk-dm-dm-netlink.patch
> +agk-dm-dm-netlink-add-to-core.patch
> +agk-dm-dm-netlink-mpath.patch
> +agk-dm-dm-mpath-rdac.patch
> 
>  device mapper tree updates 

I got this compile error:

  LD      drivers/md/built-in.o
drivers/md/dm-multipath.o: In function `dm_path_event':
drivers/md/dm-netlink.h:56: multiple definition of `dm_path_event'
drivers/md/dm-mod.o:drivers/md/dm-netlink.h:56: first defined here
drivers/md/dm-multipath.o: In function `dm_netlink_send_events':
drivers/md/dm-netlink.h:51: multiple definition of `dm_netlink_send_events'
drivers/md/dm-mod.o:drivers/md/dm-netlink.h:51: first defined here
make[2]: *** [drivers/md/built-in.o] Error 1

I was able to fix it by making the dummy inline functions static.

Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

diff -Nurp linux-2.6.22-rc6-mm1/drivers/md/dm-netlink.h linux/drivers/md/dm-netlink.h
--- linux-2.6.22-rc6-mm1/drivers/md/dm-netlink.h	2007-06-28 05:50:38.000000000 -0500
+++ linux/drivers/md/dm-netlink.h	2007-06-28 09:10:15.000000000 -0500
@@ -47,10 +47,10 @@ static inline int __init dm_netlink_init
 static inline void dm_netlink_exit(void)
 {
 }
-void inline dm_netlink_send_events(struct list_head *events)
+static void inline dm_netlink_send_events(struct list_head *events)
 {
 }
-void inline dm_path_event(enum dm_netlink_event_type evt_type,
+static void inline dm_path_event(enum dm_netlink_event_type evt_type,
 			  struct dm_table *t, const char *path,
 			  int nr_valid_paths)
 {

-- 
David Kleikamp
IBM Linux Technology Center

