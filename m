Return-Path: <linux-kernel-owner+w=401wt.eu-S1756095AbYKDVXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbYKDVXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 16:23:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767AbYKDVWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 16:22:54 -0500
Received: from hobbit.corpit.ru ([81.13.33.150]:23728 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123AbYKDVWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 16:22:54 -0500
Message-ID: <4910BD2B.1020808@msgid.tls.msk.ru>
Date: Wed, 05 Nov 2008 00:22:51 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Kay Sievers <kay.sievers@vrfy.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: data corruption: revalidating a (removable) hdd/flash on	re-insert
References: <490B2659.9010304@msgid.tls.msk.ru> <ac3eb2510810310910w603d90bai8c23b34fb517f21a@mail.gmail.com> <20081104195728.GC5862@ucw.cz> <ac3eb2510811041213l4a20fa12h3c5beb3c2d317574@mail.gmail.com> <20081104202011.GA7135@ucw.cz>
In-Reply-To: <20081104202011.GA7135@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>>>> Every access to removable media is guarded by this revalidation check.
>>>> If you don't see these events, you should not trust this reader, and
>>>> at least never change the media while it is connected.
>>> This is rather nasty data-corrupter.
>> Sure, it is.
>>
>>> Could we at least blacklist
>>> broken device, and force revalidation on each close or something like
>>> that?
>> What's your idea of revalidation if the hardware does not tell you?
>> Get an md5 of the disk content? :)
> 
> Well... you should not eject media while fs is mounted or blockdev is
> open, correct?
> 
> So can we simply claim 'media changed' on last close/unmount? Sure,
> sometimes media was not changed, but that only hurts performance, not
> correctness... ?

Well, that's what my tiny proggy, which I used here to work around the
problem, does.  It constantly opens/closes the /dev/sdFOO, every 0.5s
currently (I don't think I will be able to replace a media faster than
half a second :), in order to catch REMOVALs of media -- because when
the drive does not see the media anymore, it correctly reports that
the media has changed...

I tried to make it to detect CLOSE of the file (either by userspace or
by kernel on umount), to not waste time when the drive is open/mounted
as it can't be revalidated anyway, but neither dnotify nor inotify is
helpful here.

What is needed is to force "invalidation" on last close, so that on
next open, kernel thinks it's a shiny new media, never seen before.
Ie. to force-flush caches, or something like that.  Sure this is not
as good as my program, which still leaves caches in case media was
NOT removed.  But my approach is wasteful.  And the data corruption
is indeed quite bad (we've lost whole gig of photos this way already).

But yes, looks like this problem becomes less and less of an issue.
So for me, it's easy to deal with (not perfect but it works; it'd be
even better if i will be able to wait for umount using inotify, to
only wake when really needed), and the real solution is to not use
cheap broken hardware...  (My unit was about $15, real ones costs
$25 or so, but that's not the reason I've got it.  Real reason was
that it was only once than I actually saw such a thing, and it was
the last one as well... ;)

Thanks!

/mjt
