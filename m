Return-Path: <linux-kernel-owner+w=401wt.eu-S1753516AbYGUScj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbYGUScj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 14:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbYGUScb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 14:32:31 -0400
Received: from www17.your-server.de ([213.133.104.17]:53865 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbYGUSca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 14:32:30 -0400
Subject: [BUG] unable to handle kernel NULL pointer dereference
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 20:32:26 +0200
Message-Id: <1216665146.3158.5.camel@dhcppc2>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch on top of next-20080718:

diff --git a/drivers/firmware/memmap.c b/drivers/firmware/memmap.c
index e23399c..b566516 100644
--- a/drivers/firmware/memmap.c
+++ b/drivers/firmware/memmap.c
@@ -108,7 +108,13 @@ static int firmware_map_add_entry(resource_size_t start, resource_size_t end,
        entry->end = end;
        entry->type = type;
        INIT_LIST_HEAD(&entry->list);
-       kobject_init(&entry->kobj, &memmap_ktype);
+       /*
+        * don't init the kobject here since it calls kmalloc() internally
+        * which we are not ready to do in firmware_map_add_early() case
+        * Instead, do that before kobject_add() in memmap_init()
+        */
+       memset(&entry->kobj, 0, sizeof(struct kobject));
+
 
        list_add_tail(&entry->list, &map_entries);
 
@@ -195,6 +201,7 @@ static int __init memmap_init(void)
                return -ENOMEM;
 
        list_for_each_entry(entry, &map_entries, list) {
+               kobject_init(&entry->kobj, &memmap_ktype);
                entry->kobj.kset = memmap_kset;
                kobject_add(&entry->kobj, NULL, "%d", i++);
        }
diff --git a/fs/namei.c b/fs/namei.c
index a15c155..33dc63d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -286,7 +286,8 @@ int permission(struct inode *inode, int mask, struct nameidata *nd)
        if (retval)
                return retval;
 
-       return security_inode_permission(inode, mask);
+       return security_inode_permission(inode,
+                                        mask & (MAY_READ|MAY_WRITE|MAY_EXEC));
 }
 
 /**
diff --git a/net/sysctl_net.c b/net/sysctl_net.c
index b91a5de..2240a9e 100644
--- a/net/sysctl_net.c
+++ b/net/sysctl_net.c
@@ -44,13 +44,6 @@ static struct ctl_table_root net_sysctl_root = {
        .lookup = net_ctl_header_lookup,
 };
 
-static LIST_HEAD(net_sysctl_ro_tables);
-static struct list_head *net_ctl_ro_header_lookup(struct ctl_table_root *root,
-               struct nsproxy *namespaces)
-{
-       return &net_sysctl_ro_tables;
-}
-
 static int net_ctl_ro_header_perms(struct ctl_table_root *root,
                struct nsproxy *namespaces, struct ctl_table *table)
 {
@@ -61,7 +54,6 @@ static int net_ctl_ro_header_perms(struct ctl_table_root *root,
 }
 
 static struct ctl_table_root net_sysctl_ro_root = {
-       .lookup = net_ctl_ro_header_lookup,
        .permissions = net_ctl_ro_header_perms,
 };
 
@@ -89,6 +81,7 @@ static __init int sysctl_init(void)
        if (ret)
                goto out;
        register_sysctl_root(&net_sysctl_root);
+       setup_sysctl_set(&net_sysctl_ro_root.default_set, NULL, NULL);
        register_sysctl_root(&net_sysctl_ro_root);
 out:
        return ret;

I get the following BUG:

[    9.701059] BUG: unable to handle kernel NULL pointer dereference at 000002ab
[    9.701151] IP: [<c0587857>] hub_suspend+0x13/0x4d
[    9.701226] *pdpt = 0000000036f07001 *pde = 0000000000000000 
[    9.701323] Oops: 0000 [#1] SMP 
[    9.701410] last sysfs file: /sys/class/firmware/timeout
[    9.701461] Modules linked in: sata_nv ata_generic libata sd_mod scsi_mod sha256_generic aes_i586 dm_crypt dm_snapshot dm_zero dm_mirror dm_log dm_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd
[    9.701969] 
[    9.702017] Pid: 171, comm: ksuspend_usbd Not tainted (2.6.26-next-20080718 #18)
[    9.702092] EIP: 0060:[<c0587857>] EFLAGS: 00010286 CPU: 1
[    9.702142] EIP is at hub_suspend+0x13/0x4d
[    9.702190] EAX: 0000005b EBX: f6df3000 ECX: c0587844 EDX: 00000001
[    9.702240] ESI: f6f47600 EDI: f6e1ec00 EBP: f796ff4c ESP: f796ff44
[    9.702289]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    9.702338] Process ksuspend_usbd (pid: 171, ti=f796f000 task=f7906ff0 task.ti=f796f000)
[    9.702387] Stack: f6e1ec00 f6f47600 f796ff70 c058cd08 00000000 00000000 00000000 00000002 
[    9.702641]        f6e1ec00 f6e1eee0 00000000 f796ff88 c058cb21 f6e1ef20 f7961e00 f6e1eee0 
[    9.702896]        c058d04d f796ff90 c058d05c f796ffa8 c0434232 f7961e04 f7961e00 f7961e04 
[    9.703150] Call Trace:
[    9.703242]  [<c058cd08>] ? usb_suspend_both+0xc5/0x239
[    9.703255]  [<c058cb21>] ? usb_autopm_do_device+0xa3/0xb9
[    9.703255]  [<c058d04d>] ? usb_autosuspend_work+0x0/0x11
[    9.703255]  [<c058d05c>] ? usb_autosuspend_work+0xf/0x11
[    9.703255]  [<c0434232>] ? run_workqueue+0x71/0xe6
[    9.703255]  [<c043435d>] ? worker_thread+0xb6/0xc2
[    9.703255]  [<c0436fbf>] ? autoremove_wake_function+0x0/0x33
[    9.703255]  [<c04342a7>] ? worker_thread+0x0/0xc2
[    9.703255]  [<c0436d48>] ? kthread+0x3b/0x61
[    9.703255]  [<c0436d0d>] ? kthread+0x0/0x61
[    9.703255]  [<c04044ef>] ? kernel_thread_helper+0x7/0x10
[    9.703255]  =======================
[    9.703255] Code: c3 55 8b 80 ec 00 00 00 ba 01 00 00 00 89 e5 e8 8a ff ff ff 31 c0 c9 c3 55 ba 01 00 00 00 89 e5 56 53 8b 98 ec 00 00 00 8b 43 04 <8b> b0 50 02 00 00 eb 1c 8b 8c 90 50 02 00 00 85 c9 74 10 f6 81 
[    9.703255] EIP: [<c0587857>] hub_suspend+0x13/0x4d SS:ESP 0068:f796ff44
[    9.706196] ---[ end trace 352a4d041c742925 ]---


