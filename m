Return-Path: <linux-kernel-owner+w=401wt.eu-S1760283AbZJIIj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760283AbZJIIj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 04:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756774AbZJIIj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 04:39:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55026 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196AbZJIIjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 04:39:55 -0400
Date: Fri, 9 Oct 2009 10:39:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata build fix
Message-ID: <20091009083903.GA20687@elte.hu>
References: <20091009043248.GA12304@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091009043248.GA12304@havoc.gtf.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Garzik <jeff@garzik.org> wrote:

> Please pull from 'upstream-linus' branch of
> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus
> 
> to receive the following updates:
> 
>  drivers/ata/ahci.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> Markus Trippelsdorf (1):
>       ahci: Add ifdef wrapper to ahci_gtf_filter_workaround
> 
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index 4edca6e..b1a2577 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -2884,6 +2884,7 @@ static bool ahci_broken_online(struct pci_dev *pdev)
>  	return pdev->bus->number == (val >> 8) && pdev->devfn == (val & 0xff);
>  }
>  
> +#ifdef CONFIG_ATA_ACPI
>  static void ahci_gtf_filter_workaround(struct ata_host *host)
>  {
>  	static const struct dmi_system_id sysids[] = {
> @@ -2927,6 +2928,10 @@ static void ahci_gtf_filter_workaround(struct ata_host *host)
>  				dev->gtf_filter |= filter;
>  	}
>  }
> +#else
> +static inline void ahci_gtf_filter_workaround(struct ata_host *host)
> +{}
> +#endif

btw., i made the slightly different fix below before i saw your fix on 
lkml, and i think it's slightly cleaner to have a single definition of a 
function instead of an
#else branch.

	Ingo

---------------------->
>From 1f4a08ff9647d24d9590a7e23349036dbeafbb1b Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 9 Oct 2009 10:13:56 +0200
Subject: [PATCH] ahci: Fix "filter FPDMA non-zero offset enable for Aspire 3810T" on !CONFIG_ATA_ACPI
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Commit f80ae7e ("ahci: filter FPDMA non-zero offset enable for Aspire
3810T") introduced a new build breakage:

  drivers/ata/ahci.c: In function ‘ahci_gtf_filter_workaround’:
  drivers/ata/ahci.c:2927: error: ‘struct ata_device’ has no member named ‘gtf_filter’
  make[2]: *** [drivers/ata/ahci.o] Error 1
  make[1]: *** [drivers/ata] Error 2
  make[1]: *** Waiting for unfinished jobs....

As the acpi taskfile command filter support is a property of
libata-acpi - so the ata_device::gtf_filter field only exists
under CONFIG_ATA_ACPI.

Add the trivial #ifdef to turn ahci_gtf_filter_workaround()
into a NOP on !CONFIG_ATA_ACPI.

Cc: Marcus Meissner <meissner@novell.com>
Cc: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/ata/ahci.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 4edca6e..fc8d527 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -2886,6 +2886,7 @@ static bool ahci_broken_online(struct pci_dev *pdev)
 
 static void ahci_gtf_filter_workaround(struct ata_host *host)
 {
+#ifdef CONFIG_ATA_ACPI
 	static const struct dmi_system_id sysids[] = {
 		/*
 		 * Aspire 3810T issues a bunch of SATA enable commands
@@ -2926,6 +2927,7 @@ static void ahci_gtf_filter_workaround(struct ata_host *host)
 			ata_for_each_dev(dev, link, ALL)
 				dev->gtf_filter |= filter;
 	}
+#endif
 }
 
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
