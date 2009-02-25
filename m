Return-Path: <linux-kernel-owner+w=401wt.eu-S1759508AbZBYJ66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbZBYJ66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 04:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761453AbZBYJ6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 04:58:34 -0500
Received: from mail.openmoko.org ([88.198.124.205]:52680 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759761AbZBYJ6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 04:58:32 -0500
Date: Wed, 25 Feb 2009 15:28:09 +0530
From: Balaji Rao <balajirrao@openmoko.org>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Green <andy@openmoko.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mmc: During unsafe resume, select the right volatge for
	the card
Message-ID: <20090225095806.GB3217@fedora.yogi>
References: <20090209132806.GD3278@fedora.yogi> <20090218212515.6bae1bf6@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218212515.6bae1bf6@mjolnir.ossman.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 09:25:15PM +0100, Pierre Ossman wrote:
> On Mon, 9 Feb 2009 18:58:08 +0530
> Balaji Rao <balajirrao@openmoko.org> wrote:
> 
> > When mmc_power_up is called during unsafe resume, host->ocr should be
> > used instead of host->ocr_avail.
> > 
> > Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
> > Cc: Andy Green <andy@openmoko.com>
> > Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
> > ---
> 
> Hmm... This is a bit hackish and changes the previously known behaviour
> of mmc_power_up(). We probably need to refactor things and have some
> other explicit call from the resume path.
> 

Hi Pierre,

Here's a simpler patch. How does this look ? 

Thanks,
Balaji

---
During mmc unsafe resume, choose the right voltage for the card after
powerup.

Although this has not seen to cause trouble, it's the wrong behaviour.
 
Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
Cc: Andy Green <andy@openmoko.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 3ad7f87..1e8de16 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -881,6 +881,7 @@ int mmc_resume_host(struct mmc_host *host)
 	mmc_bus_get(host);
 	if (host->bus_ops && !host->bus_dead) {
 		mmc_power_up(host);
+		mmc_select_voltage(host, host->ocr);
 		BUG_ON(!host->bus_ops->resume);
 		host->bus_ops->resume(host);
 	}
