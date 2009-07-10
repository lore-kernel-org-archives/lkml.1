Return-Path: <linux-kernel-owner+w=401wt.eu-S1755960AbZGJQmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbZGJQmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 12:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbZGJQmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 12:42:14 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:34945 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbZGJQmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 12:42:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=q+ewhOypHjFWcrx4VPJZwWRjgujBPuuWHPgWrbp8xQMxHmJ28k/kS0httfrOeYF1Af
         DOVRuO9cTRg6Gd4DzQ71gZlGysmTRtFCqCzfrGzG8tcnSjYylPQv1ZsmxtzJu8UeosLs
         RnhEkJ6uGUHFS8JkIAj3gcjffPQbT4LvMBtqY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [BISECTED] HP G7000 battery disappears after suspend
Date: Fri, 10 Jul 2009 18:46:16 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc2-next-20090708-03666-gb620e95-dirty; KDE/4.2.4; i686; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
References: <61b223ba0907081216q3813c8f0n677bcce8b24ae52c@mail.gmail.com> <200907092211.31250.rjw@sisk.pl> <61b223ba0907100144g14b89e71l2dc8301d4c56f9c4@mail.gmail.com>
In-Reply-To: <61b223ba0907100144g14b89e71l2dc8301d4c56f9c4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907101846.16800.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 July 2009 10:44:15 Alan Jenkins wrote:
> 2009/7/9 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Thursday 09 July 2009, Alan Jenkins wrote:
> >> 2009/7/8 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>:
> >> > On Wednesday 08 July 2009 21:41:17 Rafael J. Wysocki wrote:
> >> >> On Wednesday 08 July 2009, Alan Jenkins wrote:
> >> >> > Hi,
> >> >> >
> >> >> > I've borrowed this laptop for a few days.  Linux works pretty well,
> >> >> > but I found a problem on newer kernels.  After suspend it claims the
> >> >> > battery has been removed.  E.g. /proc/acpi/battery/BAT0/state claims
> >> >> > the battery is not present (but it is).
> >> >> >
> >> >> > I've attached acpidump and dmidecode output at
> >> >> > <http://bugzilla.kernel.org/show_bug.cgi?id=13745>.  I still have
> >> >> > access to the laptop for further tests, but only until Friday.
> >> >> >
> >> >> > I bisected it to the commit below.  Manually reverting the patch fixes
> >> >> > the problem (in both 2.6.30 and 2.6.31-rc2).
> >> >>
> >> >> Well, the commit below can't be reverted, because that would cause the boxes
> >> >> it fixed to stop working.
> >> >>
> >> >> Now, the only case this patch can make any difference is when the BIOS doesn't
> >> >> set SCI_EN before returning control the the kernel, which quite evidently is a
> >> >> BIOS bug.  The fact that the battery doesn't work with this patch applied means
> >> >> that the BIOS not only doesn't set SCI_EN, but also expects it to remain unset,
> >> >> which is insane.
> >> >>
> >> >> IMO this is a "won't fix", sorry.
> >> >
> >> > Lets be pragmatic here..
> >> >
> >> > Besides this is a regression and we are already handling some such insane
> >> > systems in STR case.  Moreover sending SMI ACPI_ENABLE command may result in
> >> > some things happening behind our back and not only setting of SCI_EN bit..
> >> >
> >> > PS Looking at the set_sci_en_on_resume quirk history it seems that if we are
> >> > lucky we may may fix another issue (screaming IRQ one) at the same time :)
> >> >
> >> > Alan, could you try this patch?
> >> >
> >> > ---
> >> > debug patch (needs to have both CONFIG_SUSPEND=y & CONFIG_HIBERNATION=y)
> >> >
> >> >  drivers/acpi/sleep.c |   13 ++++++++++++-
> >> >  1 file changed, 12 insertions(+), 1 deletion(-)
> >> >
> >> > Index: b/drivers/acpi/sleep.c
> >> > ===================================================================
> >> > --- a/drivers/acpi/sleep.c
> >> > +++ b/drivers/acpi/sleep.c
> >> > @@ -383,6 +383,14 @@ static struct dmi_system_id __initdata a
> >> >                },
> >> >        },
> >> >        {
> >> > +       .callback = init_set_sci_en_on_resume,
> >> > +       .ident = "Hewlett-Packard HP G7000 Notebook PC",
> >> > +       .matches = {
> >> > +               DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
> >> > +               DMI_MATCH(DMI_PRODUCT_NAME, "HP G7000 Notebook PC"),
> >> > +               },
> >> > +       },
> >> > +       {
> >> >        .callback = init_old_suspend_ordering,
> >> >        .ident = "Panasonic CF51-2L",
> >> >        .matches = {
> >>
> >> Thanks for coding this up for me in full.  It works, the battery now
> >> survives, and it does indeed remove the IRQ warning.
> >
> > Great, thanks for testing, Bart, thanks for the patch!
> >
> > Len, can you add the Bart's patch to your 2.6.31 queue, please?
> >
> >> I didn't test the hibernation hunk.  I have hibernation set up, but
> >> there is a different problem (not a regression).  I don't have much
> >> more time to investigate on this laptop, so I don't expect to get it
> >> fixed.  But here are some details anyway :-).
> >>
> >> When I run s2disk, it writes the image out, and then instantly
> >> resumes.  It doesn't seem to read the image, but neither does the
> >> kernel report an error:
> >>
> >> [  491.088802] ACPI: Preparing to enter system sleep state S4
> >> [  491.090498] PM: Saving platform NVS memory
> >> [  491.094638] Disabling non-boot CPUs ...
> >> [  491.094867] PM: Creating hibernation image:
> >> [  491.096015] PM: Need to copy 114990 pages
> >> [  491.096015] PM: Normal pages needed: 114990 + 1024 + 22, available
> >> pages: 144595
> >> [  491.096015] PM: Hibernation image created (114990 pages copied)
> >> [  491.096015] ACPI: Waking up from system sleep state S4
> >>
> >> It happens on 2.6.24-23-generic, 2.6.30, and 2.6.30-rc2.
> >
> > Hmm.  Interesting.
> >
> > I _guess_ this problem is ACPI-related as well.  You can try putting
> > 'shutdown method = shutdown' into /etc/suspend.conf (or whatever the s2disk's
> > configuration file is on your system).
> 
> That doesn't change anything.
> 
> > If possible, it would be interesting to see if that also happens if
> > 'echo disk > /sys/power/state' is used to trigger hibernation instead of
> > s2disk.   In particular when booted with init=/bin/bash.
> 
> That worked, even though I didn't use init=/bin/bash.
> 
> If it matters, I'm using a swap file on an NTFS partition.  [The
> system was installed by Ubuntu "Wubi" (i.e. using Windows partition
> and bootloader), but I had to set up both uswsusp and kernel swsusp
> myself.  pm-hibernate refuses to work; I don't think it knows about
> swap files].
> 
> I noticed an error message, I'm not sure if it's relevant or not.
> 
> Suspending using this method, I see two lines of ATA errors on the
> console when suspending.  They appear to be post-snapshot - they don't
> appear in the log - but it looks like the same error happens on resume
> too.  s2disk generates the same error on resume as well.
> 
> [  192.247475] sd 0:0:0:0: [sda] Starting disk
> [  192.340428] ata4.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
> [  192.340432] ata4.00: ACPI cmd ef/03:22:00:00:00:a0 filtered out
> [  192.372314] ata4.00: configured for MWDMA2
> [  192.640075] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  192.642338] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
> [  192.644365] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
> [  192.644381] ata1.00: configured for UDMA/100
> * [  192.660076] ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
> * [  192.660079] ata1: irq_stat 0x00400040, connection status changed
> [  192.663198] ata1.00: configured for UDMA/100
> [  192.663201] ata1: EH complete
> 
> The lines marked with * are the ones that appear on the console during
> suspend.  This happens on both 2.6.31-rc2 and 2.6.30.

BTW Did you have a chance to test the second part of the original patch?

[ Rafal, what do we want to do with it?  It seems logical to have the same
  behavior w.r.t. SCI_EN bit both when leaving S3 and S4 but I haven't yet
  verified this with the spec (is the ACPI is enabled on leaving the state
  assumption also valid for S4 or only for S0-S3?) and the change itself
  would require some more time in linux-next if we decide to go this way.. ]
