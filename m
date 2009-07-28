Return-Path: <linux-kernel-owner+w=401wt.eu-S1755067AbZG1RnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbZG1RnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbZG1RnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:43:24 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:36811 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbZG1RnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:43:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=X1hLX2qC4qJuK+qros/gxdhgFpRzDssi+lbf/dKF9UQLJkpMqV26ORbz5jY88+TdSO
         kWWsjLLWi1V0KIx5np/MDhYU2I6V9PvST4yYIe9zNcsFnTHx96bNP110rzSRoaGIRNft
         cp/gWSUxJY13Bt2kQGa2WylvLtdXMjXyv12lI=
Message-ID: <4A6F3965.5030105@gmail.com>
Date: Tue, 28 Jul 2009 19:46:13 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: mingo@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: Buffer overflow
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the vendor name (from c16) can be longer than 100 bytes (or missing a
terminating null), then the null is writen past the end of vendor[].

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found with Parfait, http://research.sun.com/projects/parfait/

diff --git a/arch/x86/kernel/efi.c b/arch/x86/kernel/efi.c
index 96f7ac0..436a42f 100644
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -354,7 +354,7 @@ void __init efi_init(void)
 	 */
 	c16 = tmp = early_ioremap(efi.systab->fw_vendor, 2);
 	if (c16) {
-		for (i = 0; i < sizeof(vendor) && *c16; ++i)
+		for (i = 0; i < sizeof(vendor) - 1 && *c16; ++i)
 			vendor[i] = *c16++;
 		vendor[i] = '\0';
 	} else
