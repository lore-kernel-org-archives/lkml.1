Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbYK2HYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbYK2HYu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 02:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbYK2HYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 02:24:42 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:47024 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbYK2HYl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 02:24:41 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: xfs@oss.sgi.com
Subject: hangs with MTRR_SANITIZER? (was: Re: truncated files)
Date: Sat, 29 Nov 2008 08:24:37 +0100
User-Agent: KMail/1.9.9
References: <200811252244.14718.Martin@Lichtvoll.de> <200811282302.42809.Martin@lichtvoll.de> <200811282339.24197.Martin@lichtvoll.de> (sfid-20081129_074736_759214_8BA75EA5)
In-Reply-To: <200811282339.24197.Martin@lichtvoll.de>
Cc: tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200811290824.38750.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi!

CC'd to linux-kernel mailinglist, as that might be something that goes 
beyond any possible TuxOnIce or XFS issues. I know I am using TuxOnIce 
which is not part of the mainline kernel. And I am even using an 
inofficial patch - which I will use again unchanged for the non 
MTRR_SANITIZER kernel, in order to know whether its the MTRR_SANITIZER 
thing. And anyway before knowing whether it might be MTRR_SANITIZER 
related I need to run the non MTRR_SANITIZER kernel for at least a week 
and have quite some hibernate cycles. If someone else had issues with 
MTRR_SANITIZER I would like to hear about it. Also if someone thinks I am 
completely off track on trying to track this down I appreciate a hint.


Links to my posts on xfs and tuxonice-devel mailing lists:

http://oss.sgi.com/pipermail/xfs/2008-November/037399.html

http://lists.tuxonice.net/pipermail/tuxonice-devel/2008-November/000421.html


Am Freitag 28 November 2008 schrieb Martin Steigerwald:
> Am Freitag 28 November 2008 schrieb Martin Steigerwald:
> > Am Mittwoch 26 November 2008 schrieb Dave Chinner:
> > > On Wed, Nov 26, 2008 at 09:49:18AM +0100, Martin Steigerwald wrote:
> > > > Am Dienstag 25 November 2008 schrieb Dave Chinner:
> > > > > On Tue, Nov 25, 2008 at 10:44:14PM +0100, Martin Steigerwald
>
> wrote:
> > > > > > Hi!
> > > > > >
> > > > > > Today on one try to hibernate via tuxonice it machine
> > > > > > appeared dead. I am
> > > > >
> > > > >                       ^^^^^^^^^
> > > > > When (not if) suspend to disk/resume fails, you get to keep all
> > > > > the broken pieces of your filesystem. It works most of the
> > > > > time, but it has some fundamentally broken corner cases that
> > > > > you probably just hit....
> > > >
> > > > Well I use TuxOnIce for a reason! I had uptimes of up to 70 days
> > > > with it already. And they are usually only interrupted by kernel
> > > > updates or manual shutdowns. I was never convinced by in-kernel
> > > > solutions for hibernate.
> > >
> > > Sure, though I'm not convinced that TuxOnIce is any better because
> > > it still uses the same fundamental design as the in-kernel ones.
> >
> > Might be.
> >
> > But something is fishy here. I had it a second time today. This time
> > I know for sure that the machine freezed hard. Mouse pointer froze
> > and the machine didn't even respond to a ping anymore. Nothing in
> > logs - doesn't surprise me.
> >
> > I didn't have this issue with 2.6.26, and I also don't think I had it
> > with 2.6.27.5. I will downgrade to 2.6.27.5 now.
>
> I wonder about those truncated files nonetheless. As I don't think that
> KDE is writing config files all the time. Well I might be wrong, but I
> didn't even change KDE configuration during time of the crash... OTOH
> XFS uses a in memory inode size and should be safe with the point in
> time when it writes the size to disk as far as I read here. Well this
> time at least again the file "kdeglobals" was affected and this file
> might be written rather often.

Okay, I thought about this a bit more in my dreams this night it seems. I 
think it even hangs before starting much of hibernate.

I had this pre-hibernate script:

shambhala:/etc/acpi> bzr cat -r304 hibernate-tuxonice.sh
#!/bin/sh

# Änderung der Netzwerkumgebung erkennen und Zeitserver handeln
/etc/init.d/ifplugd stop
ifdown eth0
/etc/init.d/chrony stop

# Gutnacht
hibernate

# Änderung der Netzwerkumgebung erkennen und Zeitserver handeln
/etc/init.d/chrony start
/etc/init.d/ifplugd start


Thus its logical that pinging the machine did not work anymore, since its 
first thing it does is to disable the network in order to detect changes 
in network environment between snapshot cycles reliably. 

Then it froze hard even before the desktop was locked. AFAIR not even the 
hibernater / suspend LED of my ThinkPad T42 started to blink. Thus I 
guess it froze way before any serious hibernation work started. It also 
didn't yet switch to console. And actually somewhere along the line of 
this it might fail.

I at least have the idea that it could have to do with:

  │ CONFIG_MTRR_SANITIZER:
  │ 
  │ Convert MTRR layout from continuous to discrete, so X drivers can
  │ add writeback entries.
  │
  │ Can be disabled with disable_mtrr_cleanup on the kernel command line.
  │ The largest mtrr entry size for a continous block can be set with
  │ mtrr_chunk_size.
  │
  │ If unsure, say N.

Especially as some earlier description of this config option adds an 
important detail:

>  > +config MTRR_SANITIZER
>  > +     def_bool y
>  > +     prompt "MTRR cleanup support"
>  > +     depends on MTRR
>  > +     help
>  > +       Convert MTRR layout from continuous to discrete, so some X 
driver
>  > +       could add WB entries.
>  > +
>  > +       Say N here if you see bootup problems (boot crash, boot hang,
>  > +       spontaneous reboots).

This one at least sounds interesting. Especially in combintion with the 
sentence about X drivers. But then it only speaks about boot related 
issues. And here it hanged shortly after I pressed Fn-F12 to start a 
snapshot cycle.


shambhala:/etc/acpi> lspci -nn | grep -i vga
01:00.0 VGA compatible controller [0300]: ATI Technologies Inc RV350 
[Mobility Radeon 9600 M10] [1002:4e50]

It didn't yet hang with my IBM ThinkPad T23 (SuperSavage) and my 
workstation at work (newer ATI Radeon). So that might be another hint.

On the first occurence the machine did not respond to user input very 
early, even before serious hibernating work started, too.

>  > +
>  > +       could be disabled with disable_mtrr_cleanup. also 
mtrr_chunk_size

http://lkml.org/lkml/2008/4/28/685

Thus I am compiling 2.6.27.7 without MTRR_SANITIZER support, but elsewise 
unchanged. And will test whether those hangs will be gone. It didn't 
happen with 2.6.27.5 tough. That might just be concurrence or it might 
hint at those BIOS corruption prevention patch that came in between 
2.6.27.5 and 2.6.27.7. But actually I doubt that the BIOS corruption 
prevention patch is at play here.


To avoid the truncated files problems, I will try this:

shambhala:/etc/acpi> cat hibernate-tuxonice.sh
#!/bin/sh

# Zur Sicherheit gleich am Anfang alle ausstehenden Änderungen schreiben
sync

# Änderung der Netzwerkumgebung erkennen und Zeitserver handeln
/etc/init.d/ifplugd stop
ifdown eth0
/etc/init.d/chrony stop

# Zur Sicherheit hier nochmal alle ausstehenden Änderungen schreiben
sync

# Gutnacht
hibernate

# Änderung der Netzwerkumgebung erkennen und Zeitserver handeln
/etc/init.d/chrony start
/etc/init.d/ifplugd start

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
