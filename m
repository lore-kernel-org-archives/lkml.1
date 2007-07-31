Return-Path: <linux-kernel-owner+w=401wt.eu-S1761805AbXGaUJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761805AbXGaUJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 16:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757478AbXGaUIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 16:08:50 -0400
Received: from mail.gmx.net ([213.165.64.20]:46244 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756046AbXGaUIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 16:08:48 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1+IqAkvsRyINF+zXAIBz/m1aYpKS6bQ6hlEtNUA7h
	noT6hC7tg+LP17
Date: Tue, 31 Jul 2007 22:08:25 +0200
From: Eric Sesterhenn / Snakebyte <snakebyte@gmx.de>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Eric Sesterhenn / Snakebyte <snakebyte@gmx.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-acpi@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Time Problems with 2.6.23-rc1-gf695baf2
Message-ID: <20070731200825.GB28917@alice>
References: <20070731145456.GB25175@alice> <653FFBB4508B9042B5D43DC9E18836F5013588F6@scsmsx415.amr.corp.intel.com> <20070731153808.GC25175@alice> <20070731190431.GA24577@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070731190431.GA24577@linux-os.sc.intel.com>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.22.1 (x86_64)
X-Uptime: 22:08:02 up 10:35,  6 users,  load average: 0.52, 0.51, 0.39
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Venki Pallipadi (venkatesh.pallipadi@intel.com) wrote:
> Can you check the test patch below (over latest git) and let me know whether it
> resolves the issue.
> 

the patch fixes the issue for me,
thanks a lot.

Eric

> Enable C3 without bm control only for CST based C3.
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> 
> Index: linux-2.6/drivers/acpi/processor_idle.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/processor_idle.c	2007-07-31 04:29:26.000000000 -0700
> +++ linux-2.6/drivers/acpi/processor_idle.c	2007-07-31 04:52:50.000000000 -0700
> @@ -969,11 +969,17 @@
>  	}
>  
>  	if (pr->flags.bm_check) {
> -		/* bus mastering control is necessary */
>  		if (!pr->flags.bm_control) {
> -			/* In this case we enter C3 without bus mastering */
> -			ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> -				"C3 support without bus mastering control\n"));
> +			if (pr->flags.has_cst != 1) {
> +				/* bus mastering control is necessary */
> +				ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> +					"C3 support requires BM control\n"));
> +				return;
> +			} else {
> +				/* Here we enter C3 without bus mastering */
> +				ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> +					"C3 support without BM control\n"));
> +			}
>  		}
>  	} else {
>  		/*
