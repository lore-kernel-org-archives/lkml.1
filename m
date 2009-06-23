Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbZFWK7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbZFWK7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 06:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbZFWK7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 06:59:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36692
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752761AbZFWK7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 06:59:21 -0400
Date: Tue, 23 Jun 2009 03:59:26 -0700 (PDT)
Message-Id: <20090623.035926.155211513.davem@davemloft.net>
To: elendil@planet.nl
Cc: bzolnier@gmail.com, sparclinux@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide-cd: Improve "weird block size" error message
From: David Miller <davem@davemloft.net>
In-Reply-To: <200906230951.24615.elendil@planet.nl>
References: <200906222101.38586.elendil@planet.nl>
	<200906222335.06700.bzolnier@gmail.com>
	<200906230951.24615.elendil@planet.nl>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frans Pop <elendil@planet.nl>
Date: Tue, 23 Jun 2009 09:51:23 +0200

> In that case I'd like to propose the following patch. Currently the error
> can get printed much to frequently when there's a disc in the drive.
> Example:
> 
> Jun 13 18:06:28 gimli kernel: ide-cd: hdd: weird block size 2352
> Jun 13 18:06:28 gimli kernel: ide-cd: hdd: default to 2kb block size
> Jun 13 18:06:32 gimli kernel: ide-cd: hdd: weird block size 2352
> Jun 13 18:06:42 gimli kernel: ide-cd: hdd: default to 2kb block size

Thinking about this a bit.  Let's look at what problem this is
trying to avoid, as per the commit message:

--------------------
    ide-cd: fix oops when using growisofs
    
    cdrom_read_capacity() will blindly return the capacity from the device
    without sanity-checking it.  This later causes code in fs/buffer.c to
    oops.
    
    Fix this by checking that the device is telling us sensible things.
--------------------

Well, for the values Frans's CDROM is giving, this OOPS would not
take place and the weird sector value is completely harmless.

Since SECTOR_BITS is 9:

(2352 >> 9) == (2048 >> 9) == 4

There is simply no benefit from this warning in this situation.

Therefore, any objections to something like this?

ide-cd: Don't warn on bogus block size unless it actually matters.

Frans Pop reported that his CDROM drive reports a blocksize of 2352,
and this causes new warnings due to commit
e8e7b9eb11c34ee18bde8b7011af41938d1ad667 ("ide-cd: fix oops when using
growisofs").

What we're trying to do is make sure that "blocklen >> SECTOR_BITS"
is something the block layer won't choke on.

And for Frans case "2352 >> SECTOR_BITS" is equal to
"2048 >> SECTOR_BITS", and thats "4".

So warning in this case gives no real benefit.

Reported-by: Frans Pop <elendil@planet.nl>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 4a19686..a9a1bfb 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -876,9 +876,12 @@ static int cdrom_read_capacity(ide_drive_t *drive, unsigned long *capacity,
 		return stat;
 
 	/*
-	 * Sanity check the given block size
+	 * Sanity check the given block size, in so far as making
+	 * sure the sectors_per_frame we give to the caller won't
+	 * end up being bogus.
 	 */
 	blocklen = be32_to_cpu(capbuf.blocklen);
+	blocklen = (blocklen >> SECTOR_BITS) << SECTOR_BITS;
 	switch (blocklen) {
 	case 512:
 	case 1024:
