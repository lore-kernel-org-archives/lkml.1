Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753398AbYLRAei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbYLRAei (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 19:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYLRAe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 19:34:28 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:29264 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbYLRAe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 19:34:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=YTlr6dBIY983Y6Lht5ttIB0+fNxqo79gT1cpZV7OVxzzp8IbH6mF8uwpjmJSDnCBGx
         LDlrsFh23j7LE6R5x/+q/wHoQet/h8M57uvmq7SqJaVyKdeNeTUdKdxMiJvcy0UOKe2+
         3bpdRDbQvy1oMBXJ9+5E/EnD6kAd0kqw/NkVE=
Message-ID: <76366b180812171634k6c5a25d6uad0de0d6c514ebb5@mail.gmail.com>
Date: Wed, 17 Dec 2008 19:34:26 -0500
From: "Andrew Paprocki" <andrew@ishiboo.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: i8k: fails to detect Dell XPS M1530, fails to get SMM BIOS version with force=1
Cc: dz@debian.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: e5b4d5bee3c5f3c6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see two problems with the i8k module and the Dell XPS M1530. First,
the laptop is not detected. Second, even if it is detected, the module
prints that it is unable to get the SMM BIOS version even though the
module appears to be working:

# modprobe i8k force=1
# dmesg | grep i8k
[  547.007217] i8k: not running on a supported Dell system.
[  547.007234] i8k: vendor=Dell Inc., model=XPS M1530
     , version=A08
[  547.007629] i8k: unable to get SMM BIOS version
# cat /proc/i8k
1.0 A08 5D26YF1 53 0 0 0 0 -1 -22

Information from DMI:

BIOS Information
        Vendor: Dell Inc.
        Version: A08
        Release Date: 03/19/2008

System Information
        Manufacturer: Dell Inc.
        Product Name: XPS M1530

It seems straightforward to add a record for the auto-detection, but
I'm not sure how generic it should be. From looking online, it appears
the M1330, M1530, and M1730 all need to be detected. Perhaps it should
just be "Dell XPS M Series" and only match on "XPS M"? Does anyone
else on the list use these laptops?

Thanks,
-Andrew

--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -485,6 +485,13 @@ static struct dmi_system_id __initdata i8k_dmi_table[] = {
                        DMI_MATCH(DMI_PRODUCT_NAME, "MP061"),
                },
        },
+       {
+               .ident = "Dell XPS M1530",
+               .matches = {
+                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+                       DMI_MATCH(DMI_PRODUCT_NAME, "XPS M1530"),
+               },
+       },
        { }
 };
