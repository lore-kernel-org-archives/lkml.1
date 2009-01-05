Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbZAETDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbZAETDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbZAETDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:03:05 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:38751 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbZAETDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:03:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=S7UgN8ZPNf05fvpwYE8/PPYWLZrvnsfliWvZ+KGnAumvwr3vuxpkheRFpD7KK/3KZl
         XrmXfH8KgfORWpTB+eLI0Z9syr1buO9SBeH+aXu+VGqpruRizCZdZwtFVYdrZ6ix72Fz
         myebhoUiVYLQqBOAs8W8TXglnImRRB9nMHLm8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] block: export SSD/non-rotational queue flag through sysfs
Date: Mon, 5 Jan 2009 20:02:15 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-next-20090102; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200901051952.58029.bzolnier@gmail.com> <20090105185428.GS32491@kernel.dk>
In-Reply-To: <20090105185428.GS32491@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901052002.15984.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 January 2009, Jens Axboe wrote:
> On Mon, Jan 05 2009, Bartlomiej Zolnierkiewicz wrote:
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] block: export SSD/non-rotational queue flag through sysfs
> > 
> > For some devices (i.e. CFA ATA) we can't reliably detect whether
> > the device is of rotational or non-rotational type so we need to
> > leave the final decision about this setting to the user-space.
> 
> I agree with that, was actually planning on doing that myself.
> 
> > @@ -146,8 +167,8 @@ static ssize_t queue_nomerges_store(stru
> >  		queue_flag_set(QUEUE_FLAG_NOMERGES, q);
> >  	else
> >  		queue_flag_clear(QUEUE_FLAG_NOMERGES, q);
> > -
> >  	spin_unlock_irq(q->queue_lock);
> > +
> >  	return ret;
> >  }
> >  
> 
> Hmm?

This is just a "bonus". :)

> > @@ -210,6 +231,12 @@ static struct queue_sysfs_entry queue_hw
> >  	.show = queue_hw_sector_size_show,
> >  };
> >  
> > +static struct queue_sysfs_entry queue_nonrot_entry = {
> > +	.attr = {.name = "nonrot", .mode = S_IRUGO | S_IWUSR },
> > +	.show = queue_nonrot_show,
> > +	.store = queue_nonrot_store,
> > +};
> > +
> 
> Lets please use a better name for export reasons, non-rotational is a
> lot better. Nobody will know what nonrot means :-)

Yeah...

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH v2] block: export SSD/non-rotational queue flag through sysfs

For some devices (i.e. CFA ATA) we can't reliably detect whether
the device is of rotational or non-rotational type so we need to
leave the final decision about this setting to the user-space.

As a bonus do a minor CodingStyle fixup in queue_nomerges_store().

Suggested-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 block/blk-sysfs.c |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

Index: b/block/blk-sysfs.c
===================================================================
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -130,6 +130,27 @@ static ssize_t queue_max_hw_sectors_show
 	return queue_var_show(max_hw_sectors_kb, (page));
 }
 
+static ssize_t queue_nonrot_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(blk_queue_nonrot(q), page);
+}
+
+static ssize_t queue_nonrot_store(struct request_queue *q, const char *page,
+				  size_t count)
+{
+	unsigned long nm;
+	ssize_t ret = queue_var_store(&nm, page, count);
+
+	spin_lock_irq(q->queue_lock);
+	if (nm)
+		queue_flag_set(QUEUE_FLAG_NONROT, q);
+	else
+		queue_flag_clear(QUEUE_FLAG_NONROT, q);
+	spin_unlock_irq(q->queue_lock);
+
+	return ret;
+}
+
 static ssize_t queue_nomerges_show(struct request_queue *q, char *page)
 {
 	return queue_var_show(blk_queue_nomerges(q), page);
@@ -146,8 +167,8 @@ static ssize_t queue_nomerges_store(stru
 		queue_flag_set(QUEUE_FLAG_NOMERGES, q);
 	else
 		queue_flag_clear(QUEUE_FLAG_NOMERGES, q);
-
 	spin_unlock_irq(q->queue_lock);
+
 	return ret;
 }
 
@@ -210,6 +231,12 @@ static struct queue_sysfs_entry queue_hw
 	.show = queue_hw_sector_size_show,
 };
 
+static struct queue_sysfs_entry queue_nonrot_entry = {
+	.attr = {.name = "non-rotational", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_nonrot_show,
+	.store = queue_nonrot_store,
+};
+
 static struct queue_sysfs_entry queue_nomerges_entry = {
 	.attr = {.name = "nomerges", .mode = S_IRUGO | S_IWUSR },
 	.show = queue_nomerges_show,
@@ -229,6 +256,7 @@ static struct attribute *default_attrs[]
 	&queue_max_sectors_entry.attr,
 	&queue_iosched_entry.attr,
 	&queue_hw_sector_size_entry.attr,
+	&queue_nonrot_entry.attr,
 	&queue_nomerges_entry.attr,
 	&queue_rq_affinity_entry.attr,
 	NULL,
