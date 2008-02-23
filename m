Return-Path: <linux-kernel-owner+w=401wt.eu-S935867AbYBWLZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935867AbYBWLZw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 06:25:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934799AbYBWLZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 06:25:21 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53554 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbYBWLZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 06:25:19 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 23 Feb 2008 12:24:17 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/2] firewire: endianess fix
To: linux1394-devel@lists.sourceforge.net
cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Kristian Hoegsberg <krh@bitplanet.net>,
       Jarod Wilson <jwilson@redhat.com>
In-Reply-To: <tkrat.e2bfb30f2c0ae70a@s5r6.in-berlin.de>
Message-ID: <tkrat.9e19fa31951506af@s5r6.in-berlin.de>
References: <20080220220326.GA22328@uranus.ravnborg.org>
 <1203545913.25307.47.camel@brick> <tkrat.e2bfb30f2c0ae70a@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generation of incoming requests was filled in in wrong byte order on
machines with big endian CPU.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: sparclinux@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org
---

This patch is a shot in the dark, based on a warning when building with
C=1 CHECKFLAGS="-D__CHECK_ENDIAN__".  Is it really a fix, or was the
previous code accidentally correct?

This needs to be tested on different big endian PCs, if possible with
the Apple Uninorth FireWire controller and other types of controllers.
One test which involves ohci->request_generation is simply with an SBP-2
device (harddisk, CD-ROM...).  Does SBP-2 login etc. work?

If possible, also test whether the device remains accessible after
forcing a bus reset, e.g. by "echo br short > firecontrol".  You need
the easy to build utility firecontrol and a libraw1394 with "juju"
backend.  See wiki.linux1394.org for directions.


 drivers/firewire/fw-ohci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -375,7 +375,7 @@ static __le32 *handle_ar_packet(struct a
 	 */
 
 	if (p.ack + 16 == 0x09)
-		ohci->request_generation = (buffer[2] >> 16) & 0xff;
+		ohci->request_generation = (p.header[2] >> 16) & 0xff;
 	else if (ctx == &ohci->ar_request_ctx)
 		fw_core_handle_request(&ohci->card, &p);
 	else

-- 
Stefan Richter
-=====-==--- --=- =-===
http://arcgraph.de/sr/

