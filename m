Return-Path: <linux-kernel-owner+w=401wt.eu-S1759630AbZKYTwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759630AbZKYTwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 14:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759614AbZKYTww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 14:52:52 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:39956 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759608AbZKYTwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 14:52:51 -0500
Date: Wed, 25 Nov 2009 12:52:57 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: J?r?my Cochoy <jeremy.cochoy@gmail.com>
Cc: Liuweni <qingshenlwy@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       strongzgy <strongzgy@gmail.com>, xgr178 <xgr178@163.com>,
       Liu Hui <onlyflyer@gmail.com>, viro <viro@zeniv.linux.org.uk>,
       akpm <akpm@linux-foundation.org>, jack <jack@suse.cz>,
       npiggin <npiggin@suse.de>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1/3]fs/inode: iunique() Optimize Performance
Message-ID: <20091125195256.GL9482@parisc-linux.org>
References: <200911252209432039291@gmail.com> <20091125141505.GH9482@parisc-linux.org> <a229bc400911251120y220066afjb10d391198c5807c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a229bc400911251120y220066afjb10d391198c5807c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 08:20:02PM +0100, J?r?my Cochoy wrote:
> Hello,
> 
> There is something strange in iunique : what will happend if all inode
> between max_reserved+1 and (unsinged in)(0-1) ? Will it make an
> infinite loop or an interruption can happen and make an inode become
> free?

Another process can free an inode while this loop is executing.

> In that case, it will be better to stop search when counter overflow, no?

If you have all four billion inodes allocated, you have significantly
bigger problems than this loop.  For a start, at 600 bytes per inode,
I'd like to see your machine with 2.4TB of memory.  Then there's the
size of your inode hash, and the depth of the chains within it.

> Will it not be better to use a field max_ino_used (in superblock, for
> exemple) where we store the last inode allocated with iunique and make
> a search only if max_ino_used become to (unsigned)(-1) ?
> 
> But, if iunique is here to provide a solution in order to generate
> unused inode in filesystem which have various inode number, it's
> better to use a list of used ino, in a short hash table which use the
> first 8 bits of the inode, always use the same function to create a
> new inode and look at the head if we can add a new inode with bigger
> ino and still in the range. (But i think filesystems developper prefer
> to write ther own functions in order to do that, no?)
> 
> Well, if we want to stop in case of full inode filesystem, we can put
> the first condition in the head and add change return as :
> return inode->i_ino > max_reserved ? res : 0; // 0 might "i can't find
> an inode after max_reserved"

Gloves.

http://thedailywtf.com/Articles/The_Complicator_0x27_s_Gloves.aspx

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
