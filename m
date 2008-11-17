Return-Path: <linux-kernel-owner+w=401wt.eu-S1758113AbYKQHbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113AbYKQHbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:31:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbYKQHVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:21:32 -0500
Received: from kroah.org ([198.145.64.141]:38555 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755274AbYKQHVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:21:23 -0500
Date: Sun, 16 Nov 2008 23:16:04 -0800
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
       alan@lxorguk.ukuu.org.uk, Andrew Vasquez <andrew.vasquez@qlogic.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 29/46] SCSI: qla2xxx: Return a FAILED status when abort
	mailbox-command fails.
Message-ID: <20081117071604.GD29522@kroah.com>
References: <20081117070621.430169021@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi-qla2xxx-return-a-failed-status-when-abort-mailbox-command-fails.patch"
In-Reply-To: <20081117071333.GA29522@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Reed <mdr@sgi.com>

commit 5bff55db3dc4d659f46b4d2fce2f61c1964c2762 upstream.

Mike Reed noted
(https://bugzilla.novell.com/show_bug.cgi?id=421330) that the
driver was incorrectly returning a SUCCESS status if the driver's
request to the firmware to abort a command failed.  By doing so,
the mid-layer believed, incorrectly, that the command has
completed and has been returned (ultimately clearing
scsi_cmnd.request_buffer) yet the driver still has the command.
What should correctly happen is a mid-layer escalation
(device-reset, etc.) of recovery during which the driver will
eventually return the outstanding commands to the mid-layer.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/qla2xxx/qla_os.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -730,6 +730,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		if (ha->isp_ops->abort_command(ha, sp)) {
 			DEBUG2(printk("%s(%ld): abort_command "
 			    "mbx failed.\n", __func__, ha->host_no));
+			ret = FAILED;
 		} else {
 			DEBUG3(printk("%s(%ld): abort_command "
 			    "mbx success.\n", __func__, ha->host_no));

-- 
