Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZFAViz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZFAViz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 17:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZFAViq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 17:38:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34185 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbZFAVip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 17:38:45 -0400
Message-ID: <4A244A5B.7070605@sandeen.net>
Date: Mon, 01 Jun 2009 16:38:35 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
       Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] skip I_CLEAR state inodes
References: <20090318170237.8F6C.61FB500B@jp.fujitsu.com> <20090323103846.GA16577@localhost> <20090324155655.2684.61FB500B@jp.fujitsu.com> <20090324074457.GA7745@localhost> <20090324120502.GC23439@duck.suse.cz> <20090324124001.GA25326@localhost>
In-Reply-To: <20090324124001.GA25326@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
> Add I_CLEAR tests to drop_pagecache_sb(), generic_sync_sb_inodes() and
> add_dquot_ref().
> 
> clear_inode() will switch inode state from I_FREEING to I_CLEAR,
> and do so _outside_ of inode_lock. So any I_FREEING testing is
> incomplete without the testing of I_CLEAR.
> 
> Masayoshi MIZUMA first discovered the bug in drop_pagecache_sb() and
> Jan Kara reminds fixing the other two cases. Thanks!

Is there a reason it's not done for __sync_single_inode as well?

Jeff Layton asked the question and I'm following it up :)

__sync_single_inode currently only tests I_FREEING, but I think we are
safe because __sync_single_inode sets I_SYNC, and clear_inode waits for
I_SYNC to be cleared before it changes I_STATE.

On the other hand, testing I_CLEAR here probably would be safe anyway,
and it'd be bonus points for consistency?

Same basic question for generic_sync_sb_inodes, which has a
BUG_ON(inode->i_state & I_FREEING), seems like this could check I_CLWAR
as well?

Thanks,
-Eric
