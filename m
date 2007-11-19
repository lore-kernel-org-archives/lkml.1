Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbXKSS35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbXKSS35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750875AbXKSSWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:22:49 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49401 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbXKSSWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:22:48 -0500
Date: Mon, 19 Nov 2007 10:19:33 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Olof Johansson <olof@lixom.net>, Jean Delvare <khali@linux-fr.org>
Subject: [patch 24/26] i2c-pasemi: Fix NACK detection
Message-ID: <20071119181933.GY15425@kroah.com>
References: <20071119181438.617190424@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="i2c-pasemi-fix-nack-detection.patch"
In-Reply-To: <20071119181746.GA15425@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Jean Delvare <khali@linux-fr.org>

patch be8a1f7cd4501c3b4b32543577a33aee6d2193ac in mainline.

Turns out we don't actually check the status to see if there was a
device out there to talk to, just if we had a timeout when doing so.

Add the proper check, so we don't falsly think there are devices
on the bus that are not there, etc.

Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/i2c/busses/i2c-pasemi.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/i2c/busses/i2c-pasemi.c
+++ b/drivers/i2c/busses/i2c-pasemi.c
@@ -51,6 +51,7 @@ struct pasemi_smbus {
 #define MRXFIFO_DATA_M	0x000000ff
 
 #define SMSTA_XEN	0x08000000
+#define SMSTA_MTN	0x00200000
 
 #define CTL_MRR		0x00000400
 #define CTL_MTR		0x00000200
@@ -98,6 +99,10 @@ static unsigned int pasemi_smb_waitready
 		status = reg_read(smbus, REG_SMSTA);
 	}
 
+	/* Got NACK? */
+	if (status & SMSTA_MTN)
+		return -ENXIO;
+
 	if (timeout < 0) {
 		dev_warn(&smbus->dev->dev, "Timeout, status 0x%08x\n", status);
 		reg_write(smbus, REG_SMSTA, status);

-- 
