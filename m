Return-Path: <linux-kernel-owner+w=401wt.eu-S1764164AbZDAQGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764164AbZDAQGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 12:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754962AbZDAQGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 12:06:09 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:27952 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540AbZDAQGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 12:06:07 -0400
Subject: Re: Linux 2.6.29
From: Chris Mason <chris.mason@oracle.com>
To: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>
Cc: Dave Chinner <david@fromorbit.com>, Mark Lord <lkml@rtr.ca>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <49D38B22.1050105@ursus.ath.cx>
References: <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain>
	 <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca>
	 <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de>
	 <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de>
	 <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed>
	 <1238417751.30488.12.camel@think.oraclecorp.com>
	 <20090331235509.GU26138@disturbed>
	 <1238590413.18549.7.camel@think.oraclecorp.com>
	 <49D38B22.1050105@ursus.ath.cx>
Content-Type: text/plain
Date: Wed, 01 Apr 2009 12:02:26 -0400
Message-Id: <1238601746.18549.55.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.49D3901E.0065:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-01 at 17:41 +0200, Andreas T.Auer wrote:
> 
> On 01.04.2009 14:53 Chris Mason wrote:
> > On Wed, 2009-04-01 at 10:55 +1100, Dave Chinner wrote:
> >   
> >> If you crash while rsync is running, then the state of the copy
> >> is garbage anyway. You have to restart from scratch and rsync will
> >> detect such failures and resync the file. gnome/kde have no
> >> mechanism for such recovery.
> >>     
> > If this were the recovery system they had in mind, then why use rename
> > at all?  They could just as easily overwrite the original in place.
> >   
> 
> It is not a recovery system.  The renaming procedure is almost atomic
> with e.g. reiser or ext3 (ordered), but simple overwriting would always
> leave a window between truncating and the complete rewrite of the file.
> 

Well, we're considering a future where ext3 and reiser are no longer
used, and applications are responsible for the flushing if they want
renames atomic for data as well as metadata.

In this case, rename without additional flush and truncate are the same.

> > Using rename implies they want to replace the old with a complete new
> > version.
> >
> > There's also the window where you crash after the rsync is done but
> > before all the new data safely makes it into the replacement files.
> >   
> 
> Sure, but in that case you have only lost some of your _mirrored_ data.
> The original will usually be untouched by this. So after the restart you
> just start the mirroring process again, and hopefully, this time you get
> a perfect copy.
> 

If we crash during the rsync, the backup logs will yell.  If we crash
just after the rsync, the backup logs won't know.  The data could still
be gone.

> In KDE and lots of other apps the _original_ config files (and not any
> copies) are "overlinked" with the new files by the rename. That's the
> difference.

We don't run backup programs because we can use the original as a backup
for the backup ;)  From an rsync-for-backup point of view, the backup is
the only copy.

Yes, rsync could easily be fixed.  Or maybe people just aren't worried,
its hard to say.  Having the ext3 style flush with the rename makes the
system easier to use, and easier to predict how it will react.

rsync was originally brought up when someone asked about applications
that do renames and don't care about atomic data replacement.  If the
flushing is a horrible thing, there must be a lot more examples?

-chris


