Return-Path: <linux-kernel-owner+w=401wt.eu-S935894AbXLQMBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935894AbXLQMBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 07:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935564AbXLQMB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 07:01:27 -0500
Received: from smtp108.plus.mail.re1.yahoo.com ([69.147.102.71]:27866 "HELO
	smtp108.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S935556AbXLQMB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 07:01:26 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:User-Agent;
  b=DOSjiDUJDolXFHvz2K1Yv53yPkuDT2zbXNNGc5rfJwBwnDVQ8EVTOsuu0uWazHpl7/HAPG3o1QG+HUfX+zvPzinNK2o1i60+FrFM60OgFzUQXG71G2Xu+s8bViKsL8PKoDqzlB+noHXDscgy52H5fQM2VDkkLpHcvz80cqBrpaM=  ;
X-YMail-OSG: l62bS2sVM1nMcZ2CT_3TuUPsxO9BBZ3m4F1N4o1Okhd21lP5LeLMohmUveJuPheVH7.ZttU8SQ--
Date: Mon, 17 Dec 2007 12:59:45 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/cdrom/cdrom.c: simplify logic in cdrom_release()
Message-ID: <20071217115944.GA12013@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de, axboe@kernel.dk,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
From: Borislav Petkov <bbpetkov@yahoo.de>

Simplify logic in cdrom_release() without semantical change.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

--

 drivers/cdrom/cdrom.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index af05610..037d4ec 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -1206,25 +1206,26 @@ int check_for_audio_disc(struct cdrom_device_info * cdi,
 	return 0;
 }
 
-/* Admittedly, the logic below could be performed in a nicer way. */
 int cdrom_release(struct cdrom_device_info *cdi, struct file *fp)
 {
 	struct cdrom_device_ops *cdo = cdi->ops;
 	int opened_for_data;
 
-	cdinfo(CD_CLOSE, "entering cdrom_release\n"); 
+	cdinfo(CD_CLOSE, "entering cdrom_release\n");
 
 	if (cdi->use_count > 0)
 		cdi->use_count--;
-	if (cdi->use_count == 0)
+
+	if (cdi->use_count == 0) {
 		cdinfo(CD_CLOSE, "Use count for \"/dev/%s\" now zero\n", cdi->name);
-	if (cdi->use_count == 0)
 		cdrom_dvd_rw_close_write(cdi);
-	if (cdi->use_count == 0 &&
-	    (cdo->capability & CDC_LOCK) && !keeplocked) {
-		cdinfo(CD_CLOSE, "Unlocking door!\n");
-		cdo->lock_door(cdi, 0);
+
+		if ((cdo->capability & CDC_LOCK) && !keeplocked) {
+			cdinfo(CD_CLOSE, "Unlocking door!\n");
+			cdo->lock_door(cdi, 0);
+		}
 	}
+
 	opened_for_data = !(cdi->options & CDO_USE_FFLAGS) ||
 		!(fp && fp->f_flags & O_NONBLOCK);
 
-- 
Regards/Gruﬂ,
    Boris.
