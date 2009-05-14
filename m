Return-Path: <linux-kernel-owner+w=401wt.eu-S1759350AbZENWqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350AbZENWqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 18:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756502AbZENWmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:42:13 -0400
Received: from kroah.org ([198.145.64.141]:51558 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756159AbZENWmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:42:05 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:35:22 2009
Message-Id: <20090514223522.308179990@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:32:48 -0700
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
       alan@lxorguk.ukuu.org.uk, Dave Airlie <airlied@redhat.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: [patch 13/51] i2c-algo-bit: Fix timeout test
References: <20090514223235.348540705@mini.kroah.org>
Content-Disposition: inline; filename=i2c-algo-bit-fix-timeout-test.patch
In-Reply-To: <20090514223755.GA27019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 0cdba07bb23cdd3e0d64357ec3d983e6b75e541f upstream

When fetching DDC using i2c algo bit, we were often seeing timeouts
before getting valid EDID on a retry. The VESA spec states 2ms is the
DDC timeout, so when this translates into 1 jiffie and we are close
to the end of the time period, it could return with a timeout less than
2ms.

Change this code to use time_after instead of time_after_eq.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/i2c/algos/i2c-algo-bit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/algos/i2c-algo-bit.c
+++ b/drivers/i2c/algos/i2c-algo-bit.c
@@ -104,7 +104,7 @@ static int sclhi(struct i2c_algo_bit_dat
 		 * chips may hold it low ("clock stretching") while they
 		 * are processing data internally.
 		 */
-		if (time_after_eq(jiffies, start + adap->timeout))
+		if (time_after(jiffies, start + adap->timeout))
 			return -ETIMEDOUT;
 		cond_resched();
 	}


