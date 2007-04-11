Return-Path: <linux-kernel-owner+w=401wt.eu-S1161356AbXDKXGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161356AbXDKXGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 19:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161352AbXDKXG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 19:06:28 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55571 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161356AbXDKWy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:54:27 -0400
Date: Wed, 11 Apr 2007 15:51:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Adam Kropelin <akropel1@rochester.rr.com>,
       Jiri Kosina <jkosina@suse.cz>
Subject: [patch 10/31] HID: Do not discard truncated input reports
Message-ID: <20070411225148.GK24814@kroah.com>
References: <20070411224329.866978349@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hid-do-not-discard-truncated-input-reports.patch"
In-Reply-To: <20070411225100.GA24814@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Adam Kropelin <akropel1@rochester.rr.com>

HID: Do not discard truncated input reports

Truncated reports should not be discarded since it prevents buggy
devices from communicating with userspace.

Prior to the regession introduced in 2.6.20, a shorter-than-expected
report in hid_input_report() was passed thru after having the missing
bytes cleared. This behavior was established over a few patches in the
2.6.early-teens days, including commit
cd6104572bca9e4afe0dcdb8ecd65ef90b01297b.

This patch restores the previous behavior and fixes the regression.

Signed-off-by: Adam Kropelin <akropel1@rochester.rr.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hid-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -975,7 +975,7 @@ int hid_input_report(struct hid_device *
 
 	if (size < rsize) {
 		dbg("report %d is too short, (%d < %d)", report->id, size, rsize);
-		return -1;
+		memset(data + size, 0, rsize - size);
 	}
 
 	if ((hid->claimed & HID_CLAIMED_HIDDEV) && hid->hiddev_report_event)

-- 
