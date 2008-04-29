Return-Path: <linux-kernel-owner+w=401wt.eu-S1761531AbYD2R0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761531AbYD2R0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758443AbYD2RU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:20:56 -0400
Received: from ns1.suse.de ([195.135.220.2]:52035 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758416AbYD2RUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:20:55 -0400
Date: Tue, 29 Apr 2008 10:18:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Cox <alan@redhat.com>, Hans Verkuil <hverkuil@xs4all.nl>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [15/37] V4L: Fix VIDIOCGAP corruption in ivtv
Message-ID: <20080429171831.GP14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-fix-vidiocgap-corruption-in-ivtv.patch"
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

(cherry picked from commit d2b213f7b76f187c4391079c7581d3a08b940133)

Frank Bennett reported that ivtv was causing skype to crash. With help
from one of their developers he showed it was a kernel problem.
VIDIOCGCAP copies a name into a fixed length buffer - ivtv uses names
that are too long and does not truncate them so corrupts a few bytes of
the app data area.

Possibly the names also want trimming but for now this should fix the
corruption case.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/ivtv/ivtv-ioctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/video/ivtv/ivtv-ioctl.c
+++ b/drivers/media/video/ivtv/ivtv-ioctl.c
@@ -741,7 +741,8 @@ int ivtv_v4l2_ioctls(struct ivtv *itv, s
 
 		memset(vcap, 0, sizeof(*vcap));
 		strcpy(vcap->driver, IVTV_DRIVER_NAME);     /* driver name */
-		strcpy(vcap->card, itv->card_name); 	    /* card type */
+		strncpy(vcap->card, itv->card_name,
+				sizeof(vcap->card)-1); 	    /* card type */
 		strcpy(vcap->bus_info, pci_name(itv->dev)); /* bus info... */
 		vcap->version = IVTV_DRIVER_VERSION; 	    /* version */
 		vcap->capabilities = itv->v4l2_cap; 	    /* capabilities */

-- 
