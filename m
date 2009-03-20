Return-Path: <linux-kernel-owner+w=401wt.eu-S1758888AbZCTDVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888AbZCTDVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 23:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754508AbZCTDUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 23:20:47 -0400
Received: from smtp05.mail.tnz.yahoo.co.jp ([203.216.246.68]:36146 "HELO
	smtp05.mail.tnz.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757535AbZCTDUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 23:20:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=yj20050223; d=yahoo.co.jp;
  h=Received:X-Apparently-From:Message-ID:From:To:Subject:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:X-MSMail-Priority:X-Mailer:X-MimeOLE;
  b=P9qUnh3F0H4EHTS4RP46F33aOsNVQbXOYxSniSu/xvnUfMMfhga250541x8QJibYHUQrOA3CiTZg7XyIqpPBJgx4HKoLDO/EDXFarbLKHM4/0sk5UcAfR9OBegoPki98  ;
X-Apparently-From: <n0diamond@yahoo.co.jp>
Message-ID: <F79C774361EF45A6A68BC08F8621E406@DIAMOND8600>
From: "Norman Diamond" <n0diamond@yahoo.co.jp>
To: <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>
Subject: Overagressive failing of disk reads, both LIBATA and IDE
Date: Fri, 20 Mar 2009 11:12:11 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-2022-jp";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For months I was wondering how a disk could do this:
dd if=/dev/hda of=/dev/null bs=512 skip=551540 count=4  # succeeds
dd if=/dev/hda of=/dev/null bs=512 skip=551544 count=4  # succeeds
dd if=/dev/hda of=/dev/null bs=512 skip=551540 count=8  # fails

It turns out the disk isn't doing that.  Linux is.  The old IDE drivers did
it, but with LIBATA the same thing happens to /dev/sda.  In later examples
also, the same happens to /dev/sda as /dev/hda.

Here's what the disk is really responsible for:
dd if=/dev/hda of=/dev/null bs=512 skip=551562 count=1  # really fails

Here's Linux to blame again:
dd if=/dev/hda of=/dev/null bs=512 skip=551561 count=1  # fails

When the drive reports an uncorrectable media error, Linux correctly records
it in the log.  But when the app didn't ask for that block, when blocks that
the app asked for were all read, Linux incorrectly reports failure to the
app.

I don't know how Linux decides how many blocks to read ahead, but no matter
how many it chooses, read ahead is read ahead.  Go ahead and record it in
the log.  I'd also like to suggest that if a user is logged in on the screen
(whether X11 or text) see if we can warn them that their disk is dying.  But
don't return a failure to the app.  If the blocks that the app asked for
were read, we should give them to the app, successfully.

Sheesh.

P.S.
One would expect this to persuade the hard drive to relocate the block:
dd if=/dev/zero of=/dev/hda bs=512 seek=551562 count=1
But it doesn't because Linux wants to read 4 blocks, modify 1, and write 4
blocks.  The read fails.

One would expect this to persuade the hard drive to relocate the block:
dd if=/dev/zero of=/dev/hda bs=512 seek=551560 count=4
But it doesn't because the hard drive reports success.  If an app tries to
read the bad sector again it still fails.  So the drive has egregiously bad
firmware.  That doesn't excuse Linux.

--------------------------------------
Power up the Internet with Yahoo! Toolbar.
http://pr.mail.yahoo.co.jp/toolbar/
