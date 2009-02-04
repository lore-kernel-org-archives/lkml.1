Return-Path: <linux-kernel-owner+w=401wt.eu-S1761751AbZBDTA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761751AbZBDTA7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761409AbZBDSte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:49:34 -0500
Received: from kroah.org ([198.145.64.141]:32821 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758995AbZBDStZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:49:25 -0500
Date: Wed, 4 Feb 2009 10:46:38 -0800
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
       alan@lxorguk.ukuu.org.uk, Zhao Yakui <yakui.zhao@intel.com>,
       Zhang Rui <rui.zhang@intel.com>, Andi Kleen <ak@linux.intel.com>,
       Len Brown <len.brown@intel.com>, Thomas Renninger <trenn@suse.de>
Subject: [patch 25/41] ACPI: Attach the ACPI device to the ACPI handle as
	early as possible
Message-ID: <20090204184638.GZ25246@kroah.com>
References: <20090204184029.881610776@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-attach-the-acpi-device-to-the-acpi-handle-as-early-as-possible.patch"
In-Reply-To: <20090204184539.GA25246@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhao Yakui <yakui.zhao@intel.com>

commit eab4b645769fa2f8703f5a3cb0cc4ac090d347af upstream.

Attach the ACPI device to the ACPI handle as early as possible so that OS
can get the corresponding ACPI device by the acpi handle in the course
of getting the power/wakeup/performance flags.

http://bugzilla.kernel.org/show_bug.cgi?id=8049
http://bugzilla.kernel.org/show_bug.cgi?id=11000

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/scan.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1262,6 +1262,16 @@ acpi_add_single_object(struct acpi_devic
 	acpi_device_set_id(device, parent, handle, type);
 
 	/*
+	 * The ACPI device is attached to acpi handle before getting
+	 * the power/wakeup/peformance flags. Otherwise OS can't get
+	 * the corresponding ACPI device by the acpi handle in the course
+	 * of getting the power/wakeup/performance flags.
+	 */
+	result = acpi_device_set_context(device, type);
+	if (result)
+		goto end;
+
+	/*
 	 * Power Management
 	 * ----------------
 	 */
@@ -1291,8 +1301,6 @@ acpi_add_single_object(struct acpi_devic
 			goto end;
 	}
 
-	if ((result = acpi_device_set_context(device, type)))
-		goto end;
 
 	result = acpi_device_register(device, parent);
 

