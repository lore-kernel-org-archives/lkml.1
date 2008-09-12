Return-Path: <linux-kernel-owner+w=401wt.eu-S1758453AbYILVH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758453AbYILVH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 17:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756247AbYILVHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 17:07:17 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:44617 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564AbYILVHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 17:07:15 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Organization: Mandriva
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: Partition check considered as error is breaking mounting in 2.6.27
Date: Fri, 12 Sep 2008 18:07:27 -0300
User-Agent: KMail/1.9.10
Cc: "Alan Stern" <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, bogdano@mandriva.com.br,
       "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       "Abdel Benamrouche" <draconux@gmail.com>,
       "Damien Lallement" <dlallement@mandriva.com>,
       "pterjan@mandriva.com" <pterjan@mandriva.com>,
       "Jens Axboe" <axboe@kernel.dk>
References: <Pine.LNX.4.44L0.0809121423030.14509-100000@iolanthe.rowland.org> <200809121714.05443.herton@mandriva.com.br> <b6c5339f0809121327k5fd6c980le0ec5d46be089af2@mail.gmail.com>
In-Reply-To: <b6c5339f0809121327k5fd6c980le0ec5d46be089af2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809121807.28345.herton@mandriva.com.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 September 2008 17:27:54 Bob Copeland wrote:
> On Fri, Sep 12, 2008 at 4:14 PM, Herton Ronaldo Krzesinski
> <herton@mandriva.com.br> wrote:
> > diff --git a/fs/partitions/check.c b/fs/partitions/check.c
> > index 7d6b34e..15c70df 100644
> > --- a/fs/partitions/check.c
> > +++ b/fs/partitions/check.c
> > @@ -499,9 +499,9 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
> >                if (!size)
> >                        continue;
> >                if (from + size > get_capacity(disk)) {
> > -                       printk(KERN_ERR " %s: p%d exceeds device capacity\n",
> > +                       printk(KERN_WARNING
> > +                               " %s: p%d exceeds device capacity\n",
> >                                disk->disk_name, p);
> > -                       continue;
> 
> It might make sense to comment here that we intentionally want to add the
> partition anyway.  That might keep someone from re-adding the continue (same
> patch has already come up at least 3 times).
> 

Yes, here goes a new version:

___

fs/partition/check.c: revert part of commit 04ebd4aee52b06a2c38127d9208546e5b96f3a19

Fix regression introduced by commit 04ebd4aee52b06a2c38127d9208546e5b96f3a19,
where kernel changed behaviour making fatal the error when some partition
exceeds the limit of the device size. Some buggy devices become inacessible
because of errors in their partition table if the error is fatal.

This closes http://bugzilla.kernel.org/show_bug.cgi?id=11554

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>

diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 7d6b34e..2dd346d 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -499,9 +499,13 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 		if (!size)
 			continue;
 		if (from + size > get_capacity(disk)) {
-			printk(KERN_ERR " %s: p%d exceeds device capacity\n",
+			printk(KERN_WARNING
+				" %s: p%d exceeds device capacity\n",
 				disk->disk_name, p);
-			continue;
+			/* note: we don't want to break access to
+			 * devices with buggy partition tables, so we
+			 * don't want to fail here, just go on and
+			 * add partition */
 		}
 		res = add_partition(disk, p, from, size, state->parts[p].flags);
 		if (res) {



-- 
[]'s
Herton
