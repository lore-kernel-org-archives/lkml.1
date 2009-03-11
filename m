Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbZCKBuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbZCKBuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 21:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbZCKBuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 21:50:44 -0400
Received: from web4115.mail.ogk.yahoo.co.jp ([124.83.200.77]:42385 "HELO
	web4115.mail.ogk.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753696AbZCKBun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 21:50:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=yj20050223; d=yahoo.co.jp;
  h=Message-ID:Received:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type;
  b=Wh3LW4NiFUpEEgmbuFc+NjC9StMJUdqrbzrdaarzD3wAjhWdCDyZ+4m91UGGi7mnTmd3UhDGUtTpS5wGTtOfxNhFiW/BR2aRi8MsJYR4RnmyEBpJS5mM/fgFlzdukmsN  ;
Message-ID: <20090311015039.42922.qmail@web4115.mail.ogk.yahoo.co.jp>
Date: Wed, 11 Mar 2009 10:50:39 +0900 (JST)
From: Norman Diamond <n0diamond@yahoo.co.jp>
Reply-To: n0diamond@yahoo.co.jp
Subject: Off-by-one in both LIBATA and IDE drivers
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Cc: n0diamond@yahoo.co.jp
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like both LIBATA and the old IDE drivers have an
off-by-one error in deciding whether to use READ SECTOR(S)
instead of READ SECTOR(S) EXT.

Sorry the kernel numbers are in the range around 2.6.24. 
Knoppix 6.0.1 has a newer kernel but doesn't have hdparm,
so I haven't tested it yet.  Also this adds onto a thread
that I started in linux-kernel yesterday, but a lot of
information here is new.

LBA number 0x0fffffff fits in 28 bits but READ SECTOR(S)
can't reliably handle it.  In my testing the largest LBA
number that could be read reliably using READ SECTOR(S) is
0x0ffffffe.

It looks like a Western Digital drive could handle sector
number 0x0fffffff in LBA28, but Toshiba and Seagate
couldn't.

This can be reproduced using commands
hdparm --read-sector 268435455 /dev/sda
or
hdparm --read-sector 268435455 /dev/hda
depending on which driver is involved.

Sectors 268435454 and 268435456 have no problem.  I didn't
take a close look but a pretty obvious guess is that LBA28
worked for the preceding one and LBA48 worked for the
following one.

If LIBATA is in charge, dmesg shows that the command was
0x20 (READ SECTOR) and the sector number appears to be
correct, but the error bit is IDNF.

If IDE is in charge, dmesg shows that the command was 0x20
(READ SECTOR) and the sector number is shown as 16777215
instead of 268435455.  This looks like an error in the
error message to compound the error in the main code. 
I'll guess the command had the additional nibble correct,
just that LBA28 can't handle it.

Sometimes the dd command can read that sector but
sometimes not.  If dd fails then dmesg shows several error
messages with sector numbers, 0x0ffffff8, 268435448, and
33554431.  Someone decides 8 sectors should be read so the
start sector makes sense in both hex and decimal, but the
error sector is missing three bits instead of missing an
entire nibble.  And here, the command code is 0xc8, READ
DMA, LBA28 again.  This one needs changing to READ DMA
EXT.

All drives in my test were SATA, and the chipsets were
ICH7 or ICH7M, but BIOSes differed in setting ICH7 to
expose IDE or SATA interfaces.  In the case with ICH7 and
full SATA operation, the Western Digital drive worked but
Seagate failed.


--------------------------------------
Power up the Internet with Yahoo! Toolbar.
http://pr.mail.yahoo.co.jp/toolbar/
