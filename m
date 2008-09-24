Return-Path: <linux-kernel-owner+w=401wt.eu-S1752268AbYIXHLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbYIXHLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 03:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbYIXHLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 03:11:03 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:1881 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbYIXHLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 03:11:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=Ct/FqKHZ1cL55+f0V5zM/ZuRGEXH2jB0v4nepplYpEOQTzMY5Iy6DynNtUHxTZlJ3e
         /Sn17iFdKb74Yk06fr0CT2JnYFEGsv/H8FIhg0yrJBzWQikorbogqAGstd0B0v8CNw+k
         U/RmRZIDx2R+p67VVqff//rEBjWV9edunP6vE=
Date: Wed, 24 Sep 2008 09:10:55 +0200
To: bzolnier@gmail.com
Cc: Mark de Wever <koraq@xs4all.nl>, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Gadi Oxman <gadio@netvision.net.il>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IDE-TAPE NULL terminate strings.
Message-ID: <20080924071055.GB16949@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, bzolnier@gmail.com,
	Mark de Wever <koraq@xs4all.nl>,
	Sergei Shtylyov <sshtylyov@ru.mvista.com>,
	Gadi Oxman <gadio@netvision.net.il>, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080921185138.GA16310@localhost> <48D79ABD.8060805@ru.mvista.com> <9ea470500809220656j6dfcf4c9q7a5a4185481ec994@mail.gmail.com> <20080922204129.GA3495@localhost> <48D80949.4080901@ru.mvista.com> <20080923074845.GB5656@gollum.tnic> <20080923165914.GA7803@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923165914.GA7803@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 06:59:14PM +0200, Mark de Wever wrote:
> On Tue, Sep 23, 2008 at 09:48:45AM +0200, Borislav Petkov wrote:
> > ---
> > diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> > index 1bce84b..3833189 100644
> > --- a/drivers/ide/ide-tape.c
> > +++ b/drivers/ide/ide-tape.c
> > @@ -2338,7 +2338,7 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
> >  {
> >  	idetape_tape_t *tape = drive->driver_data;
> >  	struct ide_atapi_pc pc;
> > -	char fw_rev[6], vendor_id[10], product_id[18];
> > +	char fw_rev[4], vendor_id[8], product_id[16];
> >  
> >  	idetape_create_inquiry_cmd(&pc);
> >  	if (idetape_queue_pc_tail(drive, &pc)) {
> > @@ -2350,11 +2350,11 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
> >  	memcpy(product_id, &pc.buf[16], 16);
> >  	memcpy(fw_rev, &pc.buf[32], 4);
> >  
> > -	ide_fixstring(vendor_id, 10, 0);
> > -	ide_fixstring(product_id, 18, 0);
> > -	ide_fixstring(fw_rev, 6, 0);
> > +	ide_fixstring(vendor_id, 8, 0);
> > +	ide_fixstring(product_id, 16, 0);
> > +	ide_fixstring(fw_rev, 4, 0);
> >  
> > -	printk(KERN_INFO "ide-tape: %s <-> %s: %s %s rev %s\n",
> > +	printk(KERN_INFO "ide-tape: %s <-> %s: %.8s %.16s rev %.4s\n",
> >  			drive->name, tape->name, vendor_id, product_id, fw_rev);
> >  }
> >  
> >
> 
> I think this patch looks good, better as all previous versions
> (including my initial version). I just tested it and it solves the
> problem. Feel free to add my tested-by.
> 
> Regards,
> Mark de Wever
> 
> PS I was not able to test earlier ;-)

Bart,

please apply the following patch.

@Sergei: would you like to add your Signed-off-by too?

--
Subject: ide-tape: fix vendor strings

Remove superfluous two bytes from each string buffer and add proper length
format specifiers.

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
Tested-by: Mark de Wever <koraq@xs4all.nl>

--

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 1bce84b..3833189 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2338,7 +2338,7 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc pc;
-	char fw_rev[6], vendor_id[10], product_id[18];
+	char fw_rev[4], vendor_id[8], product_id[16];
 
 	idetape_create_inquiry_cmd(&pc);
 	if (idetape_queue_pc_tail(drive, &pc)) {
@@ -2350,11 +2350,11 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
 	memcpy(product_id, &pc.buf[16], 16);
 	memcpy(fw_rev, &pc.buf[32], 4);
 
-	ide_fixstring(vendor_id, 10, 0);
-	ide_fixstring(product_id, 18, 0);
-	ide_fixstring(fw_rev, 6, 0);
+	ide_fixstring(vendor_id, 8, 0);
+	ide_fixstring(product_id, 16, 0);
+	ide_fixstring(fw_rev, 4, 0);
 
-	printk(KERN_INFO "ide-tape: %s <-> %s: %s %s rev %s\n",
+	printk(KERN_INFO "ide-tape: %s <-> %s: %.8s %.16s rev %.4s\n",
 			drive->name, tape->name, vendor_id, product_id, fw_rev);
 }
 

-- 
Regards/Gruss,
    Boris.
