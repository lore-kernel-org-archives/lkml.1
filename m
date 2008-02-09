Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790AbYBIMTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbYBIMTQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 07:19:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbYBIMS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 07:18:59 -0500
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:50044 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189AbYBIMS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 07:18:58 -0500
From: Prakash Punnoor <prakash@punnoor.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Replace nvidia timer override quirk with pci id list
Date: Sat, 9 Feb 2008 13:18:52 +0100
User-Agent: KMail/1.9.7
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, lenb@kernel.org,
       linux-kernel@vger.kernel.org
References: <20080207195519.GA21772@basil.nowhere.org> <200802090008.05430.prakash@punnoor.de> <alpine.LFD.1.00.0802091140170.3145@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0802091140170.3145@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2111665.n0YeBMxahX";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200802091318.53249.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2111665.n0YeBMxahX
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On the day of Saturday 09 February 2008 Thomas Gleixner hast written:
> On Sat, 9 Feb 2008, Prakash Punnoor wrote:
> > On the day of Friday 08 February 2008 Andi Kleen hast written:
> > > On Fri, Feb 08, 2008 at 08:00:39PM +0100, Prakash Punnoor wrote:
> > > > On the day of Friday 08 February 2008 Andi Kleen hast written:
> > > > > On Fri, Feb 08, 2008 at 06:39:17PM +0100, Prakash Punnoor wrote:
> > > > > > Yes, confirmed. timer w/o the skipping stays XT-PIC on nforce2.
> > > > >
> > > > > Confirmed what? Did you test my patch on both machines?
> > > > > What was the result?
> > > >
> > > > I confirmed that it (nforce2) needed the acpi_skip_timer_override. =
If
> > > > you read my mail, you knew I didn't test your patch.
> > >
> > > Ok can you please do so then?  Or stop your obstructism?
> >
> > Grr, I don't know why I am discussing with stubborn and/or arrogant devs
> > like you seem to be. But I actually did what you wanted and as *expecte=
d*
> > - as I said I understand that trivial piece of code you posted - your
> > patch fails here for my nforce2:
>
> No worry, this patch wont go anywhere near mainline as long as it
> breaks stuff and obviously you are under no obligation to re-test
> patches that have not been changed just re-submitted.

The problem is current behaviour is already broken as it applies the quirk=
=20
*unconditionally* for all Nvidia hardwarde where no hpet is detected. The=20
latter is just heuristics. *If* correct Nforce2 ID gets added to the propos=
ed=20
patch, behaviour would be equivalent to current situation for me (nforce2,=
=20
mcp51). Still I am saying mcp51 doesn't belong per-se to the list of chipse=
ts=20
which need to be quirked, as for me it shows adverse effect. Taking mcp51 o=
ut=20
would be an advancement.


If there are situations where quirking is correct and other situation where=
 it=20
is incorrect for the same type of chipsets, I think then the quirk should n=
ot=20
be applied automatically.



So I suggest something like this as a start. The quirk only gets applied fo=
r=20
nforce2 unconditionally, as it was intended originally. For chipsets betwee=
n=20
nforce3 and before nforce5 the user gets a message and no quirk gets applie=
d=20
automatically. If there are known bug reports (Andi Kleen didn't supply any=
=20
references) some more infos could be asked from the reportes. Then for know=
n=20
broken bios versions the quirk could be applied by DMI scan *selectively*.=
=20
(This part of code is missing here.) I also don't know whether the list of=
=20
IDs is complete.

Warning I hand edited the original proposed patch, so it won't apply and=20
probably won't compile. But I hope one gets the idea.


Index: linux/arch/x86/kernel/early-quirks.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- linux.orig/arch/x86/kernel/early-quirks.c
+++ linux/arch/x86/kernel/early-quirks.c
@@ -60,38 +60,21 @@ static void __init via_bugs(int  num, in
 #endif
 }
=20
=2D#ifdef CONFIG_ACPI
=2D#ifdef CONFIG_X86_IO_APIC
=2D
=2Dstatic int __init nvidia_hpet_check(struct acpi_table_header *header)
=2D{
=2D       return 0;
=2D}
=2D#endif /* CONFIG_X86_IO_APIC */
=2D#endif /* CONFIG_ACPI */
=2D
=2Dstatic void __init nvidia_bugs(int num, int slot, int func)
+static void __init nvidia_timer(int num, int slot, int func)
 {
 #ifdef CONFIG_ACPI
 #ifdef CONFIG_X86_IO_APIC
        /*
=2D        * All timer overrides on Nvidia are
=2D        * wrong unless HPET is enabled.
=2D        * Unfortunately that's not true on many Asus boards.
=2D        * We don't know yet how to detect this automatically, but
=2D        * at least allow a command line override.
+        * Timer overrides on Nvidia NForce2 are
+        * wrong.
         */
        if (acpi_use_timer_override)
                return;
=20
=2D       if (acpi_table_parse(ACPI_SIG_HPET, nvidia_hpet_check)) {
=2D               acpi_skip_timer_override =3D 1;
=2D               printk(KERN_INFO "Nvidia board "
=2D                      "detected. Ignoring ACPI "
=2D                      "timer override.\n");
=2D               printk(KERN_INFO "If you got timer trouble "
=2D                       "try acpi_use_timer_override\n");
=2D       }
+       acpi_skip_timer_override =3D 1;
+       printk(KERN_INFO "NForce2 Nvidia board detected."
+                        "Ignoring ACPI timer override.\n");
+       printk(KERN_INFO "If you have trouble try acpi_use_timer_override\n=
");
 #endif
 #endif
        /* RED-PEN skip them on mptables too? */
@@ -121,9 +104,19 @@ struct chipset {
        void (*f)(int num, int slot, int func);
 };
=20
+ static void __init nvidia_timer_hint(int num, int slot, int func)
+ {
+ 	if (!acpi_skip_timer_override)
+ 		printk(KERN_INFO "Pre NForce5 Nvidia board detected."
+				 "If you have trouble, try booting with acpi_skip_timer_override\n"
+				 "If that works for you please report to the Linux kernel mailing=20
list.");
+ }

+#define QBRIDGE(vendor, device, func) { \
+       vendor, device, PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, \
+       QFLAG_APPLY_ONCE, func }
+
 static struct chipset early_qrk[] __initdata =3D {
=2D       { PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
=2D         PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, QFLAG_APPLY_ONCE, nvidia_bugs=
 },
+       /* This list should cover at least one PCI ID from each NF3 or NF4
+          mainboard to handle a bug in their reference BIOS. */
+ =A0 =A0 =A0 QBRIDGE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE2,=20
nvidia_timer),
+       QBRIDGE(PCI_VENDOR_ID_NVIDIA, 0x00e1, nvidia_timer_hint), /* nforce=
 3=20
*/
+       QBRIDGE(PCI_VENDOR_ID_NVIDIA, 0x00ed, nvidia_timer_hint), /* nforce=
 3=20
*/
+       QBRIDGE(PCI_VENDOR_ID_NVIDIA, 0x003d, nvidia_timer_hint), /* mcp 04=
 ??=20
*/
+       QBRIDGE(PCI_VENDOR_ID_NVIDIA, 0x02f0, nvidia_timer_hint), /* mcp=20
51/nf4 ? */
+       QBRIDGE(PCI_VENDOR_ID_NVIDIA, 0x026f, nvidia_timer_hint), /* mcp=20
51/nf4 ? */
+       QBRIDGE(PCI_VENDOR_ID_NVIDIA, 0x005c, nvidia_timer_hint), /* ck 804=
 */
        { PCI_VENDOR_ID_VIA, PCI_ANY_ID,
          PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, QFLAG_APPLY_ONCE, via_bugs },
        { PCI_VENDOR_ID_ATI, PCI_ANY_ID,


=2D-=20
(=B0=3D                 =3D=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart2111665.n0YeBMxahX
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHrZotxU2n/+9+t5gRAtjDAKDJS1xgKPtDXbdeG1AvXPg3Gc3B0gCg+IyC
0wIaS2qXZsqmjUc2PWfdlHw=
=QAs0
-----END PGP SIGNATURE-----

--nextPart2111665.n0YeBMxahX--
