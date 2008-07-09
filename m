Return-Path: <linux-kernel-owner+w=401wt.eu-S1756573AbYGIIhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbYGIIhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 04:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbYGIIh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 04:37:29 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:4801 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbYGIIh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 04:37:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=XPCr0YS8r1jVkA/dvccE6rSIa2Zr63ZMSdwtvHEzobUli508drBsU32yV0pvkfIDec
         3Z8g3oF6Zhur63AVIgSLoNRLyVW9L66nRoLKn5HIK9c+qSoFP2U/2uk9t5kEDV4NfLOs
         OH9Nja1zSBaVe7V3IYRJKbtIssepjBRkNGQtU=
Message-ID: <86802c440807090137t41734ac3l25f565cf5efb3e7b@mail.gmail.com>
Date: Wed, 9 Jul 2008 01:37:27 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: not overmap than end in init_memory_mapping - 64bit
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080709083425.GA23952@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_29359_11628213.1215592647132"
References: <200807080141.05436.yhlu.kernel@gmail.com>
	 <200807080143.27997.yhlu.kernel@gmail.com>
	 <20080709073844.GB30428@elte.hu> <20080709083425.GA23952@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_29359_11628213.1215592647132
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, Jul 9, 2008 at 1:34 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>> > handle head and tail that can not aligned to big pages.
>> >
>> > with this patch, on system that support gbpages
>> > change
>> > last_map_addr: 1080000000 end: 1078000000
>> > to
>> > last_map_addr: 1078000000 end: 1078000000
>> >
>> > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>
>> applied to tip/x86/core, thanks Yinghai.
>
> found an early boot crash on a testbox:
>
> [    0.000000] last_pfn = 0x3fff0 max_arch_pfn = 0x3ffffffff
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] init_memory_mapping
> [    0.000000] kernel direct mapping tables up to 3fff0000 @ 8000-b000
> [    0.000000] last_map_addr: 40000000 end: 3fff0000
> [    0.000000] ACPI: RSDP 000F76F0, 0014 (r0 Nvidia)
> PANIC: early exception 0e rip 10:ffffffff803d3b8a error 0 cr2 ffff88003fff3040
> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.26-rc9-tip-00118-g95f03c7-dirty #16954
> [    0.000000]
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff80c05196>] early_idt_handler+0x56/0x6a
> [    0.000000]  [<ffffffff803d3b8a>] ? acpi_tb_print_table_header+0xe/0xd5
> [    0.000000]  [<ffffffff803d3bfc>] ? acpi_tb_print_table_header+0x80/0xd5
> [    0.000000]  [<ffffffff803d42f4>] ? acpi_tb_scan_memory_for_rsdp+0xc8/0xd3
>
> i bisected it down to:
>
> |  a1007454854803f6fc63f0a881518cea87df6d9a is first bad commit
> |  commit a1007454854803f6fc63f0a881518cea87df6d9a
> |  Author: Yinghai Lu <yhlu.kernel@gmail.com>
> |  Date:   Tue Jul 8 01:43:27 2008 -0700
> |
> |      x86: not overmap more than the end of RAM in init_memory_mapping - 64bit
>
> with this config:
>
>  http://redhat.com/~mingo/misc/config-Wed_Jul__9_09_43_06_CEST_2008.bad
>
> crashlog:
>
>  http://redhat.com/~mingo/misc/crashlog-Wed_Jul__9_09_43_06_CEST_2008.bad
>
> i've pushed the failing tree out to tip/tmp.x86.Jul__9_09_43
>
> reverting the commit solves the crash. The crash seems to be because
> ACPI is unable to access that memory range. (perhaps early_ioremap
> fails?)

system with less than 4g?

please test attached patch
[PATCH] x86: make max_pfn cover acpi table below 4g

YH

------=_Part_29359_11628213.1215592647132
Content-Type: text/x-patch; name=e820_end.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fifoepuw0
Content-Disposition: attachment; filename=e820_end.patch

W1BBVENIXSB4ODY6IG1ha2UgbWF4X3BmbiBjb3ZlciBhY3BpIHRhYmxlIGJlbG93IDRnCgp3aGVu
IHN5c3RlbSBoYXZlIDRnIGxlc3MgcmFtIGluc3RhbGxlZCwgYW5kIGFjcGkgdGFibGUgc2l0Cm5l
YXIgZW5kIG9mIHJhbS4gbWFrZSBtYXhfcGZuIGNvdmVyIHRoZW0gdG9vLgpzbyA2NGJpdCBrZXJu
ZWwgZG9uJ3QgbmVlZCB0byBtZXNzIHVwIGZpeG1hcC4KClNpZ25lZC1vZmYtYnk6IFlpbmdoYWkg
THUgPHlobHUua2VybmVsQGdtYWlsLmNvbT4KCi0tLQogYXJjaC94ODYva2VybmVsL2U4MjAuYyAg
fCAgIDE4ICsrKysrKysrKysrKy0tLS0tLQogYXJjaC94ODYva2VybmVsL3NldHVwLmMgfCAgIDEz
ICsrKy0tLS0tLS0tLS0KIGluY2x1ZGUvYXNtLXg4Ni9lODIwLmggIHwgICAgMiArLQogMyBmaWxl
cyBjaGFuZ2VkLCAxNiBpbnNlcnRpb25zKCspLCAxNyBkZWxldGlvbnMoLSkKCkluZGV4OiBsaW51
eC0yLjYvYXJjaC94ODYva2VybmVsL2U4MjAuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3Jp
Zy9hcmNoL3g4Ni9rZXJuZWwvZTgyMC5jCisrKyBsaW51eC0yLjYvYXJjaC94ODYva2VybmVsL2U4
MjAuYwpAQCAtMTA1NiwxMiArMTA1NiwyMCBAQCB1bnNpZ25lZCBsb25nIF9faW5pdGRhdGEgZW5k
X3VzZXJfcGZuID0KIC8qCiAgKiBGaW5kIHRoZSBoaWdoZXN0IHBhZ2UgZnJhbWUgbnVtYmVyIHdl
IGhhdmUgYXZhaWxhYmxlCiAgKi8KLXVuc2lnbmVkIGxvbmcgX19pbml0IGU4MjBfZW5kX29mX3Jh
bSh2b2lkKQordW5zaWduZWQgbG9uZyBfX2luaXQgZTgyMF9lbmQodm9pZCkKIHsKLQl1bnNpZ25l
ZCBsb25nIGxhc3RfcGZuOworCWludCBpOworCXVuc2lnbmVkIGxvbmcgbGFzdF9wZm4gPSAwOwog
CXVuc2lnbmVkIGxvbmcgbWF4X2FyY2hfcGZuID0gTUFYX0FSQ0hfUEZOOwogCi0JbGFzdF9wZm4g
PSBmaW5kX21heF9wZm5fd2l0aF9hY3RpdmVfcmVnaW9ucygpOworCWZvciAoaSA9IDA7IGkgPCBl
ODIwLm5yX21hcDsgaSsrKSB7CisJCXN0cnVjdCBlODIwZW50cnkgKmVpID0gJmU4MjAubWFwW2ld
OworCQl1bnNpZ25lZCBsb25nIGVuZF9wZm47CisKKwkJZW5kX3BmbiA9IChlaS0+YWRkciArIGVp
LT5zaXplKSA+PiBQQUdFX1NISUZUOworCQlpZiAoZW5kX3BmbiA+IGxhc3RfcGZuKQorCQkJbGFz
dF9wZm4gPSBlbmRfcGZuOworCX0KIAogCWlmIChsYXN0X3BmbiA+IG1heF9hcmNoX3BmbikKIAkJ
bGFzdF9wZm4gPSBtYXhfYXJjaF9wZm47CkBAIC0xMTkyLDkgKzEyMDAsNyBAQCBzdGF0aWMgaW50
IF9faW5pdCBwYXJzZV9tZW1tYXBfb3B0KGNoYXIKIAkJICogdGhlIHJlYWwgbWVtIHNpemUgYmVm
b3JlIG9yaWdpbmFsIG1lbW9yeSBtYXAgaXMKIAkJICogcmVzZXQuCiAJCSAqLwotCQllODIwX3Jl
Z2lzdGVyX2FjdGl2ZV9yZWdpb25zKDAsIDAsIC0xVUwpOwotCQlzYXZlZF9tYXhfcGZuID0gZTgy
MF9lbmRfb2ZfcmFtKCk7Ci0JCXJlbW92ZV9hbGxfYWN0aXZlX3JhbmdlcygpOworCQlzYXZlZF9t
YXhfcGZuID0gZTgyMF9lbmQoKTsKICNlbmRpZgogCQllODIwLm5yX21hcCA9IDA7CiAJCXVzZXJk
ZWYgPSAxOwpJbmRleDogbGludXgtMi42L2FyY2gveDg2L2tlcm5lbC9zZXR1cC5jCj09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gveDg2L2tlcm5lbC9zZXR1cC5jCisrKyBsaW51eC0y
LjYvYXJjaC94ODYva2VybmVsL3NldHVwLmMKQEAgLTcxNCwyMiArNzE0LDE4IEBAIHZvaWQgX19p
bml0IHNldHVwX2FyY2goY2hhciAqKmNtZGxpbmVfcCkKIAllYXJseV9nYXJ0X2lvbW11X2NoZWNr
KCk7CiAjZW5kaWYKIAotCWU4MjBfcmVnaXN0ZXJfYWN0aXZlX3JlZ2lvbnMoMCwgMCwgLTFVTCk7
CiAJLyoKIAkgKiBwYXJ0aWFsbHkgdXNlZCBwYWdlcyBhcmUgbm90IHVzYWJsZSAtIHRodXMKIAkg
KiB3ZSBhcmUgcm91bmRpbmcgdXB3YXJkczoKIAkgKi8KLQltYXhfcGZuID0gZTgyMF9lbmRfb2Zf
cmFtKCk7CisJbWF4X3BmbiA9IGU4MjBfZW5kKCk7CiAKIAkvKiBwcmVhbGxvY2F0ZSA0ayBmb3Ig
bXB0YWJsZSBtcGMgKi8KIAllYXJseV9yZXNlcnZlX2U4MjBfbXBjX25ldygpOwogCS8qIHVwZGF0
ZSBlODIwIGZvciBtZW1vcnkgbm90IGNvdmVyZWQgYnkgV0IgTVRSUnMgKi8KIAltdHJyX2JwX2lu
aXQoKTsKLQlpZiAobXRycl90cmltX3VuY2FjaGVkX21lbW9yeShtYXhfcGZuKSkgewotCQlyZW1v
dmVfYWxsX2FjdGl2ZV9yYW5nZXMoKTsKLQkJZTgyMF9yZWdpc3Rlcl9hY3RpdmVfcmVnaW9ucygw
LCAwLCAtMVVMKTsKLQkJbWF4X3BmbiA9IGU4MjBfZW5kX29mX3JhbSgpOwotCX0KKwlpZiAobXRy
cl90cmltX3VuY2FjaGVkX21lbW9yeShtYXhfcGZuKSkKKwkJbWF4X3BmbiA9IGU4MjBfZW5kKCk7
CiAKICNpZmRlZiBDT05GSUdfWDg2XzMyCiAJLyogbWF4X2xvd19wZm4gZ2V0IHVwZGF0ZWQgaGVy
ZSAqLwpAQCAtNzcyLDkgKzc2OCw2IEBAIHZvaWQgX19pbml0IHNldHVwX2FyY2goY2hhciAqKmNt
ZGxpbmVfcCkKIAkgKi8KIAlhY3BpX2Jvb3RfdGFibGVfaW5pdCgpOwogCi0JLyogUmVtb3ZlIGFj
dGl2ZSByYW5nZXMgc28gcmVkaXNjb3Zlcnkgd2l0aCBOVU1BLWF3YXJlbmVzcyBoYXBwZW5zICov
Ci0JcmVtb3ZlX2FsbF9hY3RpdmVfcmFuZ2VzKCk7Ci0KICNpZmRlZiBDT05GSUdfQUNQSV9OVU1B
CiAJLyoKIAkgKiBQYXJzZSBTUkFUIHRvIGRpc2NvdmVyIG5vZGVzLgpJbmRleDogbGludXgtMi42
L2luY2x1ZGUvYXNtLXg4Ni9lODIwLmgKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvaW5j
bHVkZS9hc20teDg2L2U4MjAuaAorKysgbGludXgtMi42L2luY2x1ZGUvYXNtLXg4Ni9lODIwLmgK
QEAgLTk5LDcgKzk5LDcgQEAgZXh0ZXJuIHZvaWQgZnJlZV9lYXJseSh1NjQgc3RhcnQsIHU2NCBl
bgogZXh0ZXJuIHZvaWQgZWFybHlfcmVzX3RvX2Jvb3RtZW0odTY0IHN0YXJ0LCB1NjQgZW5kKTsK
IGV4dGVybiB1NjQgZWFybHlfcmVzZXJ2ZV9lODIwKHU2NCBzdGFydHQsIHU2NCBzaXpldCwgdTY0
IGFsaWduKTsKIAotZXh0ZXJuIHVuc2lnbmVkIGxvbmcgZTgyMF9lbmRfb2ZfcmFtKHZvaWQpOwor
ZXh0ZXJuIHVuc2lnbmVkIGxvbmcgZTgyMF9lbmQodm9pZCk7CiBleHRlcm4gaW50IGU4MjBfZmlu
ZF9hY3RpdmVfcmVnaW9uKGNvbnN0IHN0cnVjdCBlODIwZW50cnkgKmVpLAogCQkJCSAgdW5zaWdu
ZWQgbG9uZyBzdGFydF9wZm4sCiAJCQkJICB1bnNpZ25lZCBsb25nIGxhc3RfcGZuLAo=
------=_Part_29359_11628213.1215592647132--
