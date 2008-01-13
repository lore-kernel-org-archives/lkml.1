Return-Path: <linux-kernel-owner+w=401wt.eu-S1754926AbYAMXTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbYAMXTi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 18:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487AbYAMXT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 18:19:29 -0500
Received: from smtp.ono.com ([62.42.230.12]:10035 "EHLO resmaa06.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754331AbYAMXT2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 18:19:28 -0500
Date: Mon, 14 Jan 2008 00:19:14 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Tejun Heo <htejun@gmail.com>
Cc: "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.24-rc7
Message-ID: <20080114001914.1e05fdb5@werewolf>
In-Reply-To: <47861930.7010708@gmail.com>
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
	<20080108015012.2e518dd4@werewolf>
	<478429B2.2030002@gmail.com>
	<20080110102505.62097da1@werewolf>
	<47861930.7010708@gmail.com>
X-Mailer: Claws Mail 3.2.0cvs34 (GTK+ 2.12.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008 22:10:08 +0900, Tejun Heo <htejun@gmail.com> wrote:

> Hi,
> 
> J.A. Magallón wrote:
> > It reproduces also with 2.6.23.13.
> > Finally I think the problematic disk is sdc:
> 
> Okay, then, it's less likely a regression and more likely a newly
> developed hardware problem.
> 
> > ICH5 PATA -> sda
> > ICH5 SATA0 -> sdb
> > ICH5 SATA1 -> sdc
> > Promise SATA -> sdd
> > 
> > The problem is that even I have commented out the entry for sdc in fstab,
> > the system is still giving me errors. An my guess is that errors in sdc makes
> > the ICH5 sata controller go nuts, and then I get errors also in sdb.
> > Just a couple questions...
> 
> I've never seen ICHs or any other SATA controllers act that way.
> 
> > - Can I say to ata_piix something like 'please, detect first SATA ports before
> >   ATA', so my system disk (sdb) becomes sda ?
> 
> You do that using LABEL, UUID or device ID.  Just run 'ls -l
> /dev/disk/by-*/' and see the result.
> 
> > - Can I say 'plz, ignore port 1', so it does not try to detect/start/spin sdc ?
> >   So I ban be sure it is the one to blame, before start to remove hardware...
> 
> Unfortunately not but you can boot into single mode where there's
> nothing trying to access the disk without your explicit command and
> verify access to each hard disk.
> 
> Hmm... You are seeing timeouts from multiple harddisks.  The first thing
> I would try is to reseat the cables and connect the SATA hard drives to
> a separate power supply and see whether that changes anything.
> 

I'm still pending to pysically remove the disks (or at least unplug the
cable...), but I have realized a cusious thing: after some errors, the
kernel is lowering the disk speed (UDMA/133, then 100, then 33):

ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd c8/00:08:07:81:3f/00:00:00:00:00/e0 tag 0 dma 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3.00: status: { DRDY }
ata3: soft resetting link
ata3.00: configured for UDMA/133
ata3: EH complete
...
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd c8/00:48:05:73:33/00:00:00:00:00/ef tag 0 dma 36864 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3.00: status: { DRDY }
ata3: soft resetting link
ata3.00: configured for UDMA/133
ata3: EH complete
...
(one more 133)
...
ata3.00: limiting speed to UDMA/100:PIO4
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd c8/00:40:8d:9c:84/00:00:00:00:00/eb tag 0 dma 32768 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3.00: status: { DRDY }
ata3: soft resetting link
ata3.00: configured for UDMA/100
...
(3 more 100)
...
ata3.00: limiting speed to UDMA/33:PIO4
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd ca/00:08:9f:00:1a/00:00:00:00:00/e2 tag 0 dma 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3.00: status: { DRDY }
ata3: soft resetting link
ata3.00: configured for UDMA/33
...

Perhaps this gives a clue.
Or I just had bad luck and 2 of my 4 disks broke at the same time.

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux 2.6.23-jam05 (gcc 4.2.2 20071128 (4.2.2-2mdv2008.1)) SMP PREEMPT
