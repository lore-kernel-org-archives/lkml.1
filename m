Return-Path: <linux-kernel-owner+w=401wt.eu-S1760930AbYDWBjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760930AbYDWBjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 21:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762221AbYDWBij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 21:38:39 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:38803 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762119AbYDWBii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 21:38:38 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: [bisected] Latest git not seeing HD with sata_nv
References: <adazlrlcw9f.fsf@cisco.com> <adave29cqgh.fsf@cisco.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 22 Apr 2008 18:38:36 -0700
In-Reply-To: <adave29cqgh.fsf@cisco.com> (Roland Dreier's message of "Tue, 22
	Apr 2008 18:25:34 -0700")
Message-ID: <adar6cxcpur.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Apr 2008 01:38:37.0441 (UTC) FILETIME=[C0365710:01C8A4E2]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FWIW, the patch below also makes my box start working again...  I have
no idea what the right fix is, given that bug 3352 mostly seems to be
about nforce2 and nforce3, and my box has a more modern nvidia chipset:

    00:04.0 IDE interface [0101]: nVidia Corporation MCP55 IDE [10de:036e] (rev a1)

Anyway, it seems 305d2a1a broke the logic that nv_hardreset() relies on
when it doesn't let sata_sff_hardreset() set class.

diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 109b074..d0d85a3 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -1597,7 +1597,7 @@ static int nv_hardreset(struct ata_link *link, unsigned int *class,
 	 * some controllers.  Don't classify on hardreset.  For more
 	 * info, see http://bugzilla.kernel.org/show_bug.cgi?id=3352
 	 */
-	return sata_sff_hardreset(link, &dummy, deadline);
+	return sata_sff_hardreset(link, class, deadline);
 }
 
 static void nv_adma_error_handler(struct ata_port *ap)
