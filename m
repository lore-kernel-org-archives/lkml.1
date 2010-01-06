Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367Ab0AFE4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab0AFE4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 23:56:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764Ab0AFE4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 23:56:32 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:46309 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab0AFE4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 23:56:31 -0500
From: "Chaithrika U S" <chaithrika@ti.com>
To: "'Kevin Hilman'" <khilman@deeprootsystems.com>,
       "'Janakiram Sistla'" <janakiram.sistla@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
       <davinci-linux-open-source@linux.davincidsp.com>
References: <1261052101-14409-1-git-send-email-chaithrika@ti.com>	<4fb5db50912180303w2052bce8q76c04782d9cd355e@mail.gmail.com> <87y6kcp0q6.fsf@deeprootsystems.com>
In-Reply-To: <87y6kcp0q6.fsf@deeprootsystems.com>
Subject: RE: [PATCH 2/2] davinci: MMC: updates to suspend/resume  implementation
Date: Wed, 6 Jan 2010 10:23:22 +0530
Message-ID: <000001ca8e8c$2c82dda0$858898e0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcqOYF19jX4L58ZRRJGTXv4G7jAGnAAK6qoA
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 05:23:53, Kevin Hilman wrote:
> Janakiram Sistla <janakiram.sistla@gmail.com> writes:
> 
> > On 12/17/09, Chaithrika U S <chaithrika@ti.com> wrote:
> >> Improve the suspend and resume callbacks in DaVinci MMC
> >> host controller driver.
> >
> > [Ram] I came cross in the mailing some days back that "direct"
> > .suspend and .resume calls will stop being supported.Is This
> > true??This patch does require a migration then again.
> 
> Yes, this patch (or an additional patch) will have to update the
> MMC driver to use dev_pm_ops.
> 
> See this commit in Linus' tree where I converted the smc91x driver.
> Something like this will nee dto be done for this driver as well.

OK. I will submit an updated version of this patch soon.

Regards, 
Chaithrika

> 
> Kevin
> 
> commit 9f950f72e57fe4bf9b16ace67e4cc5ffcee79d00
> Author: Kevin Hilman <khilman@deeprootsystems.com>
> Date:   Tue Nov 24 12:57:47 2009 +0000
> 
>     NET: smc91x: convert to dev_pm_ops
>     
>     Convert smc91x driver from legacy PM hooks over to using dev_pm_ops.
>     
>     Tested on OMAP3 platform.
>     
>     Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
>     Acked-by: Nicolas Pitre <nico@fluxnic.net>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> >> Tested on DA850/OMAP-L138 EVM. This testing requires patches
> >> which add suspend-to-RAM support to DA850/OMAP-L138 SoC[1].
> >>
> >> [1]http://linux.davincidsp.com/pipermail/davinci-linux-open-source/
> >> 2009-September/016118.html
> >>
> >> Signed-off-by: Chaithrika U S <chaithrika@ti.com>
> >> ---
> >> Applies to Linus' kernel tree.
> >>
> >>  drivers/mmc/host/davinci_mmc.c |   31 +++++++++++++++++++++++++++++--
> >>  1 files changed, 29 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
> >> index 25645bf..7d05cc1 100644
> >> --- a/drivers/mmc/host/davinci_mmc.c
> >> +++ b/drivers/mmc/host/davinci_mmc.c
> >> @@ -170,6 +170,7 @@ struct mmc_davinci_host {
> >>  #define DAVINCI_MMC_DATADIR_READ       1
> >>  #define DAVINCI_MMC_DATADIR_WRITE      2
> >>        unsigned char data_dir;
> >> +       unsigned char suspended;
> >>
> >>        /* buffer is used during PIO of one scatterlist segment, and
> >>         * is updated along with buffer_bytes_left.  bytes_left applies
> >> @@ -1300,15 +1301,41 @@ static int __exit davinci_mmcsd_remove(struct platform_device *pdev)
> >>  static int davinci_mmcsd_suspend(struct platform_device *pdev, pm_message_t msg)
> >>  {
> >>        struct mmc_davinci_host *host = platform_get_drvdata(pdev);
> >> +       int ret;
> >>
> >> -       return mmc_suspend_host(host->mmc, msg);
> >> +       mmc_host_enable(host->mmc);
> >> +       ret = mmc_suspend_host(host->mmc, msg);
> >> +       if (!ret) {
> >> +               writel(0, host->base + DAVINCI_MMCIM);
> >> +               mmc_davinci_reset_ctrl(host, 1);
> >> +               mmc_host_disable(host->mmc);
> >> +               clk_disable(host->clk);
> >> +               host->suspended = 1;
> >> +       } else {
> >> +               host->suspended = 0;
> >> +               mmc_host_disable(host->mmc);
> >> +       }
> >> +
> >> +       return ret;
> >>  }
> >>
> >>  static int davinci_mmcsd_resume(struct platform_device *pdev)
> >>  {
> >>        struct mmc_davinci_host *host = platform_get_drvdata(pdev);
> >> +       int ret;
> >>
> >> -       return mmc_resume_host(host->mmc);
> >> +       if (!host->suspended)
> >> +               return 0;
> >> +
> >> +       clk_enable(host->clk);
> >> +       mmc_host_enable(host->mmc);
> >> +
> >> +       mmc_davinci_reset_ctrl(host, 0);
> >> +       ret = mmc_resume_host(host->mmc);
> >> +       if (!ret)
> >> +               host->suspended = 0;
> >> +
> >> +       return ret;
> >>  }
> >>  #else
> >>  #define davinci_mmcsd_suspend  NULL
> >> --
> >> 1.5.6
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> >>
> 


