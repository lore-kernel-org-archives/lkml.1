Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbZJUIsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbZJUIsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 04:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbZJUIsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 04:48:11 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55736 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbZJUIsK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 04:48:10 -0400
From: "Chaithrika U S" <chaithrika@ti.com>
To: "'Linus Walleij'" <linus.ml.walleij@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
       <davinci-linux-open-source@linux.davincidsp.com>,
       <vipin.bhandari@ti.com>, <khilman@deeprootsystems.com>
References: <1256040610-30684-1-git-send-email-chaithrika@ti.com> <63386a3d0910201514r2680bbeei13a770a3d7e4a323@mail.gmail.com>
In-Reply-To: <63386a3d0910201514r2680bbeei13a770a3d7e4a323@mail.gmail.com>
Subject: RE: [PATCH] davinci: MMC: add cpufreq support
Date: Wed, 21 Oct 2009 14:15:58 +0530
Message-ID: <029801ca522a$e8dd1ef0$ba975cd0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcpR0b8fVBl41Nc2RYOV6ddzBeinzwAVxaSA
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 21, 2009 at 03:44:51, Linus Walleij wrote:
> 2009/10/20 Chaithrika U S <chaithrika@ti.com>:
> 
> > Add cpufreq support to MMC driver. The clock divider value has to be
> > modified according to the controller input frequency.
> > (...)
> > @@ -1040,6 +1052,52 @@ static struct mmc_host_ops mmc_davinci_ops = {
> >
> >  /*----------------------------------------------------------------------*/
> >
> > +#ifdef CONFIG_CPU_FREQ
> > +static int mmc_davinci_cpufreq_transition(struct notifier_block *nb,
> > +                                    unsigned long val, void *data)
> > +{
> > +       struct mmc_davinci_host *host;
> > +       unsigned int mmc_pclk;
> > +       struct mmc_host *mmc;
> > +       unsigned long flags;
> > +
> > +       host = container_of(nb, struct mmc_davinci_host, freq_transition);
> > +       mmc = host->mmc;
> > +       mmc_pclk = clk_get_rate(host->clk);
> > +
> > +       if (val == CPUFREQ_POSTCHANGE) {
> > +               spin_lock_irqsave(&mmc->lock, flags);
> > +               host->mmc_input_clk = mmc_pclk;
> > +               calculate_clk_divider(mmc, &mmc->ios);
> > +               spin_unlock_irqrestore(&mmc->lock, flags);
> > +       }
> > +
> > +       return 0;
> > +}
> 
> Now the way I understand it CPUfreq is about rising/lowering the
> frequency of the *CPU* when the load of the system goes up/down.
> 
> I highly suspect that there is no general rule that davinci's host->clk
> will actually change just because the CPU changes frequency?
> 

In this case, the PLL controller which supplies clock to the CPU also 
provides clock to the MMC/SD peripheral. Hence, the host->clk changes
with the CPU frequency changes.

> I don't know enough about davinci to tell but I suspect there are
> system-wide operating points hidden behind this and CPUfreq
> is being (ab)used for changing and notifying the system frequency
> overall. Some of these transitions include changing the MMC clock
> so if you simply broadcast them all?
> 
> I really believe this is just masking the problem that the clk
> framework need support of real clk notifiers that can notify clk
> users pre/post a clk change. This is really what you want for a
> driver like this.
> 
> Now I don't know the davinci consensus around these things,
> do you always use CPUfreq like this, for changing frequencies
> of clocks that are not CPU clocks at all?
> 

In the case where the module clock is dependent on CPU clock, cpufreq 
is used to adjust the peripheral clock based on the CPU clock. Similar
implementation is present in Samsung S3C MCI driver too.

> I have similar code boiling for the MMCI/PL180 PrimeCell but
> I just cannot submit that because the PrimeCell is generic and
> there is no way I can implicitly correlate the CPU clk with the
> MMCI host clk like this, so I have to wait for real clock notifiers
> (or implement them myself...)
> 
> Linus Walleij
> 
> 

Regards, 
Chaithrika


