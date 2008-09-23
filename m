Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939AbYIWTjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbYIWTjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 15:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbYIWTjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 15:39:08 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:40076 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbYIWTjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 15:39:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=U1OGbyvuRyEeRlAGRMVm+HLXWuLOUPsRRdUrCgCXhHexZ5+Bb1eMGD7REa7Eaz4UUd
         ncdXvLFtkiCKgoaaSGK2gnnaTZ4Y167OBuAflKIBtW/H1nF4RuH2HHvaKmFJD5VlVBnF
         hSKc5ON5pIPK8KGKNeXYnRtTmaIJVTV6Z/krs=
Message-ID: <86802c440809231239o207c893ja508a1574bd04706@mail.gmail.com>
Date: Tue, 23 Sep 2008 12:39:05 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Jack Steiner" <steiner@sgi.com>
Subject: Re: [PATCH] - Add early detection of UV system types
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <20080923193049.GA21605@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080923182817.GA6335@sgi.com>
	 <86802c440809231159x69883d44y26bbd491b6504a0f@mail.gmail.com>
	 <20080923193049.GA21605@sgi.com>
X-Google-Sender-Auth: 0aaccc39fb5bc0d6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 12:30 PM, Jack Steiner <steiner@sgi.com> wrote:
> On Tue, Sep 23, 2008 at 11:59:26AM -0700, Yinghai Lu wrote:
>> On Tue, Sep 23, 2008 at 11:28 AM, Jack Steiner <steiner@sgi.com> wrote:
>> > Portions of system boot needs to know if a system is a UV system prior
>> > to genapic initialization. This patch adds a call from acpi_boot_table_init()
>> > to the UV code to parse the MADT to determine if the system is a UV system.
>> >
>> > Signed-off-by: Jack Steiner <steiner@sgi.com>
>> >
>> > ---
>> >  arch/x86/kernel/acpi/boot.c      |    4 ++++
>> >  arch/x86/kernel/genx2apic_uv_x.c |   21 ++++++++++++---------
>> >  arch/x86/mm/srat_64.c            |    2 +-
>> >  include/asm-x86/genapic_64.h     |    2 ++
>> >  4 files changed, 19 insertions(+), 10 deletions(-)
>> >
>> > Index: linux/arch/x86/kernel/acpi/boot.c
>> > ===================================================================
>> > --- linux.orig/arch/x86/kernel/acpi/boot.c      2008-09-23 12:55:15.000000000 -0500
>> > +++ linux/arch/x86/kernel/acpi/boot.c   2008-09-23 12:55:19.000000000 -0500
>> > @@ -1667,6 +1667,10 @@ int __init acpi_boot_table_init(void)
>> >
>> >        acpi_table_parse(ACPI_SIG_BOOT, acpi_parse_sbf);
>> >
>> > +#ifdef CONFIG_X86_64
>> > +       acpi_table_parse(ACPI_SIG_MADT, uv_early_madt_oem_check);
>> > +#endif
>> > +
>> >        /*
>> >         * blacklist may disable ACPI entirely
>> >         */
>>
>> you don't need to that.
>>
>> please call early_acpi_boot_init instead
>
> I don't mind moving the new call from acpi_boot_table_init() to early_acpi_boot_init(),
> but I still need to determine the UV type very early in boot. System type is needed
> prior to parsing the SRAT.
>
>>
>> sth like
>>
>> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
>> index 3d677b5..7ead2aa 100644
>> --- a/arch/x86/kernel/setup.c
>> +++ b/arch/x86/kernel/setup.c
>> @@ -997,6 +997,8 @@ void __init setup_arch(char **cmdline_p)
>>          */
>>         acpi_boot_table_init();
>>
>> +       early_acpi_boot_init();
>> +
>>  #ifdef CONFIG_ACPI_NUMA
>>         /*
>>          * Parse SRAT to discover nodes.
>>
>> YH
>

early_acpi_boot_init ==> early_acpi_process_madt ==>
acpi_table_parse(ACPI_SIG_MADT, acpi_parse_madt) ==> acpi_parse_madt
==> acpi_madt_oem_check
==> at last

int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
{
        int i;

        for (i = 0; apic_probe[i]; ++i) {
                if (apic_probe[i]->acpi_madt_oem_check(oem_id, oem_table_id)) {
                        genapic = apic_probe[i];
                        printk(KERN_INFO "Setting APIC routing to %s.\n",
                                genapic->name);
                        return 1;
                }
        }
        return 0;
}

and

static struct genapic *apic_probe[] __initdata = {
        &apic_x2apic_uv_x,
        &apic_x2apic_phys,
        &apic_x2apic_cluster,
        &apic_physflat,
        NULL,
};

so apic_x2apic_uv_x's uv_acpi_madt_oem_check is called at first.


YH
