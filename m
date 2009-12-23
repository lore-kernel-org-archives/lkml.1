Return-Path: <linux-kernel-owner+w=401wt.eu-S1757135AbZLWUfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135AbZLWUfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 15:35:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757002AbZLWUfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 15:35:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52284 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757035AbZLWUfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 15:35:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC] Asynchronous suspend/resume - test results
Date: Wed, 23 Dec 2009 21:35:24 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc1-tst; KDE/4.3.3; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <Pine.LNX.4.44L0.0912211200200.2979-100000@iolanthe.rowland.org> <200912212136.12665.rjw@sisk.pl>
In-Reply-To: <200912212136.12665.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912232135.25041.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 December 2009, Rafael J. Wysocki wrote:
> On Monday 21 December 2009, Alan Stern wrote:
> > On Mon, 21 Dec 2009, Rafael J. Wysocki wrote:
...
> > You should also make SCSI targets and hosts async.  Hosts are added in
> > drivers/scsi/hosts.c:scsi_add_host_with_dma() (in 2.6.32 this was
> > named scsi_add_host()).  Targets are added in
> > drivers/scsi/scsi_sysfs.c:scsi_target_add().  And for thoroughness,
> > SCSI devices are added in scsi_sysfs_add_sdev() in the same file.
> 
> Thanks a lot for the pointers.

I put device_enable_async_suspend() in all of these places and that resulted in
major reduction of suspend time without starting the async threads upfront.
Now, however, starting them upfront helps only a little, within the standard
deviation from the "non-upfront" case.

In turn, resume _without_ starting the async threads upfront makes a little
sense on my test boxes.  In fact, it only helped on the nx6325 and made things
worse on the other two (I added the results from Toshiba Portege R500, but it
has the same chipset as the Wind U100, ie. ICH7).

The results are as follows:

			HP nx6325	MSI Wind U100	Toshiba Portege R500

sync suspend		1357 (+/- 35)	 656 (+/- 50)	 889 (+/- 29)
sync resume		3027 (+/- 6)	3372 (+/- 30)	4552 (+/- 35)

async suspend		1053 (+/- 50)	 490 (+/- 42)	 620 (+/- 52)
async resume		2291 (+/- 7)	3406 (+/- 52)	4557 (+/- 26)

async "upfront" suspend	1040 (+/- 35)	 476 (+/- 9)	 585 (+/- 29)
async "upfront" resume	1787 (+/- 7)	1724 (+/- 48)	1990 (+/- 25)

The raw data are at
http://www.sisk.pl/kernel/data/async-suspend-updated.pdf
http://www.sisk.pl/kernel/data/r500/
http://www.sisk.pl/kernel/data/nx6325/
http://www.sisk.pl/kernel/data/wind/

and the previous results were moved into
http://www.sisk.pl/kernel/data/091220/

The patches used in the testing are in my async branch at
http://git.kernel.org/?p=linux/kernel/git/rafael/suspend-2.6.git;a=shortlog;h=refs/heads/async
The patches in this branch are not for upstream, but it's on top of the 
linux-next branch containing patches for the 2.6.34 merge window.

...
> > Although USB host controllers aren't the longest-running devices to
> > resume, they do tend to be on the longest paths.  Speeding them up
> > would help.  One change you could try is in the patch below.  
> > Currently when a controller has to be reset, the root hub beneath it is
> > also reset and then re-suspended.  However there's no reason to suspend
> > it if the PM core is only going to resume it a little bit later.  The
> > patch gets rid of the unnecessary suspend.  Note: I haven't tested it.
> 
> OK, I'll try it.

Unfortunately it breaks the second suspend (suspend process returns error code
and says that the controller was not suspended, more or less).

Rafael
