Return-Path: <linux-kernel-owner+w=401wt.eu-S1758486AbYBALhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486AbYBALhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 06:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbYBALhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 06:37:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58444 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbYBALhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 06:37:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: hibernate/suspend-to-disk: to turn power or not?
Date: Fri, 1 Feb 2008 12:35:12 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <47A0CD90.5080208@msgid.tls.msk.ru> <20080131144030.GC983@elf.ucw.cz> <47A2C791.8000303@msgid.tls.msk.ru>
In-Reply-To: <47A2C791.8000303@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802011235.13242.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 1 of February 2008, Michael Tokarev wrote:
> Pavel Machek wrote:
> []
> >> I'm looking at the uswsusp source (while the kernel compiles),
> >> and have a question here.  Is it possible to call some external
> >> application (typically a shell script) to do the final work after
> >> when the image has been written?  I mean in principle - I
> >> understand there are some limitations here, but I don't know
> >> which exactly.
> > 
> > No, you can't exec() anything. That would write mtime back to disk and
> > cause badness.
> 
> Now that's.. interesting.
> 
> s2disk writes to a swap device/file, which should update
> mtime of this device node/file.  Isn't it something which
> also causes the same badness?

No, please read the source carefully.  We create a special tmpfs for that.

> Also, if the only concern is mtime update, what's really
> wrong with it?  I mean, regardless of whether such update
> will finally hit the disk or not, there's not much difference
> really - it updates just mtime field, and there should be
> no harm in that.  Unless such update first goes to a
> journal (in a journalling filesystem) - which DOES modify
> some on-disk structures.

Yes, we're concerned about the journaling.

> >> it typically involves writing/reading something to/from
> >> a given serial port (/dev/ttySxx), or to an USB device,
> 
> > Create libups.so, and link s2disk to it?
> 
> And what's the difference here again?  We'll open a serial
> port and write something to it - which, again, will update
> mtime of that device node.  Unless the said node is on a
> tmpfs, exactly the same badness will happen.  Not all the
> world is udev, after all.

We already have a tmpfs for that.

> So I don't get the reason why we can't exec something here,
> still.  (And, for example, call splashy commands as external
> processes, instead of linking all this cruft into s2disk and
> resume.)
> 
> What I'm thinking about here is - s2ram mlock()s its memory.
> If it will fork/exec something, that something will obviously
> NOT be locked like that.  Is it of some concern?  Probably
> not, because that something will be executed after we've
> taken the snapshot.

Please don't exec() things from s2disk/s2both.  Just link them to
appropriate libraries and modify them to do things you need.

Thanks,
Rafael
