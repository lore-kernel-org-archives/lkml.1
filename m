Return-Path: <linux-kernel-owner+w=401wt.eu-S1765976AbXLPJwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765976AbXLPJwQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 04:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756153AbXLPJwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 04:52:04 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60219 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755761AbXLPJwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 04:52:03 -0500
Date: Sun, 16 Dec 2007 01:51:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Krzysztof Oledzki <olel@ans.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Osterried <osterried@jesse.de>, protasnb@gmail.com,
       bugme-daemon@bugzilla.kernel.org, Thomas Osterried <osterried@jesse.de>
Subject: Re: [Bug 9182] Critical memory leak (dirty pages)
Message-Id: <20071216015112.d0ab08a1.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0712161016290.25065@bizon.gios.gov.pl>
References: <20071215221935.306A5108068@picon.linux-foundation.org>
	<Pine.LNX.4.64.0712152358240.14491@bizon.gios.gov.pl>
	<20071215203539.d6f71e96.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0712161016290.25065@bizon.gios.gov.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Dec 2007 10:33:20 +0100 (CET) Krzysztof Oledzki <olel@ans.pl> wrote:

> 
> 
> On Sat, 15 Dec 2007, Andrew Morton wrote:
> 
> > On Sun, 16 Dec 2007 00:08:52 +0100 (CET) Krzysztof Oledzki <olel@ans.pl> wrote:
> >
> >>
> >>
> >> On Sat, 15 Dec 2007, bugme-daemon@bugzilla.kernel.org wrote:
> >>
> >>> http://bugzilla.kernel.org/show_bug.cgi?id=9182
> >>>
> >>>
> >>> ------- Comment #33 from protasnb@gmail.com  2007-12-15 14:19 -------
> >>> Krzysztof, I'd hate point you to a hard path (at least time consuming), but
> >>> you've done a lot of digging by now anyway. How about git bisecting between
> >>> 2.6.20-rc2 and rc1? Here is great info on bisecting:
> >>> http://www.kernel.org/doc/local/git-quick.html
> >>
> >> As I'm smarter than git-bistect I can tell that 2.6.20-rc1-git8 is as bad
> >> as 2.6.20-rc2 but 2.6.20-rc1-git8 with one patch reverted seems to be OK.
> >> So it took me only 2 reboots. ;)
> >>
> >> The guilty patch is the one I proposed just an hour ago:
> >>   http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Fstable%2Flinux-2.6.20.y.git;a=commitdiff_plain;h=fba2591bf4e418b6c3f9f8794c9dd8fe40ae7bd9
> >>
> >> So:
> >>   - 2.6.20-rc1: OK
> >>   - 2.6.20-rc1-git8 with fba2591bf4e418b6c3f9f8794c9dd8fe40ae7bd9 reverted: OK
> >>   - 2.6.20-rc1-git8: very BAD
> >>   - 2.6.20-rc2: very BAD
> >>   - 2.6.20-rc4: very BAD
> >>   - >= 2.6.20: BAD (but not *very* BAD!)
> >>
> >
> > well..  We have code which has been used by *everyone* for a year and it's
> > misbehaving for you alone.
> 
> No, not for me alone. Probably only I and Thomas Osterried have systems 
> where it is so easy to reproduce. Please note that the problem exists on 
> my all systems, but only on one it is critical. It is enough to run
> "sync; sleep 1; sunc; sleep 1; sync; grep Drirty /proc/meminfo" to be sure. 
> With =>2.6.20-rc1-git8 it *never* falls to 0 an *all* my hosts but only 
> on one it goes to ~200MB in about 2 weeks and then everything dies:
> http://bugzilla.kernel.org/attachment.cgi?id=13824
> http://bugzilla.kernel.org/attachment.cgi?id=13825
> http://bugzilla.kernel.org/attachment.cgi?id=13826
> http://bugzilla.kernel.org/attachment.cgi?id=13827
> 
> >  I wonder what you're doing that is different/special.
> Me to. :|
> 
> > Which filesystem, which mount options
> 
>   - ext3 on RAID1 (MD): / - rootflags=data=journal

It wouldn't surprise me if this is specific to data=journal: that
journalling mode is pretty complex wrt dairty-data handling and isn't well
tested.

Does switching that to data=writeback change things?

THomas, do you have ext3 data=journal on any filesytems?

>   - ext3 on LVM on RAID5 (MD)
>   - nfs
> 
> /dev/md0 on / type ext3 (rw)
> proc on /proc type proc (rw)
> sysfs on /sys type sysfs (rw,nosuid,nodev,noexec)
> devpts on /dev/pts type devpts (rw,nosuid,noexec)
> /dev/mapper/VolGrp0-usr on /usr type ext3 (rw,nodev,data=journal)
> /dev/mapper/VolGrp0-var on /var type ext3 (rw,nodev,data=journal)
> /dev/mapper/VolGrp0-squid_spool on /var/cache/squid/cd0 type ext3 (rw,nosuid,nodev,noatime,data=writeback)
> /dev/mapper/VolGrp0-squid_spool2 on /var/cache/squid/cd1 type ext3 (rw,nosuid,nodev,noatime,data=writeback)
> /dev/mapper/VolGrp0-news_spool on /var/spool/news type ext3 (rw,nosuid,nodev,noatime)
> shm on /dev/shm type tmpfs (rw,noexec,nosuid,nodev)
> usbfs on /proc/bus/usb type usbfs (rw,noexec,nosuid,devmode=0664,devgid=85)
> owl:/usr/gentoo-nfs on /usr/gentoo-nfs type nfs (ro,nosuid,nodev,noatime,bg,intr,tcp,addr=192.168.129.26)
> 
> 
> > what sort of workload?
> Different, depending on a host: mail (postfix + amavisd + spamassasin + 
> clamav + sqlgray), squid, mysql, apache, nfs, rsync, .... But it seems 
> that the biggest problem is on the host running mentioned mail service.
> 

