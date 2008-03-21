Return-Path: <linux-kernel-owner+w=401wt.eu-S1763927AbYCUXLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763927AbYCUXLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932200AbYCUWwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:52:25 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:41324 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932168AbYCUWwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:52:24 -0400
Message-Id: <20080321224434.771102984@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:47 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Tony Battersby <tonyb@cybernetics.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 57/76] SCSI: fix BUG when sum(scatterlist) > bufflen
Content-Disposition: inline; filename=scsi-fix-bug-when-sum-bufflen.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Tony Battersby <tonyb@cybernetics.com>

When sending a SCSI command to a tape drive via the SCSI Generic (sg)
driver, if the command has a data transfer length more than
scatter_elem_sz (32 KB default) and not a multiple of 512, then I either
hit BUG_ON(!valid_dma_direction(direction)) in dma_unmap_sg() or else
the command never completes (depending on the LLDD).

When constructing scatterlists, the sg driver rounds up the scatterlist
element sizes to be a multiple of 512.  This can result in
sum(scatterlist lengths) > bufflen.  In this case, scsi_req_map_sg()
incorrectly sets bio->bi_size to sum(scatterlist lengths) rather than to
bufflen.  When the command completes, req_bio_endio() detects that
bio->bi_size != 0, and so it doesn't call bio_endio().  This causes the
command to be resubmitted, resulting in BUG_ON or the command never
completing.

This patch makes scsi_req_map_sg() set bio->bi_size to bufflen rather
than to sum(scatterlist lengths), which fixes the problem.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Acked-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/scsi/scsi_lib.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -298,7 +298,6 @@ static int scsi_req_map_sg(struct reques
 		page = sg_page(sg);
 		off = sg->offset;
 		len = sg->length;
- 		data_len += len;
 
 		while (len > 0 && data_len > 0) {
 			/*

-- 
