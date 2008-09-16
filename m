Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbYIPUsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbYIPUsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 16:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbYIPUsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 16:48:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54573 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbYIPUsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 16:48:36 -0400
Message-ID: <48D01B99.3040908@zytor.com>
Date: Tue, 16 Sep 2008 13:48:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Randy.Dunlap" <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: linux-next: Tree for September 16 (cpustr.h)
References: <20080916173415.14012569.sfr@canb.auug.org.au> <Pine.LNX.4.64.0809161147320.32267@shark.he.net>
In-Reply-To: <Pine.LNX.4.64.0809161147320.32267@shark.he.net>
Content-Type: multipart/mixed;
 boundary="------------080403040706010902000800"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080403040706010902000800
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Randy.Dunlap wrote:
> I'm seeing lots of gcc warnings from the generated cpustr.h file, like so:
> 
>   arch/x86/boot/mkcpustr > arch/x86/boot/cpustr.h
>   gcc -Wp,-MD,arch/x86/boot/.cpu.o.d  -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.1.1/include -D__KERNEL__ -Iinclude -Iinclude2 -I/home/rdunlap/linsrc/linux-next-20080916/include -I/home/rdunlap/linsrc/linux-next-20080916/arch/x86/include -include include/linux/autoconf.h -I/home/rdunlap/linsrc/linux-next-20080916/arch/x86/boot -Iarch/x86/boot -I/home/rdunlap/linsrc/linux-next-20080916/include -Iinclude -I/home/rdunlap/linsrc/linux-next-20080916/include2 -Iinclude2  -I/home/rdunlap/linsrc/linux-next-20080916/include  -I/home/rdunlap/linsrc/linux-next-20080916/arch/x86/include -include include/linux/autoconf.h -g -Os -D_SETUP -D__KERNEL__ -Wall -Wstrict-prototypes -march=i386 -mregparm=3 -include /home/rdunlap/linsrc/linux-next-20080916/arch/x86/boot/code16gcc.h -fno-strict-aliasing -fomit-frame-pointer -ffreestanding -fno-unit-at-a-time -fno-stack-protector -mpreferred-stack-boundary=2 -m32 -D__BIG_KERNEL__  -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(cpu)"
  -D"KBUILD_MODNAME=KBUILD_STR(cpu)" -D"DEBUG_HASH=3" -D"DEBUG_HASH2=23" -c -o arch/x86/boot/cpu.o /home/rdunlap/linsrc/linux-next-20080916/arch/x86/boot/cpu.c
> cc1: warning: hex escape sequence out of range
> 
> 
> The ending lines of cpustr.h include hex strings like "\x111".
> gcc complains about these.  If I change them to "\x011" (e.g.), there
> is no warning.
> 

Yes, there is a patch that adds a 9th cpuflags word, which this code 
doesn't handle.  The warning is real, there is an #error in mkcpustr.c 
which is supposed to trigger, but doesn't because of a typo:

#if NCAPFLAGS > 8
# error "Need to adjust the boot code handling of CPUID strings"
#endif

(The actual variable is called NCAPINTS.)

Attached is a completely untested patch for this problem.

	-hpa

--------------080403040706010902000800
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff"

diff --git a/arch/x86/boot/cpu.c b/arch/x86/boot/cpu.c
index 75298fe..6ec6bb6 100644
--- a/arch/x86/boot/cpu.c
+++ b/arch/x86/boot/cpu.c
@@ -59,17 +59,18 @@ int validate_cpu(void)
 			u32 e = err_flags[i];
 
 			for (j = 0; j < 32; j++) {
-				int n = (i << 5)+j;
-				if (*msg_strs < n) {
+				if (msg_strs[0] < i ||
+				    (msg_strs[0] == i && msg_strs[1] < j)) {
 					/* Skip to the next string */
-					do {
-						msg_strs++;
-					} while (*msg_strs);
-					msg_strs++;
+					msg_strs += 2;
+					while (*msg_strs++)
+						;
 				}
 				if (e & 1) {
-					if (*msg_strs == n && msg_strs[1])
-						printf("%s ", msg_strs+1);
+					if (msg_strs[0] == i &&
+					    msg_strs[1] == j &&
+					    msg_strs[2])
+						printf("%s ", msg_strs+2);
 					else
 						printf("%d:%d ", i, j);
 				}
diff --git a/arch/x86/boot/mkcpustr.c b/arch/x86/boot/mkcpustr.c
index 4589caa..8ef60f2 100644
--- a/arch/x86/boot/mkcpustr.c
+++ b/arch/x86/boot/mkcpustr.c
@@ -17,31 +17,31 @@
 
 #include "../kernel/cpu/capflags.c"
 
-#if NCAPFLAGS > 8
-# error "Need to adjust the boot code handling of CPUID strings"
-#endif
-
 int main(void)
 {
-	int i;
+	int i, j;
 	const char *str;
 
 	printf("static const char x86_cap_strs[] = \n");
 
-	for (i = 0; i < NCAPINTS*32; i++) {
-		str = x86_cap_flags[i];
-
-		if (i == NCAPINTS*32-1) {
-			/* The last entry must be unconditional; this
-			   also consumes the compiler-added null character */
-			if (!str)
-				str = "";
-			printf("\t\"\\x%02x\"\"%s\"\n", i, str);
-		} else if (str) {
-			printf("#if REQUIRED_MASK%d & (1 << %d)\n"
-			       "\t\"\\x%02x\"\"%s\\0\"\n"
-			       "#endif\n",
-			       i >> 5, i & 31, i, str);
+	for (i = 0; i < NCAPINTS; i++) {
+		for (j = 0; j < 32; j++) {
+			str = x86_cap_flags[i*32+j];
+
+			if (i == NCAPINTS-1 && j == 31) {
+				/* The last entry must be unconditional; this
+				   also consumes the compiler-added null
+				   character */
+				if (!str)
+					str = "";
+				printf("\t\"\\x%02x\\x%02x\"\"%s\"\n",
+				       i, j, str);
+			} else if (str) {
+				printf("#if REQUIRED_MASK%d & (1 << %d)\n"
+				       "\t\"\\x%02x\\x%02x\"\"%s\\0\"\n"
+				       "#endif\n",
+				       i, j, i, j, str);
+			}
 		}
 	}
 	printf("\t;\n");

--------------080403040706010902000800--
