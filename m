Return-Path: <linux-kernel-owner+w=401wt.eu-S1755764AbZKWCB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbZKWCB0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 21:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbZKWCBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 21:01:25 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52268 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229AbZKWCBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 21:01:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=CIXigmNzOPbd4kCLDV8ETLngh4EjyTb3ODokYUCWB/zCFOrm2zjjlJilDfxrDZ/n6O
         xpCoIpmww6vHIIR4nR0msxfGYOK7txlfFVFerLBsX9SMX9Cu0pH/l6unvPiBpniLpn+E
         k4ErDqXhGQsAExEWbHRnFrjhqjiULwpUeqeGA=
Date: Mon, 23 Nov 2009 05:00:08 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, mchehab@infradead.org
Subject: [PATCH] proc_fops: convert av7110
Message-ID: <20091123020008.GB32088@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop S_IRUGO, proc entry doesn't contain read hooks.
Drop S_IFREG, simply unnecessary.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/media/dvb/ttpci/av7110_ir.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/media/dvb/ttpci/av7110_ir.c
+++ b/drivers/media/dvb/ttpci/av7110_ir.c
@@ -268,8 +268,8 @@ int av7110_check_ir_config(struct av7110 *av7110, int force)
 
 
 /* /proc/av7110_ir interface */
-static int av7110_ir_write_proc(struct file *file, const char __user *buffer,
-				unsigned long count, void *data)
+static ssize_t av7110_ir_proc_write(struct file *file, const char __user *buffer,
+				    size_t count, loff_t *pos)
 {
 	char *page;
 	u32 ir_config;
@@ -309,6 +309,10 @@ static int av7110_ir_write_proc(struct file *file, const char __user *buffer,
 	return count;
 }
 
+static const struct file_operations av7110_ir_proc_fops = {
+	.owner		= THIS_MODULE,
+	.write		= av7110_ir_proc_write,
+};
 
 /* interrupt handler */
 static void ir_handler(struct av7110 *av7110, u32 ircom)
@@ -368,11 +372,9 @@ int __devinit av7110_ir_init(struct av7110 *av7110)
 	input_dev->timer.data = (unsigned long) &av7110->ir;
 
 	if (av_cnt == 1) {
-		e = create_proc_entry("av7110_ir", S_IFREG | S_IRUGO | S_IWUSR, NULL);
-		if (e) {
-			e->write_proc = av7110_ir_write_proc;
+		e = proc_create("av7110_ir", S_IWUSR, NULL, &av7110_ir_proc_fops);
+		if (e)
 			e->size = 4 + 256 * sizeof(u16);
-		}
 	}
 
 	tasklet_init(&av7110->ir.ir_tasklet, av7110_emit_key, (unsigned long) &av7110->ir);
