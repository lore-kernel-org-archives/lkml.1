Return-Path: <linux-kernel-owner+w=401wt.eu-S1754144AbZGJIoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbZGJIoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 04:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbZGJIoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 04:44:21 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:49261 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbZGJIoR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 04:44:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Cjs4AC96BpkexGQDu5/bl6T/dXC00xz3py8g14WMlMu3QyNoLTzysrZ0J6/CqjvQh3
         3ocapkH4ORbkzW/PkZJ+JqfBNo/bolG2pz9nfgO7CZgQYP6Y816rzZjn4344K7vMZyit
         pB7aomrxnoD2wMAwAyUBZJ6YcI8uq08CWOdzk=
MIME-Version: 1.0
In-Reply-To: <200907092211.31250.rjw@sisk.pl>
References: <61b223ba0907081216q3813c8f0n677bcce8b24ae52c@mail.gmail.com>
	 <200907082345.22084.bzolnier@gmail.com>
	 <61b223ba0907090619ld35b51eqe3ace5aad7fde821@mail.gmail.com>
	 <200907092211.31250.rjw@sisk.pl>
Date: Fri, 10 Jul 2009 09:44:15 +0100
X-Google-Sender-Auth: c88d6ec46facfa2f
Message-ID: <61b223ba0907100144g14b89e71l2dc8301d4c56f9c4@mail.gmail.com>
Subject: Re: [BISECTED] HP G7000 battery disappears after suspend
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/9 Rafael J. Wysocki <rjw@sisk.pl>:
> On Thursday 09 July 2009, Alan Jenkins wrote:
>> 2009/7/8 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>:
>> > On Wednesday 08 July 2009 21:41:17 Rafael J. Wysocki wrote:
>> >> On Wednesday 08 July 2009, Alan Jenkins wrote:
>> >> > Hi,
>> >> >
>> >> > I've borrowed this laptop for a few days.  Linux works pretty well,
>> >> > but I found a problem on newer kernels.  After suspend it claims the
>> >> > battery has been removed.  E.g. /proc/acpi/battery/BAT0/state claims
>> >> > the battery is not present (but it is).
>> >> >
>> >> > I've attached acpidump and dmidecode output at
>> >> > <http://bugzilla.kernel.org/show_bug.cgi?id=13745>.  I still have
>> >> > access to the laptop for further tests, but only until Friday.
>> >> >
>> >> > I bisected it to the commit below.  Manually reverting the patch fixes
>> >> > the problem (in both 2.6.30 and 2.6.31-rc2).
>> >>
>> >> Well, the commit below can't be reverted, because that would cause the boxes
>> >> it fixed to stop working.
>> >>
>> >> Now, the only case this patch can make any difference is when the BIOS doesn't
>> >> set SCI_EN before returning control the the kernel, which quite evidently is a
>> >> BIOS bug.  The fact that the battery doesn't work with this patch applied means
>> >> that the BIOS not only doesn't set SCI_EN, but also expects it to remain unset,
>> >> which is insane.
>> >>
>> >> IMO this is a "won't fix", sorry.
>> >
>> > Lets be pragmatic here..
>> >
>> > Besides this is a regression and we are already handling some such insane
>> > systems in STR case.  Moreover sending SMI ACPI_ENABLE command may result in
>> > some things happening behind our back and not only setting of SCI_EN bit..
>> >
>> > PS Looking at the set_sci_en_on_resume quirk history it seems that if we are
>> > lucky we may may fix another issue (screaming IRQ one) at the same time :)
>> >
>> > Alan, could you try this patch?
>> >
>> > ---
>> > debug patch (needs to have both CONFIG_SUSPEND=y & CONFIG_HIBERNATION=y)
>> >
>> >  drivers/acpi/sleep.c |   13 ++++++++++++-
>> >  1 file changed, 12 insertions(+), 1 deletion(-)
>> >
>> > Index: b/drivers/acpi/sleep.c
>> > ===================================================================
>> > --- a/drivers/acpi/sleep.c
>> > +++ b/drivers/acpi/sleep.c
>> > @@ -383,6 +383,14 @@ static struct dmi_system_id __initdata a
>> >                },
>> >        },
>> >        {
>> > +       .callback = init_set_sci_en_on_resume,
>> > +       .ident = "Hewlett-Packard HP G7000 Notebook PC",
>> > +       .matches = {
>> > +               DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
>> > +               DMI_MATCH(DMI_PRODUCT_NAME, "HP G7000 Notebook PC"),
>> > +               },
>> > +       },
>> > +       {
>> >        .callback = init_old_suspend_ordering,
>> >        .ident = "Panasonic CF51-2L",
>> >        .matches = {
>>
>> Thanks for coding this up for me in full.  It works, the battery now
>> survives, and it does indeed remove the IRQ warning.
>
> Great, thanks for testing, Bart, thanks for the patch!
>
> Len, can you add the Bart's patch to your 2.6.31 queue, please?
>
>> I didn't test the hibernation hunk.  I have hibernation set up, but
>> there is a different problem (not a regression).  I don't have much
>> more time to investigate on this laptop, so I don't expect to get it
>> fixed.  But here are some details anyway :-).
>>
>> When I run s2disk, it writes the image out, and then instantly
>> resumes.  It doesn't seem to read the image, but neither does the
>> kernel report an error:
>>
>> [  491.088802] ACPI: Preparing to enter system sleep state S4
>> [  491.090498] PM: Saving platform NVS memory
>> [  491.094638] Disabling non-boot CPUs ...
>> [  491.094867] PM: Creating hibernation image:
>> [  491.096015] PM: Need to copy 114990 pages
>> [  491.096015] PM: Normal pages needed: 114990 + 1024 + 22, available
>> pages: 144595
>> [  491.096015] PM: Hibernation image created (114990 pages copied)
>> [  491.096015] ACPI: Waking up from system sleep state S4
>>
>> It happens on 2.6.24-23-generic, 2.6.30, and 2.6.30-rc2.
>
> Hmm.  Interesting.
>
> I _guess_ this problem is ACPI-related as well.  You can try putting
> 'shutdown method = shutdown' into /etc/suspend.conf (or whatever the s2disk's
> configuration file is on your system).

That doesn't change anything.

> If possible, it would be interesting to see if that also happens if
> 'echo disk > /sys/power/state' is used to trigger hibernation instead of
> s2disk.   In particular when booted with init=/bin/bash.

That worked, even though I didn't use init=/bin/bash.

If it matters, I'm using a swap file on an NTFS partition.  [The
system was installed by Ubuntu "Wubi" (i.e. using Windows partition
and bootloader), but I had to set up both uswsusp and kernel swsusp
myself.  pm-hibernate refuses to work; I don't think it knows about
swap files].

I noticed an error message, I'm not sure if it's relevant or not.

Suspending using this method, I see two lines of ATA errors on the
console when suspending.  They appear to be post-snapshot - they don't
appear in the log - but it looks like the same error happens on resume
too.  s2disk generates the same error on resume as well.

[  192.247475] sd 0:0:0:0: [sda] Starting disk
[  192.340428] ata4.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
[  192.340432] ata4.00: ACPI cmd ef/03:22:00:00:00:a0 filtered out
[  192.372314] ata4.00: configured for MWDMA2
[  192.640075] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  192.642338] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[  192.644365] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[  192.644381] ata1.00: configured for UDMA/100
* [  192.660076] ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
* [  192.660079] ata1: irq_stat 0x00400040, connection status changed
[  192.663198] ata1.00: configured for UDMA/100
[  192.663201] ata1: EH complete

The lines marked with * are the ones that appear on the console during
suspend.  This happens on both 2.6.31-rc2 and 2.6.30.

Thanks
Alan
