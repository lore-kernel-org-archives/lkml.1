Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbYI2SSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbYI2SSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbYI2SSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:18:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:22437 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576AbYI2SST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:18:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=OeblUjD/HLyTSfPJkYs7763nXAYKDvF7li8qwi2gn3+DF1HnIoFSZZh0DQ20SGYPLo
         0ugcKMy6Va19I7s7evQuEG6doTMkpZ19HvXSJ3fuVcJJfjdhKelSdku2eAypQNA1oIp6
         L403B/i3PnEcMdIJR+m7Kl5hngPG6ykOc0mAA=
Date: Mon, 29 Sep 2008 23:47:52 +0530
From: Rabin Vincent <rabin@rab.in>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       marcel@holtmann.org, linux-bluetooth@vger.kernel.org
Subject: Re: BUG kmalloc-16: Object already free
Message-ID: <20080929181752.GA2027@debian>
References: <dd18b0c30809281554g11ac7275x819812935b6ac68f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd18b0c30809281554g11ac7275x819812935b6ac68f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2008 at 03:54:23PM -0700, Justin Mattock wrote:
> After frying my system, I'm finally up and
> running. Not sure if this was due to a git-pull
> (only be a few days since the last pull), or what:
> when waking from suspend I see this
> (I know it says tainted in it, so this will be the only noise you'll
> here from me on this);
> 
> [  274.327003] =============================================================================
> [  274.327528] BUG kmalloc-16: Object already free
> [  274.327877] -----------------------------------------------------------------------------
> [  274.327879]
> [  274.327890] INFO: Allocated in btusb_open+0x82/0x16f [btusb] age=0
> cpu=1 pid=3763
> [  274.327899] INFO: Freed in btusb_open+0x13d/0x16f [btusb] age=0
> cpu=1 pid=3763
> [  274.327905] INFO: Slab 0xc139a100 objects=64 used=62 fp=0xdcd08100
> flags=0x400000c3

There's a commit in the latest git which looks like it will solve the
btusb suspend/resume issues: 5fbcd260.. ("[Bluetooth] Fix USB disconnect
handling of btusb driver").

Marcel / linux-bluetooth, I think this double free is a separate issue
with the error handling, and the following patch should fix it.

---
From: Rabin Vincent <rabin@rab.in>
Subject: [PATCH] btusb, bpa10x: fix double frees on error paths

Justin Mattock reported this double free in btusb:

  BUG kmalloc-16: Object already free
  -----------------------------------------------------------------------------

  INFO: Allocated in btusb_open+0x82/0x16f [btusb] age=3D0 cpu=3D1 pid=3D3763
  INFO: Freed in btusb_open+0x13d/0x16f [btusb] age=3D0 cpu=3D1 pid=3D3763

This occurs because the urb's transfer buffer is being freed separately
in the error path even though the URB_FREE_BUFFER transfer_flag is set
on the urb.

There are similar cases elsewhere in btusb and in bpa10x.  Fix all of
them by removing the additional kfree()'s.

Reported-by: Justin Mattock <justinmattock@gmail.com>
Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 drivers/bluetooth/bpa10x.c |    2 --
 drivers/bluetooth/btusb.c  |    3 ---
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/bluetooth/bpa10x.c b/drivers/bluetooth/bpa10x.c
index 1e55a65..32f3a8e 100644
--- a/drivers/bluetooth/bpa10x.c
+++ b/drivers/bluetooth/bpa10x.c
@@ -256,7 +256,6 @@ static inline int bpa10x_submit_intr_urb(struct hci_dev *hdev)
 		BT_ERR("%s urb %p submission failed (%d)",
 						hdev->name, urb, -err);
 		usb_unanchor_urb(urb);
-		kfree(buf);
 	}
 
 	usb_free_urb(urb);
@@ -298,7 +297,6 @@ static inline int bpa10x_submit_bulk_urb(struct hci_dev *hdev)
 		BT_ERR("%s urb %p submission failed (%d)",
 						hdev->name, urb, -err);
 		usb_unanchor_urb(urb);
-		kfree(buf);
 	}
 
 	usb_free_urb(urb);
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 29ae998..262e9be 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -271,7 +271,6 @@ static int btusb_submit_intr_urb(struct hci_dev *hdev)
 		BT_ERR("%s urb %p submission failed (%d)",
 						hdev->name, urb, -err);
 		usb_unanchor_urb(urb);
-		kfree(buf);
 	}
 
 	usb_free_urb(urb);
@@ -354,7 +353,6 @@ static int btusb_submit_bulk_urb(struct hci_dev *hdev)
 		BT_ERR("%s urb %p submission failed (%d)",
 						hdev->name, urb, -err);
 		usb_unanchor_urb(urb);
-		kfree(buf);
 	}
 
 	usb_free_urb(urb);
@@ -475,7 +473,6 @@ static int btusb_submit_isoc_urb(struct hci_dev *hdev)
 		BT_ERR("%s urb %p submission failed (%d)",
 						hdev->name, urb, -err);
 		usb_unanchor_urb(urb);
-		kfree(buf);
 	}
 
 	usb_free_urb(urb);
-- 
1.5.6.5

