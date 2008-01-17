Return-Path: <linux-kernel-owner+w=401wt.eu-S1757354AbYAQVH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354AbYAQVH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbYAQVHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:07:17 -0500
Received: from smtp-out.google.com ([216.239.33.17]:58320 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbYAQVHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:07:15 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Pf/SBOI6txN/y9To6mftNP24SJ047YPhKoWY+igJew5lAWqF38SDXGZV883cJKHt8
	YQJJeinDGBy8CuitOcsaA==
Message-ID: <532480950801171307q4b540ewa3acb6bfbea5dbc8@mail.gmail.com>
Date: Thu, 17 Jan 2008 13:07:05 -0800
From: "Michael Rubin" <mrubin@google.com>
To: "Fengguang Wu" <wfg@mail.ustc.edu.cn>
Subject: Re: [patch] Converting writeback linked lists to a tree based data structure
Cc: a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <400562938.07583@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080115080921.70E3810653@localhost> <400562938.07583@ustc.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 17, 2008 1:41 AM, Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> On Tue, Jan 15, 2008 at 12:09:21AM -0800, Michael Rubin wrote:
> The main benefit of rbtree is possibly better support of future policies.
> Can you demonstrate an example?

These are ill-formed thoughts as of now on my end but the idea was
that keeping one tree sorted via a scheme might be simpler than
multiple list_heads.

> Bugs can only be avoided by good understanding of all possible cases.)

I take the above statement as a tautology.  And am trying my best to do so. :-)

> The most tricky writeback issues could be starvation prevention
> between


>         - small/large files
>         - new/old files
>         - superblocks

So I have written tests and believe I have covered these issues. If
you are concerned in specific on any and have a test case please let
me know.

> Some kind of limit should be applied for each. They used to be:
>         - requeue to s_more_io whenever MAX_WRITEBACK_PAGES is reached
>           this preempts big files

The patch uses th same limit.

>         - refill s_io iif it is drained
>           this prevents promotion of big/old files

Once a big file gets its first do_writepages it is moved behind the
other smaller files via i_flushed_when. And the same in reverse for
big vs old.

>         - return from sync_sb_inodes() after one go of s_io

I am not sure how this limit helps things out. Is this for superblock
starvation? Can you elaborate?

> Michael, could you sort out and document the new starvation prevention schemes?

The basic idea behind the writeback algorithm to handle starvation.
The over arching idea is that we want to preserve order of writeback
based on when an inode was dirtied and also preserve the dirtied_when
contents until the inode has been written back (partially or fully)

Every sync_sb_inodes we find the least recent inodes dirtied. To deal
with large or small starvation we have a s_flush_gen for each
iteration of sync_sb_inodes every time we issue a writeback we mark
that the inode cannot be processed until the next s_flush_gen. This
way we don't process one get to the rest since we keep pushing them
into subsequent s_fush_gen's.

Let me know if you want more detail or structured responses.

> Introduce i_flush_gen to help restarting from the last inode?
> Well, it's not as simple as list_heads.
>
> > 2) Added an inode flag to allow inodes to be marked so that they
> >    are never written back to disk.
> >
> >    The motivation behind this change is several fold. The first is
> >    to insure fairness in the writeback algorithm. The second is to
>
> What do you mean by fairness?

So originally this comment was written when I was trying to fix a bug
in 2.6.23. The one where we were starving large files from being
flushed. There was a fairness issue where small files were being
flushed but the large ones were just ballooning in memory.

> Why cannot I_WRITEBACK_NEVER be in a decoupled standalone patch?

The WRITEBACK_NEVER could be in a previous patch to the rbtree. But
not a subsequent patch to the rbtree. The rbtree depends on the
WRITEBACK_NEVER patch otherwise we run in to problems in
generic_delete_inode. Now that you point it out I think I can split
this patch into two patches and make the WRITEBACK_NEVER in the first
one.

> More details about the fixings, please?

So again this comment was written against 2.6.23. The biggest fix is
the starving of big files. I remember there were other smaller issues,
but there have been so many changes in the patch sets that I need to
go back to quantify.
