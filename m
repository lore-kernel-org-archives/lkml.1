Return-Path: <linux-kernel-owner+w=401wt.eu-S1752316AbYAUMfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbYAUMfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 07:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbYAUMfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 07:35:42 -0500
Received: from dbs1.uni-c.dtu.dk ([130.225.88.6]:40269 "HELO dbs1.uni-c.dtu.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750879AbYAUMfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 07:35:41 -0500
From: "Oyvind Aabling" <Oyvind.Aabling@uni-c.dk>
Date: Mon, 21 Jan 2008 13:35:39 +0100 (CET)
To: linux-kernel@vger.kernel.org
cc: Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] drivers/char/moxa.c, kernel 2.6.23.14
Message-ID: <Pine.LNX.4.64.0801211324060.32175@dbs1.uni-c.dtu.dk>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-511572392-525703753-1200918939=:32175"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---511572392-525703753-1200918939=:32175
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

moxa.c changes to MOXA_GET_CONF ioctl breaks moxaload (userspace
application for firmware download to MOXA Intellio CPU boards).

Attached (and included inline below) is a patch to solve a problem
introduced by changes to struct moxa_board_conf in drivers/char/moxa.c.

AFAICS from the changelogs, moxa.c was rewritten to a new API in 2.6.21,
but I've only tested it (and moxaload) on kernels up to 2.6.19.2
(where it works) and on 2.6.22.6 and various later kernels,
including the latest (2.6.23.14), where it doesn't work.

Steps to reproduce:

Call the moxaload program (from MOXA) to download the firmware.

moxaload will fail on most systems (all the ones I've tried), because it
thinks there is a memory conflict, although this behaviour will depend
on the exact contents of struct moxa_board_conf (in drivers/char/moxa.c).

The problem is, that moxaload uses the MOXA_GET_CONF ioctl,
which returns (verbatim) the contents of struct moxa_board_conf,
the structure (and contents) of which has changed heavily.

This patch corrects this problem by reverting the behaviour of the
MOXA_GET_CONF ioctl, so it returns the info that moxaload expects.

I'm not on the kernel list, so please CC:
me with any questions and/or comments.

To Jiri Slaby <jirislaby@gmail.com>:

I've CC'ed this to you, although linux/MAINTAINERS doesn't
mention you as the maintainer of moxa.c, since the changelogs
seems to indicate, that you're the current maintainer.

linux/MAINTAINERS mentions you (Jiri) as the maintainer
of mxser, but that is the driver for other MOXA
boards, so I hope that I've guessed right ...

=D8yvind.

PS: Jiri, you may receive this twice (sorry 'bout that),
but it seems that pine doesn't encode the From: field
properly, so my first mail got rejected by vger.kernel.org
due to the iso-latin-1 Ooblique char in my name.
What a depressingly stupid program :-(

**************************************************************************
* =D8yvind Aabling     E-mail : Oyvind.Aabling@uni-c.dk    /~\ The ASCII   =
*
* UNI-C Lyngby       Phone  : +45 35 87 88 89            \ / Ribbon      *
* DTU Building 304   Phone  : +45 35 87 89 51 (direct)    X  Campaign    *
* DK-2800 LYNGBY     Fax    : +45 35 87 89 90            / \ Against     *
* Denmark                                                    HTML Email! *
**************************************************************************

--- linux-2.6.23.14/drivers/char/moxa.c=092008-01-14 21:49:56.000000000 +01=
00
+++ linux/drivers/char/moxa.c=092008-01-20 18:30:15.000000000 +0100
@@ -109,6 +109,8 @@
  =09int busType;

  =09int loadstat;
+=09unsigned short busNum;
+=09unsigned short devNum;

  =09void __iomem *basemem;
  =09void __iomem *intNdx;
@@ -116,6 +118,16 @@
  =09void __iomem *intTable;
  } moxa_boards[MAX_BOARDS];

+/* Used by userspace application moxaload (firmware download) */
+static struct moxa_board_info {
+=09int boardType;
+=09int numPorts;
+=09unsigned long baseAddr;
+=09int busType;
+=09unsigned short busNum;
+=09unsigned short devNum;
+} moxa_board_info[MAX_BOARDS];
+
  struct mxser_mstatus {
  =09tcflag_t cflag;
  =09int cts;
@@ -304,6 +316,9 @@
  =09=09goto err;

  =09board->boardType =3D board_type;
+=09board->baseAddr =3D pci_resource_start(pdev, 2);
+=09board->busNum =3D pdev->bus->number;
+=09board->devNum =3D PCI_SLOT(pdev->devfn);
  =09switch (board_type) {
  =09case MOXA_BOARD_C218_ISA:
  =09case MOXA_BOARD_C218_PCI:
@@ -1494,8 +1509,16 @@
  =09}
  =09switch (cmd) {
  =09case MOXA_GET_CONF:
-=09=09if(copy_to_user(argp, &moxa_boards, MAX_BOARDS *
-=09=09=09=09sizeof(struct moxa_board_conf)))
+=09=09for (i =3D 0; i < MAX_BOARDS; i++) {
+=09=09=09moxa_board_info[i].boardType =3D moxa_boards[i].boardType;
+=09=09=09moxa_board_info[i].numPorts  =3D moxa_boards[i].numPorts;
+=09=09=09moxa_board_info[i].baseAddr  =3D moxa_boards[i].baseAddr;
+=09=09=09moxa_board_info[i].busType   =3D moxa_boards[i].busType;
+=09=09=09moxa_board_info[i].busNum    =3D moxa_boards[i].busNum;
+=09=09=09moxa_board_info[i].devNum    =3D moxa_boards[i].devNum;
+=09=09}
+=09=09if(copy_to_user(argp, &moxa_board_info, MAX_BOARDS *
+=09=09=09=09sizeof(struct moxa_board_info)))
  =09=09=09return -EFAULT;
  =09=09return (0);
  =09case MOXA_INIT_DRIVER:
---511572392-525703753-1200918939=:32175
Content-Type: TEXT/x-diff; charset=US-ASCII; name=moxa.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0801211335390.32175@dbs1.uni-c.dtu.dk>
Content-Description: 
Content-Disposition: attachment; filename=moxa.patch

LS0tIGxpbnV4LTIuNi4yMy4xNC9kcml2ZXJzL2NoYXIvbW94YS5jCTIwMDgt
MDEtMTQgMjE6NDk6NTYuMDAwMDAwMDAwICswMTAwDQorKysgbGludXgvZHJp
dmVycy9jaGFyL21veGEuYwkyMDA4LTAxLTIwIDE4OjMwOjE1LjAwMDAwMDAw
MCArMDEwMA0KQEAgLTEwOSw2ICsxMDksOCBAQA0KIAlpbnQgYnVzVHlwZTsN
CiANCiAJaW50IGxvYWRzdGF0Ow0KKwl1bnNpZ25lZCBzaG9ydCBidXNOdW07
DQorCXVuc2lnbmVkIHNob3J0IGRldk51bTsNCiANCiAJdm9pZCBfX2lvbWVt
ICpiYXNlbWVtOw0KIAl2b2lkIF9faW9tZW0gKmludE5keDsNCkBAIC0xMTYs
NiArMTE4LDE2IEBADQogCXZvaWQgX19pb21lbSAqaW50VGFibGU7DQogfSBt
b3hhX2JvYXJkc1tNQVhfQk9BUkRTXTsNCiANCisvKiBVc2VkIGJ5IHVzZXJz
cGFjZSBhcHBsaWNhdGlvbiBtb3hhbG9hZCAoZmlybXdhcmUgZG93bmxvYWQp
ICovDQorc3RhdGljIHN0cnVjdCBtb3hhX2JvYXJkX2luZm8gew0KKwlpbnQg
Ym9hcmRUeXBlOw0KKwlpbnQgbnVtUG9ydHM7DQorCXVuc2lnbmVkIGxvbmcg
YmFzZUFkZHI7DQorCWludCBidXNUeXBlOw0KKwl1bnNpZ25lZCBzaG9ydCBi
dXNOdW07DQorCXVuc2lnbmVkIHNob3J0IGRldk51bTsNCit9IG1veGFfYm9h
cmRfaW5mb1tNQVhfQk9BUkRTXTsNCisNCiBzdHJ1Y3QgbXhzZXJfbXN0YXR1
cyB7DQogCXRjZmxhZ190IGNmbGFnOw0KIAlpbnQgY3RzOw0KQEAgLTMwNCw2
ICszMTYsOSBAQA0KIAkJZ290byBlcnI7DQogDQogCWJvYXJkLT5ib2FyZFR5
cGUgPSBib2FyZF90eXBlOw0KKwlib2FyZC0+YmFzZUFkZHIgPSBwY2lfcmVz
b3VyY2Vfc3RhcnQocGRldiwgMik7DQorCWJvYXJkLT5idXNOdW0gPSBwZGV2
LT5idXMtPm51bWJlcjsNCisJYm9hcmQtPmRldk51bSA9IFBDSV9TTE9UKHBk
ZXYtPmRldmZuKTsNCiAJc3dpdGNoIChib2FyZF90eXBlKSB7DQogCWNhc2Ug
TU9YQV9CT0FSRF9DMjE4X0lTQToNCiAJY2FzZSBNT1hBX0JPQVJEX0MyMThf
UENJOg0KQEAgLTE0OTQsOCArMTUwOSwxNiBAQA0KIAl9DQogCXN3aXRjaCAo
Y21kKSB7DQogCWNhc2UgTU9YQV9HRVRfQ09ORjoNCi0JCWlmKGNvcHlfdG9f
dXNlcihhcmdwLCAmbW94YV9ib2FyZHMsIE1BWF9CT0FSRFMgKg0KLQkJCQlz
aXplb2Yoc3RydWN0IG1veGFfYm9hcmRfY29uZikpKQ0KKwkJZm9yIChpID0g
MDsgaSA8IE1BWF9CT0FSRFM7IGkrKykgew0KKwkJCW1veGFfYm9hcmRfaW5m
b1tpXS5ib2FyZFR5cGUgPSBtb3hhX2JvYXJkc1tpXS5ib2FyZFR5cGU7DQor
CQkJbW94YV9ib2FyZF9pbmZvW2ldLm51bVBvcnRzICA9IG1veGFfYm9hcmRz
W2ldLm51bVBvcnRzOw0KKwkJCW1veGFfYm9hcmRfaW5mb1tpXS5iYXNlQWRk
ciAgPSBtb3hhX2JvYXJkc1tpXS5iYXNlQWRkcjsNCisJCQltb3hhX2JvYXJk
X2luZm9baV0uYnVzVHlwZSAgID0gbW94YV9ib2FyZHNbaV0uYnVzVHlwZTsN
CisJCQltb3hhX2JvYXJkX2luZm9baV0uYnVzTnVtICAgID0gbW94YV9ib2Fy
ZHNbaV0uYnVzTnVtOw0KKwkJCW1veGFfYm9hcmRfaW5mb1tpXS5kZXZOdW0g
ICAgPSBtb3hhX2JvYXJkc1tpXS5kZXZOdW07DQorCQl9DQorCQlpZihjb3B5
X3RvX3VzZXIoYXJncCwgJm1veGFfYm9hcmRfaW5mbywgTUFYX0JPQVJEUyAq
DQorCQkJCXNpemVvZihzdHJ1Y3QgbW94YV9ib2FyZF9pbmZvKSkpDQogCQkJ
cmV0dXJuIC1FRkFVTFQ7DQogCQlyZXR1cm4gKDApOw0KIAljYXNlIE1PWEFf
SU5JVF9EUklWRVI6DQo=

---511572392-525703753-1200918939=:32175--
