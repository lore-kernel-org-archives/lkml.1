Return-Path: <linux-kernel-owner+w=401wt.eu-S1755129AbYAQJmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbYAQJmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 04:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754095AbYAQJmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 04:42:15 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:38020 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751752AbYAQJmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 04:42:13 -0500
Message-ID: <400562938.07583@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Thu, 17 Jan 2008 17:41:41 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Michael Rubin <mrubin@google.com>
Cc: a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] Converting writeback linked lists to a tree based data structure
References: <20080115080921.70E3810653@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115080921.70E3810653@localhost>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.12-2006-07-14
Message-Id: <E1JFRFm-00011Q-0q@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 12:09:21AM -0800, Michael Rubin wrote:
> 1) Adding a datastructure to guarantee fairness when writing
>    inodes to disk and simplify the code base.
> 
>    When inodes are parked for writeback they are parked in the
>    flush_tree. The flush tree is a data structure based on an rb tree.

The main benefit of rbtree is possibly better support of future policies.
Can you demonstrate an example?

(grumble:
Apart from the benefit of flexibility, I don't think it makes things
simpler, nor does the introduction of rbtree automatically fixes bugs.
Bugs can only be avoided by good understanding of all possible cases.)

The most tricky writeback issues could be starvation prevention
between
        - small/large files
        - new/old files
        - superblocks
Some kind of limit should be applied for each. They used to be:
        - requeue to s_more_io whenever MAX_WRITEBACK_PAGES is reached
          this preempts big files
        - refill s_io iif it is drained
          this prevents promotion of big/old files
        - return from sync_sb_inodes() after one go of s_io
          (todo: don't restart from the first superblock in writeback_inodes())
          this prevents busy superblock from starving others
          and ensures fairness between superblocks
 
Michael, could you sort out and document the new starvation prevention schemes?

>    Duplicate keys are handled by making a list in the tree for each key
>    value. The order of how we choose the next inode to flush is decided
>    by two fields. First the earliest dirtied_when value. If there are
>    duplicate dirtied_when values then the earliest i_flush_gen value
>    determines who gets flushed next.
> 
>    The flush tree organizes the dirtied_when keys with the rb_tree. Any
>    inodes with a duplicate dirtied_when value are link listed together. This
>    link list is sorted by the inode's i_flush_gen. When both the
>    dirtied_when and the i_flush_gen are identical the order in the
>    linked list determines the order we flush the inodes.

Introduce i_flush_gen to help restarting from the last inode?
Well, it's not as simple as list_heads.

> 2) Added an inode flag to allow inodes to be marked so that they
>    are never written back to disk.
> 
>    The motivation behind this change is several fold. The first is
>    to insure fairness in the writeback algorithm. The second is to

What do you mean by fairness? Why cannot I_WRITEBACK_NEVER be in a
decoupled standalone patch?

>    deal with a bug where the writing to large files concurrently
>    to smaller ones creates a situation where writeback cannot
>    keep up with traffic and memory baloons until the we hit the
>    threshold watermark. This can result in surprising long latency
>    with respect to disk traffic. This latency can take minutes. The

>    flush tree fixes this issue and fixes several other minor issues
>    with fairness also.

More details about the fixings, please?

