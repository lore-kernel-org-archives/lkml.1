Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbZBJNtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbZBJNtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 08:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754183AbZBJNtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 08:49:23 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:51485 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbZBJNtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 08:49:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rjI+jAzySgC6xz0t9FnGt5SlcmlHeOc1e+5Ar/ckJv6CbIS15pWp+Dt2+THqxDM3eP
         0vN+WySng+l0z1nU2TvYxAVurHpkoZUIR9tDO88DqdxeaiHQf9IIQnPnkS9ZXaZpN/no
         QRnMuYpsjnwZ2xegegdACVWmu9/f5UEMDFv7c=
MIME-Version: 1.0
Date: Tue, 10 Feb 2009 14:49:20 +0100
Message-ID: <56e1b5710902100549s67d02216k8101045e4247ab52@mail.gmail.com>
Subject: [PATCH]: Cleanup: Remove trivial gcc format string warnings when 
	compiling with -Wformat-security (part 3: verified code)
From: Floris Kraak <randakar@gmail.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>,
       Andreas Schwab <schwab@suse.de>, Mike Isely <isely@isely.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 2:26 PM, Floris Kraak <randakar@gmail.com> wrote:
> On Thu, Feb 5, 2009 at 3:41 PM, Floris Kraak <randakar@gmail.com> wrote:
>>
>> Here's the patch that I get when I blindly patch every single location
>> that emits this warning.
>>
>> If needed I can attempt to split this monster into 135 patches but
>> given my limited experience with the tools involved a little help on
>> how to go about creating such a series would be appreciated ;-)
>>
>
> Here's the first part of a split series of patches dealing with this.
> I will reply to this message with further patches in the series.
>

This patch contains changes that have been verified / acked by
responsible kernel devs.
Right now that list is limited to a single dev & driver - in this case
no bug beyond surpressing the warning is fixed.

---
[PATCH]: Cleanup: Remove trivial gcc format string warnings when
compiling with -Wformat-security (part 3: verified code)

When compiling the kernel with an allyesconfig and the gcc flags
-Wformat and -Wformat-security the build process emits ~150 warnings
along these lines:

init/main.c:557: warning: format not a string literal and no format arguments
init/initramfs.c:582: warning: format not a string literal and no
format arguments
arch/x86/kernel/dumpstack.c:115: warning: format not a string literal
and no format arguments
...

Many of these warnings are harmless - the format string is statically
set within the kernel itself and is known to not contain any format
qualifiers.
This patch contains changes to the pvrusb2 driver.

Signed-off-by: Floris Kraak <randakar@gmail.com>
Acked-by: Mike Isely <isely@pobox.com>
---
diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
index fa304e5..42ccab0 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
@@ -1967,7 +1967,7 @@ static void pvr2_hdw_setup_low(struct pvr2_hdw *hdw)
 	if (!pvr2_hdw_dev_ok(hdw)) return;

 	for (idx = 0; idx < hdw->hdw_desc->client_modules.cnt; idx++) {
-		request_module(hdw->hdw_desc->client_modules.lst[idx]);
+		request_module("%s", hdw->hdw_desc->client_modules.lst[idx]);
 	}

 	if (!hdw->hdw_desc->flag_no_powerup) {
diff --git a/drivers/media/video/pvrusb2/pvrusb2-std.c
b/drivers/media/video/pvrusb2/pvrusb2-std.c
index ca9f83a..c18091e 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-std.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-std.c
@@ -216,7 +216,7 @@ unsigned int pvr2_std_id_to_str(char *bufPtr,
unsigned int bufSize,
 			bufSize -= c2;
 			bufPtr += c2;
 			c2 = scnprintf(bufPtr,bufSize,
-				       ip->name);
+				       "%s", ip->name);
 			c1 += c2;
 			bufSize -= c2;
 			bufPtr += c2;

---
Regards,
Floris
---
"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."
  -- Ben Franklin

"The course of history shows that as a government grows, liberty
decreases."
  -- Thomas Jefferson
