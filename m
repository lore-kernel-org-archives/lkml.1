Return-Path: <linux-kernel-owner+w=401wt.eu-S1762346AbXFBS6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762346AbXFBS6b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 14:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757441AbXFBS6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 14:58:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:3702 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757641AbXFBS6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 14:58:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ZqlmeCsrWhAYZ8gtttMr/qmx01Ehj2QU5NXbiUu5SQ6KzlYe66/ucru9ECQEUGHkk0bm9PwqxZjzXq+LjWu6ll07EqghZYEPIyEFjghtPTb82iugHolkctwy/MCNMEQ+h0+HFRtxs8SLkWwqUVX2beBFZyKZtWcfehZ90WxdXdQ=
Date: Sat, 2 Jun 2007 22:57:07 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Eric Sandeen <sandeen@sandeen.net>,
       Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Fix possible leakage of blocks in UDF
Message-ID: <20070602185707.GA8518@cvg>
References: <46609FBD.5040407@sandeen.net> <20070601154834.53558d1b.akpm@linux-foundation.org> <4660FD7F.4090302@sandeen.net> <20070601224339.c803e04e.akpm@linux-foundation.org> <20070602063403.GA8387@cvg> <20070601235422.fdc1f750.akpm@linux-foundation.org> <20070602065923.GB8387@cvg> <20070602000645.508ddf93.akpm@linux-foundation.org> <20070602140619.GA10303@cvg> <20070602103203.e39d25ed.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070602103203.e39d25ed.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Andrew Morton - Sat, Jun 02, 2007 at 10:32:03AM -0700]
| On Sat, 2 Jun 2007 18:06:19 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > [Andrew Morton - Sat, Jun 02, 2007 at 12:06:45AM -0700]
| > | On Sat, 2 Jun 2007 10:59:23 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| > | 
| > | > [Andrew Morton - Fri, Jun 01, 2007 at 11:54:22PM -0700]
| > | > | On Sat, 2 Jun 2007 10:34:03 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| > | > | 
| > | > | > | That patch is DOA, methinks.
| > | > | > | 
| > | > | > 
| > | > | > Andrew, what does it mean - "DOA"? Dead on arrival?
| > | > | 
| > | > | yes - I dropped it.
| > | > | 
| > | > 
| > | > But that could lead to rejection of my code-style-conversion patch...
| > | > Should I remake them?
| > | 
| > | Actually I've rebuilt those patches four times already.  People keep
| > | changing stuff.
| > | 
| > | > Actually Jan was right, the current state of UDF (without his patches)
| > | > could lead to lost blocks and his patch must be just fixed I think.
| > | 
| > | sure.
| > | 
| > 
| > Andrew, you know I've been trying to reproduce Eric's lockup case almost
| > two hour and still can't reach it. All manupulation I've done to UDF didn't
| > lead to lockup. Moreover, I've added debug print for UDF module and here is
| > the results (for single drop_inode call):
| > 
| > 	[12063.897000] UDF: udf_drop_inode:105 --> udf_drop_inode --> inode->i_count: 0
| > 	[12063.897000] UDF: udf_drop_inode:107 udf_drop_inode -> discard_prealloc
| > 	[12063.897000] UDF: udf_discard_prealloc:136 udf_discard_prealloc
| > 	[12063.897000] UDF: udf_truncate_tail_extent:84 udf_truncate_tail_extent
| > 	[12063.897000] UDF: udf_truncate_extents:194 udf_truncate_extents -->
| > 	[12063.897000] UDF: extent_trunc:38 --->
| > 	[12063.897000] UDF: extent_trunc:54 call to udf_write_aext
| > 	[12063.897000] UDF: udf_write_aext:1843 udf_write_aext
| > 	[12063.897000] UDF: udf_write_aext:1846 dont has epos->bh
| > 	[12063.897000] UDF: udf_write_aext:1866 ICBTAG_FLAG_AD_LONG
| > --->	[12063.897000] UDF: udf_write_aext:1893 ---> gotcha ---> call mark_inode_dirty
| > --->	[12063.897000] UDF: extent_trunc:59 --> gotcha --> call mark_inode_dirty
| > 	[12063.897000] UDF: extent_trunc:68 <---
| > --->	[12063.897000] UDF: udf_truncate_extents:282 call mark_inode_dirty
| > 	[12063.897000] UDF: udf_truncate_extents:330 udf_truncate_extents <--
| > 	[12063.897000] UDF: udf_drop_inode:115 <-- udf_drop_inode <--
| > 
| > As you may see, mark_inode_dirty is called several time and no locking happened.
| > Maybe I should use some test utils?
| > 
| 
| Silly question: you _do_ have CONFIG_SMP=y, yes?
| 
Oh, no I don't :( So the problem is in kernel sync (as I thought)...
damn... I have to rebuild my kernel... but hold on - my machine has only
one CPU ;)

| And did you enable lockdep?
| 
Yes

So the problem is 'cause of mark_inode_dirty may sleep? Right?
So only thing to be checked is lock_kernel I think

		Cyrill

