Return-Path: <linux-kernel-owner+w=401wt.eu-S935934AbZLQB3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935934AbZLQB3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:29:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935546AbZLQB2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:28:55 -0500
Received: from kroah.org ([198.145.64.141]:48127 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763685AbZLQBUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:54 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:07 2009
Message-Id: <20091217011607.262223579@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:15:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [71/90] p54usb: Remove DMA buffer from stack
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 21d6c270f11c7d0ab5aafa48a6e79ba514f4e5e7 upstream.

On 2.6.32-rc6 from wireless-testing, the following warning is emitted:

------------[ cut here ]------------
WARNING: at lib/dma-debug.c:860 check_for_stack+0xaa/0xe0()
Hardware name: HP Pavilion dv2700 Notebook PC
ehci_hcd 0000:00:02.1: DMA-API: device driver maps memory fromstack
	 [addr=ffff8800b6e2bca8]
Modules linked in: <Removed>
Pid: 16378, comm: modprobe Not tainted 2.6.32-rc6-wl #244
Call Trace:
 [<ffffffff81049698>] warn_slowpath_common+0x78/0xb0
 [<ffffffff8104972c>] warn_slowpath_fmt+0x3c/0x40
 [<ffffffff811ae52a>] check_for_stack+0xaa/0xe0
 [<ffffffff811afc8d>] debug_dma_map_page+0xfd/0x170
 [<ffffffffa006297a>] usb_hcd_submit_urb+0x3da/0x9c0 [usbcore]
 [<ffffffff81076e6f>] ? lockdep_init_map+0x5f/0x5d0
 [<ffffffffa0063365>] usb_submit_urb+0xe5/0x260 [usbcore]
 [<ffffffffa0064b7e>] usb_start_wait_urb+0x5e/0xf0 [usbcore]
 [<ffffffffa0063943>] ? usb_init_urb+0x23/0x40 [usbcore]
 [<ffffffffa0064cd4>] usb_bulk_msg+0xc4/0x150 [usbcore]
 [<ffffffffa0441a91>] T.719+0x31/0x40 [p54usb]
 [<ffffffffa0441acf>] p54u_upload_firmware_3887+0x2f/0x490 [p54usb]
 [<ffffffffa049c667>] ? p54_parse_firmware+0x427/0x450 [p54common]
 <Rest of traceback removed>
---[ end trace f77df0316ddad3de ]---

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/p54/p54usb.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -427,12 +427,16 @@ static const char p54u_romboot_3887[] = 
 static int p54u_firmware_reset_3887(struct ieee80211_hw *dev)
 {
 	struct p54u_priv *priv = dev->priv;
-	u8 buf[4];
+	u8 *buf;
 	int ret;
 
-	memcpy(&buf, p54u_romboot_3887, sizeof(buf));
+	buf = kmalloc(4, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	memcpy(buf, p54u_romboot_3887, 4);
 	ret = p54u_bulk_msg(priv, P54U_PIPE_DATA,
-			    buf, sizeof(buf));
+			    buf, 4);
+	kfree(buf);
 	if (ret)
 		dev_err(&priv->udev->dev, "(p54usb) unable to jump to "
 			"boot ROM (%d)!\n", ret);


