Return-Path: <linux-kernel-owner+w=401wt.eu-S1761363AbXLMGnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761363AbXLMGnD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 01:43:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759191AbXLMGhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:37:36 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56335 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbXLMGh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:37:29 -0500
Date: Wed, 12 Dec 2007 22:34:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, rleigh@whinlatter.ukfsn.org,
       benh@kernel.crashing.org, mb@bu3sch.de, khali@linux-fr.org,
       adaplas@pol.net
Subject: [patch 15/36] fb_ddc: fix DDC lines quirk
Message-ID: <20071213063442.GP25301@kroah.com>
References: <20071213062511.265908583@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fb_ddc-fix-ddc-lines-quirk.patch"
In-Reply-To: <20071213063308.GA25301@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Jean Delvare <khali@linux-fr.org>

patch b64d70825abbf706bbe80be1b11b09514b71f45e in mainline.

The code in fb_ddc_read() is said to be based on the implementation of the
radeon driver:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=fc5891c8a3ba284f13994d7bc1f1bfa8283982de

However, comparing the old radeon driver code with the new fb_ddc code
reveals some differences.  Most notably, the I2C bus lines are held at the
end of the function, while the original code was releasing them (as the
comment above correctly says.)

There are a few other differences, which appear to be responsible for read
failures on my system.  While tracing low-level I2C code in i2c-algo-bit, I
noticed that the initial attempt to read the EDID always failed.  It takes
one retry for the read to succeed.  As we are about to remove this
automatic retry property from i2c-algo-bit, reading the EDID would really
fail.

As a summary, the I2C lines quirk which is supposedly needed to read EDID
on some older monitors is currently breaking the (first) read on all other
monitors (and might not even work with older ones - did anyone try since
October 2006?)

After applying the patch below, which makes the code in fb_ddc_read()
really similar to what the radeon driver used to have, the first EDID read
succeeds again.

On top of that, as it appears that this code has been broken for one year
now and nobody seems to have complained, I'm curious if it makes sense to
keep this quirk in place.  It makes the code more complex and slower just
for the sake of monitors which I guess nobody uses anymore.  Can't we just
get rid of it?

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Tested-by: Roger Leigh <rleigh@whinlatter.ukfsn.org>
Tested-by: Michael Buesch <mb@bu3sch.de>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/fb_ddc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/video/fb_ddc.c
+++ b/drivers/video/fb_ddc.c
@@ -56,13 +56,12 @@ unsigned char *fb_ddc_read(struct i2c_ad
 	int i, j;
 
 	algo_data->setscl(algo_data->data, 1);
-	algo_data->setscl(algo_data->data, 0);
 
 	for (i = 0; i < 3; i++) {
 		/* For some old monitors we need the
 		 * following process to initialize/stop DDC
 		 */
-		algo_data->setsda(algo_data->data, 0);
+		algo_data->setsda(algo_data->data, 1);
 		msleep(13);
 
 		algo_data->setscl(algo_data->data, 1);
@@ -97,14 +96,15 @@ unsigned char *fb_ddc_read(struct i2c_ad
 		algo_data->setsda(algo_data->data, 1);
 		msleep(15);
 		algo_data->setscl(algo_data->data, 0);
+		algo_data->setsda(algo_data->data, 0);
 		if (edid)
 			break;
 	}
 	/* Release the DDC lines when done or the Apple Cinema HD display
 	 * will switch off
 	 */
-	algo_data->setsda(algo_data->data, 0);
-	algo_data->setscl(algo_data->data, 0);
+	algo_data->setsda(algo_data->data, 1);
+	algo_data->setscl(algo_data->data, 1);
 
 	return edid;
 }

-- 
