Return-Path: <linux-kernel-owner+w=401wt.eu-S933921AbXDATi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933921AbXDATi3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 15:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933925AbXDATi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 15:38:29 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52189 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933921AbXDATi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 15:38:27 -0400
Message-ID: <46100A43.9040001@us.ibm.com>
Date: Sun, 01 Apr 2007 14:38:43 -0500
From: "Steve French (smfltc)" <smfltc@us.ibm.com>
User-Agent: Mozilla Thunderbird 1.0 (Windows/20041206)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: RE: cifs causes BUG: soft lockup detected on CPU
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Valentin Zaharov"  wrote on 04/01/2007 03:02:07 AM:
 > Hi again,
 >
 > After applying changes manually to 2.6.20.4 according to the link that
 > Steven sent I still get those errors (attached below) but no crash so
 > far.
 > I am wondering if its ok or having errors still will cause freezes.
It is ok and I see no indication of lookup. You have two errors logged:
a) a missing entry in the kernel translation table for your default
codepage to UCS-16 (Unicode).
    "char2uni returned -22"  (EINVAL, presumably due to a missing character)
b) some access denied (-13) warnings on cifs_get_info_info (lookup).
This is probably harmless.

We could isolate the failing character by modifying the error log entry
but you may be able to guess at the problem by seeing which filenames
are requested with '?' in it ('?' is used when translation to Unicode
fails)

We could probably isolate the missing character by checking what
is logged to dmesag after this minor modification to the warning
message (we would also need to know which nls codepage
you are running).

diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index d2a8b29..793c4b9 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -74,8 +74,8 @@ cifs_strtoUCS(__le16 * to, const char *f
         charlen = codepage->char2uni(from, len, &wchar_to[i]);
         if (charlen < 1) {
             cERROR(1,
-                   ("cifs_strtoUCS: char2uni returned %d",
-                charlen));
+                   ("strtoUCS: char2uni of %d returned %d",
+                (int)*from, charlen));
             /* A question mark */
             to[i] = cpu_to_le16(0x003f);
             charlen = 1;



 > Thanks in advance,
 >
 > Apr  1 04:23:49 UFR2 kernel:  CIFS VFS: cifs_strtoUCS: char2uni returned
 > -22
 > Apr  1 04:37:14 UFR2 last message repeated 30 times
 > Apr  1 04:38:53 UFR2 last message repeated 10 times
 > Apr  1 04:40:33 UFR2 last message repeated 10 times
 > Apr  1 04:45:31 UFR2 last message repeated 10 times
 > Apr  1 04:47:11 UFR2 last message repeated 10 times
 > Apr  1 05:00:32 UFR2 last message repeated 10 times
 > Apr  1 05:07:21 UFR2 last message repeated 10 times
 > Apr  1 05:21:50 UFR2 last message repeated 10 times
 > Apr  1 05:23:29 UFR2 last message repeated 10 times
 > Apr  1 05:29:07 UFR2 last message repeated 10 times
 > Apr  1 05:30:58 UFR2 last message repeated 10 times
 > Apr  1 05:30:58 UFR2 last message repeated 9 times
 > Apr  1 05:55:33 UFR2 kernel:  CIFS VFS: Error 0xfffffff3 on
 > cifs_get_inode_info in lookup of \nv322657
 > Apr  1 05:55:33 UFR2 kernel:  CIFS VFS: Error 0xfffffff3 on
 > cifs_get_inode_info in lookup of \nv322657
 > Apr  1 06:28:41 UFR2 kernel:  CIFS VFS: cifs_strtoUCS: char2uni returned
 > -22
 > Apr  1 07:24:36 UFR2 last message repeated 10 times
 > Apr  1 07:26:29 UFR2 last message repeated 10 times
 > Apr  1 07:28:17 UFR2 last message repeated 10 times
 > Apr  1 07:30:09 UFR2 last message repeated 10 times
 > Apr  1 07:35:45 UFR2 last message repeated 10 times
 > Apr  1 07:44:46 UFR2 last message repeated 10 times
 > Apr  1 08:23:10 UFR2 last message repeated 10 times
 > Apr  1 08:24:52 UFR2 last message repeated 10 times
 > Apr  1 10:04:37 UFR2 last message repeated 10 times
 > Apr  1 10:04:37 UFR2 last message repeated 8 times
 > Apr  1 10:36:17 UFR2 kernel:  CIFS VFS: Error 0xfffffff3 on
 > cifs_get_inode_info in lookup of \nv322657
 > Apr  1 10:36:18 UFR2 last message repeated 4 times
 > Apr  1 10:38:19 UFR2 kernel:  CIFS VFS: cifs_strtoUCS: char2uni returned
 > -22
 >
 >
 > Valentin Zaharov
 >
 > System Department
 >
 > NetVision Ltd.
