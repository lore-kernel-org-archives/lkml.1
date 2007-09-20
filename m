Return-Path: <linux-kernel-owner+w=401wt.eu-S1757418AbXITJOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbXITJOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 05:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759347AbXITJM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 05:12:27 -0400
Received: from sacred.ru ([62.205.161.221]:34455 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759876AbXITJM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 05:12:26 -0400
Message-ID: <46F238DF.4010000@openvz.org>
Date: Thu, 20 Sep 2007 13:09:51 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH] Consolidate sleeping routines in file locking code
References: <46EFD574.5060705@openvz.org> <20070919183703.GE5946@fieldses.org>
In-Reply-To: <20070919183703.GE5946@fieldses.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 20 Sep 2007 13:12:11 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields wrote:
> On Tue, Sep 18, 2007 at 05:41:08PM +0400, Pavel Emelyanov wrote:
>> This is the next step in fs/locks.c cleanup before turning
>> it into using the struct pid *. 
>>
>> This time I found, that there are some places that do a
>> similar thing - they try to apply a lock on a file and go 
>> to sleep on error till the blocker exits.
>>
>> All these places can be easily consolidated, saving 28 
>> lines of code and more than 600 bytes from the .text,
>> but there is one minor note. 
> 
> I'm not opposed to consolidating this code, but would it be possible to
> do so in a more straightforward way, without passing in a callback
> function?  E.g. a single __posix_lock_file_wait that just took an inode
> instead of a filp and called __posix_lock_file() could be called from
> both posix_lock_file_wait() and locks_mandatory_locked, right?

Well, the locks_mandatory_area() has to check for inode mode change
in my lock callback, the fcntl_setlk() has to call the vfs_lock_file,
and flock_lock_file_wait() has to call the flock_lock_file, so
I don't see the ways of having one routine to lock the file.

If you don't mind, I'd port the patch with this approach (with the
"trylock" callback) on the latest Andrew's tree.

>> The locks_mandatory_area() code becomes a bit different 
>> after this patch - it no longer checks for the inode's 
>> permissions change. Nevertheless, this check is useless 
>> without my another patch that wakes the waiter up in the
>> notify_change(), which is not considered to be useful for
>> now.
> 
> OK.  Might be better to submit this as a separate patch, though.

This one is already accepted, but I have just noticed that
the check for __mandatory_lock() in wait_event_interruptible
is ambiguous :(

> --b.
> 

