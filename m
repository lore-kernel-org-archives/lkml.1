Return-Path: <linux-kernel-owner+w=401wt.eu-S933591AbXBXX0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591AbXBXX0k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 18:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933594AbXBXX0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 18:26:39 -0500
Received: from mx6.mail.ru ([194.67.23.26]:32639 "EHLO mx6.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933591AbXBXX0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 18:26:38 -0500
X-Greylist: delayed 48690 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Feb 2007 18:26:37 EST
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.19: ACPI reports AC not present after resume from STD
Date: Sun, 25 Feb 2007 02:26:31 +0300
User-Agent: KMail/1.9.6
Cc: "Lebedev, Vladimir P" <vladimir.p.lebedev@intel.com>,
       "Karasyov, Konstantin A" <konstantin.a.karasyov@intel.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.osdl.org
References: <8E389A5F2FEABA4CB1DEC35A25CB39CE82FE9F@mssmsx411> <200702241255.02073.arvidjaar@mail.ru> <200702242046.20216.rjw@sisk.pl>
In-Reply-To: <200702242046.20216.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6047175.j0FXaUPr0m";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702250226.34877.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6047175.j0FXaUPr0m
Content-Type: multipart/mixed;
  boundary="Boundary-01=_qmM4FnGsQuJ13u5"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_qmM4FnGsQuJ13u5
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On =D0=A1=D1=83=D0=B1=D0=B1=D0=BE=D1=82=D0=B0 24 =D1=84=D0=B5=D0=B2=D1=80=
=D0=B0=D0=BB=D1=8F 2007, Rafael J. Wysocki wrote:
> Hi,
>
> On Saturday, 24 February 2007 10:55, Andrey Borzenkov wrote:
> > On =D0=92=D1=82=D0=BE=D1=80=D0=BD=D0=B8=D0=BA 13 =D1=84=D0=B5=D0=B2=D1=
=80=D0=B0=D0=BB=D1=8F 2007, Andrey Borzenkov wrote:
> > > On =D0=A7=D0=B5=D1=82=D0=B2=D0=B5=D1=80=D0=B3 07 =D0=B4=D0=B5=D0=BA=
=D0=B0=D0=B1=D1=80=D1=8F 2006, Lebedev, Vladimir P wrote:
> > > > Please register new bug, attach acpidump and dmesg.
> > >
> > > http://bugzilla.kernel.org/show_bug.cgi?id=3D7995
> > >
> > > regards
> >
> > Well, this starts looking like ACPI is not at fault.
> >
> > When reporting AC state ACPI just reads contents of system memory (I
> > presume it gets updated by BIOS/ACPI when AC state changes). It looks
> > like this memory area is restored during resume from STD. I updated
> > mentioned bug report with more detailed description. Now if someone cou=
ld
> > suggest a way to catch if specific physical address gets saved/restored
> > this would finally explain it.
>
> First, if you want the reserved memory areas to be left alone by swsusp,
> you need to mark them as 'nosave'.  On x86_64 this is done by the function
> e820_mark_nosave_range() in arch/x86_64/kernel/e820.c that can be ported =
to
> i386 with no problems.  However, we haven't found that very useful, so fa=
r,
> since no one has ever reported any problems with the current approach,
> which is to save and restore them.
>

Well, the following proof of concept patch fixes this issue for me. Please=
=20
notice that original version of e820_mark_nosave_range() could fail to=20
exclude some areas due to alignment issues (exactly what happened to me on=
=20
first try) so it still can explain your problem too.

=2Dandrey


--Boundary-01=_qmM4FnGsQuJ13u5
Content-Type: text/x-diff;
  charset="utf-8";
  name="nosave_reserved_memory"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="nosave_reserved_memory"

Mark e820 reserved memory areas as nosave for suspend/resume

=46rom: Andrey Borzenkov <<arvidjaar@mail.ru>>

This fixes bug http://bugzilla.kernel.org/show_bug.cgi?id=3D7995. From
lkml:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> When reporting AC state ACPI just reads contents of system memory (I
> presume
> it gets updated by BIOS/ACPI when AC state changes). It looks like this
> memory area is restored during resume from STD. I updated mentioned bug
> report with more detailed description. Now if someone could suggest a way
> to
> catch if specific physical address gets saved/restored this would finally
> explain it.

=46irst, if you want the reserved memory areas to be left alone by swsusp,
you need to mark them as 'nosave'.  On x86_64 this is done by the function
e820_mark_nosave_range() in arch/x86_64/kernel/e820.c that can be ported to
i386 with no problems.  However, we haven't found that very useful, so far,
since no one has ever reported any problems with the current approach,
which is to save and restore them.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

The patch adapts x84_64 version to mark as nosave all consequitive
areas. Otherwise in my case the region in question covered only partial
page and was excluded from nosave:

 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 00000000000eee00 (reserved)
 BIOS-e820: 00000000000eee00 - 00000000000ef000 (ACPI NVS)
 BIOS-e820: 00000000000ef000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001ef60000 (usable)
 BIOS-e820: 000000001ef60000 - 000000001ef70000 (ACPI data)
 BIOS-e820: 000000001ef70000 - 0000000020000000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)

The region in question starts at ee800.
=2D--

 arch/i386/kernel/e820.c  |   45 ++++++++++++++++++++++++++++++++++++++++++=
+++
 arch/i386/kernel/setup.c |    1 +
 include/asm-i386/e820.h  |    1 +
 3 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/arch/i386/kernel/e820.c b/arch/i386/kernel/e820.c
index f391abc..7c00ec7 100644
=2D-- a/arch/i386/kernel/e820.c
+++ b/arch/i386/kernel/e820.c
@@ -311,6 +311,51 @@ static int __init request_standard_resources(void)
=20
 subsys_initcall(request_standard_resources);
=20
+/* Mark pages corresponding to given pfn range as nosave */
+static void __init
+e820_mark_nosave_range(unsigned long start, unsigned long end)
+{
+	unsigned long pfn, max_pfn =3D PFN_DOWN(end);
+
+	if (start >=3D end)
+		return;
+
+	printk("Nosave address range: %016lx - %016lx\n", start, end);
+	for (pfn =3D PFN_UP(start); pfn < max_pfn; pfn++)
+		if (pfn_valid(pfn))
+			SetPageNosave(pfn_to_page(pfn));
+}
+
+/*
+ * Find the ranges of physical addresses that do not correspond to
+ * e820 RAM areas and mark the corresponding pages as nosave for software
+ * suspend and suspend to RAM.
+ *
+ * This assumes entries are sorted and all consequitive entries are
+ * excluded together with gaps.
+ */
+void __init e820_mark_nosave_regions(void)
+{
+	int i;
+	unsigned long pstart =3D 0L;
+	unsigned long pend =3D 0L;
+
+	for (i =3D 0; i < e820.nr_map; i++) {
+		struct e820entry *ei =3D &e820.map[i];
+
+		if (ei->type !=3D E820_RAM) {
+			if (!pstart)
+				pstart =3D ei->addr;
+			if (pend < ei->addr + ei->size)
+				pend =3D ei->addr + ei->size;
+		} else {
+			e820_mark_nosave_range(pstart, pend);
+			pstart =3D pend =3D 0L;
+		}
+	}
+	e820_mark_nosave_range(pstart, pend);
+}
+
 void __init add_memory_region(unsigned long long start,
 			      unsigned long long size, int type)
 {
diff --git a/arch/i386/kernel/setup.c b/arch/i386/kernel/setup.c
index 4b31ad7..4f43e46 100644
=2D-- a/arch/i386/kernel/setup.c
+++ b/arch/i386/kernel/setup.c
@@ -640,6 +640,7 @@ void __init setup_arch(char **cmdline_p)
 #endif
=20
 	e820_register_memory();
+	e820_mark_nosave_regions();
=20
 #ifdef CONFIG_VT
 #if defined(CONFIG_VGA_CONSOLE)
diff --git a/include/asm-i386/e820.h b/include/asm-i386/e820.h
index c5b8fc6..80e49bc 100644
=2D-- a/include/asm-i386/e820.h
+++ b/include/asm-i386/e820.h
@@ -43,6 +43,7 @@ extern void register_bootmem_low_pages(unsigned long max_=
low_pfn);
 extern void e820_register_memory(void);
 extern void limit_regions(unsigned long long size);
 extern void print_memory_map(char *who);
+extern void e820_mark_nosave_regions(void);
=20
 #endif/*!__ASSEMBLY__*/
=20

--Boundary-01=_qmM4FnGsQuJ13u5--

--nextPart6047175.j0FXaUPr0m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF4MmqR6LMutpd94wRAu/KAKCWFrdVu7OM47g4YsBBIkGQHAiCNACfe56L
CHZD9jU1b7X8HwaO7xkyIW4=
=h6M0
-----END PGP SIGNATURE-----

--nextPart6047175.j0FXaUPr0m--
