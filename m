Return-Path: <linux-kernel-owner+w=401wt.eu-S1757354AbYFSVel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354AbYFSVel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 17:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755254AbYFSVcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 17:32:21 -0400
Received: from mx1.suse.de ([195.135.220.2]:38166 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755213AbYFSVcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 17:32:18 -0400
Date: Thu, 19 Jun 2008 14:30:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 10/15] SCSI: sr: fix corrupt CD data after media change and
	delay
Message-ID: <20080619213003.GK20267@suse.de>
References: <20080619211313.834170620@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi-sr-fix-corrupt-cd-data-after-media-change-and-delay.patch"
In-Reply-To: <20080619212621.GA20267@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: James Bottomley <James.Bottomley@HansenPartnership.com>

commit: d1daeabf0da5bfa1943272ce508e2ba785730bf0 upstream

Reported-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

If you delay 30s or more before mounting a CD after inserting it then
the kernel has the wrong value for the CD size.

http://marc.info/?t=121276133000001

The problem is in sr_test_unit_ready(): the function eats unit
attentions without adjusting the sdev->changed status.  This means
that when the CD signals changed media via unit attention, we can
ignore it.  Fix by making sr_test_unit_ready() adjust the changed
status.

Reported-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Tested-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/sr.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -178,6 +178,9 @@ int sr_test_unit_ready(struct scsi_devic
 		the_result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL,
 					      0, sshdr, SR_TIMEOUT,
 					      retries--);
+		if (scsi_sense_valid(sshdr) &&
+		    sshdr->sense_key == UNIT_ATTENTION)
+			sdev->changed = 1;
 
 	} while (retries > 0 &&
 		 (!scsi_status_is_good(the_result) ||

-- 
