Return-Path: <linux-kernel-owner+w=401wt.eu-S1756297AbZKUPxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbZKUPxN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 10:53:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755637AbZKUPxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 10:53:13 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:56159 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755605AbZKUPxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 10:53:12 -0500
Date: Sat, 21 Nov 2009 16:53:16 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Sage Weil <sage@newdream.net>, ceph-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] fs/ceph: Move a dereference below a NULL test
Message-ID: <Pine.LNX.4.64.0911211652550.26930@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If the NULL test is necessary, then the dereference should be moved below
the NULL test.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/).

// <smpl>
@@
type T;
expression E;
identifier i,fld;
statement S;
@@

- T i = E->fld;
+ T i;
  ... when != E
      when != i
  if (E == NULL) S
+ i = E->fld;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/ceph/osd_client.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -u -p a/fs/ceph/osd_client.c b/fs/ceph/osd_client.c
--- a/fs/ceph/osd_client.c
+++ b/fs/ceph/osd_client.c
@@ -1244,11 +1244,12 @@ int ceph_osdc_writepages(struct ceph_osd
 static void dispatch(struct ceph_connection *con, struct ceph_msg *msg)
 {
 	struct ceph_osd *osd = con->private;
-	struct ceph_osd_client *osdc = osd->o_osdc;
+	struct ceph_osd_client *osdc;
 	int type = le16_to_cpu(msg->hdr.type);
 
 	if (!osd)
 		return;
+	osdc = osd->o_osdc;
 
 	switch (type) {
 	case CEPH_MSG_OSD_MAP:
