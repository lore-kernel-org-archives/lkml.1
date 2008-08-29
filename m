Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbYH2KZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbYH2KZm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 06:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbYH2KY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 06:24:56 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:41724 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbYH2KYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 06:24:55 -0400
Date: Fri, 29 Aug 2008 11:24:44 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory
 corruption
In-Reply-To: <b170af450808290313x574b4561i3048ffca3e4da197@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0808291120540.8561@blonde.site>
References: <48B701FB.2020905@goop.org>  <86802c440808281849nb972d64te89894077ea9f33c@mail.gmail.com>
  <48B76CE0.5010309@goop.org>  <20080829102547.655440bf@lxorguk.ukuu.org.uk>
 <b170af450808290313x574b4561i3048ffca3e4da197@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1807564604-1220005484=:8561"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1807564604-1220005484=:8561
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

> On Fri, 29 Aug 2008, Rafa=C5=82 Mi=C5=82ecki wrote:
>=20
> Out of current discussion I tried using s2ram on patched kernel (I did
> not try s2ram earlier, my problem was (un)plugging HDMI - some ACPI
> code probably).
>=20
> Corruption output is quite huge, I attached it to bug report:
> http://bugzilla.kernel.org/show_bug.cgi?id=3D11237
> http://bugzilla.kernel.org/attachment.cgi?id=3D17526

Not quite the output we were expecting!  I've not got around to trying
it yet, so beware, but I think Jeremy's patch needs the following on top.
Or you may prefer to wait until one of us reports that it is now working
as intended.

--- a/arch/x86/kernel/setup.c=092008-08-29 11:17:16.000000000 +0100
+++ b/arch/x86/kernel/setup.c=092008-08-29 11:19:24.000000000 +0100
@@ -636,11 +636,12 @@ void check_for_bios_corruption(void)
 =09=09unsigned long *addr =3D __va(scan_areas[i].addr);
 =09=09unsigned long size =3D scan_areas[i].size;
=20
-=09=09for(; size; addr++, size--) {
+=09=09for(; size; addr++, size -=3D sizeof(unsigned long)) {
 =09=09=09if (!*addr)
 =09=09=09=09continue;
 =09=09=09printk(KERN_ERR "Corrupted low memory at %p (%lx phys) =3D %08lx\=
n",
 =09=09=09       addr, __pa(addr), *addr);
+=09=09=09*addr =3D 0;
 =09=09=09corruption =3D 1;
 =09=09}
 =09}
--8323584-1807564604-1220005484=:8561--
