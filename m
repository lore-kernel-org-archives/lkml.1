Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbZFYXFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbZFYXFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 19:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbZFYXFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 19:05:33 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:36467 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbZFYXFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 19:05:32 -0400
Date: Thu, 25 Jun 2009 17:05:35 -0600
From: Alex Chiang <achiang@hp.com>
To: Alex Riesen <raa.lkml@gmail.com>
Cc: lenb@kernel.org, twmoure@szypr.net, alessandro.suardi@gmail.com,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 11/12] ACPI: video: convert to acpi_get_pci_dev
Message-ID: <20090625230535.GE1723@ldl.fc.hp.com>
References: <20090610194714.28982.51363.stgit@bob.kio> <20090610195600.28982.3404.stgit@bob.kio> <81b0412b0906251538j2614bf91ya2edbaf120796dfc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81b0412b0906251538j2614bf91ya2edbaf120796dfc@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

Thanks for the bug report and sorry for the troubles.

I've already got a debug patch here:

	http://thread.gmane.org/gmane.linux.kernel/857228/focus=857468

Perhaps you can try it too?

Len, in the mean time, can you please apply this as an emergency,
"let's not crash anyone else's machine" while I try and figure
out why the ACPI video driver breaks my assumptions?

Troy, I applied your S-o-B, but maybe that was not a good
assumption on my part? To be sure, could you please respond with
your S-o-B?

Thanks.

/ac, wearing a brown paper bag

From: Troy Moure <twmoure@szypr.net>

ACPI: prevent NULL deref in acpi_get_pci_dev()

When the ACPI video driver initializes, it does a namespace walk
looking for for supported devices. When we find an appropriate
handle, we walk up the ACPI tree looking for a PCI root bus, and
then walk back down the PCI bus, assuming that every device
inbetween is a P2P bridge.

This assumption is not correct, and is reported broken on at
least:

	Dell Latitude E6400
	ThinkPad X61
	Dell XPS M1330

Add a NULL deref check to prevent boot panics.

Reported-by: Alessandro Suardi <alessandro.suardi@gmail.com>
Signed-off-by: Troy Moure <twmoure@szypr.net>
Signed-off-by: Alex Chiang <achiang@hp.com>
---
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 8a5bf3b..55b5b90 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -395,7 +395,7 @@ struct pci_dev *acpi_get_pci_dev(acpi_handle handle)
 		fn  = adr & 0xffff;

 		pdev = pci_get_slot(pbus, PCI_DEVFN(dev, fn));
-		if (hnd == handle)
+		if (!pdev || hnd == handle)
 			break;

 		pbus = pdev->subordinate;
