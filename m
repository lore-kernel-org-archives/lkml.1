Return-Path: <linux-kernel-owner+w=401wt.eu-S1757249AbYJXErS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249AbYJXErS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbYJXEjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:39:39 -0400
Received: from kroah.org ([198.145.64.141]:51938 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751432AbYJXEjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:39:32 -0400
Date: Thu, 23 Oct 2008 21:35:08 -0700
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
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <len.brown@intel.com>
Subject: [patch 23/27] ACPI suspend: Always use the 32-bit waking vector
Message-ID: <20081024043508.GX30828@kroah.com>
References: <20081024042023.054190751@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-suspend-always-use-the-32-bit-waking-vector.patch"
In-Reply-To: <20081024043303.GA30828@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Rafael J. Wysocki <rjw@sisk.pl>

commit a6629105dd03d370fcb31e97bddf223fa4bb651e upstream.

According to the ACPI specification 2.0c and later, the 64-bit waking vector
should be cleared and the 32-bit waking vector should be used, unless we want
the wake-up code to be called by the BIOS in Protected Mode.  Moreover, some
systems (for example HP dv5-1004nr) are known to fail to resume if the 64-bit
waking vector is used.  Therefore, modify the code to clear the 64-bit waking
vector, for FACS version 1 or greater, and set the 32-bit one before suspend.

http://bugzilla.kernel.org/show_bug.cgi?id=11368

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/hardware/hwsleep.c |   37 +++++++++++--------------------------
 1 file changed, 11 insertions(+), 26 deletions(-)

--- a/drivers/acpi/hardware/hwsleep.c
+++ b/drivers/acpi/hardware/hwsleep.c
@@ -78,19 +78,17 @@ acpi_set_firmware_waking_vector(acpi_phy
 		return_ACPI_STATUS(status);
 	}
 
-	/* Set the vector */
+	/*
+	 * According to the ACPI specification 2.0c and later, the 64-bit
+	 * waking vector should be cleared and the 32-bit waking vector should
+	 * be used, unless we want the wake-up code to be called by the BIOS in
+	 * Protected Mode.  Some systems (for example HP dv5-1004nr) are known
+	 * to fail to resume if the 64-bit vector is used.
+	 */
+	if (facs->version >= 1)
+		facs->xfirmware_waking_vector = 0;
 
-	if ((facs->length < 32) || (!(facs->xfirmware_waking_vector))) {
-		/*
-		 * ACPI 1.0 FACS or short table or optional X_ field is zero
-		 */
-		facs->firmware_waking_vector = (u32) physical_address;
-	} else {
-		/*
-		 * ACPI 2.0 FACS with valid X_ field
-		 */
-		facs->xfirmware_waking_vector = physical_address;
-	}
+	facs->firmware_waking_vector = (u32)physical_address;
 
 	return_ACPI_STATUS(AE_OK);
 }
@@ -134,20 +132,7 @@ acpi_get_firmware_waking_vector(acpi_phy
 	}
 
 	/* Get the vector */
-
-	if ((facs->length < 32) || (!(facs->xfirmware_waking_vector))) {
-		/*
-		 * ACPI 1.0 FACS or short table or optional X_ field is zero
-		 */
-		*physical_address =
-		    (acpi_physical_address) facs->firmware_waking_vector;
-	} else {
-		/*
-		 * ACPI 2.0 FACS with valid X_ field
-		 */
-		*physical_address =
-		    (acpi_physical_address) facs->xfirmware_waking_vector;
-	}
+	*physical_address = (acpi_physical_address)facs->firmware_waking_vector;
 
 	return_ACPI_STATUS(AE_OK);
 }

-- 
