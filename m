Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbZBJTHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbZBJTHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbZBJTDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:03:37 -0500
Received: from kroah.org ([198.145.64.141]:53693 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755104AbZBJTDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:03:36 -0500
Date: Tue, 10 Feb 2009 11:00:02 -0800
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
       alan@lxorguk.ukuu.org.uk, Holger Macht <hmacht@suse.de>,
       Len Brown <len.brown@intel.com>
Subject: [patch 11/53] ACPI: dock: Dont eval _STA on every show_docked
	sysfs read
Message-ID: <20090210190002.GL14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-dock-don-t-eval-_sta-on-every-show_docked-sysfs-read.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Holger Macht <hmacht@suse.de>

commit fc5a9f8841ee87d93376ada5d73117d4d6a373ea upstream.

Some devices trigger a DEVICE_CHECK on every evalutation of _STA. This
can also be seen in commit 8b59560a3baf2e7c24e0fb92ea5d09eca92805db
(ACPI: dock: avoid check _STA method).  If an undock is processed, the
dock driver sends a uevent and userspace might read the show_docked
property in sysfs. This causes an evaluation of _STA of the particular
device which causes the dock driver to immediately dock again.

In any case, evaluation of _STA (show_docked) does not necessarily mean
that we are docked, so check with the internal device structure.

http://bugzilla.kernel.org/show_bug.cgi?id=12360

Signed-off-by: Holger Macht <hmacht@suse.de>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/dock.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -855,10 +855,14 @@ fdd_out:
 static ssize_t show_docked(struct device *dev,
 			   struct device_attribute *attr, char *buf)
 {
+	struct acpi_device *tmp;
+
 	struct dock_station *dock_station = *((struct dock_station **)
 		dev->platform_data);
-	return snprintf(buf, PAGE_SIZE, "%d\n", dock_present(dock_station));
 
+	if (ACPI_SUCCESS(acpi_bus_get_device(dock_station->handle, &tmp)))
+		return snprintf(buf, PAGE_SIZE, "1\n");
+	return snprintf(buf, PAGE_SIZE, "0\n");
 }
 static DEVICE_ATTR(docked, S_IRUGO, show_docked, NULL);
 

