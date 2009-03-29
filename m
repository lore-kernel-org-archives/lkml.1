Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbZC2Mbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbZC2Mbq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 08:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbZC2Mbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 08:31:36 -0400
Received: from smtp.nokia.com ([192.100.105.134]:22978 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbZC2Mbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 08:31:35 -0400
Message-ID: <49CF6A08.3000704@yandex.ru>
Date: Sun, 29 Mar 2009 15:31:04 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Kyungmin Park <kmpark@infradead.org>
CC: Artem.Bityutskiy@nokia.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: EXT4-ish "fixes" in UBIFS
References: <49CCCB0A.6070701@nokia.com> <9c9fda240903271822w29aa131ch57c33f95e543c883@mail.gmail.com>
In-Reply-To: <9c9fda240903271822w29aa131ch57c33f95e543c883@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 29 Mar 2009 12:31:05.0680 (UTC) FILETIME=[3AD48D00:01C9B06A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyungmin Park wrote:
> I also got these request. the file is empty at rename operatoin in
> case of sudden power off.
> they say it's different from jffs2. in case of jffs2, it points old
> files even though power off.

Right, because JFFS2 is synchronous :-)

> then why is UBIFS different. fix it as before. I said it's not
> filesystem bug. it's expected behaviors.

Right, this is what I've been always thinking. I've always been
thinking the FS gives no guarantees, and if you want a 100%
guarantee, use fsync() before renaming. Frankly, I still think
so. But we'll make ext4-like changes in UBIFS as well to help
the applications which do not do the sync.

> Frankly I'm not sure which one is better. how much filesystem support
> it. but remember that application programmer also don't want to change
> their application when filesystem is changed.
> "The application is not changed, only filesystem is changed. so it's
> filesystem problem, not us"

I hope Linux gurus will put it clearly after all - to fsync() or to
not fsync(). We do need clear rules of the game. For now, I still
assume the following:

1. If applications want atomic update which gives 100% guarantee,
   they should fsync before rename.
2. If the application does not use fsync, FS should try to minimize
   the probability of data loss by running asynchronous write-back
   on rename which unlinks a direntry.
3. All this performance vs. reliability hassle should be solved
   by fixing the FS, by having good defaults, by having a
   "fsync/not fsync" knobs in applications.

Indeed, people mostly talk about ext3, desktops, etc. But there
is also the embedded world, where battery is removed randomly.

But will see where this all leads. I really want clean rules
for this.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
