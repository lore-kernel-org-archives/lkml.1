Return-Path: <linux-kernel-owner+w=401wt.eu-S1764281AbYHDU26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764281AbYHDU26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763499AbYHDU2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:28:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45977 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764201AbYHDU2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:28:35 -0400
Date: Mon, 4 Aug 2008 13:16:03 -0700
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
       alan@lxorguk.ukuu.org.uk, Arjan van de Ven <arjan@linux.intel.com>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [patch 22/33] ACPI: Reject below-freezing temperatures as invalid
	critical temperatures
Message-ID: <20080804201603.GW1139@suse.de>
References: <20080804200515.110033151@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-reject-below-freezing-temperatures-as-invalid-critical-temperatures.patch"
In-Reply-To: <20080804201321.GA1139@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Arjan van de Ven <arjan@linux.intel.com>

commit a39a2d7c72b358c6253a2ec28e17b023b7f6f41c upstream

My laptop thinks that it's a good idea to give -73C as the critical
CPU temperature.... which isn't the best thing since it causes a shutdown
right at bootup.

Temperatures below freezing are clearly invalid critical thresholds
so just reject these as such.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/thermal.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -359,10 +359,17 @@ static int acpi_thermal_trips_update(str
 	if (flag & ACPI_TRIPS_CRITICAL) {
 		status = acpi_evaluate_integer(tz->device->handle,
 				"_CRT", NULL, &tz->trips.critical.temperature);
-		if (ACPI_FAILURE(status)) {
+		/*
+		 * Treat freezing temperatures as invalid as well; some
+		 * BIOSes return really low values and cause reboots at startup.
+		 * Below zero (Celcius) values clearly aren't right for sure..
+		 * ... so lets discard those as invalid.
+		 */
+		if (ACPI_FAILURE(status) ||
+				tz->trips.critical.temperature <= 2732) {
 			tz->trips.critical.flags.valid = 0;
 			ACPI_EXCEPTION((AE_INFO, status,
-					"No critical threshold"));
+					"No or invalid critical threshold"));
 			return -ENODEV;
 		} else {
 			tz->trips.critical.flags.valid = 1;

-- 
