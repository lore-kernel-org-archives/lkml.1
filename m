Return-Path: <linux-kernel-owner+w=401wt.eu-S1758221AbXGVAup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221AbXGVAup (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 20:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757730AbXGVAtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 20:49:43 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:18518 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757608AbXGVAtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 20:49:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=iI7kiUmT1OuVTunJzKQDkRkJWH+G0tEHHqUlAFRncbpTN/uWH09ZAOWTtjkLuv6347+/aTndBeI05F7AAgHqMwRA7//1u/LzuhnzxIF0WbgE1OcxWt2Xb/LRVq2EVuLU4o1Vc72TxNCIYa/WTN7oEXhkeXrWa9kdb9UIPosurwQ=
Message-ID: <86802c440707211749x3258891fhbb72a155dc484e86@mail.gmail.com>
Date: Sat, 21 Jul 2007 17:49:41 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>
Subject: [PATCH 3/3] x86_64: offset apicid_to_node before use it before init_cpu_to_node
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_141656_29632225.1185065381185"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_141656_29632225.1185065381185
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

[PATCH 3/3] x86_64: offset apicid_to_node before use it before init_cpu_to_node

When acpi=off or there is no SRAT defined, apicid_to_node is got from K8
Northbridge PCI configuration space in k8_scan_nodes() in
arch/x86_64/mm/k8toplogy.c.
The problem is that it assumes bsp apic id is 0 at that point.
For four socket system with Quad core cpus installed, all cpus apic id
is offset by 4, and bsp apic id is 4.
For eight socket system with dual core cpus installed, all cpus apic id
is offset by 2, and bsp apic id is 2.
We need offset apicid_to_node array according to boot_cpu_id.--- bsp apic id.
before we use apicid_to_node array.
boot_cpu_id is only valid init_apic_mappings.

So do update_apicid_to_node and init_cpu_to_node after init_apic_mappings

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

 arch/x86_64/kernel/setup.c |   10 ++++++++--
 arch/x86_64/mm/numa.c      |   24 ++++++++++++++++++++++++
 include/asm-x86_64/numa.h  |    2 ++
 3 files changed, 34 insertions(+), 2 deletions(-)

------=_Part_141656_29632225.1185065381185
Content-Type: text/x-patch; name=3.patch; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f4etup8c
Content-Disposition: attachment; filename="3.patch"

CmRpZmYgLS1naXQgYS9hcmNoL3g4Nl82NC9rZXJuZWwvc2V0dXAuYyBiL2FyY2gveDg2XzY0L2tl
cm5lbC9zZXR1cC5jCmluZGV4IDMzZWY3MTguLjE4NjJhOTEgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2
XzY0L2tlcm5lbC9zZXR1cC5jCisrKyBiL2FyY2gveDg2XzY0L2tlcm5lbC9zZXR1cC5jCkBAIC0z
ODUsOCArMzg1LDYgQEAgdm9pZCBfX2luaXQgc2V0dXBfYXJjaChjaGFyICoqY21kbGluZV9wKQog
CWFjcGlfYm9vdF9pbml0KCk7CiAjZW5kaWYKIAotCWluaXRfY3B1X3RvX25vZGUoKTsKLQogCS8q
CiAJICogZ2V0IGJvb3QtdGltZSBTTVAgY29uZmlndXJhdGlvbjoKIAkgKi8KQEAgLTM5NSw2ICsz
OTMsMTQgQEAgdm9pZCBfX2luaXQgc2V0dXBfYXJjaChjaGFyICoqY21kbGluZV9wKQogCWluaXRf
YXBpY19tYXBwaW5ncygpOwogCiAJLyoKKwkgKiBuZWVkIHRvIHB1dCBpbml0X2NwdV90b19ub2Rl
IGFmdGVyIGluaXRfYXBpY19tYXBwaW5ncworCSAqIHdlIG5lZWQgdG8gZ2V0IGJvb3RfY3B1X2lk
ICh0aGUgQlNQIGFwaWMgaWQpIHRvIG1vZGlmeQorCSAqIGFwaWNpZF90b19ub2RlIGFycmF5LCBi
ZWZvcmUgaW5pdF9jcHVfbm9kZQorCSAqLworCXVwZGF0ZV9hcGljaWRfdG9fbm9kZSgpOworCWlu
aXRfY3B1X3RvX25vZGUoKTsKKworCS8qCiAJICogV2UgdHJ1c3QgZTgyMCBjb21wbGV0ZWx5LiBO
byBleHBsaWNpdCBST00gcHJvYmluZyBpbiBtZW1vcnkuCiAgCSAqLwogCWU4MjBfcmVzZXJ2ZV9y
ZXNvdXJjZXMoKTsgCmRpZmYgLS1naXQgYS9hcmNoL3g4Nl82NC9tbS9udW1hLmMgYi9hcmNoL3g4
Nl82NC9tbS9udW1hLmMKaW5kZXggNTE1NDg5NC4uOTE2MDVhYSAxMDA2NDQKLS0tIGEvYXJjaC94
ODZfNjQvbW0vbnVtYS5jCisrKyBiL2FyY2gveDg2XzY0L21tL251bWEuYwpAQCAtNjA3LDYgKzYw
NywzMCBAQCBlYXJseV9wYXJhbSgibnVtYSIsIG51bWFfc2V0dXApOwogICogcHJpb3IgdG8gdGhp
cyBjYWxsLCBhbmQgdGhpcyBpbml0aWFsaXphdGlvbiBpcyBnb29kIGVub3VnaAogICogZm9yIHRo
ZSBmYWtlIE5VTUEgY2FzZXMuCiAgKi8KK3ZvaWQgX19pbml0IHVwZGF0ZV9hcGljaWRfdG9fbm9k
ZSh2b2lkKQoreworCS8qCisJICogbGV0IG1vZGlmeSBhcGljaWRfdG9fbm9kZSBhcnJheSB3aGVu
IGJvb3RfY3B1X2lkICE9MAorCSAqIGFwaWNpZF90b19ub2RlWzBdICE9IE5VTUFfTk9ERQorCSAq
LworCisJaW50IGk7CisKKwkvKiB0aGVyZSBpcyBubyBhcGljIGlkIG9mZnNldCAqLworCWlmICgh
Ym9vdF9jcHVfaWQpCisJCXJldHVybjsKKworCS8qIGNoZWNrIGlmIGl0IGlzIGFscmVhZHkgdXBk
YXRlZCAqLworCWlmIChhcGljaWRfdG9fbm9kZVswXSA9PSBOVU1BX05PX05PREUpCisJCXJldHVy
bjsKKworCWZvciAoaSA9IE5SX0NQVVMgLTE7IGkgPj0gYm9vdF9jcHVfaWQ7IGktLSkKKwkJYXBp
Y2lkX3RvX25vZGVbaV0gPSBhcGljaWRfdG9fbm9kZVtpIC0gYm9vdF9jcHVfaWRdOworCisJZm9y
IChpID0gYm9vdF9jcHVfaWQgLSAxOyBpID49IDA7IGktLSkKKwkJYXBpY2lkX3RvX25vZGVbaV0g
PSBOVU1BX05PX05PREU7CisKK30KIHZvaWQgX19pbml0IGluaXRfY3B1X3RvX25vZGUodm9pZCkK
IHsKIAlpbnQgaTsKZGlmZiAtLWdpdCBhL2luY2x1ZGUvYXNtLXg4Nl82NC9udW1hLmggYi9pbmNs
dWRlL2FzbS14ODZfNjQvbnVtYS5oCmluZGV4IDkzM2ZmMTEuLjI4MmI3YTcgMTAwNjQ0Ci0tLSBh
L2luY2x1ZGUvYXNtLXg4Nl82NC9udW1hLmgKKysrIGIvaW5jbHVkZS9hc20teDg2XzY0L251bWEu
aApAQCAtMjEsNiArMjEsNyBAQCBleHRlcm4gaW50IGhvdGFkZF9wZXJjZW50OwogCiBleHRlcm4g
dW5zaWduZWQgY2hhciBhcGljaWRfdG9fbm9kZVsyNTZdOwogI2lmZGVmIENPTkZJR19OVU1BCitl
eHRlcm4gdm9pZCBfX2luaXQgdXBkYXRlX2FwaWNpZF90b19ub2RlKHZvaWQpOwogZXh0ZXJuIHZv
aWQgX19pbml0IGluaXRfY3B1X3RvX25vZGUodm9pZCk7CiAKIHN0YXRpYyBpbmxpbmUgdm9pZCBj
bGVhcl9ub2RlX2NwdW1hc2soaW50IGNwdSkKQEAgLTI5LDYgKzMwLDcgQEAgc3RhdGljIGlubGlu
ZSB2b2lkIGNsZWFyX25vZGVfY3B1bWFzayhpbnQgY3B1KQogfQogCiAjZWxzZQorI2RlZmluZSB1
cGRhdGVfYXBpY2lkX3RvX25vZGUoKSBkbyB7fSB3aGlsZSAoMCkKICNkZWZpbmUgaW5pdF9jcHVf
dG9fbm9kZSgpIGRvIHt9IHdoaWxlICgwKQogI2RlZmluZSBjbGVhcl9ub2RlX2NwdW1hc2soY3B1
KSBkbyB7fSB3aGlsZSAoMCkKICNlbmRpZgo=
------=_Part_141656_29632225.1185065381185--
