Return-Path: <linux-kernel-owner+w=401wt.eu-S1757086AbZIKWbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086AbZIKWbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 18:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbZIKWbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 18:31:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46286 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbZIKWbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 18:31:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Regression in suspend to ram in 2.6.31-rc kernels
Date: Sat, 12 Sep 2009 00:32:13 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Christoph Hellwig <hch@lst.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mmc@vger.kernel.org, viro@zeniv.linux.org.uk
References: <c4e36d110908310451t7c238e09u5af112fa3321cc23@mail.gmail.com> <200909120004.02146.rjw@sisk.pl> <20090911222154.GB11441@elf.ucw.cz>
In-Reply-To: <20090911222154.GB11441@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909120032.13164.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 September 2009, Pavel Machek wrote:
> On Sat 2009-09-12 00:04:02, Rafael J. Wysocki wrote:
> > On Friday 11 September 2009, OGAWA Hirofumi wrote:
> > > Pavel Machek <pavel@ucw.cz> writes:
> > > 
> > > > On Wed 2009-09-09 22:21:56, OGAWA Hirofumi wrote:
> > > >> Pavel Machek <pavel@ucw.cz> writes:
> > > >> 
> > > >> >> It seems
> > > >> >> 
> > > >> >>     1) sync() (probabry "sync" command)
> > > >> >>     2) sync as part of suspend sequence
> > > >> >>     3) sync_filesystem() by mmc remove event
> > > >> >> 
> > > >> >> I guess the root-cause of the problem would be 3). However, it would not
> > > >> >> be easy to fix, at least, we would need to think about what we want to
> > > >> >> do for it. So, to workaround it for now, I've made this patch.
> > > >> >
> > > >> > MMC driver trying to synchronize filesystems looks like ugly layering
> > > >> > violation to me. Why are we doing that?
> > > >> 
> > > >> There is no _layering violation_ here. IIRC, mmc just tells card removed
> > > >> event to another layer (on some points of view, to tell event can be
> > > >> wrong though). The partition (block) layer does it by event.
> > > >
> > > > So what is the problem?  Emulating sync when card is already removed
> > > > seems little ... interesting?
> > > 
> > > Um..., sorry, I'm not sure what are you talking about. Of course, the
> > > problem of this is that system freeze on suspend.
> > > 
> > > Or are you asking my guess of the cause, or something?  If so, although
> > > I'm not reading all emails on this thread, from Zdenek's backtrace, the
> > > sequence would be
> > > 
> > >     1) suspend mmc
> > >     2) mmc generates card removed event
> > 
> > Which shouldn't happen.
> 
> Are you sure? IIRC it depends on  CONFIG_MMC_UNSAFE_RESUME.

Generating the event at this point is too late, because there's no way to
handle it cleanly with the current suspend/resume design.

It probably will work if the event is generated before we freeze the user
space, for example with the help of a suspend notifier, but generating it
from a driver's suspend routine is not valid.

Again, that's a consequence of the lack of a general solution for handling
"removable" file systems over suspend/resume.

Thanks,
Rafael
