Return-Path: <linux-kernel-owner+w=401wt.eu-S933903AbYBGVBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933903AbYBGVBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:01:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762710AbYBGUvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:51:53 -0500
Received: from ns1.suse.de ([195.135.220.2]:45515 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762236AbYBGUvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:51:49 -0500
Date: Thu, 7 Feb 2008 12:47:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, linux-usb@vger.kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Janusz <janumix@poczta.fm>, Jon Masters <jcm@redhat.com>
Subject: [patch 21/45] USB: handle idVendor of 0x0000
Message-ID: <20080207204727.GV16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-handle-idvendor-of-0x0000.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Greg Kroah-Hartman <gregkh@suse.de>

Some crazy devices in the wild have a vendor id of 0x0000.  If we try to
add a module alias with this id, we just can't do it due to a check in
the file2alias.c file.  Change the test to verify that both the vendor
and product ids are 0x0000 to show a real "blank" module alias.

Note, the module-init-tools package also needs to be changed to properly
generate the depmod tables.

Cc: Janusz <janumix@poczta.fm>
Cc: Jon Masters <jcm@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/driver.c |    4 ++--
 scripts/mod/file2alias.c  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -534,8 +534,8 @@ const struct usb_device_id *usb_match_id
 	   id->driver_info is the way to create an entry that
 	   indicates that the driver want to examine every
 	   device and interface. */
-	for (; id->idVendor || id->bDeviceClass || id->bInterfaceClass ||
-	       id->driver_info; id++) {
+	for (; id->idVendor || id->idProduct || id->bDeviceClass ||
+	       id->bInterfaceClass || id->driver_info; id++) {
 		if (usb_match_one_id(interface, id))
 			return id;
 	}
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -155,7 +155,7 @@ static void do_usb_entry_multi(struct us
 	 * Some modules (visor) have empty slots as placeholder for
 	 * run-time specification that results in catch-all alias
 	 */
-	if (!(id->idVendor | id->bDeviceClass | id->bInterfaceClass))
+	if (!(id->idVendor | id->idProduct | id->bDeviceClass | id->bInterfaceClass))
 		return;
 
 	/* Convert numeric bcdDevice range into fnmatch-able pattern(s) */

-- 
