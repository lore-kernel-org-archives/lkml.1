Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbYJ1MGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbYJ1MGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 08:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbYJ1MGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 08:06:07 -0400
Received: from hs-out-0708.google.com ([64.233.178.242]:47870 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbYJ1MGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 08:06:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=gdt76pP4noElcDs/ynbjaDU8Y7EMDw9f1j/4O4qg/wFFvUnCy8pjeBuRWXC6Ha0hxf
         EbTHLmIg8xSX19CXXcJ9nGt1HGNkC35Loz3hmRzCbbXxVQYaGMzCutmWu5/WK0T7VUDF
         QshhsmPA4NcIYToJUyTZckOOMGVLZLWjiBot0=
Message-ID: <87a5b0800810280506h71fd6508i9474917b0ef0b191@mail.gmail.com>
Date: Tue, 28 Oct 2008 12:06:00 +0000
From: "Will Newton" <will.newton@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/net/smc911x.c: Fix lockdep warning on xmit.
Cc: netdev <netdev@vger.kernel.org>, "Jeff Garzik" <jeff@garzik.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_36537_9124936.1225195560682"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_36537_9124936.1225195560682
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

>From 0e3ec7f78e115533e4aca9ac067acbc33eb0a21f Mon Sep 17 00:00:00 2001
From: Will Newton <will.newton@gmail.com>
Date: Tue, 28 Oct 2008 10:52:36 +0000
Subject: [PATCH] drivers/net/smc911x.c: Fix lockdep warning on xmit.

dev_kfree_skb should not be called with irqs disabled, use dev_kfree_skb_irq
instead. The warning caused looks like this:

======================================================
[ INFO: hard-safe -> hard-unsafe lock order detected ]
2.6.28-rc1 #273
------------------------------------------------------
swapper/0 [HC0[0]:SC1[2]:HE0:SE0] is trying to acquire:
 (clock-AF_INET){-..+}, at: [<4015c17c>] _sock_def_write_space+0x28/0xd8

and this task is already holding:
 (&lp->lock){++..}, at: [<4013f230>] _smc911x_hard_start_xmit+0x30/0x4b8
which would create a new lock dependency:
 (&lp->lock){++..} -> (clock-AF_INET){-..+}

Signed-off-by: Will Newton <will.newton@gmail.com>
---
 drivers/net/smc911x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/smc911x.c b/drivers/net/smc911x.c
index f59c777..5051554 100644
--- a/drivers/net/smc911x.c
+++ b/drivers/net/smc911x.c
@@ -499,7 +499,7 @@ static void smc911x_hardware_send_pkt(struct
net_device *dev)
 #else
 	SMC_PUSH_DATA(lp, buf, len);
 	dev->trans_start = jiffies;
-	dev_kfree_skb(skb);
+	dev_kfree_skb_irq(skb);
 #endif
 	if (!lp->tx_throttle) {
 		netif_wake_queue(dev);
-- 
1.5.5.2

------=_Part_36537_9124936.1225195560682
Content-Type: text/x-diff;
 name=0001-drivers-net-smc911x.c-Fix-lockdep-warning-on-xmit.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fmuhsg0n0
Content-Disposition: attachment;
 filename=0001-drivers-net-smc911x.c-Fix-lockdep-warning-on-xmit.patch

RnJvbSAwZTNlYzdmNzhlMTE1NTMzZTRhY2E5YWMwNjdhY2JjMzNlYjBhMjFmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBXaWxsIE5ld3RvbiA8d2lsbC5uZXd0b25AZ21haWwuY29tPgpE
YXRlOiBUdWUsIDI4IE9jdCAyMDA4IDEwOjUyOjM2ICswMDAwClN1YmplY3Q6IFtQQVRDSF0gZHJp
dmVycy9uZXQvc21jOTExeC5jOiBGaXggbG9ja2RlcCB3YXJuaW5nIG9uIHhtaXQuCgpkZXZfa2Zy
ZWVfc2tiIHNob3VsZCBub3QgYmUgY2FsbGVkIHdpdGggaXJxcyBkaXNhYmxlZCwgdXNlIGRldl9r
ZnJlZV9za2JfaXJxCmluc3RlYWQuIFRoZSB3YXJuaW5nIGNhdXNlZCBsb29rcyBsaWtlIHRoaXM6
Cgo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0K
WyBJTkZPOiBoYXJkLXNhZmUgLT4gaGFyZC11bnNhZmUgbG9jayBvcmRlciBkZXRlY3RlZCBdCjIu
Ni4yOC1yYzEgIzI3MwotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0Kc3dhcHBlci8wIFtIQzBbMF06U0MxWzJdOkhFMDpTRTBdIGlzIHRyeWluZyB0
byBhY3F1aXJlOgogKGNsb2NrLUFGX0lORVQpey0uLit9LCBhdDogWzw0MDE1YzE3Yz5dIF9zb2Nr
X2RlZl93cml0ZV9zcGFjZSsweDI4LzB4ZDgKCmFuZCB0aGlzIHRhc2sgaXMgYWxyZWFkeSBob2xk
aW5nOgogKCZscC0+bG9jayl7KysuLn0sIGF0OiBbPDQwMTNmMjMwPl0gX3NtYzkxMXhfaGFyZF9z
dGFydF94bWl0KzB4MzAvMHg0YjgKd2hpY2ggd291bGQgY3JlYXRlIGEgbmV3IGxvY2sgZGVwZW5k
ZW5jeToKICgmbHAtPmxvY2speysrLi59IC0+IChjbG9jay1BRl9JTkVUKXstLi4rfQoKU2lnbmVk
LW9mZi1ieTogV2lsbCBOZXd0b24gPHdpbGwubmV3dG9uQGdtYWlsLmNvbT4KLS0tCiBkcml2ZXJz
L25ldC9zbWM5MTF4LmMgfCAgICAyICstCiAxIGZpbGVzIGNoYW5nZWQsIDEgaW5zZXJ0aW9ucygr
KSwgMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9zbWM5MTF4LmMgYi9k
cml2ZXJzL25ldC9zbWM5MTF4LmMKaW5kZXggZjU5Yzc3Ny4uNTA1MTU1NCAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9uZXQvc21jOTExeC5jCisrKyBiL2RyaXZlcnMvbmV0L3NtYzkxMXguYwpAQCAtNDk5
LDcgKzQ5OSw3IEBAIHN0YXRpYyB2b2lkIHNtYzkxMXhfaGFyZHdhcmVfc2VuZF9wa3Qoc3RydWN0
IG5ldF9kZXZpY2UgKmRldikKICNlbHNlCiAJU01DX1BVU0hfREFUQShscCwgYnVmLCBsZW4pOwog
CWRldi0+dHJhbnNfc3RhcnQgPSBqaWZmaWVzOwotCWRldl9rZnJlZV9za2Ioc2tiKTsKKwlkZXZf
a2ZyZWVfc2tiX2lycShza2IpOwogI2VuZGlmCiAJaWYgKCFscC0+dHhfdGhyb3R0bGUpIHsKIAkJ
bmV0aWZfd2FrZV9xdWV1ZShkZXYpOwotLSAKMS41LjUuMgoK
------=_Part_36537_9124936.1225195560682--
