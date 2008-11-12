Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbYKLAlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbYKLAlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbYKLA0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:54 -0500
Received: from kroah.org ([198.145.64.141]:42585 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752977AbYKLA0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:53 -0500
Date: Tue, 11 Nov 2008 16:24:15 -0800
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
       alan@lxorguk.ukuu.org.uk, Shaohua Li <shaohua.li@intel.com>,
       Len Brown <len.brown@intel.com>
Subject: [patch 39/49] ACPI: dock: avoid check _STA method
Message-ID: <20081112002415.GN10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-dock-avoid-check-_sta-method.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Shaohua Li <shaohua.li@intel.com>

commit 8b59560a3baf2e7c24e0fb92ea5d09eca92805db upstream.

In some BIOSes, every _STA method call will send a notification again,
this cause freeze. And in some BIOSes, it appears _STA should be called
after _DCK. This tries to avoid calls _STA, and still keep the device
present check.

http://bugzilla.kernel.org/show_bug.cgi?id=10431

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/dock.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -604,14 +604,17 @@ static int handle_eject_request(struct d
 static void dock_notify(acpi_handle handle, u32 event, void *data)
 {
 	struct dock_station *ds = data;
+	struct acpi_device *tmp;
 
 	switch (event) {
 	case ACPI_NOTIFY_BUS_CHECK:
-		if (!dock_in_progress(ds) && dock_present(ds)) {
+		if (!dock_in_progress(ds) && acpi_bus_get_device(ds->handle,
+		   &tmp)) {
 			begin_dock(ds);
 			dock(ds);
 			if (!dock_present(ds)) {
 				printk(KERN_ERR PREFIX "Unable to dock!\n");
+				complete_dock(ds);
 				break;
 			}
 			atomic_notifier_call_chain(&dock_notifier_list,

-- 
