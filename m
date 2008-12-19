Return-Path: <linux-kernel-owner+w=401wt.eu-S1752422AbYLSRLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422AbYLSRLk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 12:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbYLSRLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 12:11:30 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:44207 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbYLSRL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 12:11:29 -0500
Date: Fri, 19 Dec 2008 18:11:25 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: pete@sensoray.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 3/3] drivers/staging/go7007: Move a dereference below a NULL
 test
Message-ID: <Pine.LNX.4.64.0812191811020.11217@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In each case, if the NULL test is necessary, then the dereference should be
moved below the NULL test.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/).  The result has been modified to
move the initialization of usb down closer to where it is used.

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
 drivers/staging/go7007/s2250-board.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/go7007/s2250-board.c b/drivers/staging/go7007/s2250-board.c
index fb6845e..a60e19c 100644
--- a/drivers/staging/go7007/s2250-board.c
+++ b/drivers/staging/go7007/s2250-board.c
@@ -149,7 +149,7 @@ static int go7007_usb_vendor_request(struct go7007 *go, u16 request,
 static int write_reg(struct i2c_client *client, u8 reg, u8 value)
 {
 	struct go7007 *go = i2c_get_adapdata(client->adapter);
-	struct go7007_usb *usb = go->hpi_context;
+	struct go7007_usb *usb;
 	int rc;
 	int dev_addr = client->addr;
 	u8 *buf;
@@ -164,6 +164,7 @@ static int write_reg(struct i2c_client *client, u8 reg, u8 value)
 	if (buf == NULL)
 		return -ENOMEM;
 
+	usb = go->hpi_context;
 	if (down_interruptible(&usb->i2c_lock) != 0) {
 		printk(KERN_INFO "i2c lock failed\n");
 		return -EINTR;
@@ -181,7 +182,7 @@ static int write_reg(struct i2c_client *client, u8 reg, u8 value)
 static int write_reg_fp(struct i2c_client *client, u16 addr, u16 val)
 {
 	struct go7007 *go = i2c_get_adapdata(client->adapter);
-	struct go7007_usb *usb = go->hpi_context;
+	struct go7007_usb *usb;
 	u8 *buf;
 	struct s2250 *dec = i2c_get_clientdata(client);
 
@@ -200,6 +201,7 @@ static int write_reg_fp(struct i2c_client *client, u16 addr, u16 val)
 
 	memset(buf, 0xcd, 6);
 
+	usb = go->hpi_context;
 	if (down_interruptible(&usb->i2c_lock) != 0) {
 		printk(KERN_INFO "i2c lock failed\n");
 		return -EINTR;
