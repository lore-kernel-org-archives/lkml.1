Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbZFMEao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbZFMEao (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 00:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbZFMEaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 00:30:35 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:35291 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbZFMEae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 00:30:34 -0400
X-IronPort-AV: E=Sophos;i="4.42,213,1243814400"; 
   d="scan'208";a="199344975"
From: Roland Dreier <rdreier@cisco.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Barnes\, Jesse" <jesse.barnes@intel.com>, Matthew Wilcox <matthew@wil.cx>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: Re: mthca double free irqs
References: <86802c440906111945n2a42dc94mf08bd2b1a252842f@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 12 Jun 2009 21:30:34 -0700
In-Reply-To: <86802c440906111945n2a42dc94mf08bd2b1a252842f@mail.gmail.com>
	(Yinghai Lu's message of "Thu, 11 Jun 2009 19:45:21 -0700")
Message-ID: <ada1vpozrf9.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Jun 2009 04:30:36.0308 (UTC) FILETIME=[B2947D40:01C9EBDF]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Something like this should help -- can you verify this fixes the double
free of irq?

 drivers/infiniband/hw/mthca/mthca_eq.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_eq.c b/drivers/infiniband/hw/mthca/mthca_eq.c
index 28f0e0c..90e4e45 100644
--- a/drivers/infiniband/hw/mthca/mthca_eq.c
+++ b/drivers/infiniband/hw/mthca/mthca_eq.c
@@ -641,9 +641,11 @@ static void mthca_free_irqs(struct mthca_dev *dev)
 	if (dev->eq_table.have_irq)
 		free_irq(dev->pdev->irq, dev);
 	for (i = 0; i < MTHCA_NUM_EQ; ++i)
-		if (dev->eq_table.eq[i].have_irq)
+		if (dev->eq_table.eq[i].have_irq) {
 			free_irq(dev->eq_table.eq[i].msi_x_vector,
 				 dev->eq_table.eq + i);
+			dev->eq_table.eq[i].have_irq = 0;
+		}
 }
 
 static int mthca_map_reg(struct mthca_dev *dev,
