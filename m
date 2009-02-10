Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbZBJJ0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbZBJJ0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 04:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbZBJJ0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 04:26:19 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62415 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbZBJJ0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 04:26:17 -0500
Message-ID: <49914815.4020209@cn.fujitsu.com>
Date: Tue, 10 Feb 2009 17:25:41 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, Arjan van de Ven <arjan@infradead.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [cgroup or VFS ?] INFO: possible recursive locking detected
References: <49617D2E.8050502@cn.fujitsu.com> <496576E7.1@cn.fujitsu.com> <20090209112321.GW28946@ZenIV.linux.org.uk> <1234180131.5951.85.camel@laptop> <4990EF3F.3010501@cn.fujitsu.com> <20090210043733.GY28946@ZenIV.linux.org.uk> <49910E55.7050905@cn.fujitsu.com> <20090210060737.GZ28946@ZenIV.linux.org.uk>
In-Reply-To: <20090210060737.GZ28946@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Tue, Feb 10, 2009 at 01:19:17PM +0800, Li Zefan wrote:
>>> 	You have no promise whatsoever that whoever's been trying to
>>> get the lock in question will even get out of the locking primitive
>>> before the memory that contains the lock gets freed.  In case of superblocks
>>> in general, you don't free them until ->s_count hits zero.  At that point
>>> anything as much as remembering the address of that superblock is already
>>> FUBAR.
>>>
>> This is not the general case. This sb won't be seen by anyone, and destroy_super()
>> is called on a sb with ->s_count == 1 and ->s_umount held.
> 
> ... so in this case we have even a stronger warranty of everything being
> OK with freeing it while locked.  "Nothing has ever seen its address"
> means that entire struct contents is fair game...
> 

Yes, this won't cause bad things, but I think it's better to make lock/unlock
consistent, and we have to make lockdep happy.

> As for the other question, you are leaving a reference to root hanging from
> superblock still on the list (grab_super() will fail on it, but that's it)
> and you have code that might look into the damn thing (test callback you
> pass to sget()).  Dereferencing pointers to freed objects is not nice, to
> put it mildly...
> 

It's clear to me now, thanks for the explanation. Though I failed to trigger
this bug, I managed to trigger it if I set sb->s_fs_info to NULL just after
kfree(root).

> BTW, which dentries are going to stick around until that point?
> 

Not sure if I got what you mean. cgroup_kill_sb() will be called only if there
are no sub-dirs.


