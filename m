Return-Path: <linux-kernel-owner+w=401wt.eu-S1752031AbZKLHsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbZKLHsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 02:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbZKLHsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 02:48:36 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:56050 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbZKLHse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 02:48:34 -0500
Date: Thu, 12 Nov 2009 08:48:37 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Scott Feldman <scofeldm@cisco.com>, Joe Eykholt <jeykholt@cisco.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/4] drivers/net/enic: decrement sizeof size in strncmp
Message-ID: <Pine.LNX.4.64.0911120848100.16627@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

As observed by Joe Perches, sizeof of a constant string includes the
trailing 0.  If what is wanted is to check the initial characters of
another string, this trailing 0 should not be taken into account.  If an
exact match is wanted, strcmp should be used instead.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression foo;
constant char *abc;
@@

strncmp(foo, abc, 
- sizeof(abc)
+ sizeof(abc)-1
 )
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/enic/vnic_dev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -u -p a/drivers/net/enic/vnic_dev.c b/drivers/net/enic/vnic_dev.c
--- a/drivers/net/enic/vnic_dev.c
+++ b/drivers/net/enic/vnic_dev.c
@@ -358,9 +358,9 @@ int vnic_dev_hw_version(struct vnic_dev 
 	if (err)
 		return err;
 
-	if (strncmp(fw_info->hw_version, "A1", sizeof("A1")) == 0)
+	if (strncmp(fw_info->hw_version, "A1", sizeof("A1") - 1) == 0)
 		*hw_ver = VNIC_DEV_HW_VER_A1;
-	else if (strncmp(fw_info->hw_version, "A2", sizeof("A2")) == 0)
+	else if (strncmp(fw_info->hw_version, "A2", sizeof("A2") - 1) == 0)
 		*hw_ver = VNIC_DEV_HW_VER_A2;
 	else
 		*hw_ver = VNIC_DEV_HW_VER_UNKNOWN;
