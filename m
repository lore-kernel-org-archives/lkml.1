Return-Path: <linux-kernel-owner+w=401wt.eu-S965054AbXCSVjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965054AbXCSVjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030586AbXCSVjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:39:49 -0400
Received: from mail.suse.de ([195.135.220.2]:55512 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964944AbXCSVji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:39:38 -0400
Date: Mon, 19 Mar 2007 14:37:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Joerg Dorchain <joerg@dorchain.net>,
       Achim Leubner <Achim_Leubner@adaptec.com>,
       James Bottomley <James.Bottomley@SteelEye.com>
Subject: [patch 04/31] gdth: fix oops in gdth_copy_cmd()
Message-ID: <20070319213736.GF9261@kroah.com>
References: <20070319213047.710101653@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="SCSI-gdth-fix-oops-in-gdth_copy_cmd.patch"
In-Reply-To: <20070319213647.GB9261@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

Recent alterations to the gdth_fill_raw_cmd() path no longer set the
sg_ranz field for zero transfer commands. However, this field is used
lower down in the function to initialise ha->cmd_len to the size of
the firmware packet.  If this uninitialised field contains a bogus
value, ha->cmd_len can become much larger than the actual firmware
packet and end up oopsing in gdth_copy_cmd() as it tries to copy this
huge packet to the device (usually because it runs into an unallocated
page).

The fix is to initialise the sg_ranz field to zero at the start of
gdth_fill_raw_cmd().

Signed-off-by: Joerg Dorchain <joerg@dorchain.net>
Acked-by: "Achim Leubner" <Achim_Leubner@adaptec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/gdth.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -3092,6 +3092,7 @@ static int gdth_fill_raw_cmd(int hanum,S
             cmdp->u.raw64.direction  = 
                 gdth_direction_tab[scp->cmnd[0]]==DOU ? GDTH_DATA_OUT:GDTH_DATA_IN;
             memcpy(cmdp->u.raw64.cmd,scp->cmnd,16);
+            cmdp->u.raw64.sg_ranz    = 0;
         } else {
             cmdp->u.raw.reserved   = 0;
             cmdp->u.raw.mdisc_time = 0;
@@ -3108,6 +3109,7 @@ static int gdth_fill_raw_cmd(int hanum,S
             cmdp->u.raw.direction  = 
                 gdth_direction_tab[scp->cmnd[0]]==DOU ? GDTH_DATA_OUT:GDTH_DATA_IN;
             memcpy(cmdp->u.raw.cmd,scp->cmnd,12);
+            cmdp->u.raw.sg_ranz    = 0;
         }
 
         if (scp->use_sg) {

-- 
