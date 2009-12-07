Return-Path: <linux-kernel-owner+w=401wt.eu-S1758715AbZLGAQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715AbZLGAQq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:16:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934388AbZLGAQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:16:42 -0500
Received: from kroah.org ([198.145.64.141]:34716 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932834AbZLGAOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:14:04 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:59 2009
Message-Id: <20091207000659.654409257@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>
Subject: [108/119] i2c: Fix userspace_device list corruption
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=i2c-fix-userspace_device-list-corruption.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jean Delvare <khali@linux-fr.org>

commit bbd2d9c9198c6efd449e9d395b3eaf2d03aa3bba upstream.

Fix userspace_device list corruption. The corruption was caused by
clients not being removed when adapters with such clients were
themselves removed. Something like the following would trigger it
(assuming i2c-stub gets adapter number 3):

# modprobe i2c-stub chip_addr=0x50
# echo 24c08 0x50 > /sys/bus/i2c/devices/i2c-3/new_device
# rmmod i2c-stub
# modprobe i2c-stub chip_addr=0x50
# echo 24c08 0x50 > /sys/bus/i2c/devices/i2c-3/new_device

For the records, the stack trace in the kernel logs look like this:

kernel: WARNING: at lib/list_debug.c:30 __list_add+0x8b/0x90()
kernel: Hardware name: (...)
kernel: list_add corruption. prev->next should be next (c137fc84), but was (null). (prev=f57111b8).
kernel: Modules linked in: (...)
kernel: Pid: 4669, comm: bash Not tainted 2.6.32-rc8 #259
kernel: Call Trace:
kernel:  [<c111eb8b>] ? __list_add+0x8b/0x90
kernel:  [<c111eb8b>] ? __list_add+0x8b/0x90
kernel:  [<c103265c>] warn_slowpath_common+0x6c/0xc0
kernel:  [<c111eb8b>] ? __list_add+0x8b/0x90
kernel:  [<c10326f6>] warn_slowpath_fmt+0x26/0x30
kernel:  [<c111eb8b>] __list_add+0x8b/0x90
kernel:  [<c11ba165>] i2c_sysfs_new_device+0x1c5/0x250
kernel:  [<c10861be>] ? might_fault+0x2e/0x80
kernel:  [<c11b9fa0>] ? i2c_sysfs_new_device+0x0/0x250
kernel:  [<c118c625>] dev_attr_store+0x25/0x30
kernel:  [<c10e305c>] sysfs_write_file+0x9c/0xf0
kernel:  [<c109d35c>] vfs_write+0x9c/0x160
kernel:  [<c10e2fc0>] ? sysfs_write_file+0x0/0xf0
kernel:  [<c109d4dd>] sys_write+0x3d/0x70
kernel:  [<c1002ed8>] sysenter_do_call+0x12/0x36

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/i2c/i2c-core.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -718,6 +718,7 @@ int i2c_del_adapter(struct i2c_adapter *
 {
 	int res = 0;
 	struct i2c_adapter *found;
+	struct i2c_client *client, *next;
 
 	/* First make sure that this adapter was ever added */
 	mutex_lock(&core_lock);
@@ -737,6 +738,16 @@ int i2c_del_adapter(struct i2c_adapter *
 	if (res)
 		return res;
 
+	/* Remove devices instantiated from sysfs */
+	list_for_each_entry_safe(client, next, &userspace_devices, detected) {
+		if (client->adapter == adap) {
+			dev_dbg(&adap->dev, "Removing %s at 0x%x\n",
+				client->name, client->addr);
+			list_del(&client->detected);
+			i2c_unregister_device(client);
+		}
+	}
+
 	/* Detach any active clients. This can't fail, thus we do not
 	   checking the returned value. */
 	res = device_for_each_child(&adap->dev, NULL, __unregister_client);


