Return-Path: <linux-kernel-owner+w=401wt.eu-S1760846AbZGINTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760846AbZGINTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 09:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759168AbZGINT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 09:19:28 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:61422 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758578AbZGINT1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 09:19:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PEa/FHf2DsftRUCF1Zy+Tn5DJZrFbzkbyZ39KD8KVqkHTo04pzdUmUTZdQHQOgcUGd
         at0Tp4AVlM1hKbRA5K2Gz+UgUAt3YV1Uu/iO7M3ppYKinL/h7ZI7ZojGw1BvITZdhbJo
         CXFcXjMkHVLKMUmTM6837gHGU3DFEg1a5rMYg=
MIME-Version: 1.0
In-Reply-To: <200907082345.22084.bzolnier@gmail.com>
References: <61b223ba0907081216q3813c8f0n677bcce8b24ae52c@mail.gmail.com>
	 <200907082141.18135.rjw@sisk.pl>
	 <200907082345.22084.bzolnier@gmail.com>
Date: Thu, 9 Jul 2009 14:19:23 +0100
X-Google-Sender-Auth: d54807ea6e6f15d1
Message-ID: <61b223ba0907090619ld35b51eqe3ace5aad7fde821@mail.gmail.com>
Subject: Re: [BISECTED] HP G7000 battery disappears after suspend
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/8 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>:
> On Wednesday 08 July 2009 21:41:17 Rafael J. Wysocki wrote:
>> On Wednesday 08 July 2009, Alan Jenkins wrote:
>> > Hi,
>> >
>> > I've borrowed this laptop for a few days.  Linux works pretty well,
>> > but I found a problem on newer kernels.  After suspend it claims the
>> > battery has been removed.  E.g. /proc/acpi/battery/BAT0/state claims
>> > the battery is not present (but it is).
>> >
>> > I've attached acpidump and dmidecode output at
>> > <http://bugzilla.kernel.org/show_bug.cgi?id=13745>.  I still have
>> > access to the laptop for further tests, but only until Friday.
>> >
>> > I bisected it to the commit below.  Manually reverting the patch fixes
>> > the problem (in both 2.6.30 and 2.6.31-rc2).
>>
>> Well, the commit below can't be reverted, because that would cause the boxes
>> it fixed to stop working.
>>
>> Now, the only case this patch can make any difference is when the BIOS doesn't
>> set SCI_EN before returning control the the kernel, which quite evidently is a
>> BIOS bug.  The fact that the battery doesn't work with this patch applied means
>> that the BIOS not only doesn't set SCI_EN, but also expects it to remain unset,
>> which is insane.
>>
>> IMO this is a "won't fix", sorry.
>
> Lets be pragmatic here..
>
> Besides this is a regression and we are already handling some such insane
> systems in STR case.  Moreover sending SMI ACPI_ENABLE command may result in
> some things happening behind our back and not only setting of SCI_EN bit..
>
> PS Looking at the set_sci_en_on_resume quirk history it seems that if we are
> lucky we may may fix another issue (screaming IRQ one) at the same time :)
>
> Alan, could you try this patch?
>
> ---
> debug patch (needs to have both CONFIG_SUSPEND=y & CONFIG_HIBERNATION=y)
>
>  drivers/acpi/sleep.c |   13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> Index: b/drivers/acpi/sleep.c
> ===================================================================
> --- a/drivers/acpi/sleep.c
> +++ b/drivers/acpi/sleep.c
> @@ -383,6 +383,14 @@ static struct dmi_system_id __initdata a
>                },
>        },
>        {
> +       .callback = init_set_sci_en_on_resume,
> +       .ident = "Hewlett-Packard HP G7000 Notebook PC",
> +       .matches = {
> +               DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
> +               DMI_MATCH(DMI_PRODUCT_NAME, "HP G7000 Notebook PC"),
> +               },
> +       },
> +       {
>        .callback = init_old_suspend_ordering,
>        .ident = "Panasonic CF51-2L",
>        .matches = {

Thanks for coding this up for me in full.  It works, the battery now
survives, and it does indeed remove the IRQ warning.

I didn't test the hibernation hunk.  I have hibernation set up, but
there is a different problem (not a regression).  I don't have much
more time to investigate on this laptop, so I don't expect to get it
fixed.  But here are some details anyway :-).

When I run s2disk, it writes the image out, and then instantly
resumes.  It doesn't seem to read the image, but neither does the
kernel report an error:

[  491.088802] ACPI: Preparing to enter system sleep state S4
[  491.090498] PM: Saving platform NVS memory
[  491.094638] Disabling non-boot CPUs ...
[  491.094867] PM: Creating hibernation image:
[  491.096015] PM: Need to copy 114990 pages
[  491.096015] PM: Normal pages needed: 114990 + 1024 + 22, available
pages: 144595
[  491.096015] PM: Hibernation image created (114990 pages copied)
[  491.096015] ACPI: Waking up from system sleep state S4

It happens on 2.6.24-23-generic, 2.6.30, and 2.6.30-rc2.

> @@ -472,7 +480,10 @@ static void acpi_hibernation_leave(void)
>         * If ACPI is not enabled by the BIOS and the boot kernel, we need to
>         * enable it here.
>         */
> -       acpi_enable();
> +       if (set_sci_en_on_resume)
> +               acpi_write_bit_register(ACPI_BITREG_SCI_ENABLE, 1);
> +       else
> +               acpi_enable();
>        /* Reprogram control registers and execute _BFS */
>        acpi_leave_sleep_state_prep(ACPI_STATE_S4);
>        /* Check the hardware signature */
>

Thanks
Alan

-- 
A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?
>> A: Top-posting.
>>> Q: What is the most annoying thing in e-mail?
