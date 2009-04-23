Return-Path: <linux-kernel-owner+w=401wt.eu-S1755608AbZDWRTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbZDWRTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 13:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbZDWRTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 13:19:06 -0400
Received: from proxima.lp0.eu ([81.2.80.65]:60466 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbZDWRTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 13:19:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:Content-Type:Content-Transfer-Encoding;
	b=iw8KiljHDtyh/lNF1pGtxRPos8mY+YWU1R57zNckrspx3o73g0ZFWG6/lVO/lPgiyjLvfMZXbIJcEhN2Bmxsnhoxf5G63eT1D3JGF/TjmBqAcXaisZ8pan9BQfdl1bZy;
Message-ID: <49F0A306.9010409@simon.arlott.org.uk>
Date: Thu, 23 Apr 2009 18:19:02 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.21 (X11/20090328)
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Subject: [PATCH] cxacru: Fix negative dB output
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Values of dB between -0.99 and -0.01 will be output with the wrong
sign. This converts the negative value to positive and outputs it
with a "-" prefix.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 drivers/usb/atm/cxacru.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index 6789089..56802d2 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -227,8 +227,14 @@ static ssize_t cxacru_sysfs_showattr_s8(s8 value, char *buf)
 
 static ssize_t cxacru_sysfs_showattr_dB(s16 value, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%d.%02u\n",
-					value / 100, abs(value) % 100);
+	if (likely(value >= 0)) {
+		return snprintf(buf, PAGE_SIZE, "%u.%02u\n",
+					value / 100, value % 100);
+	} else {
+		value = -value;
+		return snprintf(buf, PAGE_SIZE, "-%u.%02u\n",
+					value / 100, value % 100);
+	}
 }
 
 static ssize_t cxacru_sysfs_showattr_bool(u32 value, char *buf)
-- 
1.6.2.2

-- 
Simon Arlott
