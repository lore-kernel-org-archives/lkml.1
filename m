Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbXL2LqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbXL2LqU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 06:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbXL2LqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 06:46:09 -0500
Received: from an-out-0708.google.com ([209.85.132.242]:16245 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbXL2LqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 06:46:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Fvl+UyFrasi9/vht8iw+KxRuoyXOko40PNTnCjyt1y9iQLQCkPUnRHVRVH1aMlXmspEZ7x51ZE1Py9ARBtOHRicWWfSdv0H1uUI+0E770TF88rZjZGLLri2YcUOG5pN4eYIlkNhS6OOHzBvkd7OuZe3Zf8Ukzl2lAvM+d/1W43o=
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
From: Islam Amer <pharon@gmail.com>
Reply-To: pharon@gmail.com
To: Richard Harman <richard@richardharman.com>
Cc: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47760ED5.6060207@richardharman.com>
References: <47754735.1050009@richardharman.com>
	 <20071229095242.1300e19c@linux360.ro>  <47760ED5.6060207@richardharman.com>
Content-Type: text/plain
Date: Sat, 29 Dec 2007 13:46:02 +0200
Message-Id: <1198928762.5077.5.camel@iamer-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.
I was interested in getting dynticks to work on my compaq presario v6000
to help with the 1 hour thirty minutes battery time, but after this
discussion I lost interest.

I too had the early boot time hang, and found it was udev triggering the
bug.

Changing the /etc/init.d/udev script so that the line containing

/sbin/udevtrigger

to

/sbin/udevtrigger --subsystem-nomatch="*misc*"

seemed to fix things.

the hang is triggered specifically by 

echo add > /sys/class/misc/rtc/uevent

after inserting rtc.ko

Also using hwclock to set the rtc , will cause a hard hang, if you are
using 64bit linux. Disable the init scripts that set the time, or use
the 32bit binary, as suggested here : 

http://www.mail-archive.com/opensuse@opensuse.org/msg41964.html

I hope this helps. But your hardware is slightly different though.



On Sat, 2007-12-29 at 04:09 -0500, Richard Harman wrote:
> Eduard-Gabriel Munteanu wrote:
> 
> > On Fri, 28 Dec 2007 13:57:57 -0500
> > Richard Harman <richard@richardharman.com> wrote:
> > 
> >> I just saw this thread online from someone else who was having
> >> problems with an HP laptop -- I believe my laptop falls into this
> >> category.
> >>
> >> The laptop is currently running Fedora Core 8, but I couldn't figure
> >> out what kernel that diff was against.  I'm not experienced with
> >> git.  Can you give me a few pointers on how to get that patch applied
> >> to a kernel tarball?  I'll be more than willing to be your test
> >> subject to see how well this patch and whatever future revision of it
> >> may work.
> >>
> >> Richard
> > 
> > Hi,
> > 
> > I'll assume you didn't read the thread careful enough, so I have to
> > emphasize the fact that this patch won't improve power savings (even
> > more, it may actually consume an additional 1-2 Watts). Try it only if
> > you need dynticks for another purpose than just saving power (in which
> > case, you should wait until a better solution comes up, namely
> > LAPIC-less dynticks).
> 
> Oh, at the moment I couldn't care less about power savings, I'm more 
> interested in simply getting the kernel properly -booting- on this hardware.
> 
> Right now, with your patch and the 'noirqdebug' option or disabling nohz 
> the system appears to be stable.  This laptop otherwise locks up trying 
> to configure apic/lapic, or locks up solid later with NO oops/bug and 
> nothing will bring it out of it (eg, sysrq has no effect).  NMI watchdog 
> was also inoperable, which I believe was due to the apic/lapic being 
> disabled.
> 
> With your patch, the lapic is used:
> 
> ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> 
> These kernel dmesg logs are hand-transcribed, and are from 2.6.22.5, but 
> this shows where the kernel would lock up good and solid:
> 
> http://www.richardharman.com/pavilion/2.6.22.5/dmesg.txt
> 
> > IIRC, the diff was made against 2.6.24-rc4, but it applies okay on the
> > latest -rc (2.6.24-rc6 as of now) as far as I can see. Copy starting
> > with the line below "---" all the way to the end and save it to a file
> > (make sure tabs don't get messed up), then apply with "patch -p1" as
> > you would apply any other patch. Run "make xconfig" (or whatever
> > interface to Kconfig you use), make sure "Processor type and
> > features -> Disable C1E on AMD systems to make dynticks work" is set,
> > along with all other relevant options, then build and the kernel as
> > usual.
> 
> Yeah, I actually found a how-to on how to pull down Linus's git tree, 
> and managed to patch -p1 against that.  Kudos to the folks who set up 
> faqs on using git.
> 
> Anyway, I'm extremely open to getting to the bottom of working around 
> the quirks on this hardware.  If I havn't mentioned it previously, this 
> laptop is an HP dv6408nr, with an amd turion tl-56 cpu and nVidia MCP51 
> chipset.
> 
> What can I do to help?  It has been pulling teeth trying to get to the 
> bottom of this.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

