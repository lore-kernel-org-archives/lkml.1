Return-Path: <linux-kernel-owner+w=401wt.eu-S1759708AbYGVXcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708AbYGVXcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757421AbYGVXXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:23:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:58257 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757386AbYGVXXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:23:18 -0400
Date: Tue, 22 Jul 2008 16:17:26 -0700
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
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Moore <Eric.Moore@lsi.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 41/47] SCSI: mptspi: fix oops in
	mptspi_dv_renegotiate_work()
Message-ID: <20080722231726.GP8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi-mptspi-fix-oops-in-mptspi_dv_renegotiate_work.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 081a5bcb39b455405d58f79bb3c9398a9d4477ed upstream

The problem here is that if the ioc faults too early in the bring up
sequence (as it usually does for an irq routing problem), ioc_reset gets
called before the scsi host is even allocated.  This causes an oops when
it later schedules a renegotiation.  Fix this by checking ioc->sh before
trying to renegotiate.

Cc: Eric Moore <Eric.Moore@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/message/fusion/mptspi.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -1266,13 +1266,18 @@ mptspi_dv_renegotiate(struct _MPT_SCSI_H
 static int
 mptspi_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
 {
-	struct _MPT_SCSI_HOST *hd = shost_priv(ioc->sh);
 	int rc;
 
 	rc = mptscsih_ioc_reset(ioc, reset_phase);
 
-	if (reset_phase == MPT_IOC_POST_RESET)
+	/* only try to do a renegotiation if we're properly set up
+	 * if we get an ioc fault on bringup, ioc->sh will be NULL */
+	if (reset_phase == MPT_IOC_POST_RESET &&
+	    ioc->sh) {
+		struct _MPT_SCSI_HOST *hd = shost_priv(ioc->sh);
+
 		mptspi_dv_renegotiate(hd);
+	}
 
 	return rc;
 }

-- 
