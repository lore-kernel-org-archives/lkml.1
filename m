Return-Path: <linux-kernel-owner+w=401wt.eu-S1423051AbXEDXsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423051AbXEDXsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 19:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423001AbXEDXsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 19:48:25 -0400
Received: from relay5.ptmail.sapo.pt ([212.55.154.25]:41493 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1423037AbXEDXsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 19:48:00 -0400
X-AntiVirus: PTMail-AV 0.3-0.90.1
Subject: [Fwd: [PATCH -mm] working 3D/DRI intel-agp.ko resume for i815
	chip; Intel chipset testers wanted! (was: Re: intel-agp PM experiences ...)]
From: Sergio Monteiro Basto <sergio@sergiomb.no-ip.org>
To: dri-devel <dri-devel@lists.sourceforge.net>
Cc: acpi devel <linux-acpi@vger.kernel.org>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Mohr <andi@rhlx01.fht-esslingen.de>
Content-Type: multipart/signed; micalg=sha1; protocol="application/x-pkcs7-signature"; boundary="=-5sgJAzpEdqoDblfqtAMh"
Date: Sat, 05 May 2007 00:48:37 +0100
Message-Id: <1178322517.2445.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5sgJAzpEdqoDblfqtAMh
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi forward this message to dri-devel Mailing List, where you could find
more tester on i815 DRI drives .
I hope I don't had made a loop :)=20

-------- Forwarded Message --------
From: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@osdl.org>, davej@codemonkey.org.uk,
linux-acpi@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
kernel list <linux-kernel@vger.kernel.org>, andi@lisas.de
Subject: [PATCH -mm] working 3D/DRI intel-agp.ko resume for i815 chip;
Intel chipset testers wanted! (was: Re: intel-agp PM experiences ...)
Date: 	Tue, 1 May 2007 16:59:47 +0200

Hi,

On Thu, Jan 18, 2007 at 11:16:51PM +0000, Pavel Machek wrote:
> Hi!
>=20
> > > > Especially the PCI video_state trick finally got me a working resum=
e on
> > > > 2.6.19-ck2 r128 Rage Mobility M4 AGP *WITH*(!) fully enabled and wo=
rking
> > > > (and keeping working!) DRI (3D).
> > >=20
> > > Can we get whitelist entry for suspend.sf.net? s2ram from there can d=
o
> > > all the tricks you described, one letter per trick :-). We even got
> > > PCI saving lately.
> >=20
> > Whitelist? Let me blacklist it all the way to Timbuktu instead!
>=20
> > I've been doing more testing, and X never managed to come back to worki=
ng
> > state without some of my couple intel-agp changes:
> > - a proper suspend method, doing a proper pci_save_state()
> >   or improved equivalent
> > - a missing resume check for my i815 chipset
> > - global cache flush in _configure
> > - restoring AGP bridge PCI config space
>=20
> Can you post a patch?

Took way longer than I'd have wanted it to (nice daughter and stuff ;),
but here it is.

- add .suspend handler and pci_set_power_state() calls
- add i815-specific function agp_i815_remember_state() to remember importan=
t
  i815 register values
- add generic DEBUG_AGP_PM framework which will allow people to resume prop=
erly
  and help identify which registers need attention
- add obvious and detailed log message to make people sit up and take notic=
e
  about long-standing AGP resume issues
- spelling fixes

Patch against 2.6.21-rc7-mm2, my Inspiron 8000 (i815 with Radeon AGP card,
internal Intel VGA unit NOT active) resumes fine with both
either i815-specific register saving or generic DEBUG_AGP_PM mechanism enab=
led.
(of course my notebook needs vbetool post and manual saving of video card
PCI space, too, but even when doing all this I still had X.org lockups befo=
re
whenever DRI/3D was enabled)

After resume I'm now still able to run both glxgears and glxinfo without
anomalies.

Right now all I care about is that this gets into mainline relatively soon,
since I'm rather certain that many other machines suffer from similar
AGP resume lockup issues that could be debugged this way (e.g. some Thinkpa=
ds,
as witnessed accidentally via IRC chats, and from the well-known "don't ena=
ble
DRI, that will lock up on resume!" chants).
Yes, this code is a cludge and somewhat far from a nicely generic
extended PCI space resume framework, but we've spent almost 10 (TEN!) years
without anything even remotely resembling a working cludge for
AGP suspend/resume in combination with DRI, so...

Feel free to offer thoughts on how this missing generic extended PCI space
restore functionality could be implemented, to be used by intel-agp and
various other drivers. No promise that it will be me who implements that,
though ;)

> Whitelist entry would still be welcome.

OK, I'll work on this next.


Thanks!

Signed-off-by: Andreas Mohr <andi@lisas.de>


--- linux-2.6.21-rc7-mm2.orig/drivers/char/agp/intel-agp.c	2007-05-10 14:52=
:26.000000000 +0200
+++ linux-2.6.21-rc7-mm2/drivers/char/agp/intel-agp.c	2007-05-10 14:31:48.0=
00000000 +0200
@@ -31,9 +31,16 @@
 extern int agp_memory_reserved;
=20

-/* Intel 815 register */
-#define INTEL_815_APCONT	0x51
-#define INTEL_815_ATTBASE_MASK	~0x1FFFFFFF
+/* Intel i815 registers, see Intel spec #29068801 */
+#define I815_GMCHCFG		0x50
+#define I815_APCONT		0x51
+#define I815_UNKNOWN_80		0x80
+#define I815_ATTBASE_MASK	~0x1FFFFFFF
+#define I815_SM_RCOMP		0x98 /* Sys Mem R Compensation Ctrl */
+#define I815_SM			0x9c /* System Memory Control Reg */
+#define I815_AGPCMD		0xa8 /* AGP Command Register */
+#define I815_ERRSTS		0xc8 /* undocumented in i815 spec; since this one is =
modified on resume and many other related chipsets have it, I assume it *is=
* ERRSTS */
+#define I815_UNKNOWN_E8		0xe8
=20
 /* Intel i820 registers */
 #define INTEL_I820_RDCR		0x51
@@ -664,7 +671,7 @@
 	if ((pg_start + mem->page_count) > num_entries)
 		goto out_err;
=20
-	/* The i830 can't check the GTT for entries since its read only,
+	/* The i830 can't check the GTT for entries since it's read-only,
 	 * depend on the caller to make the correct offset decisions.
 	 */
=20
@@ -787,7 +794,7 @@
 	if ((pg_start + mem->page_count) > num_entries)
 		goto out_err;
=20
-	/* The i915 can't check the GTT for entries since its read only,
+	/* The i915 can't check the GTT for entries since it's read-only,
 	 * depend on the caller to make the correct offset decisions.
 	 */
=20
@@ -1103,8 +1110,8 @@
 	/* attbase - aperture base */
 	/* the Intel 815 chipset spec. says that bits 29-31 in the
 	* ATTBASE register are reserved -> try not to write them */
-	if (agp_bridge->gatt_bus_addr & INTEL_815_ATTBASE_MASK) {
-		printk (KERN_EMERG PFX "gatt bus addr too high");
+	if (agp_bridge->gatt_bus_addr & I815_ATTBASE_MASK) {
+		printk (KERN_EMERG PFX "gatt bus addr too high\n");
 		return -EINVAL;
 	}
=20
@@ -1119,7 +1126,7 @@
 	agp_bridge->gart_bus_addr =3D (temp & PCI_BASE_ADDRESS_MEM_MASK);
=20
 	pci_read_config_dword(agp_bridge->dev, INTEL_ATTBASE, &addr);
-	addr &=3D INTEL_815_ATTBASE_MASK;
+	addr &=3D I815_ATTBASE_MASK;
 	addr |=3D agp_bridge->gatt_bus_addr;
 	pci_write_config_dword(agp_bridge->dev, INTEL_ATTBASE, addr);
=20
@@ -1127,8 +1134,8 @@
 	pci_write_config_dword(agp_bridge->dev, INTEL_AGPCTRL, 0x0000);
=20
 	/* apcont */
-	pci_read_config_byte(agp_bridge->dev, INTEL_815_APCONT, &temp2);
-	pci_write_config_byte(agp_bridge->dev, INTEL_815_APCONT, temp2 | (1 << 1)=
);
+	pci_read_config_byte(agp_bridge->dev, I815_APCONT, &temp2);
+	pci_write_config_byte(agp_bridge->dev, I815_APCONT, temp2 | (1 << 1));
=20
 	/* clear any possible error conditions */
 	/* Oddness : this chipset seems to have no ERRSTS register ! */
@@ -1355,7 +1362,7 @@
 	pci_write_config_dword(agp_bridge->dev, INTEL_ATTBASE, agp_bridge->gatt_b=
us_addr);
=20
 	/* agpctrl */
-	pci_write_config_dword(agp_bridge->dev, INTEL_AGPCTRL, 0x0000);
+	pci_write_config_dword(agp_bridge->dev, INTEL_AGPCTRL, 0x00000000);
=20
 	/* mchcfg */
 	pci_read_config_word(agp_bridge->dev, INTEL_I7505_MCHCFG, &temp2);
@@ -2011,12 +2018,178 @@
 }
=20
 #ifdef CONFIG_PM
+
+static int agp_i815_remember_state(struct pci_dev *pdev, int restore)
+{
+	typedef struct {
+		int reg;
+		u32 value;
+	} saved_regs;
+
+	/* Dell Inspiron 8000 BIOS rev. A23 needs the following registers saved
+	 * to be able to successfully restore X11 when AGP 3D is enabled
+	 * (register values given are after resume vs. before suspend):
+	 *
+	 * I815_GMCHCFG (0x50; we need to set bit 1 (Aperture Access Global Enabl=
e) of I815_APCONT (0x51),
+	 *              thus use I815_GMCHCFG (0x50) as 32bit base register); 0x4=
fdd0040 instead of 0x4fdd0240
+	 * ??? (0x80); 0x07ce1cde instead of 0x07cb94de
+	 * I815_SM_RCOMP (0x98); 0x80648064 instead of 0x80548054
+	 * I815_SM (0x9c); 0x00c48405 instead of 0x04848405
+	 * I815_AGPCMD (0xa8); 0x00000000 instead of 0x00000304
+	 * INTEL_AGPCTRL (0xb0); 0x00000000 instead of 0x00000080
+	 * INTEL_APSIZE (0xb4);
+	 * INTEL_ATTBASE (0xb8); 0x00000000 instead of 0x024b0000
+	 * I815_ERRSTS?? (0xc8; undocumented for i815, see above); 0x00000000 ins=
tead of 0x00000800
+	 * ??? (0xe8); 0x1c700000 instead of 0x18500000
+	 *
+	 * Other machines/chipsets/BIOS versions may require
+	 * a different set of registers to be properly saved.
+	 */
+	static saved_regs i815_saved_regs[] =3D {
+		{ I815_UNKNOWN_80, 0 },
+		{ I815_GMCHCFG, 0 },
+		{ I815_SM_RCOMP, 0 },
+		{ I815_SM, 0 },
+		{ I815_AGPCMD, 0 },
+		{ INTEL_AGPCTRL, 0 },
+		{ INTEL_APSIZE, 0 },
+		{ INTEL_ATTBASE, 0 },
+		{ I815_ERRSTS, 0 },
+		{ I815_UNKNOWN_E8, 0 },
+		{ 0, 0 }, /* DELIMITER */
+	};
+	saved_regs *p;
+
+	if (restore) {
+		u32 val;
+		for (p =3D i815_saved_regs; (p->reg !=3D 0); p++)
+		{
+			pci_read_config_dword(pdev, p->reg, &val);
+			if (val !=3D p->value) {
+				printk(KERN_DEBUG "AGP: Writing back config space on "
+					"device %s at offset %x (was %x, writing %x)\n",
+					pci_name(pdev), p->reg,
+					val, p->value);
+				pci_write_config_dword(pdev, p->reg,
+					p->value);
+			}
+		}=09
+	} else {
+		for (p =3D i815_saved_regs; (p->reg !=3D 0); p++)
+			pci_read_config_dword(pdev, p->reg, &p->value);
+	}
+	return 1;
+}
+
+/*
+ * set DEBUG_AGP_PM to 1 if your AGP chipset has issues resuming
+ * (machine lockups due to non-restored hardware registered values),
+ * then figure out from the log which registers have to be restored manual=
ly,
+ * then add specific support for your chipset, similar to what already exi=
sts
+ * for i815 (Dell Inspiron) above.
+ * E.g. IBM X31 (i855PM) seems to still have intel-agp suspend issues, too=
.
+ *
+ * Once it's obvious which chipsets need which treatment
+ * (this is an important step to gain knowledge about all chipsets!)
+ * this stop-gap code handling (we need something that works NOW,
+ * since we could have had it almost a decade ago already!)
+ * should be cleaned up, probably by implementing a generic Linux
+ * PCI function to save/restore extended PCI config space
+ * by supplying a register array or so...
+ * At this point, it would also be nice to clean up the _suspend()/_resume=
() functions
+ * to use some non-ugly and nicely generic restore mechanism.
+ */
+#define DEBUG_AGP_PM 0
+
+#if DEBUG_AGP_PM
+static u32 pci_cfg_space[64];
+
+static void agp_intel_suspend_debug(struct pci_dev *pdev, pm_message_t sta=
te)
+{
+	int i;
+	for (i =3D 63; i >=3D 0; i--)
+		pci_read_config_dword(pdev, i * 4, &pci_cfg_space[i]);
+}
+
+static void agp_intel_resume_debug(struct pci_dev *pdev)
+{
+	int i;
+	int val;
+
+	/* Try first reading main PCI config space, then extended space;
+	 * this order should hopefully prevent any lockups that may easily
+	 * occur otherwise.
+	 */
+	for (i =3D 15; i >=3D 0; i--) {
+		pci_read_config_dword(pdev, i * 4, &val);
+		if (val !=3D pci_cfg_space[i]) {
+			/* Who the *** decided (in PM code) that logging
+			 * register offsets in very weird offset notation
+			 * (extremely uncommon in PCI datasheet spheres) was a good idea?
+			 * Fixing this in this AGP-specific log message by multiplying offsets
+			 */
+			int reg =3D i * sizeof(u32);
+			printk(KERN_DEBUG "AGP: Writing back config space on "
+				"device %s at offset %x (was %x, writing %x)\n",
+				pci_name(pdev), reg,
+				val, pci_cfg_space[i]);
+			pci_write_config_dword(pdev, reg,
+				pci_cfg_space[i]);
+		}
+	}
+	for (i =3D 63; i >=3D 16; i--) {
+		pci_read_config_dword(pdev, i * 4, &val);
+		if (val !=3D pci_cfg_space[i]) {
+			int reg =3D i * sizeof(u32);
+			printk(KERN_DEBUG "AGP: Writing back config space on "
+				"device %s at offset %x (was %x, writing %x)\n",
+				pci_name(pdev), reg,
+				val, pci_cfg_space[i]);
+			pci_write_config_dword(pdev, reg,
+				pci_cfg_space[i]);
+		}
+	}
+}
+#else
+static inline void agp_intel_suspend_debug(struct pci_dev *pdev, pm_messag=
e_t state) { }
+static inline void agp_intel_resume_debug(struct pci_dev *pdev) { }
+#endif /* DEBUG_AGP_PM */
+
+
+static int agp_intel_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct agp_bridge_data *bridge =3D pci_get_drvdata(pdev);
+
+	if (bridge->driver =3D=3D &intel_815_driver)
+		agp_i815_remember_state(pdev, 0);
+
+	agp_intel_suspend_debug(pdev, state);
+
+	pci_save_state(pdev);
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+
+	return 0;
+}
+
 static int agp_intel_resume(struct pci_dev *pdev)
 {
 	struct agp_bridge_data *bridge =3D pci_get_drvdata(pdev);
=20
+	/* This ought to be enough meat in here to let us
+	 * resume successfully, at least when also being helped
+	 * by additional manual /sys/bus/pci/DEVICE recovering
+	 * of the graphics card and "vbetool post"
+	 * (the s2ram tool should do this nicely already)
+	 */
+
+	pci_set_power_state (pdev, PCI_D0);
 	pci_restore_state(pdev);
=20
+	agp_intel_resume_debug(pdev);
+
+	if (bridge->driver =3D=3D &intel_815_driver)
+		agp_i815_remember_state(pdev, 1);
+
 	/* We should restore our graphics device's config space,
 	 * as host bridge (00:00) resumes before graphics device (02:00),
 	 * then our access to its pci space can work right.
@@ -2038,6 +2211,8 @@
 		intel_i915_configure();
 	else if (bridge->driver =3D=3D &intel_830_driver)
 		intel_i830_configure();
+	/* Please no entry for i815 here since it already has
+	 * specific resume support above */
 	else if (bridge->driver =3D=3D &intel_810_driver)
 		intel_i810_configure();
 	else if (bridge->driver =3D=3D &intel_i965_driver)
@@ -2045,7 +2220,7 @@
=20
 	return 0;
 }
-#endif
+#endif /* CONFIG_PM */
=20
 static struct pci_device_id agp_intel_pci_table[] =3D {
 #define ID(x)						\
@@ -2098,6 +2273,7 @@
 	.probe		=3D agp_intel_probe,
 	.remove		=3D __devexit_p(agp_intel_remove),
 #ifdef CONFIG_PM
+	.suspend	=3D agp_intel_suspend,
 	.resume		=3D agp_intel_resume,
 #endif
 };
@@ -2106,6 +2282,12 @@
 {
 	if (agp_off)
 		return -EINVAL;
+	/* let people know that this is an important place to investigate at in c=
ase of resume lockups */
+	printk(KERN_INFO PFX
+		"suspend/resume of intel-agp.ko is NOT always stable for all Intel AGP\n=
"
+		"chipset/BIOS combos, may cause resume lockups when DRI (3D accel) activ=
e,\n"
+		"in AGP (non-PCI) mode! (see DEBUG_AGP_PM in intel-agp.c source to inves=
tigate)\n"
+	);
 	return pci_register_driver(&agp_intel_pci_driver);
 }
=20
-
To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--=20
S=C3=A9rgio M. B.

--=-5sgJAzpEdqoDblfqtAMh
Content-Type: application/x-pkcs7-signature; name=smime.p7s
Content-Disposition: attachment; filename=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGVjCCAw8w
ggJ4oAMCAQICEGne8YrzxxgYAeyxZxmiO+owDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQ
ZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA2MTAxMTEwMjAzOVoXDTA3MTAxMTEwMjAz
OVowSzEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEoMCYGCSqGSIb3DQEJARYZc2Vy
Z2lvQHNlcmdpb21iLm5vLWlwLm9yZzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAN9R
ix9koyWSNQDmAHxcSeWXdFO1osqg2yeNgBBl+fz8FLYyROsDGpZMcnOd/Df6tWwMZpMSYDNIksiZ
5VkCWaWIzIBccHX3wIkqrkcq3v1OcPGW9adXClXSbSZ0Hb4V4+bQ9LMAOjaMlH/dKLVkln6qmbko
NOxgPotdVxCGcUy1Pqa4dT1zFo5+nIv1NAUNqKpq63X/+3nILNG4JGAvLIL8wcYs0cETGS6vISgd
YFN/JlIqekWUGGUmc+SJcyyTWjXGN+2G0SDS8K3a9NFCo7a1Y0FyHQxikQRtB9sCcpQCoXiqaWsT
npSrNJ0Od4w1sHZz09uEdhWKqXEmJsKKwi8CAwEAAaNZMFcwDgYDVR0PAQH/BAQDAgSQMBEGCWCG
SAGG+EIBAQQEAwIFoDAkBgNVHREEHTAbgRlzZXJnaW9Ac2VyZ2lvbWIubm8taXAub3JnMAwGA1Ud
EwEB/wQCMAAwDQYJKoZIhvcNAQEFBQADgYEAwVE8/kY82qYG7I2+gW0NhSyn+DR0uAWYbSxB2NgP
16QOrzXt2HazlXkl2Bc+NKQEqEGKOu5fPPg2GoJ3zDO1Y8GUNGtJH0sX+63RGoUNOAv+bAK1Nxhb
illDUUCjW3OqA/hRyBwjU9kHJPYhl1EbAUGpAhfENHjkS/S7b1REBLMwggM/MIICqKADAgECAgEN
MA0GCSqGSIb3DQEBBQUAMIHRMQswCQYDVQQGEwJaQTEVMBMGA1UECBMMV2VzdGVybiBDYXBlMRIw
EAYDVQQHEwlDYXBlIFRvd24xGjAYBgNVBAoTEVRoYXd0ZSBDb25zdWx0aW5nMSgwJgYDVQQLEx9D
ZXJ0aWZpY2F0aW9uIFNlcnZpY2VzIERpdmlzaW9uMSQwIgYDVQQDExtUaGF3dGUgUGVyc29uYWwg
RnJlZW1haWwgQ0ExKzApBgkqhkiG9w0BCQEWHHBlcnNvbmFsLWZyZWVtYWlsQHRoYXd0ZS5jb20w
HhcNMDMwNzE3MDAwMDAwWhcNMTMwNzE2MjM1OTU5WjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMc
VGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZy
ZWVtYWlsIElzc3VpbmcgQ0EwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAMSmPFVzVftOucqZ
Wh5owHUEcJ3f6f+jHuy9zfVb8hp2vX8MOmHyv1HOAdTlUAow1wJjWiyJFXCO3cnwK4Vaqj9xVsuv
PAsH5/EfkTYkKhPPK9Xzgnc9A74r/rsYPge/QIACZNenprufZdHFKlSFD0gEf6e20TxhBEAeZBly
YLf7AgMBAAGjgZQwgZEwEgYDVR0TAQH/BAgwBgEB/wIBADBDBgNVHR8EPDA6MDigNqA0hjJodHRw
Oi8vY3JsLnRoYXd0ZS5jb20vVGhhd3RlUGVyc29uYWxGcmVlbWFpbENBLmNybDALBgNVHQ8EBAMC
AQYwKQYDVR0RBCIwIKQeMBwxGjAYBgNVBAMTEVByaXZhdGVMYWJlbDItMTM4MA0GCSqGSIb3DQEB
BQUAA4GBAEiM0VCD6gsuzA2jZqxnD3+vrL7CF6FDlpSdf0whuPg2H6otnzYvwPQcUCCTcDz9reFh
YsPZOhl+hLGZGwDFGguCdJ4lUJRix9sncVcljd2pnDmOjCBPZV+V2vf3h9bGCE6u9uo05RAaWzVN
d+NWIXiC3CEZNd4ksdMdRv9dX2VPMYIB/DCCAfgCAQEwdjBiMQswCQYDVQQGEwJaQTElMCMGA1UE
ChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFs
IEZyZWVtYWlsIElzc3VpbmcgQ0ECEGne8YrzxxgYAeyxZxmiO+owCQYFKw4DAhoFAKBdMBgGCSqG
SIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTA3MDUwNDIzNDgzN1owIwYJKoZI
hvcNAQkEMRYEFABODM/OsbKzZHzvnTqtdOxzgnsmMA0GCSqGSIb3DQEBAQUABIIBAAXHFId2ajdh
+l+nMyhQ3kmk3r2kdvH7sl6RFSWs2lUobgSFu7PdcVyKMYh/cQIG6ullwgJePcj8jjnN57n29loI
khjf2Q/4YBjPtgtQ2ITvaNWMQl4De6a4pkFx2kvJ51QBGoX9R0avmcEOlGNhKrCr/w5Kg+XAujLe
Rhe2YXsHVQ5sb+W/iSiBb6nimK+/2/7IJvUmviD2I11jQr7rlD4UGiorwY16NEvA7CSFXHXXlavz
qe2Kv69zhS9q5NI5SI4rNoHB+lk3uak6y4u7egctomZdrn43nIpB34pgcWdwuK3nw4o5eLPod2+8
8tr1v9Qu1IvZuiPjFJQnyuhfnMwAAAAAAAA=


--=-5sgJAzpEdqoDblfqtAMh--

