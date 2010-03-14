Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586Ab0CNQQg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 12:16:36 -0400
Received: from mail-iw0-f176.google.com ([209.85.223.176]:48412 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab0CNQQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 12:16:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=p/ayIrW/jfL4w9eottO0D1QqOa/UUU2h5hQqr8P5RhifI7kqpbPj2d6zYcCNijGhSP
         7Bx1/3YtT6T9syjNwyGn7A4rkbgeAdPoCTaa7OlWpKPw6FRRb34k51vlp4h10M2N4iJJ
         xUOysg7CroF/jwYXeLwLxb6ZDyw96a/tShDjQ=
Message-ID: <4B9D0BDD.4030706@gmail.com>
Date: Sun, 14 Mar 2010 10:16:29 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
CC: ide <linux-ide@vger.kernel.org>
Subject: Re: nvidia controller failed command, possibly related to SMART selftest
 (2.6.32)
References: <20100313092559.GA14213@piper.oerlikon.madduck.net>
In-Reply-To: <20100313092559.GA14213@piper.oerlikon.madduck.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(ccing linux-ide)

On 03/13/2010 03:25 AM, martin f krafft wrote:
> Hello,
>
> I swapped in a new motherboard into a server that was previously
> having the occasional SATA hiccoughs[0]. It didn't last 24 hours
> before I got the next set of troubles:
>
> 0. http://marc.info/?l=linux-kernel&m=125654588201284&w=2
>
>    kernel: [45091.756037] ata4: EH in SWNCQ mode,QC:qc_active 0x1 sactive 0x1
>    kernel: [45091.756042] ata4: SWNCQ:qc_active 0x1 defer_bits 0x0 last_issue_tag 0x0
>    kernel: [45091.756043]   dhfis 0x1 dmafis 0x0 sdbfis 0x0
>    kernel: [45091.756046] ata4: ATA_REG 0x40 ERR_REG 0x0
>    kernel: [45091.756048] ata4: tag : dhfis dmafis sdbfis sacitve
>    kernel: [45091.756051] ata4: tag 0x0: 1 0 0 1
>    kernel: [45091.756063] ata4.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
>    kernel: [45091.756068] ata4.00: failed command: WRITE FPDMA QUEUED
>    kernel: [45091.756074] ata4.00: cmd 61/08:00:07:30:e1/00:00:01:00:00/40 tag 0 ncq 4096 out
>    kernel: [45091.756075]          res 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
>    kernel: [45091.756077] ata4.00: status: { DRDY }
>    kernel: [45091.756085] ata4: hard resetting link
>    kernel: [45091.756087] ata4: nv: skipping hardreset on occupied port
>    kernel: [45097.264713] ata4: link is slow to respond, please be patient (ready=0)
>    kernel: [45101.800044] ata4: SRST failed (errno=-16)
>                           […]
>    kernel: [45151.900793] ata4: reset failed, giving up
>    kernel: [45151.900797] ata4.00: disabled
>    kernel: [45151.900851] sd 3:0:0:0: [sdd] Unhandled error code
>    kernel: [45151.900853] sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
>    kernel: [45151.900856] sd 3:0:0:0: [sdd] CDB: Write(10): 2a 00 01 e1 30 07 00 00 08 00
>    kernel: [45151.900864] end_request: I/O error, dev sdd, sector 31535111
>    kernel: [45151.900870] raid1: Disk failure on sdd2, disabling device.
>    kernel: [45151.900871] raid1: Operation continuing on 1 devices.
>
> How do I learn how to interpret such kernel logs?
> Does it suggest anything about who's at fault?

Well, it seems like a genuine timeout, though it's not clear why the 
reset ended up failing afterwards. It could be that the drive's 
implementation of the SMART self test is buggy (it's supposed to still 
respond to host commands while it's running, but it could be it doesn't 
always, or takes so long to respond that the kernel times out).

>
> If it's of any relevance, the problems also occured with 2.6.26, but
> the RAID code didn't always eject the disks on that kernel; the
> first time I encountered a degraded array due to this was shortly
> after the upgrade to 2.6.32. However, this is speculation, I have
> not verified the causality.
>
>
> All this happened at 2:09am, which made me wonder about smartd, and
> indeed this is the time I scheduled SMART self-tests on the device.
>
> What's more: I can reproduce the problem at will, e.g. run a short
> SMART self-test and a RAID resync on the device at the same time,
> and boom!
>
> However, I can only reproduce this on two disks, which are on
> separate SATA controller channels ata2 and ata4, which makes me
> think that the problems are with the disks, not with the controller
> (ata1 and ata3 stand up fine to the stress test)
>
> Generally, SMART self-tests should be a transparent operation that
> doesn't affect the operating system's use of the devices, right? Is
> it conceivable or even common that the disks' own controllers are
> broken to the point where they fall over SMART tests?
>
> Thank you for any feedback,
>

