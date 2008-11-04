Return-Path: <linux-kernel-owner+w=401wt.eu-S1757073AbYKDXh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073AbYKDXh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:37:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbYKDXhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:37:33 -0500
Received: from ns2.suse.de ([195.135.220.15]:51762 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755071AbYKDXhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:37:32 -0500
Date: Tue, 4 Nov 2008 15:30:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jamie Wellnitz <Jamie.Wellnitz@emulex.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 02/57] SCSI: sd: Fix handling of NO_SENSE check condition
Message-ID: <20081104233059.GC659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi-sd-fix-handling-of-no_sense-check-condition.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>

commit 10dab22664914505dcb804d9ad09cad6bc94d349 upstream

The current handling of NO_SENSE check condition is the same as
RECOVERED_ERROR, and assumes that in both cases, the I/O was fully
transferred.

We have seen cases of arrays returning with NO_SENSE (no error), but
the I/O was not completely transferred, thus residual set.  Thus,
rather than return good_bytes as the entire transfer, set good_bytes
to 0, so that the midlayer then applies the residual in calculating
the transfer, and for sd, will fail the I/O and fall into a retry
path.

Signed-off-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/sd.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1047,7 +1047,6 @@ static int sd_done(struct scsi_cmnd *SCp
 		good_bytes = sd_completed_bytes(SCpnt);
 		break;
 	case RECOVERED_ERROR:
-	case NO_SENSE:
 		/* Inform the user, but make sure that it's not treated
 		 * as a hard error.
 		 */
@@ -1056,6 +1055,15 @@ static int sd_done(struct scsi_cmnd *SCp
 		memset(SCpnt->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 		good_bytes = scsi_bufflen(SCpnt);
 		break;
+	case NO_SENSE:
+		/* This indicates a false check condition, so ignore it.  An
+		 * unknown amount of data was transferred so treat it as an
+		 * error.
+		 */
+		scsi_print_sense("sd", SCpnt);
+		SCpnt->result = 0;
+		memset(SCpnt->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
+		break;
 	case ABORTED_COMMAND:
 		if (sshdr.asc == 0x10) { /* DIF: Disk detected corruption */
 			scsi_print_result(SCpnt);

-- 
