Return-Path: <linux-kernel-owner+w=401wt.eu-S1764381AbYD2SyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764381AbYD2SyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759431AbYD2SvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:51:17 -0400
Received: from mx1.suse.de ([195.135.220.2]:51672 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758939AbYD2SvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:51:15 -0400
Date: Tue, 29 Apr 2008 11:50:05 -0700
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
Subject: [10/12] V4L: Fix VIDIOCGAP corruption in ivtv
Message-ID: <20080429185005.GL24199@suse.de>
References: <20080429184543.308594866@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-fix-vidiocgap-corruption-in-ivtv.patch"
In-Reply-To: <20080429184911.GA24199@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Alan Cox <alan@lxorguk.ukuu.org.uk>

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
(cherry picked from commit d2b213f7b76f187c4391079c7581d3a08b940133)
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/ivtv/ivtv-ioctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/video/ivtv/ivtv-ioctl.c
+++ b/drivers/media/video/ivtv/ivtv-ioctl.c
@@ -727,7 +727,8 @@ int ivtv_v4l2_ioctls(struct ivtv *itv, s
 
 		memset(vcap, 0, sizeof(*vcap));
 		strcpy(vcap->driver, IVTV_DRIVER_NAME);     /* driver name */
-		strcpy(vcap->card, itv->card_name); 	    /* card type */
+		strncpy(vcap->card, itv->card_name,
+				sizeof(vcap->card)-1); 	    /* card type */
 		strcpy(vcap->bus_info, pci_name(itv->dev)); /* bus info... */
 		vcap->version = IVTV_DRIVER_VERSION; 	    /* version */
 		vcap->capabilities = itv->v4l2_cap; 	    /* capabilities */

-- 
