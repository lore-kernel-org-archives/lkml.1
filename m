Return-Path: <linux-kernel-owner+w=401wt.eu-S1754294AbZFOFf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbZFOFf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 01:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751173AbZFOFfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 01:35:18 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:54250 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbZFOFfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 01:35:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=M5KINC5OGqijRuu7hbQyGJLt/6b3j1HsfjYb5jGtppsLLdA/YYeUb1SdeC2brxkrDD
         bLMEaJXtKVaTExDbgn6wK5IrGkiLwXOVu7sXer+u2/uiWxfPz3vWvXGS4TZDJRAn6pIu
         x/R0oTZrdg1N9kM1qAdZZAWBwdTAipMvEP3l8=
Date: Mon, 15 Jun 2009 07:35:14 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: ide tree build failure
Message-ID: <20090615053514.GA13226@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090615113430.21122e44.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090615113430.21122e44.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 15, 2009 at 11:34:30AM +1000, Stephen Rothwell wrote:
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> drivers/ide/ide-tape.c: In function 'idetape_chrdev_open':
> drivers/ide/ide-tape.c:1515: error: implicit declaration of function 'idetape_read_position'
> 
> Caused by commit 55ce3a129ea2e8faba4a11bb5dbc305590d1c20c ("ide-tape: fix
> READ POSITION cmd handling") interacting with the later merge
> 8dcce4081305d3d1629190edd112e6473c315cbc ("Merge branch
> 'bp-remove-pc-buf' into for-next").
> 
> I have used the ide tree from next-20090612 for today.

Ah, the function got renamed in 55ce3a129ea2e8faba4a11bb5dbc305590d1c20c. Here's
a fix:

---
From: Borislav Petkov <petkovbb@gmail.com>
Date: Mon, 15 Jun 2009 07:32:04 +0200
Subject: [PATCH] ide-tape: fix build issue

This fixes

drivers/ide/ide-tape.c: In function `idetape_chrdev_open':
drivers/ide/ide-tape.c:1515: error: implicit declaration of function `idetape_read_position'
make[1]: *** [drivers/ide/ide-tape.o] Error 1

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index bb71e1e..3a3f10f 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1512,7 +1512,7 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 		goto out_put_tape;
 	}
 
-	idetape_read_position(drive);
+	ide_tape_read_position(drive);
 	if (!test_bit(ilog2(IDE_AFLAG_ADDRESS_VALID), &drive->atapi_flags))
 		(void)idetape_rewind_tape(drive);
 
-- 
1.6.3.1


-- 
Regards/Gruss,
    Boris.
