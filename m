Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378Ab0CKXj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 18:39:29 -0500
Received: from mail-pz0-f194.google.com ([209.85.222.194]:39728 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab0CKXj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 18:39:27 -0500
To: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Cc: linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] davinci: MMC: Pass number of SG segments as platform data
References: <1268292756-5369-1-git-send-email-sudhakar.raj@ti.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Thu, 11 Mar 2010 15:39:24 -0800
In-Reply-To: <1268292756-5369-1-git-send-email-sudhakar.raj@ti.com> (Sudhakar Rajashekhara's message of "Thu\, 11 Mar 2010 13\:02\:36 +0530")
Message-ID: <87wrxia0nn.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sudhakar Rajashekhara <sudhakar.raj@ti.com> writes:

> On some platforms like DM355, the number of EDMA parameter
> slots available for EDMA_SLOT_ANY usage are few. In such cases,
> if MMC/SD uses 16 slots for each instance of MMC controller,
> then the number of slots available for other modules will be
> very few.
>
> By passing the number of EDMA slots to be used in MMC driver
> from platform data, EDMA slots available for other purposes
> can be controlled.
>
> Signed-off-by: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
> ---
>  arch/arm/mach-davinci/include/mach/mmc.h |    3 +++
>  drivers/mmc/host/davinci_mmc.c           |   22 +++++++++++++++-------
>  2 files changed, 18 insertions(+), 7 deletions(-)
>

[...]

> @@ -1202,6 +1206,10 @@ static int __init davinci_mmcsd_probe(struct platform_device *pdev)
>  
>  	init_mmcsd_host(host);
>  
> +	host->nr_sg = pdata->nr_sg - 1;

If a board doesn't setup pdata->nr_sg it will be zero, leaving
host->nr_sg = -1.

> +	if (host->nr_sg > MAX_NR_SG || host->nr_sg == 0)
> +		host->nr_sg = MAX_NR_SG;

Since host->nr_sg is unsigned, you get lucky and fix it up here, but
for readability, this not too clean and should be more thorough.

Wrapping the above in 'if (pdata->nr_sg)' is a more standard way
of handling optional platform_data paramaters.

Kevin
