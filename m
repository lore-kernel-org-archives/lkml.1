Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbZBILjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbZBILjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 06:39:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755098AbZBILix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 06:38:53 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49204 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755085AbZBILiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 06:38:51 -0500
Message-ID: <499015A7.3040400@cn.fujitsu.com>
Date: Mon, 09 Feb 2009 19:38:15 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, Arjan van de Ven <arjan@infradead.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [cgroup or VFS ?] INFO: possible recursive locking detected
References: <49617D2E.8050502@cn.fujitsu.com> <496576E7.1@cn.fujitsu.com> <20090209112321.GW28946@ZenIV.linux.org.uk>
In-Reply-To: <20090209112321.GW28946@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Thu, Jan 08, 2009 at 11:45:43AM +0800, Li Zefan wrote:
>> Hi Al Viro,
>>
>> I hacked into the kernel with the patch below (I think It's ok for me
>> to comment out bdev->bd_mount_sem for testing):
> 
>> And ran 2 threads:
>> 	for ((; ;))  # thread 1
>> 	{
>> 		mount -t ext3 /dev/sda9 /mnt1
>> 		umount /mnt1
>> 	}
>>
>> 	for ((; ;))  # thread 2
>> 	{
>> 		mount -t ext3 /dev/sda9 /mnt2
>> 		umount /mnt2
>> 	}
>>
>> And I got the same lockdep warning immediately, so I think it's
>> VFS's issue.
> 
> It's a lockdep issue, actually.  It _is_ a false positive; we could get rid

Yes, I believe it's a false positive when I looked into this issue.

> of that if we took destroy_super(s); just before grab_super(), but I really
> do not believe that there's any point.
> 
> Frankly, I'd rather see if there's any way to teach lockdep that this instance
> of lock is getting initialized into "one writer" state and that yes, we know
> that it's not visible to anyone, so doing that is safe, TYVM, even though
> we are under spinlock.  Then take that sucker to just before set().
> 

It would be nice if we can do this way..

> In any case, I really do not believe that it might have anything to do with
> the WARN_ON() from another thread...
> 

agreed. I don't think they are related, and that's why I sent 2 different reports.

