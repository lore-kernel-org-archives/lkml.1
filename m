Return-Path: <linux-kernel-owner+w=401wt.eu-S966049AbXCSRmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966049AbXCSRmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 13:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966050AbXCSRmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 13:42:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:11087 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966049AbXCSRmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 13:42:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=j9I5K+rkbQzURzDWhOdaEJyHM4t+lA6kihVxmd2dQ78AVeyWlohHuHP4yN56owrPc7XyRf0gtTZhQSdy7B3phuV6HN0naiSr8l2gqZrPFFinetrZp6E5DZSSHo1UWi7hGsoaCrSSH858cqbau83ba91sfUdFGy8vsy4SG9zTi/E=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH][5/5][resend] floppy.c: Fix device_create_file() warning
Date: Mon, 19 Mar 2007 18:42:22 +0100
User-Agent: KMail/1.9.6
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Trent Waddington" <trent.waddington@gmail.com>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, jesper.juhl@gmail.com
References: <200703191611.13849.jesper.juhl@gmail.com> <9a8748490703190816w2f4bc4b5je8d5c17d232f15c9@mail.gmail.com> <200703191620.00179.ak@suse.de>
In-Reply-To: <200703191620.00179.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703191842.24152.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 March 2007 16:20:00 Andi Kleen wrote:
> On Monday 19 March 2007 16:16, Jesper Juhl wrote:
> > On 19/03/07, Andi Kleen <ak@suse.de> wrote:
> > > > -            
> > > > device_create_file(&floppy_device[drive].dev,&dev_attr_cmos); +      
> > > >       err = device_create_file(&floppy_device[drive].dev,
> > > > &dev_attr_cmos); +             if (err)
> > > > +                     printk(KERN_WARNING "Unable to create sysfs
> > > > attribute " +                             "file for floppy device:
> > > > %s\n", +                             floppy_device[drive].name);
> > >
> > > That change looks pretty useless. Either the error should be handled
> > > correctly by bailing out or the warn_unused_results should be dropped.
> >
> > At least letting the user know that something failed is better than
> > the current situation of just failing silently I'd say.
>
> I don't think so. That's just bloat.
>

Ok, how about one of the following then?  
Personally I'd be ok with either one.


Either this : 

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 577c621..9d543f3 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4302,7 +4302,12 @@ static int __init floppy_init(void)
 		if (err)
 			goto out_flush_work;
 
-		device_create_file(&floppy_device[drive].dev,&dev_attr_cmos);
+		err = device_create_file(&floppy_device[drive].dev, &dev_attr_cmos);
+		if (err) {
+			printk(KERN_WARNING "Unable to create sysfs attribute "
+				"file for floppy device: %s\n", 
+				floppy_device[drive].name);
+			goto out_flush_work;
+		}
+
 		/* to be cleaned up... */
 		disks[drive]->private_data = (void *)(long)drive;
 		disks[drive]->queue = floppy_queue;


or this : 


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 577c621..9d543f3 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4302,7 +4302,12 @@ static int __init floppy_init(void)
 		if (err)
 			goto out_flush_work;
 
-		device_create_file(&floppy_device[drive].dev,&dev_attr_cmos);
+		err = device_create_file(&floppy_device[drive].dev, &dev_attr_cmos);
+		if (err)
+			goto out_flush_work;
+
 		/* to be cleaned up... */
 		disks[drive]->private_data = (void *)(long)drive;
 		disks[drive]->queue = floppy_queue;

