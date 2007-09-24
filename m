Return-Path: <linux-kernel-owner+w=401wt.eu-S1760660AbXIXQ03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760660AbXIXQ03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760247AbXIXQYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:24:48 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47162 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760225AbXIXQYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:24:47 -0400
Date: Mon, 24 Sep 2007 09:19:57 -0700
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
       Jarod Wilson <jwilson@redhat.com>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Trent Piepho <xyzzy@speakeasy.org>,
       Geoffrey Hausheer <inli3epy93n@phracturedblue.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [04/50] DVB: b2c2-flexcop: fix Airstar HD5000 tuning regression
Message-ID: <20070924161957.GE13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dvb-b2c2-flexcop-fix-airstar-hd5000-tuning-regression.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Trent Piepho <xyzzy@speakeasy.org>

cherry picked from commit 6175e487e314385e37f06448847e4c46c20edb44

b2c2-flexcop: fix Airstar HD5000 tuning regression

Git changeset 6bdcc6e6dbab8daffd05e5026486f34ba41a6c72 dropped the
stand-alone lgh06xf module, whose functionality was absorbed into the
dvb-pll module. However, there was a minor difference between the code
in lgh06xf and dvb-pll, which caused a regression in b2c2-flexcop
devices using the LG-H06xF NIM.

dvb-pll will probe for the presence of an i2c pll chip by performing a
single byte read, the lgh06xf driver did not do this. Unfortunately, the
code in flexcop-i2c.c does not currently support 1 byte or 0 byte reads
as a probe.  Such probes with the current code will always fail.

In order to work around this problem, and restore proper functionality
of the Airstar HD5000 device, this hack was created to make the probe
appear to succeed.  The single byte read in dvb_pll_attach is the only
place where such a probe would ever occur, so this change is safe, and
will not affect any other devices.

Of course, if one knew how to actually perform the read operation, it
would be better to go that route.  In the meantime, however, we must
apply this workaround, in order to prevent the regression that causes
tuning to fail on the Airstar HD5000 ATSC device.

Thanks to Jarod Wilson, who had originally reported this regression, and
to Geoffrey Hausheer, whose original workaround patch led us to find the
actual cause of the problem.

Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>
Cc: Geoffrey Hausheer <inli3epy93n@phracturedblue.com>
Acked-by: Jarod Wilson <jwilson@redhat.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/b2c2/flexcop-i2c.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/media/dvb/b2c2/flexcop-i2c.c
+++ b/drivers/media/dvb/b2c2/flexcop-i2c.c
@@ -135,6 +135,13 @@ static int flexcop_master_xfer(struct i2
 	struct flexcop_device *fc = i2c_get_adapdata(i2c_adap);
 	int i, ret = 0;
 
+	/* Some drivers use 1 byte or 0 byte reads as probes, which this
+	 * driver doesn't support.  These probes will always fail, so this
+	 * hack makes them always succeed.  If one knew how, it would of
+	 * course be better to actually do the read.  */
+	if (num == 1 && msgs[0].flags == I2C_M_RD && msgs[0].len <= 1)
+		return 1;
+
 	if (mutex_lock_interruptible(&fc->i2c_mutex))
 		return -ERESTARTSYS;
 

-- 
