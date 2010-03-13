Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935764Ab0CMThA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 14:37:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40611 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935673Ab0CMTg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 14:36:56 -0500
X-Authority-Analysis: v=1.0 c=1 a=CqbfznbHtQcA:10 a=kj9zAlcOel0A:10 a=yQdBAQUQAAAA:8 a=38yDhJykAcdOYXzoem8A:9 a=6bqzCSF5JNc8fyjP0wQlVJzDMMMA:4 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.235
Date: Sat, 13 Mar 2010 13:36:54 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: torvalds@linux-foundation.org, ebiederm@xmission.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] base firmware: Fix BUG from sysfs attributes change in
 commit a2db6842873c8e5a70652f278d469128cb52db70
Message-ID: <4b9be956.x5+yAHXGDfXer810%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a2db6842873c8e5a70652f278d469128cb52db70 changed the way that
sysfs attributes are handled. With lockdep checking enabled, a firmware
loading request from b43 generates the following BUG:

BUG: key ffff8800b85f4870 not in .data!
------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2706 lockdep_init_map+0x236/0x5d0()
Hardware name: HP Pavilion dv2700 Notebook PC
Pid: 2283, comm: NetworkManager Not tainted 2.6.34-rc1-wl #320
Call Trace:
[<ffffffff81046068>] warn_slowpath_common+0x78/0xb0
[<ffffffff810460af>] warn_slowpath_null+0xf/0x20
[<ffffffff810765e6>] lockdep_init_map+0x236/0x5d0
[<ffffffff811633aa>] sysfs_add_file_mode+0x6a/0xc0
[<ffffffff8116340c>] sysfs_add_file+0xc/0x10
[<ffffffff81165ae1>] sysfs_create_bin_file+0x21/0x30
[<ffffffff8124f6b7>] _request_firmware+0x267/0x630
[<ffffffff8124fb0e>] request_firmware+0xe/0x10
[<ffffffffa04038d2>] b43_do_request_fw+0x92/0x230 [b43]
(rest of dump snipped)

Fixed by initing the attribute.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/base/firmware_class.c
===================================================================
--- wireless-testing.orig/drivers/base/firmware_class.c
+++ wireless-testing/drivers/base/firmware_class.c
@@ -442,6 +442,7 @@ static int fw_setup_device(struct firmwa
 	fw_priv = dev_get_drvdata(f_dev);
 
 	fw_priv->fw = fw;
+	sysfs_bin_attr_init(&fw_priv->attr_data);
 	retval = sysfs_create_bin_file(&f_dev->kobj, &fw_priv->attr_data);
 	if (retval) {
 		dev_err(device, "%s: sysfs_create_bin_file failed\n", __func__);
