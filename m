Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbXDZRHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbXDZRHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbXDZRBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:01:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39642 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbXDZRAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:00:36 -0400
Date: Thu, 26 Apr 2007 09:56:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, adam radford <aradford@gmail.com>,
       James Bottomley <James.Bottomley@SteelEye.com>
Subject: [patch 22/33] 3w-xxxx: fix oops caused by incorrect REQUEST_SENSE
	handling
Message-ID: <20070426165645.GW1898@kroah.com>
References: <20070426165111.393445007@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="3w-xxxx-fix-oops-caused-by-incorrect-request_sense-handling.patch"
In-Reply-To: <20070426165445.GA1898@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: James Bottomley <James.Bottomley@steeleye.com>

3w-xxxx emulates a REQUEST_SENSE response by simply returning nothing.
Unfortunately, it's assuming that the REQUEST_SENSE command is
implemented with use_sg == 0, which is no longer the case.  The oops
occurs because it's clearing the scatterlist in request_buffer instead
of the memory region.

This is fixed by using tw_transfer_internal() to transfer correctly to
the scatterlist.

Acked-by: adam radford <aradford@gmail.com>
Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/3w-xxxx.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1864,10 +1864,17 @@ static int tw_scsiop_read_write(TW_Devic
 /* This function will handle the request sense scsi command */
 static int tw_scsiop_request_sense(TW_Device_Extension *tw_dev, int request_id)
 {
+	char request_buffer[18];
+
 	dprintk(KERN_NOTICE "3w-xxxx: tw_scsiop_request_sense()\n");
 
-	/* For now we just zero the request buffer */
-	memset(tw_dev->srb[request_id]->request_buffer, 0, tw_dev->srb[request_id]->request_bufflen);
+	memset(request_buffer, 0, sizeof(request_buffer));
+	request_buffer[0] = 0x70; /* Immediate fixed format */
+	request_buffer[7] = 10;	/* minimum size per SPC: 18 bytes */
+	/* leave all other fields zero, giving effectively NO_SENSE return */
+	tw_transfer_internal(tw_dev, request_id, request_buffer,
+			     sizeof(request_buffer));
+
 	tw_dev->state[request_id] = TW_S_COMPLETED;
 	tw_state_request_finish(tw_dev, request_id);
 

-- 
