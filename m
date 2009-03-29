Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbZC2Mzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbZC2Mzd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 08:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756342AbZC2MzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 08:55:05 -0400
Received: from smtp.nokia.com ([192.100.122.233]:39242 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbZC2MzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 08:55:03 -0400
Message-ID: <49CF6F90.9040609@yandex.ru>
Date: Sun, 29 Mar 2009 15:54:40 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Kyungmin Park <kmpark@infradead.org>
CC: Artem.Bityutskiy@nokia.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: EXT4-ish "fixes" in UBIFS
References: <49CCCB0A.6070701@nokia.com> <9c9fda240903271822w29aa131ch57c33f95e543c883@mail.gmail.com> <49CF6A08.3000704@yandex.ru>
In-Reply-To: <49CF6A08.3000704@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 29 Mar 2009 12:54:42.0425 (UTC) FILETIME=[8746AE90:01C9B06D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy wrote:
> Kyungmin Park wrote:
>> I also got these request. the file is empty at rename operatoin in
>> case of sudden power off.
>> they say it's different from jffs2. in case of jffs2, it points old
>> files even though power off.
> 
> Right, because JFFS2 is synchronous :-)
> 
>> then why is UBIFS different. fix it as before. I said it's not
>> filesystem bug. it's expected behaviors.
> 
> Right, this is what I've been always thinking. I've always been
> thinking the FS gives no guarantees, and if you want a 100%
> guarantee, use fsync() before renaming. Frankly, I still think
> so. But we'll make ext4-like changes in UBIFS as well to help
> the applications which do not do the sync.
> 
>> Frankly I'm not sure which one is better. how much filesystem support
>> it. but remember that application programmer also don't want to change
>> their application when filesystem is changed.
>> "The application is not changed, only filesystem is changed. so it's
>> filesystem problem, not us"
> 
> I hope Linux gurus will put it clearly after all - to fsync() or to
> not fsync(). We do need clear rules of the game. For now, I still
> assume the following:
> 
> 1. If applications want atomic update which gives 100% guarantee,
>   they should fsync before rename.
> 2. If the application does not use fsync, FS should try to minimize
>   the probability of data loss by running asynchronous write-back
>   on rename which unlinks a direntry.
> 3. All this performance vs. reliability hassle should be solved
>   by fixing the FS, by having good defaults, by having a
>   "fsync/not fsync" knobs in applications.
> 
> Indeed, people mostly talk about ext3, desktops, etc. But there
> is also the embedded world, where battery is removed randomly.

Let me elaborate why I tell about embedded. Looking into the
"Linux-2.6.29" thread, it _seems_ people assume that it is enough
if FS will start _asynchronous_ write-back after rename, so that
dirty data will not sit in the cache for long time. E.g., many
people are happy with ext3's 5 seconds. So for me it seems like
some people do not care about 100% atomicity guarantees, they are
fine with just low data loss probability.

So what I say, that in embedded we need 100% atomic updates,
because our power cuts may be frequent and random. And at this
moment only fsync() before rename may guarantee this.

And updating a file using truncate/rewrite does not guarantee
anything at all.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
