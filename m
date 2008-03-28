Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbYC1PLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbYC1PLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 11:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbYC1PLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 11:11:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:30462 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbYC1PLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 11:11:34 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] reuse xxx_fifo_fops for xxx_pipe_fops
Date: Fri, 28 Mar 2008 16:09:54 +0100
User-Agent: KMail/1.8.2
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_CpQ7H24Jz/h9Zrd"
Message-Id: <200803281609.54601.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_CpQ7H24Jz/h9Zrd
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Al,

I noticed that read/write/rdwr_pipe_fops are (1) const and
(2) exactly identical to xxx_fifo_fops, which are also const.

Attached patch #defines xxx_pipe_fops as aliases to xxx_fifo_fops.
Size difference:

# size linux-2.6.25-rc6*/*/pipe.o
   text    data     bss     dec     hex filename
   6534     144       0    6678    1a16 linux-2.6.25-rc6/fs/pipe.o
   5862     144       0    6006    1776 linux-2.6.25-rc6-pt/fs/pipe.o

--
vda

--Boundary-00=_CpQ7H24Jz/h9Zrd
Content-Type: text/x-diff;
  charset="us-ascii";
  name="reuse_fifo_ops_for_pipe_ops.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="reuse_fifo_ops_for_pipe_ops.diff"

--- linux-2.6.25-rc6.src/fs/pipe.c	Sat Mar 22 23:00:34 2008
+++ linux-2.6.25-rc6.pipe/fs/pipe.c	Fri Mar 28 15:52:00 2008
@@ -814,42 +814,9 @@
 	.fasync		= pipe_rdwr_fasync,
 };
 
-static const struct file_operations read_pipe_fops = {
-	.llseek		= no_llseek,
-	.read		= do_sync_read,
-	.aio_read	= pipe_read,
-	.write		= bad_pipe_w,
-	.poll		= pipe_poll,
-	.unlocked_ioctl	= pipe_ioctl,
-	.open		= pipe_read_open,
-	.release	= pipe_read_release,
-	.fasync		= pipe_read_fasync,
-};
-
-static const struct file_operations write_pipe_fops = {
-	.llseek		= no_llseek,
-	.read		= bad_pipe_r,
-	.write		= do_sync_write,
-	.aio_write	= pipe_write,
-	.poll		= pipe_poll,
-	.unlocked_ioctl	= pipe_ioctl,
-	.open		= pipe_write_open,
-	.release	= pipe_write_release,
-	.fasync		= pipe_write_fasync,
-};
-
-static const struct file_operations rdwr_pipe_fops = {
-	.llseek		= no_llseek,
-	.read		= do_sync_read,
-	.aio_read	= pipe_read,
-	.write		= do_sync_write,
-	.aio_write	= pipe_write,
-	.poll		= pipe_poll,
-	.unlocked_ioctl	= pipe_ioctl,
-	.open		= pipe_rdwr_open,
-	.release	= pipe_rdwr_release,
-	.fasync		= pipe_rdwr_fasync,
-};
+#define read_pipe_fops  read_fifo_fops
+#define write_pipe_fops write_fifo_fops
+#define rdwr_pipe_fops  rdwr_fifo_fops
 
 struct pipe_inode_info * alloc_pipe_info(struct inode *inode)
 {

--Boundary-00=_CpQ7H24Jz/h9Zrd--
