Return-Path: <linux-kernel-owner+w=401wt.eu-S932066AbXKNUai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066AbXKNUai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 15:30:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764489AbXKNUaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 15:30:08 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32849 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760432AbXKNUaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 15:30:06 -0500
Date: Wed, 14 Nov 2007 12:29:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Cc: linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: 2.6.24-rc2-mm1
Message-Id: <20071114122939.7b4ee194.akpm@linux-foundation.org>
In-Reply-To: <64bb37e0711141116h5ea9ed8cs7f2afbabe73f07bb@mail.gmail.com>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	<64bb37e0711141116h5ea9ed8cs7f2afbabe73f07bb@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007 20:16:09 +0100 "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:

> On Nov 14, 2007 2:59 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc2/2.6.24-rc2-mm1/
> 
> Breaks nfsv4 in a rather funny way:
> 
> treogen ~ # cd /usr/portage/x
> treogen x # touch bla
> touch: cannot touch `bla': File exists
> treogen x # mkdir bla
> treogen x # touch bla/bla
> touch: cannot touch `bla/bla': File exists
> treogen x # ls -lad *
> drwxr-xr-x 2 root root 6 Nov 14 20:03 bla
> treogen x # ls -la *
> total 0
> drwxr-xr-x 2 root root  6 Nov 14 20:03 .
> drwxr-xr-x 3 root root 16 Nov 14 20:03 ..
> treogen x #
> 
> So I can create new directories, but not new files. Reading files works normal.
>>
> The client is 2.6.24-rc2-mm1, the server 2.6.22-gentoo-r9.
> The fstab-line from the client:
> 192.168.2.4:/portage    /usr/portage            nfs4
> rw,noatime,nodiratime,intr 0 0
> 
> 2.6.23-mm1 as client worked, some 2.6.24-rc1-git? also.

hm.  I guess that means I get to do yet another git-bisect.  Either the nfs
changes or r-o-bind-mounts, I bet.

> Otherwise the new -mm worked OK for me, no errors visible in the syslog.
> It even fixed the ACPI Exception from regression bug 9320.
> Now the output is:
> [   83.125873] scsi8 : pata_amd
> [   83.125917] scsi9 : pata_amd
> [   83.127062] ata9: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
> [   83.127064] ata10: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
> [   83.194917] ata9.01: ATA-7: Maxtor 6L250R0, BAH41G10, max UDMA/133
> [   83.194920] ata9.01: 490234752 sectors, multi 16: LBA48
> [   83.194929] ata9: nv_mode_filter: 0x7f39f&0x701f->0x701f,
> BIOS=0x7000 (0xc00000) ACPI=0x701f (900:60:0x14)
> [   83.197327] ata9.01: configured for UDMA/33
> [   83.197348] ata10: port disabled. ignoring.
> [   83.197428] scsi 8:0:1:0: Direct-Access     ATA      Maxtor 6L250R0
>   BAH4 PQ: 0 ANSI: 5
> [   83.197487] sd 8:0:1:0: [sdd] 490234752 512-byte hardware sectors (251000 MB)
> [   83.197496] sd 8:0:1:0: [sdd] Write Protect is off
> [   83.197498] sd 8:0:1:0: [sdd] Mode Sense: 00 3a 00 00
> [   83.197510] sd 8:0:1:0: [sdd] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [   83.197542] sd 8:0:1:0: [sdd] 490234752 512-byte hardware sectors (251000 MB)
> [   83.197549] sd 8:0:1:0: [sdd] Write Protect is off
> [   83.197551] sd 8:0:1:0: [sdd] Mode Sense: 00 3a 00 00
> [   83.197562] sd 8:0:1:0: [sdd] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [   83.197565]  sdd: sdd1 sdd2 sdd3 sdd4 < sdd5 sdd6 >
> [   83.222911] sd 8:0:1:0: [sdd] Attached SCSI disk
> [   83.222944] sd 8:0:1:0: Attached scsi generic sg3 type 0
> 
> Just posting this, if someone is interested in the nv_mode_filter-output...
> (UDMA/33 is correct, its only a 40-wire cable)
> 

OK, thanks.

