Return-Path: <linux-kernel-owner+w=401wt.eu-S932924AbXBPCLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924AbXBPCLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 21:11:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932926AbXBPCLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 21:11:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:32449 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932924AbXBPCLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 21:11:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,178,1170662400"; 
   d="scan'208"; a="197381918:sNHT12234704013"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7516F.B06F8DE1"
Subject: RE: e1000_intr in request_irq faults in 2.6.20-git
Date: Thu, 15 Feb 2007 18:10:53 -0800
Message-ID: <36D9DB17C6DE9E40B059440DB8D95F5201E997BA@orsmsx418.amr.corp.intel.com>
In-Reply-To: <m1y7mzhw7b.fsf@ebiederm.dsl.xmission.com>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: e1000_intr in request_irq faults in 2.6.20-git
Thread-Index: AcdRU7nSJpm4b13tS+ayUQ7jDB7nWwAESKhQ
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, "Len Brown" <lenb@kernel.org>
Cc: "Ronciak, John" <john.ronciak@intel.com>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       "lkml - Kernel Mailing List" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Feb 2007 02:10:55.0064 (UTC) FILETIME=[B0AC2580:01C7516F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7516F.B06F8DE1
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Eric W. Biederman wrote:
> Len Brown <lenb@kernel.org> writes:
>=20
>> e1000 faults in 2.6.20-git, while 2.6.20 worked fine.
>>=20
>> System is a D875PBZ with LOM.
>>=20
>> clues?
>=20
> I'm guessing this is an old bug found by the following bit of
> debug coded added into since v2.6.20
>=20
> +#ifdef CONFIG_DEBUG_SHIRQ
> +       if (irqflags & IRQF_SHARED) {
> +               /*
> +                * It's a shared IRQ -- the driver ought to be
> prepared for it +                * to happen immediately, so let's
> make sure.... +                * We do this before actually
> registering it, to make sure that +                * a 'real' IRQ
> doesn't run in parallel with our fake +                */
> +               if (irqflags & IRQF_DISABLED) {
> +                       unsigned long flags;
> +
> +                       local_irq_save(flags);
> +                       handler(irq, dev_id);
> +                       local_irq_restore(flags);
> +               } else
> +                       handler(irq, dev_id);
> +       }
> +#endif
>=20
> I don't have a clue why the e1000 wasn't ready though.
>=20

our code is clearly calling request_irq before we have assigned the
function pointer adapter->clean_rx as well as adapter->alloc_rx_buf

That would be a bug, a possible patch would be (inline and attached):
compile tested, *but* I couldn't test this patch to make sure it worked
because I couldn't boot 2.6.20-git due to it not finding my RAID0 + lvm
disk.

[PATCH] e1000: fix shared interrupt warning message

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---

 drivers/net/e1000/e1000_main.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/e1000/e1000_main.c
b/drivers/net/e1000/e1000_main.c
index 619c892..b8c4d5c 100644
--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -1417,10 +1417,6 @@ e1000_open(struct net_device *netdev)
        if ((err =3D e1000_setup_all_rx_resources(adapter)))
                goto err_setup_rx;

-       err =3D e1000_request_irq(adapter);
-       if (err)
-               goto err_req_irq;
-
        e1000_power_up_phy(adapter);

        if ((err =3D e1000_up(adapter)))
@@ -1431,6 +1427,10 @@ e1000_open(struct net_device *netdev)
                e1000_update_mng_vlan(adapter);
        }

+       err =3D e1000_request_irq(adapter);
+       if (err)
+               goto err_req_irq;
+
        /* If AMT is enabled, let the firmware know that the network
         * interface is now open */
        if (adapter->hw.mac_type =3D=3D e1000_82573 &&
@@ -1439,10 +1439,11 @@ e1000_open(struct net_device *netdev)

        return E1000_SUCCESS;

+err_req_irq:
+       e1000_down(adapter);
+       e1000_free_irq(adapter);
 err_up:
        e1000_power_down_phy(adapter);
-       e1000_free_irq(adapter);
-err_req_irq:
        e1000_free_all_rx_resources(adapter);
 err_setup_rx:
        e1000_free_all_tx_resources(adapter);

------_=_NextPart_001_01C7516F.B06F8DE1
Content-Type: application/octet-stream;
	name="e1000_interrupt.patch"
Content-Transfer-Encoding: base64
Content-Description: e1000_interrupt.patch
Content-Disposition: attachment;
	filename="e1000_interrupt.patch"

W1BBVENIXSBlMTAwMDogZml4IHNoYXJlZCBpbnRlcnJ1cHQgd2FybmluZyBtZXNzYWdlCgpGcm9t
OiBKZXNzZSBCcmFuZGVidXJnIDxqZXNzZS5icmFuZGVidXJnQGludGVsLmNvbT4KClNpZ25lZC1v
ZmYtYnk6IEplc3NlIEJyYW5kZWJ1cmcgPGplc3NlLmJyYW5kZWJ1cmdAaW50ZWwuY29tPgotLS0K
CiBkcml2ZXJzL25ldC9lMTAwMC9lMTAwMF9tYWluLmMgfCAgIDEzICsrKysrKystLS0tLS0KIDEg
ZmlsZXMgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbmV0L2UxMDAwL2UxMDAwX21haW4uYyBiL2RyaXZlcnMvbmV0L2UxMDAwL2Ux
MDAwX21haW4uYwppbmRleCA2MTljODkyLi5iOGM0ZDVjIDEwMDY0NAotLS0gYS9kcml2ZXJzL25l
dC9lMTAwMC9lMTAwMF9tYWluLmMKKysrIGIvZHJpdmVycy9uZXQvZTEwMDAvZTEwMDBfbWFpbi5j
CkBAIC0xNDE3LDEwICsxNDE3LDYgQEAgZTEwMDBfb3BlbihzdHJ1Y3QgbmV0X2RldmljZSAqbmV0
ZGV2KQogCWlmICgoZXJyID0gZTEwMDBfc2V0dXBfYWxsX3J4X3Jlc291cmNlcyhhZGFwdGVyKSkp
CiAJCWdvdG8gZXJyX3NldHVwX3J4OwogCi0JZXJyID0gZTEwMDBfcmVxdWVzdF9pcnEoYWRhcHRl
cik7Ci0JaWYgKGVycikKLQkJZ290byBlcnJfcmVxX2lycTsKLQogCWUxMDAwX3Bvd2VyX3VwX3Bo
eShhZGFwdGVyKTsKIAogCWlmICgoZXJyID0gZTEwMDBfdXAoYWRhcHRlcikpKQpAQCAtMTQzMSw2
ICsxNDI3LDEwIEBAIGUxMDAwX29wZW4oc3RydWN0IG5ldF9kZXZpY2UgKm5ldGRldikKIAkJZTEw
MDBfdXBkYXRlX21uZ192bGFuKGFkYXB0ZXIpOwogCX0KIAorCWVyciA9IGUxMDAwX3JlcXVlc3Rf
aXJxKGFkYXB0ZXIpOworCWlmIChlcnIpCisJCWdvdG8gZXJyX3JlcV9pcnE7CisKIAkvKiBJZiBB
TVQgaXMgZW5hYmxlZCwgbGV0IHRoZSBmaXJtd2FyZSBrbm93IHRoYXQgdGhlIG5ldHdvcmsKIAkg
KiBpbnRlcmZhY2UgaXMgbm93IG9wZW4gKi8KIAlpZiAoYWRhcHRlci0+aHcubWFjX3R5cGUgPT0g
ZTEwMDBfODI1NzMgJiYKQEAgLTE0MzksMTAgKzE0MzksMTEgQEAgZTEwMDBfb3BlbihzdHJ1Y3Qg
bmV0X2RldmljZSAqbmV0ZGV2KQogCiAJcmV0dXJuIEUxMDAwX1NVQ0NFU1M7CiAKK2Vycl9yZXFf
aXJxOgorCWUxMDAwX2Rvd24oYWRhcHRlcik7CisJZTEwMDBfZnJlZV9pcnEoYWRhcHRlcik7CiBl
cnJfdXA6CiAJZTEwMDBfcG93ZXJfZG93bl9waHkoYWRhcHRlcik7Ci0JZTEwMDBfZnJlZV9pcnEo
YWRhcHRlcik7Ci1lcnJfcmVxX2lycToKIAllMTAwMF9mcmVlX2FsbF9yeF9yZXNvdXJjZXMoYWRh
cHRlcik7CiBlcnJfc2V0dXBfcng6CiAJZTEwMDBfZnJlZV9hbGxfdHhfcmVzb3VyY2VzKGFkYXB0
ZXIpOwo=

------_=_NextPart_001_01C7516F.B06F8DE1--
