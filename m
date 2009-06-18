Return-Path: <linux-kernel-owner+w=401wt.eu-S1758378AbZFRQGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378AbZFRQGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 12:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbZFRQGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 12:06:34 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:34165 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbZFRQGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 12:06:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=H5ORdABXSNeKDVzLgg/qvuD2eaABtplGTiifn+65SLs78I0kin7SE7+06v3GGptJyq
         LLzRLCPq+X7UiLyCyp9YJhQk/y6bmlxQic6u5mKstw0hj2jXQvzkvY9TD0rADAuwSraY
         SdbSLjF9TO0K2/02Dxq0Lwz+XwMc1FO1CAnww=
MIME-Version: 1.0
In-Reply-To: <87r5xh8ty7.fsf@fever.mssgmbh.com>
References: <87zlc58xgd.fsf@fever.mssgmbh.com>
	 <9ea470500906180739qdabce04u7c7875acc05358f@mail.gmail.com>
	 <87r5xh8ty7.fsf@fever.mssgmbh.com>
Date: Thu, 18 Jun 2009 18:06:34 +0200
Message-ID: <9ea470500906180906o2d558a90hbcba11874ff8917b@mail.gmail.com>
Subject: Re: [PATCH] ide-cd: prevent null pointer deref via cdrom_newpc_intr
From: Borislav Petkov <petkovbb@googlemail.com>
To: Rainer Weikusat <rweikusat@mssgmbh.com>
Cc: linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, bruinjm@xs4all.nl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 18, 2009 at 5:04 PM, Rainer Weikusat<rweikusat@mssgmbh.com> wrote:
> From: Rainer Weikusat <rweikusat@mssgmbh.com>
>
> With 2.6.30, the error handling code in cdrom_newpc_intr was changed
> to deal with partial request failures by normally completing the 'good'
> parts of a request and only 'error' the last (and presumably,
> incompletely transferred) bio associated with a particular
> request. In order to do this, ide_complete_rq is called over
> ide_cd_error_cmd() to partially complete the rq. The block layer
> does partial completion only for requests with bio's and if the
> rq doesn't have one (eg 'GPCMD_READ_DISC_INFO') the request is
> completed as a whole and the drive->hwif->rq pointer set to NULL
> afterwards. When calling ide_complete_rq again to report
> the error, this null pointer is derefenced, resulting in a kernel
> crash.

Sorry, but still not good enough. Instead, I rediffed the change against
current linux-ide branch and rewrote the commit message properly keeping
your S-O-B.

@Bart: please apply.

--
From: Rainer Weikusat <rweikusat@mssgmbh.com>
Date: Thu, 18 Jun 2009 17:48:24 +0200
Subject: [PATCH] ide-cd: don't do partial completions on bio-less rqs

The block layer completes bio-less requests totally instead of partially
and this breaks cdrom drives which fragment packet command data in
several DRQ turns (eg GPCMD_READ_DISC_INFO).

More specifically, ide_complete_rq() is called over ide_cd_error_cmd()
to partially complete the rq on error. This bio-less request is
completed as a whole and when calling ide_complete_rq again to complete
the request wholly, the rq is already vanished resulting in the
following OOPS:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
IP: [<ffffffff804deb50>] ide_complete_rq+0x19/0x4d
PGD 0
Thread overran stack, or stack corrupted
Oops: 0000 [#1] SMP
last sysfs file:
CPU 0
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.30-rc8 #22 Precision WorkStation 380
RIP: 0010:[<ffffffff804deb50>]  [<ffffffff804deb50>] ide_complete_rq+0x19/0x4d
RSP: 0018:ffff880028022e18  EFLAGS: 00010096
RAX: 0000000000000002 RBX: ffff88011a84e000 RCX: 0000000000000200
RDX: 0000000000000200 RSI: 0000000000000000 RDI: ffff88011afc9000
RBP: ffff880028022e28 R08: 00000000fffffffb R09: 0000000000000000
R10: ffff8800280302e8 R11: ffff880028030310 R12: 0000000000000000
R13: 0000000000000000 R14: ffff88011afc9000 R15: ffff88011aff7140
FS:  0000000000000000(0000) GS:ffff88002801f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000048 CR3: 0000000000201000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff809c0000, task ffffffff808f1360)
Stack:
 ffff88011aecf840 ffff88011aff7140 ffff880028022eb8 ffffffff804ed0ef
 ffffffff8025a811 00ff880028022e70 ffffffff00000050 ffff88011a84e000
 ffff88011a84e108 000000008025ef72 0000000000000000 ffff88011a84e000
Call Trace:
 <IRQ> <0> [<ffffffff804ed0ef>] cdrom_newpc_intr+0x20e/0xac5
 [<ffffffff8025a811>] ? irq_exit+0x47/0x7d
 [<ffffffff804ecee1>] ? cdrom_newpc_intr+0x0/0xac5
 [<ffffffff804de920>] ide_intr+0x1d2/0x220
 [<ffffffff80284ee1>] handle_IRQ_event+0x3a/0xba
 [<ffffffff80286c38>] handle_edge_irq+0xce/0x133
 [<ffffffff8022c0cd>] handle_irq+0x1d/0x29
 [<ffffffff8022b8c7>] do_IRQ+0x5a/0xd5
 [<ffffffff8022a013>] ret_from_intr+0x0/0xa
 <EOI> <0> [<ffffffff80230eee>] ? mwait_idle+0x60/0x6e
 [<ffffffff802282c2>] ? enter_idle+0x20/0x22
 [<ffffffff802286ef>] ? cpu_idle+0x4a/0x8d
 [<ffffffff806ebb05>] ? rest_init+0x65/0x70
 [<ffffffff809cdcef>] ? start_kernel+0x2da/0x3bb
 [<ffffffff809cd271>] ? x86_64_start_reservations+0x81/0xbc
 [<ffffffff809cd37b>] ? x86_64_start_kernel+0xcf/0xf1
Code: c3 48 25 ff ff ff fe 48 89 47 50 e8 a7 86 00 00 eb d7 55 48 89
e5 53 48 83 ec 08 41 89 f0 89 d1 48 8b 5f 40 48 8b b3 28 03 00 00 <f6>
46 48 0e 74 05 45 85 c0 7e 1e 44 89 c2 e8 85 ff ff ff 85 c0
RIP  [<ffffffff804deb50>] ide_complete_rq+0x19/0x4d
 RSP <ffff880028022e18>
CR2: 0000000000000048
---[ end trace 6662ae44d700bf58 ]---

This fixes http://bugzilla.kernel.org/show_bug.cgi?id=13399.

Tested-by: Hans de Bruin <bruinjm@xs4all.nl>
Signed-Off-By: Rainer Weikusat <rweikusat@mssgmbh.com>
Signed-Off-By: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 0b7645b..4a19686 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -667,7 +667,7 @@ out_end:
 				rq->errors = -EIO;
 		}

-		if (uptodate == 0)
+		if (uptodate == 0 && rq->bio)
 			ide_cd_error_cmd(drive, cmd);

 		/* make sure it's fully ended */
-- 
1.6.3.1



-- 
Regards/Gruss,
Boris
