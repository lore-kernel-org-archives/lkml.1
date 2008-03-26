Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbYCZDKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbYCZDKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 23:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbYCZDKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 23:10:31 -0400
Received: from eastrmmtao102.cox.net ([68.230.240.8]:50328 "EHLO
	eastrmmtao102.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbYCZDKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 23:10:30 -0400
X-Greylist: delayed 2265 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Mar 2008 23:10:30 EDT
Date: Tue, 25 Mar 2008 22:32:43 -0400
From: Brad Sawatzky <brad+debian@swatter.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH] usb-serial: fix regression in Visor/Palm OS module for
	kernels >= 2.6.24
Message-ID: <20080326023243.GA25564@enigma.swatter.net>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@suse.de>,
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes a bug/inconsistency revealed by the additional sanity checking in
   commit 063a2da8f01806906f7d7b1a1424b9afddebc443
introduced in the original 2.6.24 branch.

The Handspring Visor / PalmOS 4 device structure defines .num_bulk_out=2
but the usb-serial probe returns num_bulk_out=3, triggering the check in
the above commit and forcing a bail out when the device (a Garmin iQue in
my case) attempts to connect.  The patch bumps the expected number of
endpoints to 3.

I suppose it's possible that the kernel is identifying 3 bulk endpoints
when there should only be 2 and there is some issue with the lower level
endpoint probe?

FWIW, this patch will probably solve the following kernel bug report for
Treo users (identical symptoms, different model PalmOS units):
  <http://bugzilla.kernel.org/show_bug.cgi?id=10118>


Signed-off-by: Brad Sawatzky <brad+kernel@swatter.net>
---

--- drivers/usb/serial/visor.c.orig	2008-03-25 21:32:40.000000000 -0400
+++ drivers/usb/serial/visor.c	2008-03-25 21:29:57.000000000 -0400
@@ -191,7 +191,7 @@ static struct usb_serial_driver handspri
 	.id_table =		id_table,
 	.num_interrupt_in =	NUM_DONT_CARE,
 	.num_bulk_in =		2,
-	.num_bulk_out =		2,
+	.num_bulk_out =		3,
 	.num_ports =		2,
 	.open =			visor_open,
 	.close =		visor_close,
