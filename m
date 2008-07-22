Return-Path: <linux-kernel-owner+w=401wt.eu-S1759215AbYGVXdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215AbYGVXdj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756640AbYGVXXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:23:33 -0400
Received: from mx1.suse.de ([195.135.220.2]:53723 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622AbYGVXXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:23:31 -0400
Date: Tue, 22 Jul 2008 16:17:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Philipp Zabel <philipp.zabel@gmail.com>,
       Pierre Ossman <drzeus@drzeus.cx>
Subject: [patch 44/47] pxamci: fix byte aligned DMA transfers
Message-ID: <20080722231735.GS8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pxamci-fix-byte-aligned-dma-transfers.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Philipp Zabel <philipp.zabel@gmail.com>

commit 97f8571e663c808ad2d01a396627235167291556 upstream

The pxa27x DMA controller defaults to 64-bit alignment. This caused
the SCR reads to fail (and, depending on card type, error out) when
card->raw_scr was not aligned on a 8-byte boundary.

For performance reasons all scatter-gather addresses passed to
pxamci_request should be aligned on 8-byte boundaries, but if
this can't be guaranteed, byte aligned DMA transfers in the
have to be enabled in the controller to get correct behaviour.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/host/pxamci.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -114,6 +114,7 @@ static void pxamci_setup_data(struct pxa
 	unsigned int nob = data->blocks;
 	unsigned long long clks;
 	unsigned int timeout;
+	bool dalgn = 0;
 	u32 dcmd;
 	int i;
 
@@ -152,6 +153,9 @@ static void pxamci_setup_data(struct pxa
 		host->sg_cpu[i].dcmd = dcmd | length;
 		if (length & 31 && !(data->flags & MMC_DATA_READ))
 			host->sg_cpu[i].dcmd |= DCMD_ENDIRQEN;
+		/* Not aligned to 8-byte boundary? */
+		if (sg_dma_address(&data->sg[i]) & 0x7)
+			dalgn = 1;
 		if (data->flags & MMC_DATA_READ) {
 			host->sg_cpu[i].dsadr = host->res->start + MMC_RXFIFO;
 			host->sg_cpu[i].dtadr = sg_dma_address(&data->sg[i]);
@@ -165,6 +169,15 @@ static void pxamci_setup_data(struct pxa
 	host->sg_cpu[host->dma_len - 1].ddadr = DDADR_STOP;
 	wmb();
 
+	/*
+	 * The PXA27x DMA controller encounters overhead when working with
+	 * unaligned (to 8-byte boundaries) data, so switch on byte alignment
+	 * mode only if we have unaligned data.
+	 */
+	if (dalgn)
+		DALGN |= (1 << host->dma);
+	else
+		DALGN &= (1 << host->dma);
 	DDADR(host->dma) = host->sg_dma;
 	DCSR(host->dma) = DCSR_RUN;
 }

-- 
