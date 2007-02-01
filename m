Return-Path: <linux-kernel-owner+w=401wt.eu-S1423023AbXBAV3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423023AbXBAV3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 16:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423024AbXBAV3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 16:29:37 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:48685 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423023AbXBAV3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 16:29:37 -0500
Date: Thu, 1 Feb 2007 22:28:07 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, Jon Masters <jonathan@jonmasters.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [m-i-t part] Ban module license tag string termination trick
In-Reply-To: <Pine.LNX.4.61.0702012147470.1862@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0702012225240.30766@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0611011204140.23977@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0702012147470.1862@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ccs, hello list,



The m-i-t list subscription is foobared today, so no Cc. To compensate,
Jon has been Cced.


jengelh wrote:
>
>Proposed patch to prohibit loading modules that use early C string 
>termination ("GPL\0 for nothing, folks!") to trick the kernel believing 
>it is loading a GPL driver.
>[...]
>To work against this problem, we must store the length of the actual 
>string as the compiler knows it. This will become really cumbersome if 
>implemented as a new tag inside the modinfo section. Hence I chose the 
>way of adding a new section called ".modlicense". The length of the new 
>section's header will automatically be the string length [including 
>trailing NUL]. The module loading code then just has to compare the 
>section length with the string length as returned by strlen().
>[...]
>A separate patch is required for module-init-tools (m-i-t) to make the 
>"modinfo" userspace utility understand the new modlicense section. I do 
>not think the world will explode if someone runs an unpatched m-i-t with 
>a patched kernel.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

# modlicense-MIT.diff
Index: module-init-tools-3.2.2/modinfo.c
===================================================================
--- module-init-tools-3.2.2.orig/modinfo.c
+++ module-init-tools-3.2.2/modinfo.c
@@ -376,12 +376,22 @@ int main(int argc, char *argv[])
 		}
 
 		info = get_section(mod, modulesize, &infosize, ".modinfo");
-		if (!info)
-			continue;
-		if (field)
-			print_tag(field, info, infosize, filename, sep);
-		else
-			print_all(info, infosize, filename, sep);
+		if (info) {
+			if (field)
+				print_tag(field, info, infosize, filename, sep);
+			else
+				print_all(info, infosize, filename, sep);
+		}
+
+		info = get_section(mod, modulesize, &infosize, ".modlicense");
+		if(info != NULL && strnlen(info, infosize) + 1 == infosize) {
+			if(field != NULL && streq(field, "license"))
+				printf("%s%c", (const char *)info, sep);
+			else
+				printf("%-16s%s%c", "license:",
+				       (const char *)info, sep);
+		}
+
 		free(filename);
 	}
 	return ret;
#<EOF>
