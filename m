Return-Path: <linux-kernel-owner+w=401wt.eu-S1423147AbXDXVy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423147AbXDXVy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 17:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423139AbXDXVy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 17:54:28 -0400
Received: from smtp3.cc.ksu.edu ([129.130.7.17]:51055 "EHLO smtp3.cc.ksu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754645AbXDXVy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 17:54:27 -0400
Message-ID: <462E7C47.8080604@ksu.edu>
Date: Tue, 24 Apr 2007 16:53:11 -0500
From: Amit Gud <gud@ksu.edu>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Nikita Danilov <nikita@clusterfs.com>
CC: David Lang <david.lang@digitalinsight.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, val_henson@linux.intel.com,
       riel@surriel.com, zab@zabbo.net, arjan@infradead.org,
       suparna@in.ibm.com, brandon@ifup.org, karunasagark@gmail.com
Subject: Re: [RFC][PATCH] ChunkFS: fs fission for faster fsck
References: <Pine.LNX.4.64.0704230544450.1682@camaro.cis.ksu.edu>	<17965.60841.900376.524639@gargle.gargle.HOWL>	<Pine.LNX.4.63.0704241123200.7701@qynat.qvtvafvgr.pbz> <17966.23512.363955.141489@gargle.gargle.HOWL>
In-Reply-To: <17966.23512.363955.141489@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nikita Danilov wrote:
> Maybe I failed to describe the problem presicely.
> 
> Suppose that all chunks have been checked. After that, for every inode
> I0 having continuations I1, I2, ... In, one has to check that every
> logical block is presented in at most one of these inodes. For this one
> has to read I0, with all its indirect (double-indirect, triple-indirect)
> blocks, then read I1 with all its indirect blocks, etc. And to repeat
> this for every inode with continuations.
> 
> In the worst case (every inode has a continuation in every chunk) this
> obviously is as bad as un-chunked fsck. But even in the average case,
> total amount of io necessary for this operation is proportional to the
> _total_ file system size, rather than to the chunk size.
> 

Perhaps, I should talk about how continuation inodes are managed / 
located on disk. (This is how it is in my current implementation)

Right now, there is no distinction between an inode and continuation 
inode (also referred to as 'cnode' below), except for the 
EXT2_IS_CONT_FL flag. Every inode holds a list of static number of 
inodes, currently limited to 4.

The structure looks like this:

  ----------		----------
| cnode 0  |---------->| cnode 0  |----------> to another cnode or NULL
  ----------		----------
| cnode 1  |-----      | cnode 1  |-----
  ----------	|	----------	|
| cnode 2  |--	|      | cnode 2  |--   |
  ----------  |	|	----------  |   |
| cnode 3  | |	|      | cnode 3  | |   |
  ----------  |	|	----------  |   |
	  |  |  |		 |  |   |

	   inodes		inodes or NULL

I.e. only first cnode in the list carries forward the chain if all the 
slots are occupied.

Every cnode# field contains
{
	ino_t cnode;
	__u32 start;	/* starting logical block number */
	__u32 end;	/* ending logical block number */
}

(current implementation has just one field: cnode)

I thought of this structure to avoid recursion and / or use of any data 
structure while traversing the continuation inodes.

Additional flag, EXT2_SPARSE_CONT_FL would indicate whether the inode 
has any sparse portions. 'start' and 'end' fields are used to speed-up 
finding a cnode given a logical block number without the need of 
actually reading the inode - this can be done away with, perhaps more 
conveniently by, pinning the cnodes in memory as and when read.

Now going back to the Nikita's question, all the cnodes for an inode 
need to be scanned iff 'start' field or number of blocks or flag 
EXT2_SPARSE_CONT_FL in any of its cnodes is altered.

And yes, the whole attempt is to reduce the number of continuation inodes.

Comments, suggestions welcome.


AG
-- 
May the source be with you.
http://www.cis.ksu.edu/~gud

