Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbYJ1Xwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbYJ1Xwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 19:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbYJ1XwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 19:52:23 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:59885 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286AbYJ1XwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 19:52:22 -0400
X-IronPort-AV: E=Sophos;i="4.33,502,1220227200"; 
   d="scan'208";a="184408042"
From: Roland Dreier <rdreier@cisco.com>
To: "Phillip O'Donnell" <phillip.odonnell@gmail.com>, jeff@garzik.org
Cc: "Oskar Liljeblad" <oskar@osk.mine.nu>, jeff@garzik.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] libata: Avoid overflow in ata_tf_to_lba48() when tf->hba_lbal > 127
References: <20081028170105.GA21933@osk.mine.nu>
	<7a9b5c320810281625kbf8904x9ba432ff0ca8c2f8@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 28 Oct 2008 16:52:20 -0700
In-Reply-To: <7a9b5c320810281625kbf8904x9ba432ff0ca8c2f8@mail.gmail.com>
	(Phillip O'Donnell's message of "Wed, 29 Oct 2008 12:25:47 +1300")
Message-ID: <ada4p2wmg5n.fsf_-_@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Oct 2008 23:52:21.0268 (UTC) FILETIME=[37CA4D40:01C93958]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ata_tf_to_lba48(), when evaluating

	(tf->hob_lbal & 0xff) << 24

the expression is promoted to signed int (since int can hold all values
of u8).  However, if hob_lbal is 128 or more, then it is treated as a
negative signed value and sign-extended when promoted to u64 to | into
sectors, which leads to the MSB 32 bits of section getting set
incorrectly.

For example, Phillip O'Donnell <phillip.odonnell@gmail.com> reported
that a 1.5GB drive caused:

    ata3.00: HPA detected: current 2930277168, native 18446744072344861488

where 2930277168 == 0xAEA87B30 and 18446744072344861488 == 0xffffffffaea87b30
which shows the problem when hob_lbal is 0xae.

Fix this by adding a cast to u64, just as is used by for hob_lbah and
hob_lbam in the function.

Reported-by: Phillip O'Donnell <phillip.odonnell@gmail.com>
Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
Phillip, this should fix at least your cosmetic issue; can you test it
and report back?

Thanks,
  Roland

 drivers/ata/libata-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index bbb3cae..10424ff 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1268,7 +1268,7 @@ u64 ata_tf_to_lba48(const struct ata_taskfile *tf)
 
 	sectors |= ((u64)(tf->hob_lbah & 0xff)) << 40;
 	sectors |= ((u64)(tf->hob_lbam & 0xff)) << 32;
-	sectors |= (tf->hob_lbal & 0xff) << 24;
+	sectors |= ((u64)(tf->hob_lbal & 0xff)) << 24;
 	sectors |= (tf->lbah & 0xff) << 16;
 	sectors |= (tf->lbam & 0xff) << 8;
 	sectors |= (tf->lbal & 0xff);
