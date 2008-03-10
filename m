Return-Path: <linux-kernel-owner+w=401wt.eu-S1757209AbYCJWPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbYCJWPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 18:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756538AbYCJWPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 18:15:44 -0400
Received: from smtp.duncanthrax.net ([89.31.1.170]:60828 "EHLO
	smtp.duncanthrax.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbYCJWPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 18:15:43 -0400
X-Greylist: delayed 1531 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Mar 2008 18:15:42 EDT
From: Sven Schnelle <svens@bitebene.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, linux-kernel@vger.kernel.org,
       linux-scsi <linux-scsi@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] [SCSI] gdth: Allocate sense_buffer to prevent NULL pointer dereference
In-Reply-To: <1205183577.2941.38.camel@localhost.localdomain> (James
	Bottomley's message of "Mon, 10 Mar 2008 16:12:57 -0500")
Organization: private
References: <867igc3w8r.fsf@deprecated.bitebene.org>
	<47D551B8.9080807@panasas.com>
	<1205183577.2941.38.camel@localhost.localdomain>
User-Agent: Gnus/5.110007 (No Gnus v0.7) Emacs/23.0.50 (i686-pc-linux-gnu)
Date: Mon, 10 Mar 2008 22:50:04 +0100
Message-ID: <86zlt68d0z.fsf@deprecated.bitebene.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley <James.Bottomley@HansenPartnership.com> writes:

> On Mon, 2008-03-10 at 17:20 +0200, Boaz Harrosh wrote:
>> James and linux-scsi CCed.
>
> Looks fine .. could someone send the patch in an applyable form (i.e.
> not quoted).

Sure:

Fix NULL pointer dereference during execution of Internal commands,
where gdth only allocates scp, but not scp->sense_buffer. The rest of
the code assumes that sense_buffer is allocated, which leads to a kernel
oops e.g. on reboot (during cache flush).

Signed-off-by: Sven Schnelle <svens@stackframe.org>
---
 drivers/scsi/gdth.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 27ebd33..0b2080d 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -493,6 +493,12 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
     if (!scp)
         return -ENOMEM;
 
+    scp->sense_buffer = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
+    if (!scp->sense_buffer) {
+	kfree(scp);
+	return -ENOMEM;
+    }
+
     scp->device = sdev;
     memset(&cmndinfo, 0, sizeof(cmndinfo));
 
@@ -513,6 +519,7 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
     rval = cmndinfo.status;
     if (info)
         *info = cmndinfo.info;
+    kfree(scp->sense_buffer);
     kfree(scp);
     return rval;
 }
-- 
1.5.4.3

