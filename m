Return-Path: <linux-kernel-owner+w=401wt.eu-S1752178AbXIQGkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbXIQGkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 02:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbXIQGk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 02:40:28 -0400
Received: from sacred.ru ([62.205.161.221]:38711 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbXIQGk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 02:40:26 -0400
Message-ID: <46EE20C4.1060405@openvz.org>
Date: Mon, 17 Sep 2007 10:37:56 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org
Subject: Re: [PATCH] Wake up mandatory locks waiter on chmod
References: <46E94993.3090506@openvz.org> <20070916194135.GC31801@fieldses.org>
In-Reply-To: <20070916194135.GC31801@fieldses.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 17 Sep 2007 10:40:16 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields wrote:
> On Thu, Sep 13, 2007 at 06:30:43PM +0400, Pavel Emelyanov wrote:
>> When the process is blocked on mandatory lock and someone changes
>> the inode's permissions, so that the lock is no longer mandatory,
>> nobody wakes up the blocked process, but probably should.
> 
> I suppose so.  Does anyone actually use mandatory locking?

:) Good question.

> Would it be worth adding a
> 
> 	if (MANDATORY_LOCK(inode))
> 		return;
> 
> to the beginning of locks_wakeup_mandatory() to avoid walking the list
> of locks in that case?  Perhaps setattr is rare enough that this just
> isn't worth caring about.
> 
> Is there a small chance that a lock may be applied after this check:
> 
>> +	mandatory = (inode->i_flock && MANDATORY_LOCK(inode));
>> +
> 
> but early enough that someone can still block on the lock while the file
> is still marked for mandatory locking?  (And is the inode->i_flock check
> there really necessary?)

There is, but as you have noticed:

> Well, there are probably worse races in the mandatory locking code.

...there are. The inode->i_lock is protected with lock_kernel() only
and is not in sync with any other checks for inodes. This is sad :(
but a good locking for locks is to be done...

> (For example, my impression is that a mandatory lock can be applied just
> after the locks_mandatory_area() checks but before the io actually
> completes.)
> 
> --b.

Thanks,
Pavel
