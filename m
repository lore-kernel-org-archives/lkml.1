Return-Path: <linux-kernel-owner+w=401wt.eu-S1757066AbZIKWDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066AbZIKWDf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 18:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757054AbZIKWDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 18:03:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46210 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757047AbZIKWDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 18:03:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: Regression in suspend to ram in 2.6.31-rc kernels
Date: Sat, 12 Sep 2009 00:04:02 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Christoph Hellwig <hch@lst.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mmc@vger.kernel.org, viro@zeniv.linux.org.uk
References: <c4e36d110908310451t7c238e09u5af112fa3321cc23@mail.gmail.com> <20090910192354.GD23356@elf.ucw.cz> <87bplim1ce.fsf@devron.myhome.or.jp>
In-Reply-To: <87bplim1ce.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909120004.02146.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 September 2009, OGAWA Hirofumi wrote:
> Pavel Machek <pavel@ucw.cz> writes:
> 
> > On Wed 2009-09-09 22:21:56, OGAWA Hirofumi wrote:
> >> Pavel Machek <pavel@ucw.cz> writes:
> >> 
> >> >> It seems
> >> >> 
> >> >>     1) sync() (probabry "sync" command)
> >> >>     2) sync as part of suspend sequence
> >> >>     3) sync_filesystem() by mmc remove event
> >> >> 
> >> >> I guess the root-cause of the problem would be 3). However, it would not
> >> >> be easy to fix, at least, we would need to think about what we want to
> >> >> do for it. So, to workaround it for now, I've made this patch.
> >> >
> >> > MMC driver trying to synchronize filesystems looks like ugly layering
> >> > violation to me. Why are we doing that?
> >> 
> >> There is no _layering violation_ here. IIRC, mmc just tells card removed
> >> event to another layer (on some points of view, to tell event can be
> >> wrong though). The partition (block) layer does it by event.
> >
> > So what is the problem?  Emulating sync when card is already removed
> > seems little ... interesting?
> 
> Um..., sorry, I'm not sure what are you talking about. Of course, the
> problem of this is that system freeze on suspend.
> 
> Or are you asking my guess of the cause, or something?  If so, although
> I'm not reading all emails on this thread, from Zdenek's backtrace, the
> sequence would be
> 
>     1) suspend mmc
>     2) mmc generates card removed event

Which shouldn't happen.

>     3) prepare to invalidate blockdev
>     4) sync fs on invalidating blockdev
>     5) flush buffers on invalidating blockdev (partitions)
>     6) delete blockdev (partitions)
> 
> or like the above. And I can guess some possible issues/root-cause we
> have to handle from it.
> 
>     a) card removed event from mmc for suspend is right design?

Not with the current suspend/resume design.

>     b) the card can be changed/removed before system was resumed, mmc
>        can be detect/handle it properly?
>     c) flushing buffers on _deleted_ device is right design?
> 
> and I suspect there are more issues in detail and resume process though.

Well, first, there's a limit to which file systems can ignore the
suspend/resume process and we're hitting it right now.

Second, we need a general solution for handling file systems over
suspend/resume _and_ possibly removable devices that can be gone while
suspended.  We don't have any solution like this right now and I have a little
experience with file systems, so I'm not going to take care of this in the
foreseeable future.  If someone else can, that's going to be appreciated very
much.

Thanks,
Rafael
