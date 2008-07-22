Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbYGVIKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbYGVIKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 04:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbYGVIJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 04:09:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:29302 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbYGVIJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 04:09:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=N37Nx73bOB+h0rDUvBEdIF5OuMIB3jQrUu8cIUWgaCu7ioHJa+qzyUe3Ejvt0Mzz/+
         r9I3HF3FWBE0v6iPn5Atb4h0fG8G1IYA8AG8pgWY5OfCP10MMpwwNYnxIqwp9ssNZTRI
         dUvLVyuXLP1cG9a1KPgKESk/iCOzD/R6I78dU=
Message-ID: <86802c440807220109s63307f28uc0658402cb26cfea@mail.gmail.com>
Date: Tue, 22 Jul 2008 01:09:43 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Paul Jackson" <pj@sgi.com>,
       "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH] x86: add apic probe for genapic 64bit v2
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080722071324.GA2664@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_70575_1247777.1216714183128"
References: <200807211836.27282.yhlu.kernel@gmail.com>
	 <200807212208.22116.yhlu.kernel@gmail.com>
	 <20080722070734.GA16085@elte.hu> <20080722071324.GA2664@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_70575_1247777.1216714183128
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tue, Jul 22, 2008 at 12:13 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>> > v2: fix compiling when CONFIG_ACPI is not set
>>
>> applied to tip/x86/x2apic - thanks Yinghai.
>>
>> > +static struct genapic *apic_probe[] __initdata = {
>> > +   &apic_x2apic_uv_x,
>> > +   &apic_x2apic_phys,
>> > +   &apic_x2apic_cluster,
>> > +   &apic_physflat,
>> > +   NULL,
>> > +};
>>
>> very nice generalization!
>
> btw.:
>
>   apic_probe[i]->acpi_madt_oem_check
>
> should probably be renamed to something more neutral like "->probe" -
> there's nothing ACPI about it and some weird boxes could use PCI or
> other probing mechanisms to discover the type of APIC they want to use.

32bit has acpi_madt_oem_check and mps_oem_check
64bit should only have acpi_madt_oem_check

>
> plus i guess genapic_32.h and genapic_64.h should be unified and struct
> apic_ops should be put into struct genapic?

yes.

hope to call acpi_madt_oem_check and mps_oem_check right after
acpi_boot_table_init
to decide apic_ops and genapic as early as possible.


Jack/Mike,
does your big box support SRAT? it seems it calling is_uv_system
before acpi_madt_oem_check is called.
I like to call early_acpi_boot_init, before acpi_numa_init so
acpi_madt_oem_check is called before srat is used. can you check
attached patch on your system?

YH

------=_Part_70575_1247777.1216714183128
Content-Type: text/x-patch; name=early_madt_oem_check.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fiy811nb0
Content-Disposition: attachment; filename=early_madt_oem_check.patch

W1BBVENIXSB4ODY6IGNhbGwgZWFybHlfYWNwaV9ib290X2luaXQgYmVmb3JlIGFjcGlfbnVtYV9p
bml0CgpzbyBjb3VsZCBjYWxsIGFjcGlfbWFkdF9vZW1fY2hlY2sgZWFybHkgdG8gZmluZCBvdXQg
aWYgaXQgdXYgc3lzdGVtLgphbmQgYWNwaV9udW1hX2luaXQgY291bGQgY2FsbCBpc191dl9zeXN0
ZW0oKQoKU2lnbmVkLW9mZi1ieTogWWluZ2hhaSBMdSA8eWhsdS5rZXJuZWxAZ21haWwuY29tPgoK
LS0tCiBhcmNoL3g4Ni9rZXJuZWwvc2V0dXAuYyB8ICAgIDQgKysrKwogMSBmaWxlIGNoYW5nZWQs
IDQgaW5zZXJ0aW9ucygrKQoKSW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9rZXJuZWwvc2V0dXAu
Ywo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9hcmNoL3g4Ni9rZXJuZWwvc2V0dXAuYwor
KysgbGludXgtMi42L2FyY2gveDg2L2tlcm5lbC9zZXR1cC5jCkBAIC03ODUsNiArNzg1LDEwIEBA
IHZvaWQgX19pbml0IHNldHVwX2FyY2goY2hhciAqKmNtZGxpbmVfcCkKIAlhY3BpX2Jvb3RfdGFi
bGVfaW5pdCgpOwogCiAjaWZkZWYgQ09ORklHX0FDUElfTlVNQQorI2lmZGVmIENPTkZJR19YODZf
NjQKKwkvKiB0cnkgdG8gY2FsbCBhY3BpX21hZHRfb2VtX2NoZWNrIGhlcmUgKi8KKwllYXJseV9h
Y3BpX2Jvb3RfaW5pdCgpOworI2VuZGlmCiAJLyoKIAkgKiBQYXJzZSBTUkFUIHRvIGRpc2NvdmVy
IG5vZGVzLgogCSAqLwo=
------=_Part_70575_1247777.1216714183128--
