Return-Path: <linux-kernel-owner+w=401wt.eu-S1761844AbZCTXTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761844AbZCTXTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759530AbZCTXNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:13:49 -0400
Received: from kroah.org ([198.145.64.141]:53159 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755837AbZCTXNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:13:48 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:27:11 2009
Message-Id: <20090320222711.466724884@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:26:27 -0700
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
       alan@lxorguk.ukuu.org.uk, Mathieu Chouquet-Stringer <mchouque@free.fr>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Len Brown <len.brown@intel.com>
Subject: [patch 16/32] thinkpad-acpi: fix module autoloading for older models
References: <20090320222611.872315885@mini.kroah.org>
Content-Disposition: inline; filename=thinkpad-acpi-fix-module-autoloading-for-older-models.patch
In-Reply-To: <20090320231037.GA2732@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mathieu Chouquet-Stringer <mchouque@free.fr>

commit b36a50f92d1c4300a88f606b4d2bbdc4f442a2d7 upstream.

Looking at the source, there seems to be a missing * to match my DMI
string.  I mean for newer IBM and Lenovo's laptops you match either one
of the following:
MODULE_ALIAS("dmi:bvnIBM:*:svnIBM:*:pvrThinkPad*:rvnIBM:*");
MODULE_ALIAS("dmi:bvnLENOVO:*:svnLENOVO:*:pvrThinkPad*:rvnLENOVO:*");

While for older Thinkpads, you do this (for instance):
IBM_BIOS_MODULE_ALIAS("1[0,3,6,8,A-G,I,K,M-P,S,T]");

with IBM_BIOS_MODULE_ALIAS being MODULE_ALIAS("dmi:bvnIBM:bvr" __type "ET??WW")

Note there's no * terminating the string.  As result, udev doesn't load
anything because modprobe cannot find anything matching this (my
machine actually):

udevtest: run: '/sbin/modprobe dmi:bvnIBM:bvr1IET71WW(2.10):bd06/16/2006:svnIBM:pn236621U:pvrNotAv

Signed-off-by: Mathieu Chouquet-Stringer <mchouque@free.fr>
Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/thinkpad_acpi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/misc/thinkpad_acpi.c
+++ b/drivers/misc/thinkpad_acpi.c
@@ -6826,7 +6826,7 @@ MODULE_ALIAS(TPACPI_DRVR_SHORTNAME);
  * if it is not there yet.
  */
 #define IBM_BIOS_MODULE_ALIAS(__type) \
-	MODULE_ALIAS("dmi:bvnIBM:bvr" __type "ET??WW")
+	MODULE_ALIAS("dmi:bvnIBM:bvr" __type "ET??WW*")
 
 /* Non-ancient thinkpads */
 MODULE_ALIAS("dmi:bvnIBM:*:svnIBM:*:pvrThinkPad*:rvnIBM:*");
@@ -6835,9 +6835,9 @@ MODULE_ALIAS("dmi:bvnLENOVO:*:svnLENOVO:
 /* Ancient thinkpad BIOSes have to be identified by
  * BIOS type or model number, and there are far less
  * BIOS types than model numbers... */
-IBM_BIOS_MODULE_ALIAS("I[B,D,H,I,M,N,O,T,W,V,Y,Z]");
-IBM_BIOS_MODULE_ALIAS("1[0,3,6,8,A-G,I,K,M-P,S,T]");
-IBM_BIOS_MODULE_ALIAS("K[U,X-Z]");
+IBM_BIOS_MODULE_ALIAS("I[BDHIMNOTWVYZ]");
+IBM_BIOS_MODULE_ALIAS("1[0368A-GIKM-PST]");
+IBM_BIOS_MODULE_ALIAS("K[UX-Z]");
 
 MODULE_AUTHOR("Borislav Deianov, Henrique de Moraes Holschuh");
 MODULE_DESCRIPTION(TPACPI_DESC);


