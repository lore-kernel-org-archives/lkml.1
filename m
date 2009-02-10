Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbZBJGHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbZBJGHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 01:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbZBJGHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 01:07:43 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:34193 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbZBJGHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 01:07:42 -0500
Date: Tue, 10 Feb 2009 06:07:37 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, Arjan van de Ven <arjan@infradead.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [cgroup or VFS ?] INFO: possible recursive locking detected
Message-ID: <20090210060737.GZ28946@ZenIV.linux.org.uk>
References: <49617D2E.8050502@cn.fujitsu.com> <496576E7.1@cn.fujitsu.com> <20090209112321.GW28946@ZenIV.linux.org.uk> <1234180131.5951.85.camel@laptop> <4990EF3F.3010501@cn.fujitsu.com> <20090210043733.GY28946@ZenIV.linux.org.uk> <49910E55.7050905@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49910E55.7050905@cn.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 01:19:17PM +0800, Li Zefan wrote:
> > 	You have no promise whatsoever that whoever's been trying to
> > get the lock in question will even get out of the locking primitive
> > before the memory that contains the lock gets freed.  In case of superblocks
> > in general, you don't free them until ->s_count hits zero.  At that point
> > anything as much as remembering the address of that superblock is already
> > FUBAR.
> > 
> 
> This is not the general case. This sb won't be seen by anyone, and destroy_super()
> is called on a sb with ->s_count == 1 and ->s_umount held.

... so in this case we have even a stronger warranty of everything being
OK with freeing it while locked.  "Nothing has ever seen its address"
means that entire struct contents is fair game...

As for the other question, you are leaving a reference to root hanging from
superblock still on the list (grab_super() will fail on it, but that's it)
and you have code that might look into the damn thing (test callback you
pass to sget()).  Dereferencing pointers to freed objects is not nice, to
put it mildly...

BTW, which dentries are going to stick around until that point?
