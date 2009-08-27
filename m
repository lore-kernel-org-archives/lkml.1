Return-Path: <linux-kernel-owner+w=401wt.eu-S1751152AbZH0GGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751152AbZH0GGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 02:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbZH0GGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 02:06:17 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:55631
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbZH0GGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 02:06:16 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Theodore Tso <tytso@mit.edu>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is possible
Date: Thu, 27 Aug 2009 01:06:13 -0500
User-Agent: KMail/1.11.2 (Linux/2.6.28-14-generic; KDE/4.2.2; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Rik van Riel <riel@redhat.com>,
       Ric Wheeler <rwheeler@redhat.com>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
References: <4A92F6FC.4060907@redhat.com> <20090826111751.GC26595@elf.ucw.cz> <20090826122813.GI32712@mit.edu>
In-Reply-To: <20090826122813.GI32712@mit.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908270106.15032.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 August 2009 07:28:13 Theodore Tso wrote:
> On Wed, Aug 26, 2009 at 01:17:52PM +0200, Pavel Machek wrote:
> > > Metadata takes up such a small part of the disk that fscking
> > > it and finding it to be OK is absolutely no guarantee that
> > > the data on the filesystem has not been horribly mangled.
> > >
> > > Personally, what I care about is my data.
> > >
> > > The metadata is just a way to get to my data, while the data
> > > is actually important.
> >
> > Personally, I care about metadata consistency, and ext3 documentation
> > suggests that journal protects its integrity. Except that it does not
> > on broken storage devices, and you still need to run fsck there.
>
> Caring about metadata consistency and not data is just weird, I'm
> sorry.  I can't imagine anyone who actually *cares* about what they
> have stored, whether it's digital photographs of child taking a first
> step, or their thesis research, caring about more about the metadata
> than the data.  Giving advice that pretends that most users have that
> priority is Just Wrong.

I thought the reason for that was that if your metadata is horked, further 
writes to the disk can trash unrelated existing data because it's lost track 
of what's allocated and what isn't.  So back when the assumption was "what's 
written stays written", then keeping the metadata sane was still darn 
important to prevent normal operation from overwriting unrelated existing 
data.

Then Pavel notified us of a situation where interrupted writes to the disk can 
trash unrelated existing data _anyway_, because the flash block size on the 16 
gig flash key I bought retail at Fry's is 2 megabytes, and the filesystem thinks 
it's 4k or smaller.  It seems like what _broke_ was the assumption that the 
filesystem block size >= the disk block size, and nobody noticed for a while.  
(Except the people making jffs2 and friends, anyway.)

Today we have cheap plentiful USB keys that act like hard drives, except that 
their write block size isn't remotely the same as hard drives', but they 
pretend it is, and then the block wear levelling algorithms fuzz things 
further.  (Gee, a drive controller lying about drive geometry, the scsi crowd 
should feel right at home.)

Now Pavel's coming back with a second situation where RAID stripes (under 
certain circumstances) seem to have similar granularity issues, again breaking 
what seems to be the same assumption.  Big media use big chunks for data, and 
media is getting bigger.  It doesn't seem like this problem is going to 
diminish in future.

I agree that it seems like a good idea to have BIG RED WARNING SIGNS about 
those kind of media and how _any_ journaling filesystem doesn't really help 
here.  So specifically documenting "These kinds of media lose unrelated random 
data if writes to them are interrupted, journaling filesystems can't help with 
this and may actually hide the problem, and even an fsck will only find 
corrupted metadata not lost file contents" seems kind of useful.

That said, ext3's assumption that filesystem block size always >= disk update 
block size _is_ a fundamental part of this problem, and one that isn't shared 
by things like jffs2, and which things like btrfs might be able to address if 
they try, by adding awareness of the real media update granularity to their 
node layout algorithms.  (Heck, ext2 has a stripe size parameter already.  
Does setting that appropriately for your raid make this suck less?  I haven't 
heard anybody comment on that one yet...) 

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
