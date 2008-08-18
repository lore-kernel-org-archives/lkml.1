Return-Path: <linux-kernel-owner+w=401wt.eu-S933993AbYHRTr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933993AbYHRTr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765502AbYHRTnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:43:08 -0400
Received: from ns1.suse.de ([195.135.220.2]:49718 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761865AbYHRTnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:43:05 -0400
Date: Mon, 18 Aug 2008 12:20:54 -0700
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
       alan@lxorguk.ukuu.org.uk, Hans Verkuil <hverkuil@xs4all.nl>,
       Jean Delvare <khali@linux-fr.org>
Subject: [patch 44/49] i2c: Fix NULL pointer dereference in
	i2c_new_probed_device
Message-ID: <20080818192054.GS10350@suse.de>
References: <20080818191012.663450219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="i2c-fix-null-pointer-dereference-in-i2c_new_probed_device.patch"
In-Reply-To: <20080818191834.GA10350@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Hans Verkuil <hverkuil@xs4all.nl>

Already in Linus' tree:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b25b791b13aaa336b56c4f9bd417ff126363f80b

Fix a NULL pointer dereference that happened when calling
i2c_new_probed_device on one of the addresses for which we use byte
reads instead of quick write for detection purpose (that is: 0x30-0x37
and 0x50-0x5f).

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/i2c/i2c-core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1173,9 +1173,11 @@ i2c_new_probed_device(struct i2c_adapter
 		if ((addr_list[i] & ~0x07) == 0x30
 		 || (addr_list[i] & ~0x0f) == 0x50
 		 || !i2c_check_functionality(adap, I2C_FUNC_SMBUS_QUICK)) {
+			union i2c_smbus_data data;
+
 			if (i2c_smbus_xfer(adap, addr_list[i], 0,
 					   I2C_SMBUS_READ, 0,
-					   I2C_SMBUS_BYTE, NULL) >= 0)
+					   I2C_SMBUS_BYTE, &data) >= 0)
 				break;
 		} else {
 			if (i2c_smbus_xfer(adap, addr_list[i], 0,

-- 
