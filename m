Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbZBJEhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbZBJEhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 23:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbZBJEhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 23:37:40 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:50291 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbZBJEhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 23:37:39 -0500
Date: Tue, 10 Feb 2009 04:37:33 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, Arjan van de Ven <arjan@infradead.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [cgroup or VFS ?] INFO: possible recursive locking detected
Message-ID: <20090210043733.GY28946@ZenIV.linux.org.uk>
References: <49617D2E.8050502@cn.fujitsu.com> <496576E7.1@cn.fujitsu.com> <20090209112321.GW28946@ZenIV.linux.org.uk> <1234180131.5951.85.camel@laptop> <4990EF3F.3010501@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4990EF3F.3010501@cn.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 11:06:39AM +0800, Li Zefan wrote:

> BTW, I found another bug in current code:

Why is that a bug?  If _anything_ had been trying to acquire the
rwsem in question, it would be fscked anyway.  Not to mention
that nothing could have ever seen that struct super_block in this
particular case, as a general rule
	* if something might be blocked on your mutex/rwsem or spinning
on a spinlock, releasing it before you free the object won't save your
arse.
	You have no promise whatsoever that whoever's been trying to
get the lock in question will even get out of the locking primitive
before the memory that contains the lock gets freed.  In case of superblocks
in general, you don't free them until ->s_count hits zero.  At that point
anything as much as remembering the address of that superblock is already
FUBAR.
