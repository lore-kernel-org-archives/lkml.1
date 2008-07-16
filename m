Return-Path: <linux-kernel-owner+w=401wt.eu-S1759868AbYGPQP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759868AbYGPQP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 12:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757376AbYGPQPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 12:15:12 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:55441 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834AbYGPQPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 12:15:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OUWbN9qfddDuaiB+anhoC7E3yPyqn5zUvr5ycD0TLQNVpMkVVAEpcSImEUsg1qcFVk
         9JAkjBdqR2DGZ9RRNK3sWJRaf6LesQLCCV7+TwSS2rdN9pGeoZFR/9vfuv/MEUTojzNI
         7mWff0dXM0kzTYOF4QaI+Hcpco7XLTZVjTLmI=
Message-ID: <40f31dec0807160915g8a5b083p9f21fae729839445@mail.gmail.com>
Date: Wed, 16 Jul 2008 19:15:07 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 5/5] Ath5k: suspend/resume fixes
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@gmail.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>
In-Reply-To: <1216136661-10930-4-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216136661-10930-1-git-send-email-jirislaby@gmail.com>
	 <1216136661-10930-4-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/15 Jiri Slaby <jirislaby@gmail.com>:
> - free and re-request irq since it might have changed during suspend
> - disable and enable msi
> - don't set D0 state of the device, it's already done by the PCI layer
> - do restore_state before enable_device, it's safer
> - check ath5k_init return value
>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Nick Kossifidis <mickflemm@gmail.com>
> Cc: Luis R. Rodriguez <mcgrof@gmail.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> ---
>  drivers/net/wireless/ath5k/base.c |   26 +++++++++++++++++++++-----
>  1 files changed, 21 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index 713ee99..d58a883 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -593,6 +593,9 @@ ath5k_pci_suspend(struct pci_dev *pdev, pm_message_t state)
>        ath5k_led_off(sc);
>
>        ath5k_stop_hw(sc);
> +
> +       free_irq(pdev->irq, sc);
> +       pci_disable_msi(pdev);
>        pci_save_state(pdev);
>        pci_disable_device(pdev);
>        pci_set_power_state(pdev, PCI_D3hot);
> @@ -608,15 +611,12 @@ ath5k_pci_resume(struct pci_dev *pdev)
>        struct ath5k_hw *ah = sc->ah;
>        int i, err;
>
> -       err = pci_set_power_state(pdev, PCI_D0);
> -       if (err)
> -               return err;
> +       pci_restore_state(pdev);
>
>        err = pci_enable_device(pdev);
>        if (err)
>                return err;
>
> -       pci_restore_state(pdev);
>        /*
>         * Suspend/Resume resets the PCI configuration space, so we have to
>         * re-disable the RETRY_TIMEOUT register (0x41) to keep
> @@ -624,7 +624,17 @@ ath5k_pci_resume(struct pci_dev *pdev)
>         */
>        pci_write_config_byte(pdev, 0x41, 0);
>
> -       ath5k_init(sc);
> +       pci_enable_msi(pdev);
> +
> +       err = request_irq(pdev->irq, ath5k_intr, IRQF_SHARED, "ath", sc);
> +       if (err) {
> +               ATH5K_ERR(sc, "request_irq failed\n");
> +               goto err_msi;
> +       }
> +
> +       err = ath5k_init(sc);
> +       if (err)
> +               goto err_irq;
>        ath5k_led_enable(sc);
>
>        /*
> @@ -638,6 +648,12 @@ ath5k_pci_resume(struct pci_dev *pdev)
>                ath5k_hw_reset_key(ah, i);
>
>        return 0;
> +err_irq:
> +       free_irq(pdev->irq, sc);
> +err_msi:
> +       pci_disable_msi(pdev);
> +       pci_disable_device(pdev);
> +       return err;
>  }
>  #endif /* CONFIG_PM */
>
> --
> 1.5.6.2
>
>

It's ok for now, but have in mind that on my upcoming patch series i'm
disabling msi (commented out) since it results no interrupts on pci-e
cards (seems there is a bug in kernel's msi implementation).

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
