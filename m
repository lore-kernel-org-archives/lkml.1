Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbZIBBSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbZIBBSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 21:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755498AbZIBBSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 21:18:53 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:48278 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324AbZIBBSw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 21:18:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=MDWSgx45HSt4OP9hGZZeG2LCmUOf4W9zWvilO/CJjTHzu0X/fiWxcCW52Sv3I3yiEa
         Nj3DOPttfKqaYUdtAh6x913CfxcuFy5/WqjQkyRuiRgmuPrVaiMcpwmSKHyPj5h5GXaJ
         D0VKLEJTWL2yi8jF+IZ4mzznlYONrlP6ac73o=
MIME-Version: 1.0
In-Reply-To: <200908210848.39377.elendil@planet.nl>
References: <200908201714.30638.elendil@planet.nl>
	 <200908210829.10471.elendil@planet.nl> <4A8E3FC1.50201@redhat.com>
	 <200908210848.39377.elendil@planet.nl>
Date: Tue, 1 Sep 2009 18:18:52 -0700
X-Google-Sender-Auth: 200c1d70456e4a1f
Message-ID: <9929d2390909011818r1acf646ct8a1d5ad57b0e2bfd@mail.gmail.com>
Subject: Re: [PATCH,v2] Re: e1000e: why does pci_enable_pcie_error_reporting() 
	fail on my hp2510p?
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Frans Pop <elendil@planet.nl>
Cc: Danny Feng <dfeng@redhat.com>, Netdev <netdev@vger.kernel.org>,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 23:48, Frans Pop<elendil@planet.nl> wrote:
> On Friday 21 August 2009, Danny Feng wrote:
>> You may also need to silence pci_disable_pcie_error_reporting,
>> otherwise rmmod/shutdown, you will get
>>
>> e1000e 0000:00:19.0: pci_disable_pcie_error_reporting failed
>
> Yes, thanks. Exactly the same thing there. Updated patch below.
>
>
> From: Frans Pop <elendil@planet.nl>
> Subject: net: Don't report an error if devices don't support AER
>
> The only error returned by pci_{en,dis}able_pcie_error_reporting() is
> -EIO which simply means that Advanced Error Reporting is not supported.
> There is no need to report that, so remove the error check from e1001e,
> igb and ixgbe.
>
> Signed-off-by: Frans Pop <elendil@planet.nl>
>
> diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
> index fa92a68..d67798f 100644
> --- a/drivers/net/e1000e/netdev.c
> +++ b/drivers/net/e1000e/netdev.c
> @@ -4983,12 +4983,7 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
>                goto err_pci_reg;
>
>        /* AER (Advanced Error Reporting) hooks */
> -       err = pci_enable_pcie_error_reporting(pdev);
> -       if (err) {
> -               dev_err(&pdev->dev, "pci_enable_pcie_error_reporting failed "
> -                       "0x%x\n", err);
> -               /* non-fatal, continue */
> -       }
> +       pci_enable_pcie_error_reporting(pdev);
>
>        pci_set_master(pdev);
>        /* PCI config space info */
> @@ -5301,9 +5296,6 @@ static void __devexit e1000_remove(struct pci_dev *pdev)
>
>        /* AER disable */
>        err = pci_disable_pcie_error_reporting(pdev);
> -       if (err)
> -               dev_err(&pdev->dev,
> -                       "pci_disable_pcie_error_reporting failed 0x%x\n", err);
>
>        pci_disable_device(pdev);
>  }
> diff --git a/drivers/net/igb/igb_main.c b/drivers/net/igb/igb_main.c
> index adb09d3..1533d6f 100644
> --- a/drivers/net/igb/igb_main.c
> +++ b/drivers/net/igb/igb_main.c
> @@ -1232,12 +1232,7 @@ static int __devinit igb_probe(struct pci_dev *pdev,
>        if (err)
>                goto err_pci_reg;
>
> -       err = pci_enable_pcie_error_reporting(pdev);
> -       if (err) {
> -               dev_err(&pdev->dev, "pci_enable_pcie_error_reporting failed "
> -                       "0x%x\n", err);
> -               /* non-fatal, continue */
> -       }
> +       pci_enable_pcie_error_reporting(pdev);
>
>        pci_set_master(pdev);
>        pci_save_state(pdev);
> @@ -1668,9 +1663,6 @@ static void __devexit igb_remove(struct pci_dev *pdev)
>        free_netdev(netdev);
>
>        err = pci_disable_pcie_error_reporting(pdev);
> -       if (err)
> -               dev_err(&pdev->dev,
> -                       "pci_disable_pcie_error_reporting failed 0x%x\n", err);
>
>        pci_disable_device(pdev);
>  }
> diff --git a/drivers/net/ixgbe/ixgbe_main.c b/drivers/net/ixgbe/ixgbe_main.c
> index 77b0381..777556d 100644
> --- a/drivers/net/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ixgbe/ixgbe_main.c
> @@ -5430,12 +5430,7 @@ static int __devinit ixgbe_probe(struct pci_dev *pdev,
>                goto err_pci_reg;
>        }
>
> -       err = pci_enable_pcie_error_reporting(pdev);
> -       if (err) {
> -               dev_err(&pdev->dev, "pci_enable_pcie_error_reporting failed "
> -                                   "0x%x\n", err);
> -               /* non-fatal, continue */
> -       }
> +       pci_enable_pcie_error_reporting(pdev);
>
>        pci_set_master(pdev);
>        pci_save_state(pdev);
> @@ -5795,9 +5790,6 @@ static void __devexit ixgbe_remove(struct pci_dev *pdev)
>        free_netdev(netdev);
>
>        err = pci_disable_pcie_error_reporting(pdev);
> -       if (err)
> -               dev_err(&pdev->dev,
> -                       "pci_disable_pcie_error_reporting failed 0x%x\n", err);
>
>        pci_disable_device(pdev);
>  }

Patch looks fine

Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
