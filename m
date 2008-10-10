Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbYJJKhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbYJJKhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 06:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757958AbYJJKgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 06:36:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42509 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752857AbYJJKgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 06:36:46 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 01/27] drivers/serial/crisv10.c: add missing put_tty_driver
To: torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
Date: Fri, 10 Oct 2008 11:36:41 +0100
Message-ID: <20081010103637.31597.41557.stgit@localhost.localdomain>
In-Reply-To: <20081010103447.31597.42992.stgit@localhost.localdomain>
References: <20081010103447.31597.42992.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/serial/crisv10.c |    2 ++
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

