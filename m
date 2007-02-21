Return-Path: <linux-kernel-owner+w=401wt.eu-S964934AbXBUBwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934AbXBUBwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 20:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964824AbXBUBv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 20:51:57 -0500
Received: from mail.suse.de ([195.135.220.2]:42886 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964841AbXBUBvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 20:51:52 -0500
Date: Tue, 20 Feb 2007 17:50:14 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dirk Eibach <eibach@gdsys.de>, Adrian Bunk <bunk@stusta.de>,
       Dirk Stieler <stieler@gdsys.de>, Jean Delvare <khali@linux-fr.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 06/18] i2c: fix broken ds1337 initialization
Message-ID: <20070221015014.GG3684@kroah.com>
References: <20070221014413.282048309@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="i2c-fix-broken-ds1337-initialization.patch"
In-Reply-To: <20070221014927.GA3684@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Dirk Eibach <eibach@gdsys.de>

On a custom board with ds1337 RTC I found that upgrade from 2.6.15 to
2.6.18 broke RTC support.

The main problem are changes to ds1337_init_client().
When a ds1337 recognizes a problem (e.g. power or clock failure) bit 7
in status register is set. This has to be reset by writing 0 to status
register. But since there are only 16 byte written to the chip and the
first byte is interpreted as an address, the status register (which is
the 16th) is never written.
The other problem is, that initializing all registers to zero is not
valid for day, date and month register. Funny enough this is checked by
ds1337_detect(), which depends on this values not being zero. So then
treated by ds1337_init_client() the ds1337 is not detected anymore,
whereas the failure bit in the status register is still set.

Broken by commit f9e8957937ebf60d22732a5ca9130f48a7603f60 (2.6.16-rc1,
2006-01-06). This fix is in Linus' tree since 2.6.20-rc1 (commit
763d9c046a2e511ec090a8986d3f85edf7448e7e).

Signed-off-by: Dirk Stieler <stieler@gdsys.de>
Signed-off-by: Dirk Eibach <eibach@gdsys.de>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/i2c/chips/ds1337.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- linux-2.6.18.7.orig/drivers/i2c/chips/ds1337.c
+++ linux-2.6.18.7/drivers/i2c/chips/ds1337.c
@@ -347,13 +347,19 @@ static void ds1337_init_client(struct i2
 
 	if ((status & 0x80) || (control & 0x80)) {
 		/* RTC not running */
-		u8 buf[16];
+		u8 buf[1+16];	/* First byte is interpreted as address */
 		struct i2c_msg msg[1];
 
 		dev_dbg(&client->dev, "%s: RTC not running!\n", __FUNCTION__);
 
 		/* Initialize all, including STATUS and CONTROL to zero */
 		memset(buf, 0, sizeof(buf));
+
+		/* Write valid values in the date/time registers */
+		buf[1+DS1337_REG_DAY] = 1;
+		buf[1+DS1337_REG_DATE] = 1;
+		buf[1+DS1337_REG_MONTH] = 1;
+
 		msg[0].addr = client->addr;
 		msg[0].flags = 0;
 		msg[0].len = sizeof(buf);

--
