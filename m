Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbZGWPq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbZGWPq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 11:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbZGWPq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 11:46:27 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:36828 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbZGWPq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 11:46:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=x34ij0xjKAP7XXO+XAY8Kw8AbPOJyZVswZHAUmOyKe5/pFr+FE14JbXMed1tIJi0Nm
         PvUpKntbYrgH1zOVEbGfTbI5lh+/G0noIbITN0gC2eA0jfbPDnJTJIlUttPaNSDAEvpB
         YNQMtaXRo4TIK7JEyDwbUteXckVAU6HLGSxj0=
Message-ID: <4A688661.9040506@gmail.com>
Date: Thu, 23 Jul 2009 17:48:49 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] smbfs: Read buffer overflow
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function uses signed integers for the unix_date and local variables - if a
negative number is supplied and the leap-year condition is not met, month
will be 0, leading to a read of day_n[-1]

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
This is the easiest way to prevent the buffer overflow, but it produces a date.
Maybe a magic date would be better? What should we choose?

Credits to Parfait and Nathan Keynes,

diff --git a/fs/smbfs/proc.c b/fs/smbfs/proc.c
index 9468168..71c29b6 100644
--- a/fs/smbfs/proc.c
+++ b/fs/smbfs/proc.c
@@ -509,7 +509,7 @@ date_unix2dos(struct smb_sb_info *server,
 		month = 2;
 	} else {
 		nl_day = (year & 3) || day <= 59 ? day : day - 1;
-		for (month = 0; month < 12; month++)
+		for (month = 1; month < 12; month++)
 			if (day_n[month] > nl_day)
 				break;
 	}
