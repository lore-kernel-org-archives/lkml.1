Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbYHSBNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbYHSBNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 21:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbYHSBNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 21:13:37 -0400
Received: from mga10.intel.com ([192.55.52.92]:25195 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752332AbYHSBNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 21:13:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,231,1217833200"; 
   d="scan'208,223";a="371715349"
Message-ID: <48AA1E42.6070802@linux.intel.com>
Date: Tue, 19 Aug 2008 03:13:38 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
       Philippe Elie <phil.el@wanadoo.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: oprofile + hibernation = badness
References: <19f34abd0808181332k3c02496auabd04e927bb7cab5@mail.gmail.com>
In-Reply-To: <19f34abd0808181332k3c02496auabd04e927bb7cab5@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------000107090008080504020008"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000107090008080504020008
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


> 
> These keep on coming all through the suspend/shutdown sequence, also
> intermixing with other messages. I'm guessing oprofile is trying to
> NMI CPUs that have been brought down?

That should actually work in theory. Linux CPU offlining puts CPUs in a state where
they can still process NMIs. Hmm actually there was a change recently to free
their exception stacks. Maybe it's broken now.

Also oprofile has a suspend method that disables NMIs.

> Now I get some ACPI Exceptions, but I think that these are unrelated
> to starting oprofile, because I have seen them on regular shutdowns as
> well:
> 
> PM: Syncing filesystems ... done.
> Freezing user space processes ... (elapsed 0.00 seconds) done.
> Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
> PM: Shrinking memory... done (0 pages freed)
> PM: Freed 0 kbytes in 0.44 seconds (0.00 MB/s)
> Suspending console(s) (use no_console_suspend to debug)
> ACPI Exception (exoparg2-0444): AE_AML_PACKAGE_LIMIT, Index
> (000000007) is beyond end of object [20080609]
> ACPI Error (psparse-0530): Method parse/execution failed
> [\_SB_.PCI0.IDE0.GTM_] (Node f783bfc0), AE_AML_PACKAGE_LIMIT
> ACPI Error (psparse-0530): Method parse/execution failed
> [\_SB_.PCI0.IDE0.CHN0._GTM] (Node f783bb40), AE_AML_PACKAGE_LIMIT
> ACPI handle has no context!
> serial 00:0d: disabled
> serial 00:06: disabled
> ehci_hcd 0000:00:1d.7: PCI INT A disabled
> uhci_hcd 0000:00:1d.3: PCI INT D disabled
> uhci_hcd 0000:00:1d.2: PCI INT C disabled
> uhci_hcd 0000:00:1d.1: PCI INT B disabled
> uhci_hcd 0000:00:1d.0: PCI INT A disabled
> ACPI: Preparing to enter system sleep state S4
> 
> After that, I see the message "WQ on CPU0, prefer CPU1" a few times.
> This must also be bad.
> 
> Now some warnings:
> 
> ------------[ cut here ]------------
> WARNING: at /uio/arkimedes/s29/vegardno/git-working/linux-2.6/kernel/smp.c:328 s
> mp_call_function_mask+0x194/0x1a0()

The usual problem: the suspend function when interrupts are
already disabled calls smp_call_function which is not allowed with
interrupt off. But at this point all the other CPUs should be already
down anyways, so it should be enough to just drop that.

This patch should fix that problem at least by fixing cpu hotplug&
suspend support. Untested.

-Andi


--------------000107090008080504020008
Content-Type: text/plain;
 name="0001-oprofile-fix-cpu-hotcplug.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="0001-oprofile-fix-cpu-hotcplug.patch"

RnJvbSAzOTY3YThiMDNhMzBmMjZhNmE1ZjQxYjRjYzZhNjc3MmI1ZDBjZTRmIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBBbmRpIEtsZWVuIDxha0BsaW51eC5pbnRlbC5jb20+
CkRhdGU6IFR1ZSwgMTkgQXVnIDIwMDggMDM6MTA6MDMgKzAyMDAKU3ViamVjdDogW1BBVENI
XSBvcHJvZmlsZTogZml4IGNwdSBob3RjcGx1ZwoKU2lnbmVkLW9mZi1ieTogQW5kaSBLbGVl
biA8YWtAbGludXguaW50ZWwuY29tPgotLS0KIGFyY2gveDg2L29wcm9maWxlL25taV9pbnQu
YyB8ICAgNDAgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLQogMSBm
aWxlcyBjaGFuZ2VkLCAzNyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL2FyY2gveDg2L29wcm9maWxlL25taV9pbnQuYyBiL2FyY2gveDg2L29wcm9maWxl
L25taV9pbnQuYwppbmRleCA1MjlkNjI1Li42NDM4YzMyIDEwMDY0NAotLS0gYS9hcmNoL3g4
Ni9vcHJvZmlsZS9ubWlfaW50LmMKKysrIGIvYXJjaC94ODYvb3Byb2ZpbGUvbm1pX2ludC5j
CkBAIC0xNSw2ICsxNSw3IEBACiAjaW5jbHVkZSA8bGludXgvc2xhYi5oPgogI2luY2x1ZGUg
PGxpbnV4L21vZHVsZXBhcmFtLmg+CiAjaW5jbHVkZSA8bGludXgva2RlYnVnLmg+CisjaW5j
bHVkZSA8bGludXgvY3B1Lmg+CiAjaW5jbHVkZSA8YXNtL25taS5oPgogI2luY2x1ZGUgPGFz
bS9tc3IuaD4KICNpbmNsdWRlIDxhc20vYXBpYy5oPgpAQCAtMjgsMjMgKzI5LDQ4IEBAIHN0
YXRpYyBERUZJTkVfUEVSX0NQVSh1bnNpZ25lZCBsb25nLCBzYXZlZF9sdnRwYyk7CiAKIHN0
YXRpYyBpbnQgbm1pX3N0YXJ0KHZvaWQpOwogc3RhdGljIHZvaWQgbm1pX3N0b3Aodm9pZCk7
CitzdGF0aWMgdm9pZCBubWlfY3B1X3N0YXJ0KHZvaWQgKmR1bW15KTsKK3N0YXRpYyB2b2lk
IG5taV9jcHVfc3RvcCh2b2lkICpkdW1teSk7CiAKIC8qIDAgPT0gcmVnaXN0ZXJlZCBidXQg
b2ZmLCAxID09IHJlZ2lzdGVyZWQgYW5kIG9uICovCiBzdGF0aWMgaW50IG5taV9lbmFibGVk
ID0gMDsKIAorI2lmZGVmIENPTkZJR19TTVAKK3N0YXRpYyBpbnQgb3Byb2ZpbGVfY3B1X25v
dGlmaWVyKHN0cnVjdCBub3RpZmllcl9ibG9jayAqYiwgdW5zaWduZWQgbG9uZyBhY3Rpb24s
CisJCQkJIHZvaWQgKmRhdGEpCit7CisJaW50IGNwdSA9ICh1bnNpZ25lZCBsb25nKWRhdGE7
CisJc3dpdGNoIChhY3Rpb24pIHsgCisJY2FzZSBDUFVfRE9XTl9GQUlMRUQ6CisJY2FzZSBD
UFVfT05MSU5FOgorCQlzbXBfY2FsbF9mdW5jdGlvbl9zaW5nbGUoY3B1LCBubWlfY3B1X3N0
YXJ0LCBOVUxMLCAwKTsKKwkJYnJlYWs7CisJY2FzZSBDUFVfRE9XTl9QUkVQQVJFOgorCQlz
bXBfY2FsbF9mdW5jdGlvbl9zaW5nbGUoY3B1LCBubWlfY3B1X3N0b3AsIE5VTEwsIDEpOwor
CQlicmVhazsKKwl9CisJcmV0dXJuIE5PVElGWV9ET05FOworfQorCitzdGF0aWMgc3RydWN0
IG5vdGlmaWVyX2Jsb2NrIG9wcm9maWxlX2NwdV9uYiA9IHsgCisJLm5vdGlmaWVyX2NhbGwg
PSBvcHJvZmlsZV9jcHVfbm90aWZpZXIKK307CQorI2VuZGlmCisKICNpZmRlZiBDT05GSUdf
UE0KIAogc3RhdGljIGludCBubWlfc3VzcGVuZChzdHJ1Y3Qgc3lzX2RldmljZSAqZGV2LCBw
bV9tZXNzYWdlX3Qgc3RhdGUpCiB7CisJLyogT25seSBvbmUgQ1BVIGxlZnQsIGp1c3Qgc3Rv
cCB0aGF0IG9uZSAqLwogCWlmIChubWlfZW5hYmxlZCA9PSAxKQotCQlubWlfc3RvcCgpOwor
CQlubWlfY3B1X3N0b3AoTlVMTCk7CiAJcmV0dXJuIDA7CiB9CiAKIHN0YXRpYyBpbnQgbm1p
X3Jlc3VtZShzdHJ1Y3Qgc3lzX2RldmljZSAqZGV2KQogewogCWlmIChubWlfZW5hYmxlZCA9
PSAxKQotCQlubWlfc3RhcnQoKTsKKwkJbm1pX2NwdV9zdGFydChOVUxMKTsKIAlyZXR1cm4g
MDsKIH0KIApAQCAtNjYsNiArOTIsNyBAQCBzdGF0aWMgaW50IF9faW5pdCBpbml0X3N5c2Zz
KHZvaWQpCiAJZXJyb3IgPSBzeXNkZXZfY2xhc3NfcmVnaXN0ZXIoJm9wcm9maWxlX3N5c2Ns
YXNzKTsKIAlpZiAoIWVycm9yKQogCQllcnJvciA9IHN5c2Rldl9yZWdpc3RlcigmZGV2aWNl
X29wcm9maWxlKTsKKwkKIAlyZXR1cm4gZXJyb3I7CiB9CiAKQEAgLTQ4Myw2ICs1MTAsOSBA
QCBpbnQgX19pbml0IG9wX25taV9pbml0KHN0cnVjdCBvcHJvZmlsZV9vcGVyYXRpb25zICpv
cHMpCiAJfQogCiAJaW5pdF9zeXNmcygpOworI2lmZGVmIENPTkZJR19TTVAKKwlyZWdpc3Rl
cl9jcHVfbm90aWZpZXIoJm9wcm9maWxlX2NwdV9uYik7CisjZW5kaWYKIAl1c2luZ19ubWkg
PSAxOwogCW9wcy0+Y3JlYXRlX2ZpbGVzID0gbm1pX2NyZWF0ZV9maWxlczsKIAlvcHMtPnNl
dHVwID0gbm1pX3NldHVwOwpAQCAtNDk2LDYgKzUyNiwxMCBAQCBpbnQgX19pbml0IG9wX25t
aV9pbml0KHN0cnVjdCBvcHJvZmlsZV9vcGVyYXRpb25zICpvcHMpCiAKIHZvaWQgb3Bfbm1p
X2V4aXQodm9pZCkKIHsKLQlpZiAodXNpbmdfbm1pKQorCWlmICh1c2luZ19ubWkpIHsgCiAJ
CWV4aXRfc3lzZnMoKTsKKyNpZmRlZiBDT05GSUdfU01QCisJCXVucmVnaXN0ZXJfY3B1X25v
dGlmaWVyKCZvcHJvZmlsZV9jcHVfbmIpOworI2VuZGlmCisJfQogfQotLSAKMS41LjYKCg==
--------------000107090008080504020008--
