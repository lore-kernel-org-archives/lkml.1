Return-Path: <linux-kernel-owner+w=401wt.eu-S1762293AbZCNAq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762293AbZCNAq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbZCNAT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:19:58 -0400
Received: from kroah.org ([198.145.64.141]:35020 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751326AbZCNATn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:19:43 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:51 2009
Message-Id: <20090314000751.512679112@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:06:30 -0700
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
       alan@lxorguk.ukuu.org.uk, Roel Kluin <roel.kluin@gmail.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: [patch 82/96] i2c: Timeouts reach -1
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=i2c-timeouts-reach-1.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roel Kluin <roel.kluin@gmail.com>

commit a746b578d8406b2db0e9f0d040061bc1f78433cf upstream

With a postfix decrement these timeouts reach -1 rather than 0, but
after the loop it is tested whether they have become 0.

As pointed out by Jean Delvare, the condition we are waiting for should
also be tested before the timeout. With the current order, you could
exit with a timeout error while the job is actually done.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/i2c/busses/i2c-amd8111.c |    4 ++--
 drivers/i2c/busses/i2c-pxa.c     |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/i2c/busses/i2c-amd8111.c
+++ b/drivers/i2c/busses/i2c-amd8111.c
@@ -72,7 +72,7 @@ static unsigned int amd_ec_wait_write(st
 {
 	int timeout = 500;
 
-	while (timeout-- && (inb(smbus->base + AMD_EC_SC) & AMD_EC_SC_IBF))
+	while ((inb(smbus->base + AMD_EC_SC) & AMD_EC_SC_IBF) && --timeout)
 		udelay(1);
 
 	if (!timeout) {
@@ -88,7 +88,7 @@ static unsigned int amd_ec_wait_read(str
 {
 	int timeout = 500;
 
-	while (timeout-- && (~inb(smbus->base + AMD_EC_SC) & AMD_EC_SC_OBF))
+	while ((~inb(smbus->base + AMD_EC_SC) & AMD_EC_SC_OBF) && --timeout)
 		udelay(1);
 
 	if (!timeout) {
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -604,7 +604,7 @@ static int i2c_pxa_do_pio_xfer(struct px
 
 	i2c_pxa_start_message(i2c);
 
-	while (timeout-- && i2c->msg_num > 0) {
+	while (i2c->msg_num > 0 && --timeout) {
 		i2c_pxa_handler(0, i2c);
 		udelay(10);
 	}


