Return-Path: <linux-kernel-owner+w=401wt.eu-S1752581AbXI0Lt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbXI0Lt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 07:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbXI0LtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 07:49:18 -0400
Received: from web51411.mail.re2.yahoo.com ([206.190.39.152]:46171 "HELO
	web51411.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755860AbXI0LtR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 07:49:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=hjDOh+g2X0+5VziOKDjZHaMwp0Vgq7Fov7y+XXszxs6brWu8v/pxQrwOmQ5I9uPsTLG/W3Uwx8Rw23b/L17BJrD8LYdy5/JnQuSqqppyNOzB8vLUcGVTsC21gihHmJ4jzJLyDvLqkCmt+WdXqC65SBBhpfCXNDd59udzHmFK994=;
X-YMail-OSG: GzNdhZIVM1kmSWN2aD.DpragDo_R.J.FROMsgDI0ignByssHARAw3HODqlnnF_cafgc_dLkmzulT4A2hbRylZKE2Ms44zqgQj0HqK_hGFzWxLwo8j21qzmmo.v1_Kg--
X-Mailer: YahooMailRC/651.50 YahooMailWebService/0.7.134
Date: Thu, 27 Sep 2007 04:49:15 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Re: [GIT PULL] Workaround for broken Geode E820 BIOS
To: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jordan Crouse <jordan.crouse@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <744806.44748.qm@web51411.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I just tried 2.6.23-rc8 with the patch applied. Works fine here, so my very first

Acked-by: Joerg Pommnitz <pommnitz@yahoo.com>

for whatever it's worth, since it is already in Linus' tree.

Thanks to  Peter and Jordan  for  taking the interest and time to track
this one down and fix it. 

--  
Regards
 
       Joerg
 


----- Ursprüngliche Mail ----
Von: H. Peter Anvin <hpa@zytor.com>
An: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>; Jordan Crouse <jordan.crouse@amd.com>; Joerg Pommnitz <pommnitz@yahoo.com>
Gesendet: Donnerstag, den 27. September 2007, 00:27:20 Uhr
Betreff: [GIT PULL] Workaround for broken Geode E820 BIOS

Hi Linus,

Please pull:

  git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git for-linus

H. Peter Anvin (1):
      [x86 setup] Handle case of improperly terminated E820 chain

 arch/i386/boot/memory.c |   30 +++++++++++++++++++++++-------
 1 files changed, 23 insertions(+), 7 deletions(-)

[Log messages and full diffs follow]

commit 2efa33f81ef56e7700c09a3d8a881c96692149e5
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Wed Sep 26 14:11:43 2007 -0700

    [x86 setup] Handle case of improperly terminated E820 chain
    
    At least one system (a Geode system with a Digital Logic BIOS) has
    been found which suddenly stops reporting the SMAP signature when
    reading the E820 memory chain.  We can't know what, exactly, broke in
    the BIOS, so if we detect this situation, declare the E820 data
    unusable and fall back to E801.
    
    Also, revert to original behavior of always probing all memory
    methods; that way all the memory information is available to the
    kernel.
    
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>
    Cc: Jordan Crouse <jordan.crouse@amd.com>
    Cc: Joerg Pommnitz <pommnitz@yahoo.com>

diff --git a/arch/i386/boot/memory.c b/arch/i386/boot/memory.c
index 1a2e62d..bccaa1c 100644
--- a/arch/i386/boot/memory.c
+++ b/arch/i386/boot/memory.c
@@ -20,6 +20,7 @@
 
 static int detect_memory_e820(void)
 {
+    int count = 0;
     u32 next = 0;
     u32 size, id;
     u8 err;
@@ -33,14 +34,24 @@ static int detect_memory_e820(void)
               "=m" (*desc)
             : "D" (desc), "a" (0xe820));
 
-        if (err || id != SMAP)
+        /* Some BIOSes stop returning SMAP in the middle of
+           the search loop.  We don't know exactly how the BIOS
+           screwed up the map at that point, we might have a
+           partial map, the full map, or complete garbage, so
+           just return failure. */
+        if (id != SMAP) {
+            count = 0;
             break;
+        }
 
-        boot_params.e820_entries++;
+        if (err)
+            break;
+
+        count++;
         desc++;
-    } while (next && boot_params.e820_entries < E820MAX);
+    } while (next && count < E820MAX);
 
-    return boot_params.e820_entries;
+    return boot_params.e820_entries = count;
 }
 
 static int detect_memory_e801(void)
@@ -89,11 +100,16 @@ static int detect_memory_88(void)
 
 int detect_memory(void)
 {
+    int err = -1;
+
     if (detect_memory_e820() > 0)
-        return 0;
+        err = 0;
 
     if (!detect_memory_e801())
-        return 0;
+        err = 0;
+
+    if (!detect_memory_88())
+        err = 0;
 
-    return detect_memory_88();
+    return err;
 }






      Die etwas anderen Infos rund um das Thema Reisen. BE A BETTER WELTENBUMMLER!  www.yahoo.de/clever
