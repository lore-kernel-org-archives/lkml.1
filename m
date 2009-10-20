Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631AbZJTWOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbZJTWOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 18:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbZJTWOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 18:14:48 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:43406 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbZJTWOs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 18:14:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YfpRVEGbFLhIGPMLXcMV7fYXY0dQsCKUGq26/LL7W6ZvYuQ2L28gGm/GDsFX9P7lT/
         /kpPycBa6xrQ7+CcEl7tKKESl5u9aQVO4nMhpvQjR7B4HO2Pqz2fKj9h8AymRvUi/vDC
         j6GlokhBRSdvvgQC1F3hC2c0bkmfgSD8VSIJg=
MIME-Version: 1.0
In-Reply-To: <1256040610-30684-1-git-send-email-chaithrika@ti.com>
References: <1256040610-30684-1-git-send-email-chaithrika@ti.com>
Date: Wed, 21 Oct 2009 00:14:51 +0200
Message-ID: <63386a3d0910201514r2680bbeei13a770a3d7e4a323@mail.gmail.com>
Subject: Re: [PATCH] davinci: MMC: add cpufreq support
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Chaithrika U S <chaithrika@ti.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       davinci-linux-open-source@linux.davincidsp.com, vipin.bhandari@ti.com,
       khilman@deeprootsystems.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/20 Chaithrika U S <chaithrika@ti.com>:

> Add cpufreq support to MMC driver. The clock divider value has to be
> modified according to the controller input frequency.
> (...)
> @@ -1040,6 +1052,52 @@ static struct mmc_host_ops mmc_davinci_ops = {
>
>  /*----------------------------------------------------------------------*/
>
> +#ifdef CONFIG_CPU_FREQ
> +static int mmc_davinci_cpufreq_transition(struct notifier_block *nb,
> +                                    unsigned long val, void *data)
> +{
> +       struct mmc_davinci_host *host;
> +       unsigned int mmc_pclk;
> +       struct mmc_host *mmc;
> +       unsigned long flags;
> +
> +       host = container_of(nb, struct mmc_davinci_host, freq_transition);
> +       mmc = host->mmc;
> +       mmc_pclk = clk_get_rate(host->clk);
> +
> +       if (val == CPUFREQ_POSTCHANGE) {
> +               spin_lock_irqsave(&mmc->lock, flags);
> +               host->mmc_input_clk = mmc_pclk;
> +               calculate_clk_divider(mmc, &mmc->ios);
> +               spin_unlock_irqrestore(&mmc->lock, flags);
> +       }
> +
> +       return 0;
> +}

Now the way I understand it CPUfreq is about rising/lowering the
frequency of the *CPU* when the load of the system goes up/down.

I highly suspect that there is no general rule that davinci's host->clk
will actually change just because the CPU changes frequency?

I don't know enough about davinci to tell but I suspect there are
system-wide operating points hidden behind this and CPUfreq
is being (ab)used for changing and notifying the system frequency
overall. Some of these transitions include changing the MMC clock
so if you simply broadcast them all?

I really believe this is just masking the problem that the clk
framework need support of real clk notifiers that can notify clk
users pre/post a clk change. This is really what you want for a
driver like this.

Now I don't know the davinci consensus around these things,
do you always use CPUfreq like this, for changing frequencies
of clocks that are not CPU clocks at all?

I have similar code boiling for the MMCI/PL180 PrimeCell but
I just cannot submit that because the PrimeCell is generic and
there is no way I can implicitly correlate the CPU clk with the
MMCI host clk like this, so I have to wait for real clock notifiers
(or implement them myself...)

Linus Walleij
