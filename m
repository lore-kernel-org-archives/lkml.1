Return-Path: <linux-kernel-owner+w=401wt.eu-S1753943AbZCJIUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbZCJIUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 04:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbZCJIUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 04:20:10 -0400
Received: from web4113.mail.ogk.yahoo.co.jp ([124.83.200.75]:22501 "HELO
	web4113.mail.ogk.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753014AbZCJIUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 04:20:08 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Mar 2009 04:20:08 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=yj20050223; d=yahoo.co.jp;
  h=Message-ID:Received:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type;
  b=hYLaHzo/69DQvhQWl7sMKtGpO19t3i5Xy7WjelkWdUlaV2gRc4OPajMW4OkMG5OpK8gn/UZKTL0ghO5tLHl9CQtRXgCfkf0Am54QwA97XMyH+ZLAUE/MwF8hCeo8B3By  ;
Message-ID: <20090310081325.25764.qmail@web4113.mail.ogk.yahoo.co.jp>
Date: Tue, 10 Mar 2009 17:13:24 +0900 (JST)
From: Norman Diamond <n0diamond@yahoo.co.jp>
Reply-To: n0diamond@yahoo.co.jp
Subject: LIBATA told me it's broken
To: linux-kernel@vger.kernel.org
Cc: n0diamond@yahoo.co.jp
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry the kernel is 2.6.24.3 but I can't use a newer one
yet because TASKFILEs broke in newer ones.  This time I
booted with kernel parameter hda=noprobe so the hard disk
went to LIBATA instead of IDE.  The breakage shown below
is in LIBATA.

If LIBATA is fixed in newer kernel versions please say. 
If there's a version of Slax where LIBATA works then maybe
I can recompile its kernel without IDE.

struct sg_io_hdr sg_io;
uint8_t cdb[16];
uint8_t sense[32];
uint8_t buffer[0x20000];  // length = 256 * 512
memset(&sg_io, 0, sizeof sg_io);
memset(&cdb, 0, sizeof cdb);
memset(&sense, 0, sizeof sense);
memset(&buffer, 0xe5, sizeof buffer);
cdb[0] = 0x8a;            // WRITE (16)
cdb[6] = 0x0f;
cdb[7] = 0xff;
cdb[8] = 0xff;
cdb[9] = 0x00;            // start = 0x0fffff00
cdb[12] = 0x01;
cdb[13] = 0x00;           // count = 0x0100
sg_io.interface_id = 'S';
sg_io.cmdp = cdb;
sg_io.cmd_len = sizeof cdb;
sg_io.dxferp = buffer;
sg_io.dxfer_len = 256 * 512;
sg_io.dxfer_direction = SG_DXFER_TO_DEV;
sg_io.sbp = sense;
sg_io.mx_sb_len = sizeof sense;
sg_io.timeout = 2000;
fd = open("/dev/sda", O_WRONLY);  // succeeded
ioctl(fd, SG_IO, &sg_io);         // ioctl succeeded
                                  // but LIBATA failed

CHECK CONDITION
sense:
72 0b 14 00 00 00 00 0c 00 0a 80 00 00 00 00 00
0f ff ff 00

/dev/sda is a 250GB SATA drive but Dell's Intel ICH7M
presents it as ATA.  Ranges before and after the magic
LBA28 boundary wrote perfectly.



--------------------------------------
Power up the Internet with Yahoo! Toolbar.
http://pr.mail.yahoo.co.jp/toolbar/
