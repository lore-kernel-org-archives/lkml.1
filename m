Return-Path: <linux-kernel-owner+w=401wt.eu-S1754486AbYLUP2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbYLUP2l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 10:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbYLUP23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 10:28:29 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:41694 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbYLUP22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 10:28:28 -0500
Date: Sun, 21 Dec 2008 16:28:21 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, linux390@de.ibm.com,
       linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/13] s390: Remove redundant test
Message-ID: <Pine.LNX.4.64.0812211628030.9555@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The loop above the modified code only terminates when rc is a valid pointer.

A simplified version of the semantic patch that makes this change is as
follows: (http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
expression E;
position p1,p2;
@@

if (x@p1 == NULL || ...) { ... when forall
   return ...; }
... when != \(x=E\|x--\|x++\|--x\|++x\|x-=E\|x+=E\|x|=E\|x&=E\|&x\)
(
x@p2 == NULL
|
x@p2 != NULL
)

// another path to the test that is not through p1?
@s exists@
local idexpression r.x;
position r.p1,r.p2;
@@

... when != x@p1
(
x@p2 == NULL
|
x@p2 != NULL
)

@fix depends on !s@
position r.p1,r.p2;
expression x,E;
statement S1,S2;
@@

(
- if ((x@p2 != NULL) || ...)
  S1
|
- if ((x@p2 == NULL) && ...) S1
|
- BUG_ON(x@p2 == NULL);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/s390/kernel/debug.c          |    2 +-
 drivers/s390/net/qeth_core_main.c |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index 3665b18..e6c141c 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -391,7 +391,7 @@ debug_info_copy(debug_info_t* in, int mode)
 		debug_info_free(rc);
 	} while (1);
 
-        if(!rc || (mode == NO_AREAS))
+	if (mode == NO_AREAS)
                 goto out;
 
         for(i = 0; i < in->nr_areas; i++){
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index bbd6788..e783644 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -2346,7 +2346,6 @@ static int qeth_init_input_buffer(struct qeth_card *card,
 	 * the QETH_IN_BUF_REQUEUE_THRESHOLD we should never run  out off
 	 * buffers
 	 */
-	BUG_ON(!pool_entry);
 
 	buf->pool_entry = pool_entry;
 	for (i = 0; i < QETH_MAX_BUFFER_ELEMENTS(card); ++i) {
