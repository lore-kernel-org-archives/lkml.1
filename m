Return-Path: <linux-kernel-owner+w=401wt.eu-S1757364AbZA2Tye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbZA2Tye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 14:54:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbZA2TyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 14:54:25 -0500
Received: from mx71.mail.ru ([194.67.23.4]:54781 "EHLO mx71.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbZA2TyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 14:54:24 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-pm@lists.linux-foundation.org
Subject: 2.6.29-rc: PM notifiers are not called during hibernation
Date: Thu, 29 Jan 2009 22:53:57 +0300
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc3-1avb; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart12462283.T0OThmKhc2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901292254.09562.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart12462283.T0OThmKhc2
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

rc2 and now rc3

Orinoco driver uses notifications to request firmware before=20
suspend/hibernation. This is OK for suspend, but does not seem to work=20
for hibernation. I get what suspiciously looks like 60 seconds timeout=20
for request_firmware, but I do not see either usual request_firmware=20
output, nor debug output.

Suspend is OK.

orinoco notification handlers is:

static int orinoco_pm_notifier(struct notifier_block *notifier,
                               unsigned long pm_event,
                               void *unused)
{
        struct orinoco_private *priv =3D container_of(notifier,
                                                    struct=20
orinoco_private,
                                                    pm_notifier);

        /* All we need to do is cache the firmware before suspend, and
         * release it when we come out.
         *
         * Only need to do this if we're downloading firmware. */
        if (!priv->do_fw_download)
                return NOTIFY_DONE;

        switch (pm_event) {
        case PM_HIBERNATION_PREPARE:
        case PM_SUSPEND_PREPARE:
                printk("%s: called with %ld before\n", __FUNCTION__,=20
pm_event);
                orinoco_cache_fw(priv, 0);
                break;

        case PM_POST_RESTORE:
                /* Restore from hibernation failed. We need to clean
                 * up in exactly the same way, so fall through. */
        case PM_POST_HIBERNATION:
        case PM_POST_SUSPEND:
                printk("%s: called with %ld after\n", __FUNCTION__,=20
pm_event);
                orinoco_uncache_fw(priv);
                break;

        case PM_RESTORE_PREPARE:
        default:
                break;
        }


I get=20

[ 1975.505283] orinoco_pm_notifier: called with 3 before


for suspend. Nothing for hibernate. Hibernation log:

[11892.927098] Syncing filesystems ... done.
[11892.944480] Freezing user space processes ... (elapsed 0.00 seconds)=20
done.
[11892.951447] Freezing remaining freezable tasks ... (elapsed 0.00=20
seconds) don
e.
[11892.956299] PM: Shrinking memory... done (30918 pages freed)
[11894.679916] PM: Freed 123672 kbytes in 1.72 seconds (71.90 MB/s)
[11894.679928] Suspending console(s) (use no_console_suspend to debug)
[11894.685232] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[11894.688489] e100 0000:00:0a.0: PME# enabled
[11894.688977] e100 0000:00:0a.0: wake-up capability enabled by ACPI
[11894.742522] ALI 5451 0000:00:06.0: PCI INT A disabled
[11894.755858] ALI 5451 0000:00:06.0: power state changed by ACPI to D3
[11895.515754] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[11895.515789] ohci_hcd 0000:00:02.0: PCI INT A disabled
[11895.515859] ohci_hcd 0000:00:02.0: PME# disabled
[11895.518458] ACPI: Preparing to enter system sleep state S4
[11895.519666] PM: Saving platform NVS memory
[11895.520121] PM: Creating hibernation image:
[11895.522219] PM: Need to copy 60887 pages
[11895.522219] PM: Restoring platform NVS memory
[11895.522219] ohci_hcd 0000:00:02.0: restoring config space at offset=20
0x1 (was0x2900007, writing 0x2900003)
[11895.522219] pata_ali 0000:00:04.0: restoring config space at offset=20
0x1 (was0x2900001, writing 0x2900005)
[11895.522219] ALI 5451 0000:00:06.0: restoring config space at offset=20
0x1 (was0xc2900007, writing 0xc2900003)
[11895.522219] e100 0000:00:0a.0: restoring config space at offset 0xf=20
(was 0x380801ff, writing 0x3808010b)
[11895.522219] e100 0000:00:0a.0: restoring config space at offset 0x6=20
(was 0x48100000, writing 0xf7d00000)
[11895.522219] e100 0000:00:0a.0: restoring config space at offset 0x5=20
(was 0x2801, writing 0xeb41)
[11895.522219] e100 0000:00:0a.0: restoring config space at offset 0x4=20
(was 0x48200000, writing 0xf7efd000)
[11895.522219] e100 0000:00:0a.0: restoring config space at offset 0x1=20
(was 0x2900003, writing 0x2900007)
[11895.522219] yenta_cardbus 0000:00:10.0: restoring config space at=20
offset 0xf
(was 0x34001ff, writing 0x5c001ff)
[11895.522219] yenta_cardbus 0000:00:10.0: restoring config space at=20
offset 0x4(was 0x48201000, writing 0x48100000)
[11895.522219] yenta_cardbus 0000:00:10.0: restoring config space at=20
offset 0x3(was 0x24008, writing 0x2a808)
[11895.522219] yenta_cardbus 0000:00:10.0: restoring config space at=20
offset 0x1(was 0x2100003, writing 0x2100007)
[11895.522219] yenta_cardbus 0000:00:11.0: restoring config space at=20
offset 0xf(was 0x10001ff, writing 0x58001ff)
[11895.522219] yenta_cardbus 0000:00:11.0: restoring config space at=20
offset 0x4(was 0x48202000, writing 0x48101000)
[11895.522219] yenta_cardbus 0000:00:11.0: restoring config space at=20
offset 0x3(was 0x824000, writing 0x82a800)
[11895.522219] yenta_cardbus 0000:00:11.0: restoring config space at=20
offset 0x1(was 0x4900003, writing 0x4900007)
[11895.522219] yenta_cardbus 0000:00:11.1: restoring config space at=20
offset 0xf(was 0x10002ff, writing 0x58002ff)
[11895.522219] yenta_cardbus 0000:00:11.1: restoring config space at=20
offset 0x4(was 0x48203000, writing 0x48102000)
[11895.522219] yenta_cardbus 0000:00:11.1: restoring config space at=20
offset 0x3(was 0x824000, writing 0x82a800)
[11895.522219] yenta_cardbus 0000:00:11.1: restoring config space at=20
offset 0x1(was 0x4900003, writing 0x4900007)
[11895.538101] ACPI: Waking up from system sleep state S4
[11895.551467] agpgart-ali 0000:00:00.0: PME# disabled
[11895.551509] pci 0000:00:01.0: setting latency timer to 64
[11895.551534] ohci_hcd 0000:00:02.0: PME# disabled
[11895.551565] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNKG] -> GSI 11=20
(level,low) -> IRQ 11
[11895.551586] ohci_hcd 0000:00:02.0: PME# disabled
[11895.604269] usb usb1: root hub lost power or was reset
[11895.604359] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[11896.904448] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[11896.904645] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[11896.904671] ALI 5451 0000:00:06.0: PCI INT A -> Link[LNKH] -> GSI 11=20
(level,low) -> IRQ 11
[11897.065970] ata1.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[11897.065980] ata1.00: ACPI cmd ef/03:44:00:00:00:00 filtered out
[11897.079453] ata1.00: configured for UDMA/33
[11897.079712] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors:=20
(20.0 GB/18.6 GiB)
[11897.079799] sd 0:0:0:0: [sda] Write Protect is off
[11897.079807] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[11897.079939] sd 0:0:0:0: [sda] Write cache: enabled, read cache:=20
enabled, doesn't support DPO or FUA
[11897.185571] pci 0000:00:07.0: PME# disabled
[11897.185593] ali1535_smbus 0000:00:08.0: enabling device (0000 ->=20
0001)
[11897.185631] e100 0000:00:0a.0: restoring config space at offset 0xf=20
(was 0x38080100, writing 0x3808010b)
[11897.185663] e100 0000:00:0a.0: restoring config space at offset 0x6=20
(was 0x0, writing 0xf7d00000)
[11897.185676] e100 0000:00:0a.0: restoring config space at offset 0x5=20
(was 0x1, writing 0xeb41)
[11897.185689] e100 0000:00:0a.0: restoring config space at offset 0x4=20
(was 0x0, writing 0xf7efd000)
[11897.185702] e100 0000:00:0a.0: restoring config space at offset 0x3=20
(was 0x0, writing 0x4008)
[11897.185718] e100 0000:00:0a.0: restoring config space at offset 0x1=20
(was 0x2900000, writing 0x2900007)
[11897.185744] e100 0000:00:0a.0: wake-up capability disabled by ACPI
[11897.185755] e100 0000:00:0a.0: PME# disabled
[11897.352579] ata2.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[11897.352588] ata2.00: ACPI cmd ef/03:42:00:00:00:00 filtered out
[11897.376011] ata2.00: configured for UDMA/33
[11898.168922] pci 0000:00:12.0: PME# disabled
[11898.168943] pci 0000:01:00.0: PME# disabled
[11898.172324] sd 0:0:0:0: [sda] Starting disk
[11898.409627] hermes_init: iobase =3D 00010100, spacing =3D 0
[11898.449169] eth1: Attempting to download firmware agere_sta_fw.bin
[11898.449211] hermes_dld: AUX enable returned 0
[11898.450234] hermes_dld: AUX disable returned 0
[11898.450240] hermes_dld: Actual PDA length 998, Max allowed 1000
[11898.450247] eth1: Read PDA returned 0
[11898.450255] orinoco_cs 0.0: firmware: requesting agere_sta_fw.bin
[11958.449070] eth1: Cannot find firmware agere_sta_fw.bin
[11958.449086] eth1: Error -2 re-initializing firmware
[11958.449098] PM: Device 0.0 failed to restore: error -5
[11958.535206] Restarting tasks ... <5>toshiba_acpi: Re-enabled hotkeys
[11958.630180] done.


--nextPart12462283.T0OThmKhc2
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmCCVkACgkQR6LMutpd94znaQCgspvY37TnsfteBauAsSXgzAZo
kowAoL7lsMaD+84oiijXxPsfVU/UPo7q
=pTkI
-----END PGP SIGNATURE-----

--nextPart12462283.T0OThmKhc2--
