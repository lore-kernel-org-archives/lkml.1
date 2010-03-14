Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab0CNHtc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 03:49:32 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64370 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091Ab0CNHtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 03:49:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=xRjevaxOccvDMq7pbcSuaXk2ruo0WNX0MxLgM7k1Y4+O5xv0l6zlLbM2+Yp1Snjcxy
         AbKbk5ifGlI3H+K5QIlKIqplJr9BK9afVWe86ELPDPr8DzpdLwJR5JCHnH2+gOiP368o
         iAAho7JKI/1q7Mhr+jU348tG+2U8H+KxvmnR0=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 1/5] firmware loader: use statically initialized data attribute
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Date: Sat, 13 Mar 2010 23:49:07 -0800
Message-ID: <20100314074907.27035.41960.stgit@localhost.localdomain>
In-Reply-To: <20100314074330.27035.38765.stgit@localhost.localdomain>
References: <20100314074330.27035.38765.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason why we are using a template for binary attribute
and copying it into per-firmware data before registering. Using the
original works as well and gets rid of the following lockdep
compaint:

 platform microcode: firmware: requesting intel-ucode/06-0f-0b
 BUG: key ffff88011371be70 not in .data!
 ------------[ cut here ]------------
 WARNING: at kernel/lockdep.c:2706 lockdep_init_map+0x125/0x140()
 Hardware name: Latitude D630
 Modules linked in: ...
 Pid: 738, comm: modprobe Tainted: P           2.6.34-rc1 #237
 Call Trace:
  [<ffffffff81048fb6>] warn_slowpath_common+0x76/0xb0
  [<ffffffff81048fff>] warn_slowpath_null+0xf/0x20
  [<ffffffff8107c915>] lockdep_init_map+0x125/0x140
  [<ffffffff8118485a>] sysfs_add_file_mode+0x6a/0xc0
  [<ffffffff811848bc>] sysfs_add_file+0xc/0x10
  [<ffffffff811870e1>] sysfs_create_bin_file+0x21/0x30
  [<ffffffff8130dff1>] fw_setup_device+0x81/0x120
  [<ffffffff8130e14f>] _request_firmware+0xbf/0x270
  [<ffffffff8130e38e>] request_firmware+0xe/0x10
  [<ffffffffa0064be1>] request_microcode_fw+0x61/0xa0 [microcode]
  [<ffffffffa00643b8>] microcode_init_cpu+0xb8/0xd0 [microcode]
  [<ffffffffa0064426>] mc_sysdev_add+0x56/0x70 [microcode]
  [<ffffffff813032ae>] sysdev_driver_register+0x9e/0x130
  [<ffffffffa006a000>] ? microcode_init+0x0/0x12a [microcode]
  [<ffffffffa006a0bd>] microcode_init+0xbd/0x12a [microcode]
  [<ffffffff810001d7>] do_one_initcall+0x37/0x190
  [<ffffffff8108d178>] sys_init_module+0xd8/0x250
  [<ffffffff81002fab>] system_call_fastpath+0x16/0x1b
 ---[ end trace 93c9f72439beee7f ]---


Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/base/firmware_class.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index d0dc26a..3f50b2e 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -41,7 +41,6 @@ static DEFINE_MUTEX(fw_lock);
 struct firmware_priv {
 	char *fw_id;
 	struct completion completion;
-	struct bin_attribute attr_data;
 	struct firmware *fw;
 	unsigned long status;
 	struct page **pages;
@@ -344,8 +343,8 @@ out:
 	return retval;
 }
 
-static struct bin_attribute firmware_attr_data_tmpl = {
-	.attr = {.name = "data", .mode = 0644},
+static struct bin_attribute firmware_attr_data = {
+	.attr = { .name = "data", .mode = 0644 },
 	.size = 0,
 	.read = firmware_data_read,
 	.write = firmware_data_write,
@@ -390,7 +389,6 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
 	}
 
 	init_completion(&fw_priv->completion);
-	fw_priv->attr_data = firmware_attr_data_tmpl;
 	fw_priv->fw_id = kstrdup(fw_name, GFP_KERNEL);
 	if (!fw_priv->fw_id) {
 		dev_err(device, "%s: Firmware name allocation failed\n",
@@ -442,7 +440,7 @@ static int fw_setup_device(struct firmware *fw, struct device **dev_p,
 	fw_priv = dev_get_drvdata(f_dev);
 
 	fw_priv->fw = fw;
-	retval = sysfs_create_bin_file(&f_dev->kobj, &fw_priv->attr_data);
+	retval = sysfs_create_bin_file(&f_dev->kobj, &firmware_attr_data);
 	if (retval) {
 		dev_err(device, "%s: sysfs_create_bin_file failed\n", __func__);
 		goto error_unreg;

