Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbZH0VWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbZH0VWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 17:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbZH0VWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 17:22:32 -0400
Received: from tanas.ca ([206.248.136.31]:48631 "EHLO tanas.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033AbZH0VWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 17:22:32 -0400
MIME-Version: 1.0
Date: Thu, 27 Aug 2009 17:22:31 -0400
From: Andrei Tanas <andrei@tanas.ca>
To: Andrei Tanas <andrei@tanas.ca>
Cc: Ric Wheeler <rwheeler@redhat.com>, NeilBrown <neilb@suse.de>,
       <linux-kernel@vger.kernel.org>
Subject: MD/RAID time out writing superblock
In-Reply-To: <1571f45804875514762f60c0097171e6@localhost>
References: <004e01ca25e4$c11a54e0$434efea0$@ca>    <9cfb6af689a7010df166fdebb1ef516b.squirrel@neil.brown.name>    <4A948A82.4080901@redhat.com> <b585ed9f13649050bbc984869d081315.squirrel@neil.brown.name> <4A94905F.7050705@redhat.com> <005101ca25f4$09006830$1b013890$@ca> <4A94A0E6.4020401@redhat.com> <005401ca25ff$9ac91cc0$d05b5640$@ca> <4A950FA6.4020408@redhat.com> <92cb16daad8278b0aa98125b9e1d057a@localhost> <4A95573A.6090404@redhat.com> <1571f45804875514762f60c0097171e6@localhost>
Message-ID: <d086b110526f8bac2f562850dfc70b03@localhost>
User-Agent: RoundCube Webmail/0.2.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is about the same problem that I wrote two days ago (md gets an error
while writing superblock and fails a hard drive).

I've tried to figure out what's really going on, and as far as I can tell,
the disk doesn't really fail (as confirmed by multiple tests), it times out
trying to execute ATA_CMD_FLUSH_EXT ("at2.00 cmd ea..." in the log)
command. The reason for this I believe is that md_super_write queues the
write comand with BIO_RW_SYNCIO flag.
As I wrote before, with 32MB cache it is conceivable that it will take the
drive longer than 30 seconds (defined by SD_TIMEOUT in scsi/sd.h) to flush
its buffers.

Changing safe_mode_delay to more conservative 2 seconds should definitely
help, but is it really necessary to write the superblock synchronously when
array changes status from active to active-idle?

[90307.328266] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
frozen
[90307.328275] ata2.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[90307.328277]          res 40/00:01:01:4f:c2/00:00:00:00:00/00 Emask 0x4
(timeout)
[90307.328280] ata2.00: status: { DRDY }
[90307.328288] ata2: hard resetting link
[90313.218511] ata2: link is slow to respond, please be patient (ready=0)
[90317.377711] ata2: SRST failed (errno=-16)
[90317.377720] ata2: hard resetting link
[90318.251720] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[90318.338026] ata2.00: configured for UDMA/133
[90318.338062] ata2: EH complete
[90318.370625] end_request: I/O error, dev sdb, sector 1953519935
[90318.370632] md: super_written gets error=-5, uptodate=0

