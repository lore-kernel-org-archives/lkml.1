Return-Path: <linux-kernel-owner+w=401wt.eu-S1762259AbXFBRcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762259AbXFBRcW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 13:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760612AbXFBRcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 13:32:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34496 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760273AbXFBRcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 13:32:14 -0400
Date: Sat, 2 Jun 2007 10:32:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Jan Kara <jack@suse.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Fix possible leakage of blocks in UDF
Message-Id: <20070602103203.e39d25ed.akpm@linux-foundation.org>
In-Reply-To: <20070602140619.GA10303@cvg>
References: <465DF0B4.2050203@sandeen.net>
	<20070601211036.GA23975@duck.suse.cz>
	<46609FBD.5040407@sandeen.net>
	<20070601154834.53558d1b.akpm@linux-foundation.org>
	<4660FD7F.4090302@sandeen.net>
	<20070601224339.c803e04e.akpm@linux-foundation.org>
	<20070602063403.GA8387@cvg>
	<20070601235422.fdc1f750.akpm@linux-foundation.org>
	<20070602065923.GB8387@cvg>
	<20070602000645.508ddf93.akpm@linux-foundation.org>
	<20070602140619.GA10303@cvg>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jun 2007 18:06:19 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> [Andrew Morton - Sat, Jun 02, 2007 at 12:06:45AM -0700]
> | On Sat, 2 Jun 2007 10:59:23 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> | 
> | > [Andrew Morton - Fri, Jun 01, 2007 at 11:54:22PM -0700]
> | > | On Sat, 2 Jun 2007 10:34:03 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> | > | 
> | > | > | That patch is DOA, methinks.
> | > | > | 
> | > | > 
> | > | > Andrew, what does it mean - "DOA"? Dead on arrival?
> | > | 
> | > | yes - I dropped it.
> | > | 
> | > 
> | > But that could lead to rejection of my code-style-conversion patch...
> | > Should I remake them?
> | 
> | Actually I've rebuilt those patches four times already.  People keep
> | changing stuff.
> | 
> | > Actually Jan was right, the current state of UDF (without his patches)
> | > could lead to lost blocks and his patch must be just fixed I think.
> | 
> | sure.
> | 
> 
> Andrew, you know I've been trying to reproduce Eric's lockup case almost
> two hour and still can't reach it. All manupulation I've done to UDF didn't
> lead to lockup. Moreover, I've added debug print for UDF module and here is
> the results (for single drop_inode call):
> 
> 	[12063.897000] UDF: udf_drop_inode:105 --> udf_drop_inode --> inode->i_count: 0
> 	[12063.897000] UDF: udf_drop_inode:107 udf_drop_inode -> discard_prealloc
> 	[12063.897000] UDF: udf_discard_prealloc:136 udf_discard_prealloc
> 	[12063.897000] UDF: udf_truncate_tail_extent:84 udf_truncate_tail_extent
> 	[12063.897000] UDF: udf_truncate_extents:194 udf_truncate_extents -->
> 	[12063.897000] UDF: extent_trunc:38 --->
> 	[12063.897000] UDF: extent_trunc:54 call to udf_write_aext
> 	[12063.897000] UDF: udf_write_aext:1843 udf_write_aext
> 	[12063.897000] UDF: udf_write_aext:1846 dont has epos->bh
> 	[12063.897000] UDF: udf_write_aext:1866 ICBTAG_FLAG_AD_LONG
> --->	[12063.897000] UDF: udf_write_aext:1893 ---> gotcha ---> call mark_inode_dirty
> --->	[12063.897000] UDF: extent_trunc:59 --> gotcha --> call mark_inode_dirty
> 	[12063.897000] UDF: extent_trunc:68 <---
> --->	[12063.897000] UDF: udf_truncate_extents:282 call mark_inode_dirty
> 	[12063.897000] UDF: udf_truncate_extents:330 udf_truncate_extents <--
> 	[12063.897000] UDF: udf_drop_inode:115 <-- udf_drop_inode <--
> 
> As you may see, mark_inode_dirty is called several time and no locking happened.
> Maybe I should use some test utils?
> 

Silly question: you _do_ have CONFIG_SMP=y, yes?

And did you enable lockdep?
