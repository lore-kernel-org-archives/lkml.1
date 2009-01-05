Return-Path: <linux-kernel-owner+w=401wt.eu-S1759637AbZAEBu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759637AbZAEBu1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 20:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbZAEBuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 20:50:17 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:43806
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbZAEBuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 20:50:16 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Pavel Machek <pavel@suse.cz>
Subject: Re: document ext3 requirements
Date: Sun, 4 Jan 2009 19:50:11 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       tytso@mit.edu, mtk.manpages@gmail.com, rdunlap@xenotime.net,
       linux-doc@vger.kernel.org
References: <20090103123813.GA1512@ucw.cz> <200901041349.49906.rob@landley.net> <20090104225545.GF1913@elf.ucw.cz>
In-Reply-To: <20090104225545.GF1913@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901041950.12331.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 January 2009 16:55:45 Pavel Machek wrote:
> On Sun 2009-01-04 13:49:49, Rob Landley wrote:
> > On Saturday 03 January 2009 06:38:15 Pavel Machek wrote:
> > > +Ext3 expects disk/storage subsystem to behave sanely. On sanely
> > > +behaving disk subsystem, data that have been successfully synced will
> > > +stay on the disk. Sane means:
> > > +
> > > +* writes to media never fail. Even if disk returns error condition
> > > during +  write, ext3 can't handle that correctly, because success on
> > > fsync was already +  returned when data hit the journal.
> > > +
> > > +	   (Fortunately writes failing are very uncommon on disks, as they
> > > +	   have spare sectors they use when write fails.)
> > > +
> > > +* either whole sector is correctly written or nothing is written
> > > during +  powerfail.
> > > +
> > > +	   (Unfortuantely, none of the cheap USB/SD flash cards I seen do
> > > behave +	   like this, and are unsuitable for ext3.
> >
> > Want to document the granularity issues with flash, while you're at it?
> >
> > An inherent problem with using flash as a normal block device is that the
> > flash erase size is bigger than most filesystem sector sizes.  So when
> > you request a write, it may erase and rewrite the next 64k, 128k, or even
> > a couple megabytes on the really _big_ ones.
> >
> > If you lose power in the middle of that, ext3 won't notice that data in
> > the "sectors" _after_ the one your were trying to write to got trashed.
> >
> > The flash filesystems take this into account as part of their wear
> > levelling stuff (they normally copy the entire chunk into a new chunk,
> > leaving the old one in place until it's no longer needed), but they need
> > to query the device to get the erase granularity in order to do that,
> > which is why they don't work on non-flash block devices.
>
> Is there linux filesystem that can handle that? I know jffs2, but
> that's unsuitable for stuff like USB thumb drives, right?

Any of the flash filesystems should handle that.  The main problem with jffs2 
is it doesn't scale well to large device sizes.  UBIFS is supposed to scale 
much better, but I haven't played with it yet.

And the thing about USB thumb drives is they present as a normal block device, 
_not_ as flash, so you can't _query_ their erase granularity.  (It's like 
those hardware raid cards that wouldn't tell you they were striping and such 
so you had to figure out a well-performing layout all by yourself.)   They do 
it magically behind the scenes, and if the power goes out (or you yank the 
device out unexpectedly) if they haven't got a built-in capacitor or battery 
to have enough power to complete their pending transaction, you're screwed.

Plus they do horrible wear levelling, the lot of 'em.  Read Val Henson's 
livejournal entry about it: http://valhenson.livejournal.com/25228.html

There was also a marvelous thread Linus participated in on some hardware 
industry web message board, but I have no idea where it's gone...

> Does this sound like a fair summary?

See Ted's comment.  The summary's fine, the question is where to put this sort 
of thing...

>                 If you lose power in the middle of that, filesystem
>                 won't notice that data in the "sectors" _after_ the
>                 one your were trying to write to got trashed.

Well, the journal won't notice.  An e2fsck will notice huge swaths of missing 
metadata, but won't be able to do anything about it.  (And if what got zapped 
was file _contents_ rather than metadata, you're on your own finding it.  Fun, 
isn't it?)

> 									Pavel

Rob
