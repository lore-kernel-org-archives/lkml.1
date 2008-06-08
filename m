Return-Path: <linux-kernel-owner+w=401wt.eu-S1765345AbYFHM63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765345AbYFHM63 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 08:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762117AbYFHM6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 08:58:20 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:34996 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761000AbYFHM6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 08:58:19 -0400
Date: Sun, 8 Jun 2008 14:58:17 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] drivers/isdn/sc/ioctl.c: introduce missing kfree
Message-ID: <Pine.LNX.4.64.0806081456570.10294@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

spid has been allocated in this function and so should be freed before 
leaving it, as in the other error handling cases.

The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

@r exists@
expression E,E1;
statement S;
position p1,p2,p3;
@@

E =@p1 \(kmalloc\|kcalloc\|kzalloc\)(...)
... when != E = E1
if (E == NULL || ...) S
... when != E = E1
if@p2 (...) {
 ... when != kfree(E)
 }
... when != E = E1
kfree@p3(E);

@forall@
position r.p2;
expression r.E;
int E1 != 0;
@@

* if@p2 (...) {
 ... when != kfree(E)
     when strict
return E1; }

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p a/drivers/isdn/sc/ioctl.c b/drivers/isdn/sc/ioctl.c
--- a/drivers/isdn/sc/ioctl.c
+++ b/drivers/isdn/sc/ioctl.c
@@ -226,6 +226,7 @@ int sc_ioctl(int card, scs_ioctl *data)
 		 */
 		if (copy_from_user(spid, data->dataptr, SCIOC_SPIDSIZE)) {
 			kfree(rcvmsg);
+			kfree(spid);
 			return -EFAULT;
 		}
 
