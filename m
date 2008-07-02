Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbYGBTik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbYGBTik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 15:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbYGBTi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 15:38:29 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:47207 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986AbYGBTi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 15:38:28 -0400
Date: Wed, 2 Jul 2008 21:38:24 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH resend] drivers/md: remove null pointer dereference
Message-ID: <Pine.LNX.4.64.0807022136520.4854@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If pgpath->pg->ps.type is NULL, it is not possible to access its name
field.  Alasdair G Kergon suggested that the field type is actually known
never to be NULL; instead it is its field reinstate_path that is supposed
to be tested.


This problem was found using the following semantic match
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression E, E1;
identifier f;
statement S1,S2,S3;
@@

* if (E == NULL)
{
  ... when != if (E == NULL) S1 else S2
      when != E = E1
* E->f
  ... when any
  return ...;
}
else S3
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -u -p a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -883,7 +883,7 @@ static int reinstate_path(struct pgpath 
 	if (pgpath->path.is_active)
 		goto out;
 
-	if (!pgpath->pg->ps.type) {
+	if (!pgpath->pg->ps.type->reinstate_path) {
 		DMWARN("Reinstate path not supported by path selector %s",
 		       pgpath->pg->ps.type->name);
 		r = -EINVAL;
