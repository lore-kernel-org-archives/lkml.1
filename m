Return-Path: <linux-kernel-owner+w=401wt.eu-S933609AbXKOHGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933609AbXKOHGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:06:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765488AbXKOGsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:48:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43673 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765559AbXKOGsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:48:05 -0500
Date: Wed, 14 Nov 2007 22:45:38 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       James.Bottomley@steeleye.com
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux@highpoint-tech.com, linux-scsi@vger.kernel.org
Subject: [patch 32/40] hptiop: avoid buffer overflow when returning sense
	data
Message-ID: <20071115064538.GG19218@kroah.com>
References: <20071115062710.885284510@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hptiop-avoid-buffer-overflow-when-returning-sense-data.patch"
In-Reply-To: <20071115064302.GA19218@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



-stable review patch.  If anyone has any objections, please let us know.

------------------
From: HighPoint Linux Team <linux@highpoint-tech.com>

patch 0fec02c93f60fb44ba3a24a0d3e4a52521d34d3f in mainline.

avoid buffer overflow when returning sense data.

With current adapter firmware the driver is working but future firmware
updates may return sense data larger than 96 bytes, causing overflow on
scp->sense_buffer and a kernel crash.

This fix should be backported to earlier kernels.

Signed-off-by: HighPoint Linux Team <linux@highpoint-tech.com>
Signed-off-by: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/hptiop.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -365,8 +365,9 @@ static void hptiop_host_request_callback
 		scp->result = SAM_STAT_CHECK_CONDITION;
 		memset(&scp->sense_buffer,
 				0, sizeof(scp->sense_buffer));
-		memcpy(&scp->sense_buffer,
-			&req->sg_list, le32_to_cpu(req->dataxfer_length));
+		memcpy(&scp->sense_buffer, &req->sg_list,
+				min(sizeof(scp->sense_buffer),
+					le32_to_cpu(req->dataxfer_length)));
 		break;
 
 	default:

-- 
