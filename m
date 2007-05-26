Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbXEZGdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbXEZGdP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 02:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbXEZGdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 02:33:04 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:50398 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbXEZGdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 02:33:01 -0400
Subject: [PATCH} x86_64 PM_TRACE support.
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Randy Dunlap <rdunlap@xenotime.net>, Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Richard Hughes <hughsient@gmail.com>,
       Julian Sikorski <belegdol@gmail.com>, Andi Kleen <ak@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-orcWcV1xcjkSsnEQvCYW"
Date: Sat, 26 May 2007 16:32:54 +1000
Message-Id: <1180161174.9773.60.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-orcWcV1xcjkSsnEQvCYW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi all.

As promised I took another look at the patch and at what Randy had
prepared to fix the IA64 compilation error. I did some more work on it,
and believe that the following is the tidiest correct solution I can
come up with. It differs from the version that caused the compilation
error primarily in that:

* the #include <asm/resume-trace.h> is inside the #ifdef=20
  CONFIG_PM_TRACE.
* now-unnecessary protection for multiple #includes and ifdef testing of
  CONFIG_PM_TRACE in the asm code were removed.
* do-nothing definitions for !PM_TRACE restored to
  include/linux/resume-trace.h.

We're therefore depending upon kernel/power/Kconfig having the right
depends condition. As far as I can see, IA64 doesn't define CONFIG_X86.
Is that correct, or do we need to have (X86 && !IA64)?

Randy, since this is substantially different to the work you did, I
haven't added your signed-off-by as we previously discussed.

Signed-off-by: Nigel Cunningham <nigel@nigel.suspend2.net>
CC: Randy Dunlap <rdunlap@xenotime.net>
CC: Andi Kleen <ak@suse.de>

 arch/x86_64/kernel/vmlinux.lds.S  |    7 +++++++
 drivers/base/power/trace.c        |    5 ++++-
 include/asm-i386/resume-trace.h   |   13 +++++++++++++
 include/asm-x86_64/resume-trace.h |   13 +++++++++++++
 include/linux/resume-trace.h      |   19 +++++--------------
 kernel/power/Kconfig              |    2 +-
 6 files changed, 43 insertions(+), 16 deletions(-)
diff -ruNp 200.patch-old/arch/x86_64/kernel/vmlinux.lds.S 200.patch-new/arc=
h/x86_64/kernel/vmlinux.lds.S
--- 200.patch-old/arch/x86_64/kernel/vmlinux.lds.S	2007-05-26 14:18:22.0000=
00000 +1000
+++ 200.patch-new/arch/x86_64/kernel/vmlinux.lds.S	2007-05-26 14:23:52.0000=
00000 +1000
@@ -52,6 +52,13 @@ SECTIONS
=20
   RODATA
=20
+  . =3D ALIGN(4);
+  .tracedata : AT(ADDR(.tracedata) - LOAD_OFFSET) {
+  	__tracedata_start =3D .;
+	*(.tracedata)
+  	__tracedata_end =3D .;
+  }
+
   . =3D ALIGN(PAGE_SIZE);        /* Align data segment to page size bounda=
ry */
 				/* Data */
   .data : AT(ADDR(.data) - LOAD_OFFSET) {
diff -ruNp 200.patch-old/drivers/base/power/trace.c 200.patch-new/drivers/b=
ase/power/trace.c
--- 200.patch-old/drivers/base/power/trace.c	2007-05-26 14:18:23.000000000 =
+1000
+++ 200.patch-new/drivers/base/power/trace.c	2007-05-26 14:23:52.000000000 =
+1000
@@ -142,6 +142,7 @@ void set_trace_device(struct device *dev
 {
 	dev_hash_value =3D hash_string(DEVSEED, dev->bus_id, DEVHASH);
 }
+EXPORT_SYMBOL(set_trace_device);
=20
 /*
  * We could just take the "tracedata" index into the .tracedata
@@ -162,6 +163,7 @@ void generate_resume_trace(void *traceda
 	file_hash_value =3D hash_string(lineno, file, FILEHASH);
 	set_magic_time(user_hash_value, file_hash_value, dev_hash_value);
 }
+EXPORT_SYMBOL(generate_resume_trace);
=20
 extern char __tracedata_start, __tracedata_end;
 static int show_file_hash(unsigned int value)
@@ -170,7 +172,8 @@ static int show_file_hash(unsigned int v
 	char *tracedata;
=20
 	match =3D 0;
-	for (tracedata =3D &__tracedata_start ; tracedata < &__tracedata_end ; tr=
acedata +=3D 6) {
+	for (tracedata =3D &__tracedata_start ; tracedata < &__tracedata_end ;
+			tracedata +=3D 2 + sizeof(unsigned long)) {
 		unsigned short lineno =3D *(unsigned short *)tracedata;
 		const char *file =3D *(const char **)(tracedata + 2);
 		unsigned int hash =3D hash_string(lineno, file, FILEHASH);
diff -ruNp 200.patch-old/include/asm-i386/resume-trace.h 200.patch-new/incl=
ude/asm-i386/resume-trace.h
--- 200.patch-old/include/asm-i386/resume-trace.h	1970-01-01 10:00:00.00000=
0000 +1000
+++ 200.patch-new/include/asm-i386/resume-trace.h	2007-05-26 16:07:31.00000=
0000 +1000
@@ -0,0 +1,13 @@
+#define TRACE_RESUME(user) do {					\
+	if (pm_trace_enabled) {					\
+		void *tracedata;				\
+		asm volatile("movl $1f,%0\n"			\
+			".section .tracedata,\"a\"\n"		\
+			"1:\t.word %c1\n"			\
+			"\t.long %c2\n"				\
+			".previous"				\
+			:"=3Dr" (tracedata)			\
+			: "i" (__LINE__), "i" (__FILE__));	\
+		generate_resume_trace(tracedata, user);		\
+	}							\
+} while (0)
diff -ruNp 200.patch-old/include/asm-x86_64/resume-trace.h 200.patch-new/in=
clude/asm-x86_64/resume-trace.h
--- 200.patch-old/include/asm-x86_64/resume-trace.h	1970-01-01 10:00:00.000=
000000 +1000
+++ 200.patch-new/include/asm-x86_64/resume-trace.h	2007-05-26 16:07:27.000=
000000 +1000
@@ -0,0 +1,13 @@
+#define TRACE_RESUME(user) do {					\
+	if (pm_trace_enabled) {					\
+		void *tracedata;				\
+		asm volatile("movq $1f,%0\n"			\
+			".section .tracedata,\"a\"\n"		\
+			"1:\t.word %c1\n"			\
+			"\t.quad %c2\n"				\
+			".previous"				\
+			:"=3Dr" (tracedata)			\
+			: "i" (__LINE__), "i" (__FILE__));	\
+		generate_resume_trace(tracedata, user);		\
+	}							\
+} while (0)
diff -ruNp 200.patch-old/include/linux/resume-trace.h 200.patch-new/include=
/linux/resume-trace.h
--- 200.patch-old/include/linux/resume-trace.h	2007-05-26 14:18:47.00000000=
0 +1000
+++ 200.patch-new/include/linux/resume-trace.h	2007-05-26 16:17:43.00000000=
0 +1000
@@ -2,6 +2,7 @@
 #define RESUME_TRACE_H
=20
 #ifdef CONFIG_PM_TRACE
+#include <asm/resume-trace.h>
=20
 extern int pm_trace_enabled;
=20
@@ -9,20 +10,10 @@ struct device;
 extern void set_trace_device(struct device *);
 extern void generate_resume_trace(void *tracedata, unsigned int user);
=20
-#define TRACE_DEVICE(dev) set_trace_device(dev)
-#define TRACE_RESUME(user) do {					\
-	if (pm_trace_enabled) {					\
-		void *tracedata;				\
-		asm volatile("movl $1f,%0\n"			\
-			".section .tracedata,\"a\"\n"		\
-			"1:\t.word %c1\n"			\
-			"\t.long %c2\n"				\
-			".previous"				\
-			:"=3Dr" (tracedata)			\
-			: "i" (__LINE__), "i" (__FILE__));	\
-		generate_resume_trace(tracedata, user);		\
-	}							\
-} while (0)
+#define TRACE_DEVICE(dev) do { \
+	if (pm_trace_enabled) \
+		set_trace_device(dev); \
+	} while(0)
=20
 #else
=20
diff -ruNp 200.patch-old/kernel/power/Kconfig 200.patch-new/kernel/power/Kc=
onfig
--- 200.patch-old/kernel/power/Kconfig	2007-05-26 14:18:48.000000000 +1000
+++ 200.patch-new/kernel/power/Kconfig	2007-05-26 14:23:52.000000000 +1000
@@ -50,7 +50,7 @@ config DISABLE_CONSOLE_SUSPEND
=20
 config PM_TRACE
 	bool "Suspend/resume event tracing"
-	depends on PM && PM_DEBUG && X86_32 && EXPERIMENTAL
+	depends on PM && PM_DEBUG && X86 && EXPERIMENTAL
 	default n
 	---help---
 	This enables some cheesy code to save the last PM event point in the


--=-orcWcV1xcjkSsnEQvCYW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGV9SWN0y+n1M3mo0RAkyDAKDAigaRkHnG18Avrh2lrRt7+eNrBwCgxKdk
y8MQLV9kENFhaSHC43heJoA=
=4S27
-----END PGP SIGNATURE-----

--=-orcWcV1xcjkSsnEQvCYW--

