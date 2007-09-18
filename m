Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbXIRGjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbXIRGjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 02:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbXIRGjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 02:39:03 -0400
Received: from sacred.ru ([62.205.161.221]:55232 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077AbXIRGjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 02:39:01 -0400
Message-ID: <46EF71F0.9010606@openvz.org>
Date: Tue, 18 Sep 2007 10:36:32 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org
Subject: Re: [PATCH] Wake up mandatory locks waiter on chmod
References: <46E94993.3090506@openvz.org> <20070916194135.GC31801@fieldses.org> <46EE20C4.1060405@openvz.org> <20070917145934.GA4957@fieldses.org>
In-Reply-To: <20070917145934.GA4957@fieldses.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 18 Sep 2007 10:38:51 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields wrote:
> On Mon, Sep 17, 2007 at 10:37:56AM +0400, Pavel Emelyanov wrote:
>> J. Bruce Fields wrote:
>>> Is there a small chance that a lock may be applied after this check:
>>>
>>>> +	mandatory = (inode->i_flock && MANDATORY_LOCK(inode));
>>>> +
>>> but early enough that someone can still block on the lock while the file
>>> is still marked for mandatory locking?  (And is the inode->i_flock check
>>> there really necessary?)
>> There is, but as you have noticed:
> 
> OK, but why not just remove the inode->i_flock check there?  I can't see
> how it helps anyway.
> 
>>> Well, there are probably worse races in the mandatory locking code.
>> ...there are. The inode->i_lock is protected with lock_kernel() only
>> and is not in sync with any other checks for inodes. This is sad :(
>> but a good locking for locks is to be done...
> 
> I would also prefer a locking scheme that didn't rely on the BKL.  That
> said, except for this race:

I would as well :) But I don't know the locking code good enough to
start fixing. Besides, even if I send a patch series that handles this,
I don't think that anyone will accept it, due to "this changes too much
code", "can you prove you fixed all the places" and so on...

>>> (For example, my impression is that a mandatory lock can be applied just
>>> after the locks_mandatory_area() checks but before the io actually
>>> completes.)
> 
> ... I'm not aware of other races in the existing file-locking code.  It
> sounds like you might be.  Could you give specific examples?

Well, there's a long standing BUG in leases code - when we made all the
checks in inserting lease, we call the locks_alloc_lock() and may fall
asleep. Bu after the wakeup nobody re-checks for the things to change.

I suspect there are other bad places.

> --b.
> 

