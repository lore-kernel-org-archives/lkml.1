Return-Path: <linux-kernel-owner+w=401wt.eu-S1759573AbYATAqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573AbYATAqH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 19:46:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbYATApz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 19:45:55 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:33651 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbYATApz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 19:45:55 -0500
Date: Sat, 19 Jan 2008 18:44:39 -0600
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 1/2] W1: w1_therm.c ds18b20 decode freezing temperatures correctly
Message-ID: <20080120004439.GA3715@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Sat, 19 Jan 2008 18:44:41 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit c4ad974f3acef11e538e825ca0cb73be6faf2461
Author: David Fries <david@fries.net>
Date:   Sun Nov 4 18:14:21 2007 -0600

Corrected the decoding of negative C temperatures. The code did a binary
OR of two bytes to make a 16 bit value, but assignd it to an integer.
This caused the value to not be sign extended and to loose that it was a
negative number in the assignment.
Before the patch (in my freezer),
w1_slave
ed fe 4b 46 7f ff 03 10 e4 : crc=e4 YES
ed fe 4b 46 7f ff 03 10 e4 t=4078
With the patch,
e3 fe 4b 46 7f ff 0d 10 81 : crc=81 YES
e3 fe 4b 46 7f ff 0d 10 81 t=-17

diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
index 4318935..feed89e 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -112,7 +112,7 @@ static struct w1_therm_family_converter w1_therm_families[] = {
 
 static inline int w1_DS18B20_convert_temp(u8 rom[9])
 {
-	int t = (rom[1] << 8) | rom[0];
+	s16 t = (rom[1] << 8) | rom[0];
 	t /= 16;
 	return t;
 }

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
