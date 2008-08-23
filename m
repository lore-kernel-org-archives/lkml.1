Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbYHWQAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbYHWQAc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 12:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbYHWQAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 12:00:23 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:35592 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbYHWQAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 12:00:23 -0400
Date: Sat, 23 Aug 2008 18:00:19 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: starvik@axis.com, jesper.nilsson@axis.com, dev-etrax@axis.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] drivers/serial/crisv10.c: add missing put_tty_driver
Message-ID: <Pine.LNX.4.64.0808231759540.3162@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

alloc_tty_driver is called at the beginning of the function containing the
lines of code shown in the patch.  Thus, put_tty_driver is needed before
returning in the error handling code.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@nr exists@
local idexpression x;
expression E,f;
position p1,p2,p3;
identifier l;
statement S;
@@

x = alloc_tty_driver@p1(...)
...
if (x == NULL) S
... when != E = x
    when != put_tty_driver(x)
    when != goto l;
(
return \(0\|x\);
|
return@p3 ...;
)

@script:python@
p1 << nr.p1;
p3 << nr.p3;
@@

print "%s: call on line %s not freed or saved before return on line %s" % (p1[0].file,p1[0].line,p3[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/serial/crisv10.c      |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/crisv10.c b/drivers/serial/crisv10.c
index bf94a77..a467c77 100644
--- a/drivers/serial/crisv10.c
+++ b/drivers/serial/crisv10.c
@@ -4419,6 +4419,7 @@ rs_init(void)
 			rs485_pa_bit)) {
 		printk(KERN_CRIT "ETRAX100LX serial: Could not allocate "
 			"RS485 pin\n");
+		put_tty_driver(driver);
 		return -EBUSY;
 	}
 #endif
@@ -4427,6 +4428,7 @@ rs_init(void)
 			rs485_port_g_bit)) {
 		printk(KERN_CRIT "ETRAX100LX serial: Could not allocate "
 			"RS485 pin\n");
+		put_tty_driver(driver);
 		return -EBUSY;
 	}
 #endif
