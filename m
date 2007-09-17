Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbXIQOTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbXIQOTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 10:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbXIQOTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 10:19:47 -0400
Received: from sacred.ru ([62.205.161.221]:49042 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166AbXIQOTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 10:19:47 -0400
Message-ID: <46EE8C52.80503@openvz.org>
Date: Mon, 17 Sep 2007 18:16:50 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: Andrew Morton <akpm@osdl.org>, "J. Bruce Fields" <bfields@fieldses.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH] Wake up mandatory locks waiter on chmod (v2)
References: <46EE3724.80200@openvz.org> <1190037331.6700.14.camel@heimdal.trondhjem.org>
In-Reply-To: <1190037331.6700.14.camel@heimdal.trondhjem.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 17 Sep 2007 18:19:10 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust wrote:
> On Mon, 2007-09-17 at 12:13 +0400, Pavel Emelyanov wrote:
>> When the process is blocked on mandatory lock and someone changes 
>> the inode's permissions, so that the lock is no longer mandatory,
>> nobody wakes up the blocked process, but probably should.
> 
> Please explain in more detail why we need this patch.

>From "this fixes an OOPs/deadlock/leak" POV we do not. This is
just an attempt to make the locking code be more consistent and
clean.

On the other hand, as far as I see from the original comment
the code author expected the permissions to change and tried 
to handle this case. In this particular code there's a BUG - 
task will not be woken up. So this is a fix for this place. If 
we don't want to see tasks blocked on no-longer-mandatory 
locks, then we should remove the original check and comment.

> I don't see why changing a file from taking mandatory locks to advisory
> locks is really a useful operation that we need to support. For one
> thing, we don't support changing a file from using advisory locking to
> mandatory locking on-the-fly. Secondly, changing the locking type

Actually we have some code trying to do it - no mandatory locking
is allowed for already opened file.

> certainly isn't a documented operation and quite frankly, it doesn't
> even appear to make sense: if the file needs mandatory locking, then
> that means that you have a need to protect against some untrusted
> application that isn't following the locking rules. Then suddenly, you
> declare that you will trust that application after all???

Not trust, but keep things look as they are described in docs. I.e.
two conditions "inode is marked as mandlock" and "task cannot proceed
with opening mand.lock-ed file" must go in pair.

> Cheers,
>   Trond

Thanks,
Pavel
