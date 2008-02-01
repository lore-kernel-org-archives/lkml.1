Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbYBAIW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbYBAIW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 03:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbYBAIWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 03:22:47 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:60671 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbYBAIWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 03:22:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=PA9/TJNBxz9k2PvgGjTbRO4TlnRPOFDJ9zRix56mtFB87lYt3m+AqeIYv4xb7d2CzGofJ3YHwXfD6APPPx6uSn/hUBEQ4N7Kwb3Klle2+u1vZdDqGGySMLWuXGedCych7N+Xmo/dUZQtDWth0GiEvw1Epqmzu5hBm54QDA8CpBM=
Date: Fri, 1 Feb 2008 09:21:52 +0100
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 0/32] ide-tape redux v1
Message-ID: <20080201082152.GE4500@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1201423312-2460-1-git-send-email-bbpetkov@yahoo.de> <200801272045.40712.bzolnier@gmail.com> <20080128054343.GB3074@gollum.tnic> <200801300129.56003.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200801300129.56003.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 01:29:55AM +0100, Bartlomiej Zolnierkiewicz wrote:
> On Monday 28 January 2008, Borislav Petkov wrote:
> > Hi Bart,
> > 
> > [...]
> > 
> > > > the BKL in idetape_write_release() with finer-grained locking etc, probably also
> > > > some pipeline improvements, removal of OnStream support, etc. but that'll come
> > > > later.
> > > 
> > > On-Stream support has been long gone but it seems that deprecation
> > > warning etc. managed to survive.
> > > 
> > > w.r.t. to the pipeline-mode: it should be pipelined into /dev/null
> > > 
> > > rationale:
> > > - it is _very_ complex
> > > - causes errors to be deferred till the next user-space access
> > > - direct I/O using blk_rq_map_user() will offer superior performance
> > > 
> > > the only question is whether to remove it...
> > 
> > Well, on the one hand, since the driver is only being maintained we should not
> > remove code that works. Also, i don't know how many users ide-tape really has
> > but, would it be worth the trouble at all? Because if nobody's using it, we
> > could just as well pipe the whole thing into /dev/null.. On the other hand, the
> 
> This may be the other alternative... [ there is always libata PATA... ]
> 
> If you want to give ide-tape removal a try, go ahead (I suggest starting
> with adding warning printk() and keeping patch in -mm for some time)...

Well, we don't have any numbers on whether someone is using the driver at all,
so i probably the best thing we should do is give it a grace period of 1/2 year
before we get rid of it. In the meantime, let's see how many souls cry out :)

---
commit 5b4566d1ed9b050d53d776285da84f8c3cc13d2c
Author: Borislav Petkov <petkovbb@gmail.com>
Date:   Fri Feb 1 09:12:02 2008 +0100

    ide-tape: schedule driver for removal after 6 months in case it doesn't have
    any users left.

    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 20c4c8b..21d71a9 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -333,3 +333,13 @@ Why:	This driver has been marked obsolete for many years.
 Who:	Stephen Hemminger <shemminger@linux-foundation.org>
 
 ---------------------------
+
+What:	ide-tape driver
+When:	July 2008
+Files:	drivers/ide/ide-tape.c
+Why:	This driver might not have any users anymore and maintaining it for no
+	reason is an effort no one wants to make.
+Who:	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Borislav Petkov
+	<petkovbb@googlemail.com>
+
+---------------------------
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index f51712c..fd81f4c 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -3829,6 +3829,11 @@ static int ide_tape_probe(ide_drive_t *drive)
 	g->fops = &idetape_block_ops;
 	ide_register_region(g);
 
+	printk(KERN_WARNING "It is possible that this driver does not have any"
+		" users anymore and, as a result, it will be REMOVED soon."
+		" Please notify Bart <bzolnier@gmail.com> or Boris"
+		" <petkovbb@gmail.com> in case you still need it.\n");
+
 	return 0;
 
 out_free_tape:

-- 
Regards/Gruﬂ,
    Boris.
