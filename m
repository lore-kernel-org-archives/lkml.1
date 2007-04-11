Return-Path: <linux-kernel-owner+w=401wt.eu-S1161340AbXDKWze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161340AbXDKWze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 18:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161366AbXDKWzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:55:20 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55667 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161363AbXDKWyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:54:52 -0400
Date: Wed, 11 Apr 2007 15:52:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       "David S. Miller" <davem@davemloft.net>, Christoph Hellwig <hch@lst.de>
Subject: [patch 16/31] Fix scsi sense handling
Message-ID: <20070411225211.GQ24814@kroah.com>
References: <20070411224329.866978349@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-scsi-sense-handling.patch"
In-Reply-To: <20070411225100.GA24814@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David Miller <davem@davemloft.net>

[SCSI]: Fix scsi_send_eh_cmnd scatterlist handling

This fixes a regression caused by commit:

2dc611de5a3fd955cd0298c50691d4c05046db97

The sense buffer code in scsi_send_eh_cmnd was changed to use
alloc_page() and a scatter list, but the sense data copy was not
updated to match so what we actually get in the sense buffer is total
grabage starting with the kernel address of the struct page we got.
Basically the stack frame of scsi_send_eh_cmd() is what ends up
in the sense buffer.

Depending upon how pointers look on a given platform, you can
end up getting sr_ioctl.c errors when you mount a cdrom.  If
the CDROM gives a check condition for GPCMD_GET_CONFIGURATION issued
by drivers/cdrom/cdrom.c:cdrom_mmc_profile(), sr_ioctl will
spit out this error message in sr_do_ioctl() with the way pointers
are on sparc64:

		default:
			printk(KERN_ERR "%s: CDROM (ioctl) error, command: ", cd->cdi.name);
			__scsi_print_command(cgc->cmd);
			scsi_print_sense_hdr("sr", &sshdr);
			err = -EIO;

This is the error Tom Callaway reported in:

http://marc.info/?l=linux-sparc&m=117407453208101&w=2

Anyways, fix this by using page_address(sgl.page) which is OK
because we know this is low-mem due to GFP_ATOMIC.

Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/scsi_error.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -595,7 +595,7 @@ static int scsi_send_eh_cmnd(struct scsi
 	 */
 	if (copy_sense) {
 		if (!SCSI_SENSE_VALID(scmd)) {
-			memcpy(scmd->sense_buffer, scmd->request_buffer,
+			memcpy(scmd->sense_buffer, page_address(sgl.page),
 			       sizeof(scmd->sense_buffer));
 		}
 		__free_page(sgl.page);

-- 
