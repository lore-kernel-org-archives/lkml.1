Return-Path: <linux-kernel-owner+w=401wt.eu-S1764937AbYHRTe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764937AbYHRTe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764683AbYHRTdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:33:32 -0400
Received: from ns2.suse.de ([195.135.220.15]:41236 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761429AbYHRTda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:33:30 -0400
Date: Mon, 18 Aug 2008 12:20:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Andi Kleen <ak@linux.intel.com>
Subject: [patch 21/49] acer-wmi: Fix wireless and bluetooth on early AMW0
	v2 laptops
Message-ID: <20080818192003.GV10350@suse.de>
References: <20080818191012.663450219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acer-wmi-fix-wireless-and-bluetooth-on-early-amw0-v2-laptops.patch"
In-Reply-To: <20080818191834.GA10350@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Carlos Corbacho <carlos@strangeworlds.co.uk>

commit 5c742b45dd5fbbb6cf74d3378341704f4b23c5e8 upstream

In the old acer_acpi, I discovered that on some of the newer AMW0 laptops
that supported the WMID methods, they don't work properly for setting the
wireless and bluetooth values.

So for the AMW0 V2 laptops, we want to use both the 'old' AMW0 and the
'new' WMID methods for setting wireless & bluetooth to guarantee we always
enable it.

This was fixed in acer_acpi some time ago, but I forgot to port the patch
over to acer-wmi when it was merged.

(Without this patch, early AMW0 V2 laptops such as the Aspire 5040 won't
work with acer-wmi, where-as they did with the old acer_acpi).

AK: fix compilation

Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/acer-wmi.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/drivers/misc/acer-wmi.c
+++ b/drivers/misc/acer-wmi.c
@@ -742,11 +742,30 @@ static acpi_status get_u32(u32 *value, u
 
 static acpi_status set_u32(u32 value, u32 cap)
 {
+	acpi_status status;
+
 	if (interface->capability & cap) {
 		switch (interface->type) {
 		case ACER_AMW0:
 			return AMW0_set_u32(value, cap, interface);
 		case ACER_AMW0_V2:
+			if (cap == ACER_CAP_MAILLED)
+				return AMW0_set_u32(value, cap, interface);
+
+			/*
+			 * On some models, some WMID methods don't toggle
+			 * properly. For those cases, we want to run the AMW0
+			 * method afterwards to be certain we've really toggled
+			 * the device state.
+			 */
+			if (cap == ACER_CAP_WIRELESS ||
+				cap == ACER_CAP_BLUETOOTH) {
+				status = WMID_set_u32(value, cap, interface);
+				if (ACPI_FAILURE(status))
+					return status;
+
+				return AMW0_set_u32(value, cap, interface);
+			}
 		case ACER_WMID:
 			return WMID_set_u32(value, cap, interface);
 		default:

-- 
