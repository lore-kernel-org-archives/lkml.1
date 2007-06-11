Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbXFKVyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbXFKVyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 17:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015AbXFKVym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 17:54:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40177 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297AbXFKVyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 17:54:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: 2.6.22-rc4-mm2: Resume from RAM on HPC nx6325 broken
Date: Tue, 12 Jun 2007 00:01:26 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Lee Trager <lt73@cs.drexel.edu>
References: <200706111649.00578.rjw@sisk.pl> <200706112203.30032.bzolnier@gmail.com> <200706120001.20013.bzolnier@gmail.com>
In-Reply-To: <200706120001.20013.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706120001.26821.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 12 June 2007 00:01, Bartlomiej Zolnierkiewicz wrote:
> 
> On the second thought...
> 
> On Monday 11 June 2007, Bartlomiej Zolnierkiewicz wrote:
> 
> > I find it hard to accept that IDE patch is to blame for that. ;)
> 
> Arrgghhh :)  It looks more likely now...
> 
> > --- a/drivers/ide/ide.c
> > +++ b/drivers/ide/ide.c
> > @@ -1010,9 +1010,11 @@ static int generic_ide_resume(struct dev
> >  {
> >  	ide_drive_t *drive = dev->driver_data;
> >  	ide_hwif_t *hwif = HWIF(drive);
> > +	ide_driver_t *drv = to_ide_driver(dev->driver);
> >  	struct request rq;
> >  	struct request_pm_state rqpm;
> >  	ide_task_t args;
> > +	int err;
> >  
> >  	/* Call ACPI _STM only once */
> >  	if (!(drive->dn % 2))
> > @@ -1029,7 +1031,12 @@ static int generic_ide_resume(struct dev
> >  	rqpm.pm_step = ide_pm_state_start_resume;
> >  	rqpm.pm_state = PM_EVENT_ON;
> >  
> > -	return ide_do_drive_cmd(drive, &rq, ide_head_wait);
> > +	err = ide_do_drive_cmd(drive, &rq, ide_head_wait);
> > +
> > +	if (err == 0 && drv && drv->resume)
> 
> Could you try replacing this by
> 
> if (err == 0 && dev->driver && drv->resume)
> 
> and see if it fixes the problem?

Yes, that helps.  I've just posted a fix patch. :-)

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
