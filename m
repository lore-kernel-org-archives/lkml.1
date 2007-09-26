Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbXIZU0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbXIZU0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 16:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbXIZU0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 16:26:45 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:9717 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbXIZU0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 16:26:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=HyAJtRjfCn4KOJa5pKSSMvFM7nVJjdCi8fQjpeWqgXwpGOBPv7isDpnJef0nKgr/WTX3oJtjTY2kSUibrUXdqWjoBotRBt7/sYMLqsEp07OWm5GdLQTXOR3ibQhkZwbx8yDA0y1A12ZTR/+dimz+bx1QY8fJWySD3QyruildHI8=
Message-ID: <64bb37e0709261326h4890a07fx60c7d6772e4e63c4@mail.gmail.com>
Date: Wed, 26 Sep 2007 22:26:43 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Tejun Heo" <htejun@gmail.com>, "Jeff Garzik" <jeff@garzik.org>
Subject: sata_sil24 broken since 2.6.23-rc4-mm1
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As reported in the "2.6.23-rc4-mm1"-thread and the "What's in
linux-2.6-block.git for 2.6.24"-thread I'm having trouble that
sometimes on bootup one drive from the SiI-3132 throws errors and
becomes inaccesible.

The latest kernel I have seen this error was 2.6.23-rc7-mm1.
>From 7 boots 2 times the following happend:

Sep 25 07:42:11 treogen [   33.810000] md1: bitmap initialized from
disk: read 10/10 pages, set 0 bits
Sep 25 07:42:11 treogen [   33.810000] created bitmap (145 pages) for device md1
Sep 25 07:42:11 treogen [   63.910000] ata1.00: exception Emask 0x0
SAct 0x1 SErr 0x0 action 0x6 frozen
Sep 25 07:42:11 treogen [   63.910000] ata1.00: cmd
61/08:00:09:d6:42/00:00:25:00:00/40 tag 0 cdb 0x0 data 4096 out
Sep 25 07:42:11 treogen [   63.910000]          res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Sep 25 07:42:11 treogen [   63.910000] ata1.00: status: {DRDY }
Sep 25 07:42:11 treogen [   63.910000] ata1: hard resetting link
Sep 25 07:42:11 treogen [   66.210000] ata1: softreset failed (port not ready)
Sep 25 07:42:11 treogen [   66.210000] ata1: reset failed (errno=-5),
retrying in 8 secs
Sep 25 07:42:11 treogen [   73.910000] ata1: hard resetting link
Sep 25 07:42:11 treogen [   76.210000] ata1: softreset failed (port not ready)
Sep 25 07:42:11 treogen [   76.210000] ata1: reset failed (errno=-5),
retrying in 8 secs
Sep 25 07:42:11 treogen [   83.910000] ata1: hard resetting link
Sep 25 07:42:11 treogen [   86.210000] ata1: softreset failed (port not ready)
Sep 25 07:42:11 treogen [   86.210000] ata1: reset failed (errno=-5),
retrying in 33 secs
Sep 25 07:42:11 treogen [  118.910000] ata1: limiting SATA link speed
to 1.5 Gbps
Sep 25 07:42:11 treogen [  118.910000] ata1: hard resetting link
Sep 25 07:42:11 treogen [  121.210000] ata1: softreset failed (port not ready)
Sep 25 07:42:11 treogen [  121.210000] ata1: reset failed, giving up
Sep 25 07:42:11 treogen [  121.210000] ata1.00: disabled
Sep 25 07:42:11 treogen [  121.210000] ata1: EH complete
Sep 25 07:42:11 treogen [  121.210000] sd 0:0:0:0: [sda] Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Sep 25 07:42:11 treogen [  121.210000] end_request: I/O error, dev
sda, sector 625137161
Sep 25 07:42:11 treogen [  121.210000] md: super_written gets
error=-5, uptodate=0
Sep 25 07:42:11 treogen [  121.210000] raid5: Disk failure on sda2,
disabling device. Operation continuing on 2 devices

Comparing the driver/ata directory from rc3-mm1 and rc4-mm1 the
following change looked the most suspicions to me:
http://git.kernel.org/?p=linux/kernel/git/jgarzik/libata-dev.git;a=blobdiff;f=drivers/ata/sata_sil24.c;h=3dcb223117be9739ee04d70b6bfc776a4b839a3f;hp=e0cd31aa8002350add53ba6ff07493e503275244;hb=020bc1bd8d369a77bd9379cd9763ac0057651753;hpb=8d4bdf8087e682df98bdb856f6ad451bf6d597e7

That after rc4-mm1 the sata_sil24.c did not change anymore also
matches the occurrence of the error.

To confirm my theorie I exchanged the sata_sil24.c from rc8-mm1 with
the version from rc3-mm1.
I was able to boot the resulting kernel successfully 5 times, without
the error happening again.

Torsten
