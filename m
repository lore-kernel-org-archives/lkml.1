Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744Ab0AEAkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab0AEAkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754597Ab0AEAkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:40:20 -0500
Received: from kroah.org ([198.145.64.141]:42421 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508Ab0AEAgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:36:01 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Andrey Borzenkov <arvidjaar@mail.ru>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 78/97] orinoco: fix GFP_KERNEL in orinoco_set_key with interrupts disabled
Date: Mon,  4 Jan 2010 16:33:31 -0800
Message-Id: <1262651630-7354-78-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Borzenkov <arvidjaar@mail.ru>

commit 5b0691508aa99d309101a49b4b084dc16b3d7019 upstream.

orinoco_set_key is called from two places both with interrupts disabled
(under orinoco_lock). Use GFP_ATOMIC instead of GFP_KERNEL. Fixes following
warning:

[   77.254109] WARNING: at /home/bor/src/linux-git/kernel/lockdep.c:2465 lockdep_trace_alloc+0x9a/0xa0()
[   77.254109] Hardware name: PORTEGE 4000
[   77.254109] Modules linked in: af_packet irnet ppp_generic slhc ircomm_tty ircomm binfmt_misc dm_mirror dm_region_hash dm_log dm_round_robin dm_multipath dm_mod loop nvram toshiba cryptomgr aead pcompress crypto_blkcipher michael_mic crypto_hash crypto_algapi orinoco_cs orinoco cfg80211 smsc_ircc2 pcmcia irda toshiba_acpi yenta_socket video i2c_ali1535 backlight rsrc_nonstatic ali_agp pcmcia_core psmouse output crc_ccitt i2c_core alim1535_wdt rfkill sg evdev ohci_hcd agpgart usbcore pata_ali libata reiserfs [last unloaded: scsi_wait_scan]
[   77.254109] Pid: 2296, comm: wpa_supplicant Not tainted 2.6.32-1avb #1
[   77.254109] Call Trace:
[   77.254109]  [<c011f0ad>] warn_slowpath_common+0x6d/0xa0
[   77.254109]  [<c014206a>] ? lockdep_trace_alloc+0x9a/0xa0
[   77.254109]  [<c014206a>] ? lockdep_trace_alloc+0x9a/0xa0
[   77.254109]  [<c011f0f5>] warn_slowpath_null+0x15/0x20
[   77.254109]  [<c014206a>] lockdep_trace_alloc+0x9a/0xa0
[   77.254109]  [<c018d296>] __kmalloc+0x36/0x130
[   77.254109]  [<dffcb6a8>] ? orinoco_set_key+0x48/0x1c0 [orinoco]
[   77.254109]  [<dffcb6a8>] orinoco_set_key+0x48/0x1c0 [orinoco]
[   77.254109]  [<dffcb9fc>] orinoco_ioctl_set_encodeext+0x1dc/0x2d0 [orinoco]
[   77.254109]  [<c035b117>] ioctl_standard_call+0x207/0x3b0
[   77.254109]  [<dffcb820>] ? orinoco_ioctl_set_encodeext+0x0/0x2d0 [orinoco]
[   77.254109]  [<c0307f1f>] ? rtnl_lock+0xf/0x20
[   77.254109]  [<c0307f1f>] ? rtnl_lock+0xf/0x20
[   77.254109]  [<c02fb115>] ? __dev_get_by_name+0x85/0xb0
[   77.254109]  [<c035b616>] wext_handle_ioctl+0x176/0x200
[   77.254109]  [<dffcb820>] ? orinoco_ioctl_set_encodeext+0x0/0x2d0 [orinoco]
[   77.254109]  [<c030020f>] dev_ioctl+0x6af/0x730
[   77.254109]  [<c02eec65>] ? move_addr_to_kernel+0x55/0x60
[   77.254109]  [<c02eed59>] ? sys_sendto+0xe9/0x130
[   77.254109]  [<c02ed77e>] sock_ioctl+0x7e/0x250
[   77.254109]  [<c02ed700>] ? sock_ioctl+0x0/0x250
[   77.254109]  [<c019cf4c>] vfs_ioctl+0x1c/0x70
[   77.254109]  [<c019d1fa>] do_vfs_ioctl+0x6a/0x590
[   77.254109]  [<c0178e50>] ? might_fault+0x90/0xa0
[   77.254109]  [<c0178e0a>] ? might_fault+0x4a/0xa0
[   77.254109]  [<c02ef90e>] ? sys_socketcall+0x17e/0x280
[   77.254109]  [<c019d759>] sys_ioctl+0x39/0x60
[   77.254109]  [<c0102e3b>] sysenter_do_call+0x12/0x32
[   77.254109] ---[ end trace 95ef563548d21efd ]---

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/orinoco/wext.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/orinoco/wext.c b/drivers/net/wireless/orinoco/wext.c
index 7698fdd..31ca241 100644
--- a/drivers/net/wireless/orinoco/wext.c
+++ b/drivers/net/wireless/orinoco/wext.c
@@ -23,7 +23,7 @@
 #define MAX_RID_LEN 1024
 
 /* Helper routine to record keys
- * Do not call from interrupt context */
+ * It is called under orinoco_lock so it may not sleep */
 static int orinoco_set_key(struct orinoco_private *priv, int index,
 			   enum orinoco_alg alg, const u8 *key, int key_len,
 			   const u8 *seq, int seq_len)
@@ -32,14 +32,14 @@ static int orinoco_set_key(struct orinoco_private *priv, int index,
 	kzfree(priv->keys[index].seq);
 
 	if (key_len) {
-		priv->keys[index].key = kzalloc(key_len, GFP_KERNEL);
+		priv->keys[index].key = kzalloc(key_len, GFP_ATOMIC);
 		if (!priv->keys[index].key)
 			goto nomem;
 	} else
 		priv->keys[index].key = NULL;
 
 	if (seq_len) {
-		priv->keys[index].seq = kzalloc(seq_len, GFP_KERNEL);
+		priv->keys[index].seq = kzalloc(seq_len, GFP_ATOMIC);
 		if (!priv->keys[index].seq)
 			goto free_key;
 	} else
-- 
1.6.6

