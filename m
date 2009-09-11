Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbZIKGjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbZIKGjw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 02:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbZIKGjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 02:39:51 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:49721 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbZIKGju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 02:39:50 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Pavel Machek <pavel@ucw.cz>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>, Christoph Hellwig <hch@lst.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mmc@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: Regression in suspend to ram in 2.6.31-rc kernels
References: <c4e36d110908310451t7c238e09u5af112fa3321cc23@mail.gmail.com>
	<200908312119.12121.rjw@sisk.pl>
	<c4e36d110909010234i5f1b9357l805132137725a4f8@mail.gmail.com>
	<c4e36d110909031529q77b53122kdb85785ba293c478@mail.gmail.com>
	<20090903232317.GA6760@lst.de> <87ljkvmt71.fsf@devron.myhome.or.jp>
	<c4e36d110909040213t4d4258b4w3e2d4725e0b2a161@mail.gmail.com>
	<87iqfx5mss.fsf@devron.myhome.or.jp> <20090907125130.GA1595@ucw.cz>
	<87ljko5k3v.fsf@devron.myhome.or.jp>
	<20090910192354.GD23356@elf.ucw.cz>
Date: Fri, 11 Sep 2009 15:39:45 +0900
In-Reply-To: <20090910192354.GD23356@elf.ucw.cz> (Pavel Machek's message of
	"Thu, 10 Sep 2009 21:23:54 +0200")
Message-ID: <87bplim1ce.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

> On Wed 2009-09-09 22:21:56, OGAWA Hirofumi wrote:
>> Pavel Machek <pavel@ucw.cz> writes:
>> 
>> >> It seems
>> >> 
>> >>     1) sync() (probabry "sync" command)
>> >>     2) sync as part of suspend sequence
>> >>     3) sync_filesystem() by mmc remove event
>> >> 
>> >> I guess the root-cause of the problem would be 3). However, it would not
>> >> be easy to fix, at least, we would need to think about what we want to
>> >> do for it. So, to workaround it for now, I've made this patch.
>> >
>> > MMC driver trying to synchronize filesystems looks like ugly layering
>> > violation to me. Why are we doing that?
>> 
>> There is no _layering violation_ here. IIRC, mmc just tells card removed
>> event to another layer (on some points of view, to tell event can be
>> wrong though). The partition (block) layer does it by event.
>
> So what is the problem?  Emulating sync when card is already removed
> seems little ... interesting?

Um..., sorry, I'm not sure what are you talking about. Of course, the
problem of this is that system freeze on suspend.

Or are you asking my guess of the cause, or something?  If so, although
I'm not reading all emails on this thread, from Zdenek's backtrace, the
sequence would be

    1) suspend mmc
    2) mmc generates card removed event
    3) prepare to invalidate blockdev
    4) sync fs on invalidating blockdev
    5) flush buffers on invalidating blockdev (partitions)
    6) delete blockdev (partitions)

or like the above. And I can guess some possible issues/root-cause we
have to handle from it.

    a) card removed event from mmc for suspend is right design?
    b) the card can be changed/removed before system was resumed, mmc
       can be detect/handle it properly?
    c) flushing buffers on _deleted_ device is right design?

and I suspect there are more issues in detail and resume process though.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
