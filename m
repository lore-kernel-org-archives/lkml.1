Return-Path: <linux-kernel-owner+w=401wt.eu-S1753752AbXLCROR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbXLCROR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 12:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbXLCROF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 12:14:05 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:27769 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbXLCROC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 12:14:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=X/DSsMBCy0ocJJ+8ihtZkOE9WL21PaaltsKpB8sD81SPxYokrdAcnrWvjsv1CvcB8G8ntSq51cQttY7Tv1sc/8DhIpEKE6r6I7fI8I2lJCllbxYwJeULWRnEXH2/2Jcxn2XShxSguyUc9S6RnJ9LIpANLTCTa67BeLdhIoSsBhE=
Message-ID: <808c8e9d0712030914x513c95b8r9daa4e97ada97511@mail.gmail.com>
Date: Mon, 3 Dec 2007 11:14:01 -0600
From: "Ben Gardner" <gardner.ben@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] gpio_cs5535: disable AUX on output
Cc: "Andrew Morton" <akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AMD CS5535/CS5536 GPIO has two alternate output modes: AUX-1 and AUX-2.
When either AUX is enabled, the cs5535_gpio driver cannot control the output.

Some BIOS code for the Geode processor enables AUX-1 for GPIO-1, which
configures it as the PC BEEP output.

This patch will disable AUX-1 and AUX-2 when the user enables output.

Signed-of-by: Ben Gardner <gardner.ben@gmail.com>

--- linux-2.6.23.1.orig/drivers/char/cs5535_gpio.c	2007-10-12
11:43:44.000000000 -0500
+++ linux-2.6.23.1/drivers/char/cs5535_gpio.c	2007-12-03
09:25:49.000000000 -0600
@@ -104,6 +104,11 @@
 		for (j = 0; j < ARRAY_SIZE(rm); j++) {
 			if (c == rm[j].on) {
 				outl(m1, base + rm[j].wr_offset);
+				/* If enabling output, turn off AUX 1 and AUX 2 */
+				if (c == 'O') {
+					outl(m0, base + 0x10);
+					outl(m0, base + 0x14);
+				}
 				break;
 			} else if (c == rm[j].off) {
 				outl(m0, base + rm[j].wr_offset);
