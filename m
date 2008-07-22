Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbYGVJ0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbYGVJ0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 05:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbYGVJ0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 05:26:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751414AbYGVJ0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 05:26:41 -0400
Date: Tue, 22 Jul 2008 02:25:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Michael Buesch <mb@bu3sch.de>, Jan Kara <jack@suse.cz>,
       Arnd Bergmann <arnd@arndb.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, stable@kernel.org
Subject: Re: Oops when using growisofs
Message-Id: <20080722022519.b827697f.akpm@linux-foundation.org>
In-Reply-To: <20080626183610.GI20851@kernel.dk>
References: <200806221818.24372.mb@bu3sch.de>
	<20080626170513.GE23386@duck.suse.cz>
	<20080626181142.GH20851@kernel.dk>
	<200806262021.32140.mb@bu3sch.de>
	<20080626183610.GI20851@kernel.dk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008 20:36:11 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:

> On Thu, Jun 26 2008, Michael Buesch wrote:
> > On Thursday 26 June 2008 20:11:42 Jens Axboe wrote:
> > > On Thu, Jun 26 2008, Jan Kara wrote:
> > > > On Wed 25-06-08 11:46:29, Michael Buesch wrote:
> > > > > On Wednesday 25 June 2008 11:37:00 Jan Kara wrote:
> > > > > > > Yeah the IO error is the trigger.
> > > > > > > I noticed that it had obvious troubles accessing the DVD that was in the drive.
> > > > > > > It sweeped over it for several seconds, then hung the system for 2 or 3 seconds
> > > > > > > and then oopsed. But after that everything continued to work as usual.
> > > > > > > (Except kded of course)
> > > > > >   Hmm, by "accessing" do you mean that you've mounted the burned DVD and when
> > > > > > browsing it the IO error and the oops occured or that IO error happened
> > > > > > when burning? It is important because in the first case i_blkbits would be
> > > > > > taken from some ISOFS inode desribing some file while in the second case
> > > > > > i_blkbits are from the inode of the device...
> > > > > I don't know. kded, which caused the oops, is always running. It is a KDE daemon
> > > > > that polls device state and so on. So yeah, it might have accessed the drive
> > > > > while growisofs was writing to it.
> > > > > 
> > > > > However with "accessing" I mean the DVD drive motor was spinning up and down
> > > > > and the laser lens was moving like crazy. The sound that happens, if you put
> > > > > a completely scratched DVD into the drive and it is unable to make sense of it.
> > > > > However, this was not scratched. It was a new DVD with one session on it that
> > > > > I just burnt 5 minutes before that. So I wanted to append another session to it
> > > > > and it crashed and resulted in IO errors in growisofs.
> > > >   I've been looking into this problem for some time. The only way how
> > > >   I see blocksize can be set so big is in cdrom_read_capacity() in
> > > >   drivers/ide/ide-cd.c. That basically blindly fills in
> > > >   queue->hardsect_size with what the drive returns and this can
> > > >   propagate in bd_set_size() to i_blkbits.  Jens, do you think that is
> > > >   possible? Shouldn't ide_cd_read_toc() do some sanity checks of the
> > > >   blocksize returned?
> > > 
> > > It can't hurt, the value should be >= 512b and <= 4kb. Normally it would
> > > be 2kb, but some devices have a 512b switch so that is also seen. Not
> > > sure that 1kb and 4kb are valid, but at least it would still point to
> > > the drive possibly returning valid data and not garbage. So accept all
> > > those, reject (and complain) if it isn't one of those and default to 2kb.
> > 
> > I agree with the need for a hardware sanity check and I would happily test
> > any RFC patch :)
> 
> Something like this, totally untested...
> 
> diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> index 68e7f19..5c1e663 100644
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -1308,13 +1308,29 @@ static int cdrom_read_capacity(ide_drive_t *drive, unsigned long *capacity,
>  	req.cmd_flags |= REQ_QUIET;
>  
>  	stat = ide_cd_queue_pc(drive, &req);
> -	if (stat == 0) {
> -		*capacity = 1 + be32_to_cpu(capbuf.lba);
> -		*sectors_per_frame =
> -			be32_to_cpu(capbuf.blocklen) >> SECTOR_BITS;
> +	if (stat)
> +		return stat;
> +
> +	/*
> +	 * Sanity check the given block size
> +	 */
> +	switch (capbuf.blocklen) {
> +	case 512:
> +	case 1024:
> +	case 2048:
> +	case 4096:
> +		break;
> +	default:
> +		printk(KERN_ERR "ide-cd: weird block size %u\n",
> +							capbuf.blocklen);
> +		printk(KERN_ERR "ide-cd: default to 2kb block size\n");
> +		capbuf.blocklen = 2048;
> +		break;
>  	}
>  
> -	return stat;
> +	*capacity = 1 + be32_to_cpu(capbuf.lba);
> +	*sectors_per_frame = be32_to_cpu(capbuf.blocklen) >> SECTOR_BITS;
> +	return 0;
>  }
>  
>  static int cdrom_read_tocentry(ide_drive_t *drive, int trackno, int msf_flag,
> 

This was all nearly a month ago and we missed 2.6.25.x and 2.6.26.

Jan has confirmed that the patch did fix the oops.  So I have put
toegether the below patch, which I will send in Bart's direction.  I
believe that Jens is offline at present.

Unfortunately the surrounding code has changed a bit in the current
post-2.6.26 mainline, but it is a small syntactic thing and the patch
can easily be backported.

I believe that the fix is needed in both 2.6.25.x and 2.6.26.x.


From: Jens Axboe <jens.axboe@oracle.com>

cdrom_read_capacity() will blindly return the capacity from the device
without sanity-checking it.  This later causes code in fs/buffer.c to
oops.

Fix this by checking that the device is telling us sensible things.

Cc: Michael Buesch <mb@bu3sch.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/ide-cd.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff -puN drivers/ide/ide-cd.c~oops-when-using-growisofs drivers/ide/ide-cd.c
--- a/drivers/ide/ide-cd.c~oops-when-using-growisofs
+++ a/drivers/ide/ide-cd.c
@@ -1309,13 +1309,29 @@ static int cdrom_read_capacity(ide_drive
 
 	stat = ide_cd_queue_pc(drive, cmd, 0, &capbuf, &len, sense, 0,
 			       REQ_QUIET);
-	if (stat == 0) {
-		*capacity = 1 + be32_to_cpu(capbuf.lba);
-		*sectors_per_frame =
-			be32_to_cpu(capbuf.blocklen) >> SECTOR_BITS;
+	if (stat)
+		return stat;
+
+	/*
+	 * Sanity check the given block size
+	 */
+	switch (capbuf.blocklen) {
+	case 512:
+	case 1024:
+	case 2048:
+	case 4096:
+		break;
+	default:
+		printk(KERN_ERR "ide-cd: weird block size %u\n",
+							capbuf.blocklen);
+		printk(KERN_ERR "ide-cd: default to 2kb block size\n");
+		capbuf.blocklen = 2048;
+		break;
 	}
 
-	return stat;
+	*capacity = 1 + be32_to_cpu(capbuf.lba);
+	*sectors_per_frame = be32_to_cpu(capbuf.blocklen) >> SECTOR_BITS;
+	return 0;
 }
 
 static int cdrom_read_tocentry(ide_drive_t *drive, int trackno, int msf_flag,
_

