Return-Path: <linux-kernel-owner+w=401wt.eu-S1752134AbYI2TWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbYI2TWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 15:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbYI2TWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 15:22:08 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:56034 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbYI2TWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 15:22:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nI2iAPe85+kSsI7a2IvaSj7ytv8Bs5myNXx+OqZwrN88+WoLaVh4uKzC2I18pGgdmb
         iOsru0/ytOX9JOUC3zKkKE5RD0LzXIaCEafWCJbbRk07MK6pN+LLS1wvI7LAnxUayCGa
         gCxoqNsFzGxJ+syU7BdUF8YqObmFPdB+lDsMM=
Message-ID: <dd18b0c30809291222u1182f712yef52aad3ca0762a9@mail.gmail.com>
Date: Mon, 29 Sep 2008 12:22:05 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Rabin Vincent" <rabin@rab.in>
Subject: Re: BUG kmalloc-16: Object already free
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       marcel@holtmann.org, linux-bluetooth@vger.kernel.org
In-Reply-To: <20080929181752.GA2027@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30809281554g11ac7275x819812935b6ac68f@mail.gmail.com>
	 <20080929181752.GA2027@debian>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 11:17 AM, Rabin Vincent <rabin@rab.in> wrote:
> On Sun, Sep 28, 2008 at 03:54:23PM -0700, Justin Mattock wrote:
>> After frying my system, I'm finally up and
>> running. Not sure if this was due to a git-pull
>> (only be a few days since the last pull), or what:
>> when waking from suspend I see this
>> (I know it says tainted in it, so this will be the only noise you'll
>> here from me on this);
>>
>> [  274.327003] =============================================================================
>> [  274.327528] BUG kmalloc-16: Object already free
>> [  274.327877] -----------------------------------------------------------------------------
>> [  274.327879]
>> [  274.327890] INFO: Allocated in btusb_open+0x82/0x16f [btusb] age=0
>> cpu=1 pid=3763
>> [  274.327899] INFO: Freed in btusb_open+0x13d/0x16f [btusb] age=0
>> cpu=1 pid=3763
>> [  274.327905] INFO: Slab 0xc139a100 objects=64 used=62 fp=0xdcd08100
>> flags=0x400000c3
>
> There's a commit in the latest git which looks like it will solve the
> btusb suspend/resume issues: 5fbcd260.. ("[Bluetooth] Fix USB disconnect
> handling of btusb driver").
>
> Marcel / linux-bluetooth, I think this double free is a separate issue
> with the error handling, and the following patch should fix it.
>
> ---
> From: Rabin Vincent <rabin@rab.in>
> Subject: [PATCH] btusb, bpa10x: fix double frees on error paths
>
> Justin Mattock reported this double free in btusb:
>
>  BUG kmalloc-16: Object already free
>  -----------------------------------------------------------------------------
>
>  INFO: Allocated in btusb_open+0x82/0x16f [btusb] age=3D0 cpu=3D1 pid=3D3763
>  INFO: Freed in btusb_open+0x13d/0x16f [btusb] age=3D0 cpu=3D1 pid=3D3763
>
> This occurs because the urb's transfer buffer is being freed separately
> in the error path even though the URB_FREE_BUFFER transfer_flag is set
> on the urb.
>
> There are similar cases elsewhere in btusb and in bpa10x.  Fix all of
> them by removing the additional kfree()'s.
>
> Reported-by: Justin Mattock <justinmattock@gmail.com>
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
>  drivers/bluetooth/bpa10x.c |    2 --
>  drivers/bluetooth/btusb.c  |    3 ---
>  2 files changed, 0 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/bluetooth/bpa10x.c b/drivers/bluetooth/bpa10x.c
> index 1e55a65..32f3a8e 100644
> --- a/drivers/bluetooth/bpa10x.c
> +++ b/drivers/bluetooth/bpa10x.c
> @@ -256,7 +256,6 @@ static inline int bpa10x_submit_intr_urb(struct hci_dev *hdev)
>                BT_ERR("%s urb %p submission failed (%d)",
>                                                hdev->name, urb, -err);
>                usb_unanchor_urb(urb);
> -               kfree(buf);
>        }
>
>        usb_free_urb(urb);
> @@ -298,7 +297,6 @@ static inline int bpa10x_submit_bulk_urb(struct hci_dev *hdev)
>                BT_ERR("%s urb %p submission failed (%d)",
>                                                hdev->name, urb, -err);
>                usb_unanchor_urb(urb);
> -               kfree(buf);
>        }
>
>        usb_free_urb(urb);
> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> index 29ae998..262e9be 100644
> --- a/drivers/bluetooth/btusb.c
> +++ b/drivers/bluetooth/btusb.c
> @@ -271,7 +271,6 @@ static int btusb_submit_intr_urb(struct hci_dev *hdev)
>                BT_ERR("%s urb %p submission failed (%d)",
>                                                hdev->name, urb, -err);
>                usb_unanchor_urb(urb);
> -               kfree(buf);
>        }
>
>        usb_free_urb(urb);
> @@ -354,7 +353,6 @@ static int btusb_submit_bulk_urb(struct hci_dev *hdev)
>                BT_ERR("%s urb %p submission failed (%d)",
>                                                hdev->name, urb, -err);
>                usb_unanchor_urb(urb);
> -               kfree(buf);
>        }
>
>        usb_free_urb(urb);
> @@ -475,7 +473,6 @@ static int btusb_submit_isoc_urb(struct hci_dev *hdev)
>                BT_ERR("%s urb %p submission failed (%d)",
>                                                hdev->name, urb, -err);
>                usb_unanchor_urb(urb);
> -               kfree(buf);
>        }
>
>        usb_free_urb(urb);
> --
> 1.5.6.5
>
>

Cool, depending on the status of
this patch. either I'll apply this one, or just wait
until it gets commited,and then just do a git-pull.

-- 
Justin P. Mattock
