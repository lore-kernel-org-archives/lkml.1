Return-Path: <linux-kernel-owner+w=401wt.eu-S1760000AbZIPU5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000AbZIPU5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 16:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754503AbZIPU5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 16:57:17 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:40729 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbZIPU5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 16:57:17 -0400
Date: Wed, 16 Sep 2009 20:57:17 +0000
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: Lars Ericsson <Lars_Ericsson@telia.com>
Cc: David.Woodhouse@intel.com, sachinp@in.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: Oops in drivers\base\firmware_class
Message-ID: <20090916205717.GB12117@gambetta>
References: <CEAB105C14FD4F848BE08388151DB4E2@gotws1589>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CEAB105C14FD4F848BE08388151DB4E2@gotws1589>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lars,

On Wed, Sep 16, 2009 at 08:44:43PM +0200, Lars Ericsson wrote:
> Hi,
> 
> I have discovered a Oops in the firmware_loading_store function. 
> At first it looks like a timing issue but after adding a BUG_ON test,
> it fails every time. 
> 
> drivers\base\firmware_class:
> ------------------------------
>  541 01c0 F6463401 	testb $1,52(%esi)
>  542 01c4 0F843FFF 	je .L38
>  542      FFFF
>  543              	.loc 1 174 0
>  544 01ca 8B4630   	movl 48(%esi),%eax
>  545 01cd 8B4004   	movl 4(%eax),%eax	<---- Oops
>  546 01d0 E8FCFFFF 	call vfree
>  546      FF
> 
> The code that fails was introduced in commit
> 6e03a201bbe8137487f340d26aa662110e324b20 
Could you try the following patch?

It seems that we're missing the locking around the accesses to
fw_priv->fw.

Thanks,
Frederik

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@xprog.eu>

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 8a267c4..49105ed 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -171,12 +171,18 @@ static ssize_t firmware_loading_store(struct device *dev,
 		break;
 	case 0:
 		if (test_bit(FW_STATUS_LOADING, &fw_priv->status)) {
+			mutex_lock(&fw_lock);
+			if (!fw_priv->fw) {
+				mutex_unlock(&fw_lock);
+				break;
+			}
 			vfree(fw_priv->fw->data);
 			fw_priv->fw->data = vmap(fw_priv->pages,
 						 fw_priv->nr_pages,
 						 0, PAGE_KERNEL_RO);
 			if (!fw_priv->fw->data) {
 				dev_err(dev, "%s: vmap() failed\n", __func__);
+				mutex_unlock(&fw_lock);
 				goto err;
 			}
 			/* Pages will be freed by vfree() */
@@ -185,6 +191,7 @@ static ssize_t firmware_loading_store(struct device *dev,
 			fw_priv->nr_pages = 0;
 			complete(&fw_priv->completion);
 			clear_bit(FW_STATUS_LOADING, &fw_priv->status);
+			mutex_unlock(&fw_lock);
 			break;
 		}
 		/* fallthrough */
> 
> Attached you will find the:
> - Oops with the vanilla 2.6.31
> - The BUG_ON patch
> - Oops with the patched 2.6.31
> 
> /Lars

> [    7.249453] rt61pci 0000:00:09.0: firmware: requesting rt2561s.bin
> [    7.314512] BUG: unable to handle kernel NULL pointer dereference at 00000004
> [    7.315639] IP: [<d04d51cd>] firmware_loading_store+0xed/0x160 [firmware_class]
> [    7.315639] *pde = 00000000
> [    7.315639] Oops: 0000 [#1] PREEMPT
> [    7.315639] last sysfs file: /sys/devices/pci0000:00/0000:00:09.0/firmware/0000:00:09.0/loading
> [    7.315639] Modules linked in: arc4 ecb cryptomgr crypto_blkcipher aead pcompress crypto_hash crypto_algapi rt61pci rt2x00pci rt2x00lib firmware_class mac80211 input_polldev crc_itu_t eeprom_93cx6 cfg80211 ndccanram ndccan ndcser(P) ndcscan(P) eu16550(P) ndccon(P)
> [    7.315639]
> [    7.315639] Pid: 1004, comm: echo Tainted: P           (2.6.31 #1)
> [    7.315639] EIP: 0060:[<d04d51cd>] EFLAGS: 00010202 CPU: 0
> [    7.315639] EIP is at firmware_loading_store+0xed/0x160 [firmware_class]
> [    7.315639] EAX: 00000000 EBX: d04d50e0 ECX: 0000000a EDX: 00000028
> [    7.315639] ESI: cf65ca80 EDI: cea29c00 EBP: cea29c08 ESP: cf777f2c
> [    7.315639]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [    7.315639] Process echo (pid: 1004, ti=cf776000 task=cf755aa0 task.ti=cf776000)
> [    7.315639] Stack:
> [    7.315639]  d04d50e0 cea29c00 00000002 c028051d 00000002 c0414c40 ce9c0420 c01c9c98
> [    7.315639] <0> 00000002 c0414c40 00000002 b7f15000 ce9c1e80 cf44c000 c01c9ce6 ce9c1e94
> [    7.315639] <0> cf44c000 b7f15000 00000002 c01c9cb0 c018d362 cf777f9c cf44c000 fffffff7
> [    7.315639] Call Trace:
> [    7.315639]  [<d04d50e0>] ? firmware_loading_store+0x0/0x160 [firmware_class]
> [    7.315639]  [<c028051d>] ? dev_attr_store+0x1d/0x20
> [    7.315639]  [<c01c9c98>] ? flush_write_buffer+0x38/0x50
> [    7.315639]  [<c01c9ce6>] ? sysfs_write_file+0x36/0x60
> [    7.315639]  [<c01c9cb0>] ? sysfs_write_file+0x0/0x60
> [    7.315639]  [<c018d362>] ? vfs_write+0x82/0xf0
> [    7.315639]  [<c018d47c>] ? sys_write+0x3c/0x70
> [    7.315639]  [<c0102ba1>] ? syscall_call+0x7/0xb
> [    7.315639] Code: 91 c9 ef 3b 5e 3c 7c ed eb b5 8d 74 26 00 83 f8 ff 0f 85 50 ff ff ff e9 6a ff ff ff 89 f6 f6 46 34 01 0f 84 3f ff ff ff 8b 46 30 <8b> 40 04 e8 5b 05 cb ef 31 c9 8b 56 3c 8b 46 38 8b 5e 30 68 61
> [    7.315639] EIP: [<d04d51cd>] firmware_loading_store+0xed/0x160 [firmware_class] SS:ESP 0068:cf777f2c
> [    7.315639] CR2: 0000000000000004
> [    7.540848] ---[ end trace 6ebe83c102d3b046 ]---


> [    7.242449] ------------[ cut here ]------------
> [    7.243706] Kernel BUG at d04d523e [verbose debug info unavailable]
> [    7.243706] invalid opcode: 0000 [#1] PREEMPT
> [    7.243706] last sysfs file: /sys/devices/pci0000:00/0000:00:09.0/firmware/0000:00:09.0/loading
> [    7.243706] Modules linked in: arc4 ecb cryptomgr crypto_blkcipher aead pcompress crypto_hash crypto_algapi rt61pci rt2x00pci rt2x00lib firmware_class mac80211 input_polldev crc_itu_t eeprom_93cx6 cfg80211 ndccanram ndccan ndcser(P) ndcscan(P) eu16550(P) ndccon(P)
> [    7.243706]
> [    7.243706] Pid: 1004, comm: echo Tainted: P           (2.6.31 #1)
> [    7.243706] EIP: 0060:[<d04d523e>] EFLAGS: 00010246 CPU: 0
> [    7.243706] EIP is at firmware_loading_store+0x15e/0x170 [firmware_class]
> [    7.243706] EAX: 00000000 EBX: d04d50e0 ECX: 0000000a EDX: 00000028
> [    7.243706] ESI: cf4f2a20 EDI: cf4ffc00 EBP: cf4ffc08 ESP: cea37f2c
> [    7.243706]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [    7.243706] Process echo (pid: 1004, ti=cea36000 task=cf6c2380 task.ti=cea36000)
> [    7.243706] Stack:
> [    7.243706]  d04d50e0 cf4ffc00 00000002 c028051d 00000002 c0414c40 cf4fd420 c01c9c98
> [    7.243706] <0> 00000002 c0414c40 00000002 b7fc8000 cf636e80 cf471980 c01c9ce6 cf636e94
> [    7.243706] <0> cf471980 b7fc8000 00000002 c01c9cb0 c018d362 cea37f9c cf471980 fffffff7
> [    7.243706] Call Trace:
> [    7.243706]  [<d04d50e0>] ? firmware_loading_store+0x0/0x170 [firmware_class]
> [    7.243706]  [<c028051d>] ? dev_attr_store+0x1d/0x20
> [    7.243706]  [<c01c9c98>] ? flush_write_buffer+0x38/0x50
> [    7.243706]  [<c01c9ce6>] ? sysfs_write_file+0x36/0x60
> [    7.243706]  [<c01c9cb0>] ? sysfs_write_file+0x0/0x60
> [    7.243706]  [<c018d362>] ? vfs_write+0x82/0xf0
> [    7.243706]  [<c018d47c>] ? sys_write+0x3c/0x70
> [    7.243706]  [<c0102ba1>] ? syscall_call+0x7/0xb
> [    7.243706] Code: 66 34 fe e9 14 ff ff ff 8b 47 08 68 1c 5f 4d d0 50 89 f8 e8 65 b2 da ef 50 68 c3 5f 4d d0 e8 da 3c c5 ef 83 c4 10 e9 ea fe ff ff <0f> 0b eb fe 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 55 89 cd
> [    7.243706] EIP: [<d04d523e>] firmware_loading_store+0x15e/0x170 [firmware_class] SS:ESP 0068:cea37f2c
> [    7.458557] ---[ end trace 604593037057054f ]---

