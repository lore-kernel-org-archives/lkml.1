Return-Path: <linux-kernel-owner+w=401wt.eu-S965576AbXENKat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965576AbXENKat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 06:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756776AbXENKac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 06:30:32 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:47858 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755583AbXENKab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 06:30:31 -0400
Message-ID: <46483A25.8030301@drzeus.cx>
Date: Mon, 14 May 2007 12:29:57 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Philip Langdale <philipl@overt.org>
CC: Tobias Bengtsson <tobbe@tobbe.nu>, sdhci-devel@list.drzeus.cx,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sdhci: Add quirk to support polling for card presence
References: <46479D59.4020400@overt.org>
In-Reply-To: <46479D59.4020400@overt.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Philip Langdale wrote:
> @@ -806,11 +819,18 @@ static void sdhci_tasklet_card(unsigned long param)
>  			host->mrq->cmd->error = MMC_ERR_FAILED;
>  			tasklet_schedule(&host->finish_tasklet);
>  		}
> -	}
>
> -	spin_unlock_irqrestore(&host->lock, flags);
> +		spin_unlock_irqrestore(&host->lock, flags);
> +
>   

Where's the unlock for the other branch?

> +		host->present = present;
>
>   

And this should be protected by the lock :)

> +		mmc_detect_change(host->mmc, msecs_to_jiffies(500));
> +	}
>   

Perhaps we should have a different delay here. After all, we're no
longer delaying against an interrupt.

> -	mmc_detect_change(host->mmc, msecs_to_jiffies(500));
> +	if (host->chip->quirks & SDHCI_QUIRK_NO_CARD_DETECT_INT) {
> +		host->detect_timer.expires = jiffies + 3 * HZ;
> +		add_timer(&host->detect_timer);
> +	}
>  }
>
>  static void sdhci_tasklet_finish(unsigned long param)
>   

I wonder if three seconds is a bit much. You might give up and yank the
card in that time.

Keep up the good work. :)

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

