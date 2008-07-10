Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbYGJXlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbYGJXlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 19:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbYGJXlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 19:41:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751052AbYGJXla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 19:41:30 -0400
Date: Thu, 10 Jul 2008 16:35:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] Char: isicom, enable/disable pci device
Message-Id: <20080710163515.7d112a87.akpm@linux-foundation.org>
In-Reply-To: <1215699612-17909-1-git-send-email-jirislaby@gmail.com>
References: <1215699612-17909-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008 16:20:12 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:

> Don't forget to enable and disable PCI devices. The device
> might be unusable without that.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> ---
>  drivers/char/isicom.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
> index 4f3cefa..a1a67e3 100644
> --- a/drivers/char/isicom.c
> +++ b/drivers/char/isicom.c
> @@ -1736,6 +1736,12 @@ static int __devinit isicom_probe(struct pci_dev *pdev,
>  	if (card_count >= BOARD_COUNT)
>  		goto err;
>  
> +	retval = pci_enable_device(pdev);
> +	if (retval) {
> +		dev_err(&pdev->dev, "failed to enable\n");
> +		goto err;
> +	}
> +
>  	dev_info(&pdev->dev, "ISI PCI Card(Device ID 0x%x)\n", ent->device);
>  
>  	/* allot the first empty slot in the array */
> @@ -1790,6 +1796,7 @@ errunrr:
>  errdec:
>  	board->base = 0;
>  	card_count--;
> +	pci_disable_device(pdev);
>  err:
>  	return retval;
>  }
> @@ -1806,6 +1813,7 @@ static void __devexit isicom_remove(struct pci_dev *pdev)
>  	pci_release_region(pdev, 3);
>  	board->base = 0;
>  	card_count--;
> +	pci_disable_device(pdev);
>  }
>  
>  static int __init isicom_init(void)

hm.  Is this a recently-added problem?

I wonder what the chance is that this will fix something.  Or break
something.
