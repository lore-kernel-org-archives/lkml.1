Return-Path: <linux-kernel-owner+w=401wt.eu-S1757905AbYHRSqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905AbYHRSqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbYHRSqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:46:20 -0400
Received: from ns2.suse.de ([195.135.220.15]:34504 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757783AbYHRSqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:46:19 -0400
Date: Mon, 18 Aug 2008 11:41:31 -0700
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
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Tim Wright <timw@splhi.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 04/60] SCSI: block: Fix miscalculation of sg_io timeout in
	CDROM_SEND_PACKET handler.
Message-ID: <20080818184131.GE29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi-block-fix-miscalculation-of-sg_io-timeout-in-cdrom_send_packet-handler.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Tim Wright <timw@splhi.com>

commit ad337591f4fd20de6a0ca03d6715267a5c1d2b16 upstream

It seems cdrwtool in the udftools has been unusable on "modern" kernels
for some time. A Google search reveals many people with the same issue
but no solution (cdrwtool fails to format the disk). After spending some
time tracking down the issue, it comes down to the following:

The udftools still use the older CDROM_SEND_PACKET interface to send
things like FORMAT_UNIT through to the drive. They should really be
updated, but that's another story. Since most distros are using libata
now, the cd or dvd burner appears as a SCSI device, and we wind up in
block/scsi_ioctl.c. Here, the code tries to take the "struct
cdrom_generic_command" and translate it and stuff it into a "struct
sg_io_hdr" structure so it can pass it to the modern sg_io() routine
instead. Unfortunately, there is one error, or rather an omission in the
translation. The timeout that is passed in in the "struct
cdrom_generic_command" is in HZ=100 units, and this is modified and
correctly converted to jiffies by use of clock_t_to_jiffies(). However,
a little further down, this cgc.timeout value in jiffies is simply
copied into the sg_io_hdr timeout, which should be in milliseconds.
Since most modern x86 kernels seems to be getting build with HZ=250, the
timeout that is passed to sg_io and eventually converted to the
timeout_per_command member of the scsi_cmnd structure is now four times
too small. Since cdrwtool tries to set the timeout to one hour for the
FORMAT_UNIT command, and it takes about 20 minutes to format a 4x CDRW,
the SCSI error-handler kicks in after the FORMAT_UNIT completes because
it took longer than the incorrectly-calculated timeout.

[jejb: fix up whitespace]
Signed-off-by: Tim Wright <timw@splhi.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/scsi_ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -629,7 +629,7 @@ int scsi_cmd_ioctl(struct file *file, st
 			hdr.sbp = cgc.sense;
 			if (hdr.sbp)
 				hdr.mx_sb_len = sizeof(struct request_sense);
-			hdr.timeout = cgc.timeout;
+			hdr.timeout = jiffies_to_msecs(cgc.timeout);
 			hdr.cmdp = ((struct cdrom_generic_command __user*) arg)->cmd;
 			hdr.cmd_len = sizeof(cgc.cmd);
 

-- 
