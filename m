Return-Path: <linux-kernel-owner+w=401wt.eu-S1763952AbYEMUYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763952AbYEMUYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932267AbYEMUQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:16:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38825 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932257AbYEMUQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:16:27 -0400
Date: Tue, 13 May 2008 13:12:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeremy Higdon <jeremy@sgi.com>, Jes Sorensen <jes@sgi.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 31/37] SCSI: qla1280: Fix queue depth problem
Message-ID: <20080513201242.GF31167@suse.de>
References: <20080513200453.064446337@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi-qla1280-fix-queue-depth-problem.patch"
In-Reply-To: <20080513201053.GA31167@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Jeremy Higdon <jeremy@sgi.com>

commit af5741c6de4f4a1d8608b0f00867c77cb7123635 upstream

The qla1280 driver was ANDing the output value of mailbox register
0 with (1 << target-number) to determine whether to enable queueing
on the target in question.

But mailbox register 0 has the status code for the mailbox command
(in this case, Set Target Parameters).  Potential values are:
/*
 * ISP mailbox command complete status codes
 */

So clearly that is in error.  I can't think what the author of that
line was looking for in a mailbox register, so I just eliminated the
AND.  flag is used later in the function, and I think that the later
usage was also wrong, though it was used to set values that aren't
used.  Oh well, an overhaul of this driver is not what I want to do
now -- just a bugfix.

After the fix, I found that my disks were getting a queue depth of
255, which is far too many.  Most SCSI disks are limited to 32 or
64.  In any case, there's no point, queueing up a bunch of commands
to the adapter that will just result in queue full or starve other
targets from being issued commands due to running out of internal
memory.  So I dropped default queue depth to 32 (from which 1 is
subtracted elsewhere, giving net of 31).

I tested with a Seagate ST336753LC, and results look good, so
I'm satisfied with this patch.

Signed-off-by: Jeremy Higdon <jeremy@sgi.com>
Acked-by: Jes Sorensen <jes@sgi.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/qla1280.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -2012,7 +2012,7 @@ qla1280_set_defaults(struct scsi_qla_hos
 		nv->bus[bus].config_2.req_ack_active_negation = 1;
 		nv->bus[bus].config_2.data_line_active_negation = 1;
 		nv->bus[bus].selection_timeout = 250;
-		nv->bus[bus].max_queue_depth = 256;
+		nv->bus[bus].max_queue_depth = 32;
 
 		if (IS_ISP1040(ha)) {
 			nv->bus[bus].bus_reset_delay = 3;
@@ -2056,7 +2056,7 @@ qla1280_config_target(struct scsi_qla_ho
 	status = qla1280_mailbox_command(ha, 0x0f, mb);
 
 	/* Save Tag queuing enable flag. */
-	flag = (BIT_0 << target) & mb[0];
+	flag = (BIT_0 << target);
 	if (nv->bus[bus].target[target].parameter.tag_queuing)
 		ha->bus_settings[bus].qtag_enables |= flag;
 

-- 
