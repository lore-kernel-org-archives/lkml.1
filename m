Return-Path: <linux-kernel-owner+w=401wt.eu-S1751674AbXDWHUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbXDWHUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 03:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbXDWHUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 03:20:00 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:50623 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbXDWHT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 03:19:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JpiSi5lkEOQA6xS6EZjbzYkytYOLZVskllZAV/hxyY0TSRHLYRhQjs/SVJp72Wz2ohn6CsMyMLnIkvkIho+TaD9KK37QjU7m2/n+X9CAvqM+cLFGoKzVI60pPYiiAUWxuWfRJp/GPpd7c5E2ec7c5x8vouJRoC6/I2Crv9jy4M8=
Message-ID: <2e4afe1e0704230019h3853bc82uae6c9b5cdc325ab9@mail.gmail.com>
Date: Mon, 23 Apr 2007 12:49:58 +0530
From: "Karuna sagar K" <karunasagark@gmail.com>
To: "Amit Gud" <gud@ksu.edu>
Subject: Re: ChunkFS - measuring cross-chunk references
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <462B8D0C.7020509@ksu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2e4afe1e0704221335y6d4c84d8id65e71826ce60acb@mail.gmail.com>
	 <462B8D0C.7020509@ksu.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The tool estimates the cross-chunk references from an extt2/3 file
system. It considers a block group as one chunk and calcuates how many
block groups does a file span across. So, the block group size gives
the estimate of chunk size.

The file systems were aged for about 3-4 months on a developers laptop.

Should have given the background before. Below is the explanations for
the tool. Valh and others came up with this idea.

-------------------------
Chunkfs will only work if we have "few" cross-chunk references.  We
can estimate the effect of chunk size on the number of these
references using an existing ext2/3 file system and treating the block
groups as though they are chunks.  The basic idea is that we figure
out what the block group boundaries are and then find out which files
and directories span two or more block groups.

Step 1:
-------

Get a real-world ext2/3 file system. A file system which has been in
use is required. One from a laptop or a server of any sort will do
fine.

Step 2:
-------

Figure out where the block group boundaries are on disk. Two things
are to be known:

1. Which inode numbers are in which block group?
2. Which blocks are in which block group?

At the end of this step we should have a list that looks something like:

Block group 1: Inodes 11-343, blocks 1000-20000
Block group 2: Inodes 344-576, blocks 20000-40000
[...]

Step 3:
-------

For each file, get the inode number and use mapping from step 2 to
figure out which block group it is in.  Now use bmap() on each block
in the file, and find out the block number.  Use mapping from step 2
to figure out which block groups it has data in. For each file, record
the list of all block groups.

For each directory, get the inode number and map that to a block
group. Then get the inode numbers of all entries in the directory
(ignore symlinks) and map them to a block group.  For each directory,
record the list of all block groups.

Step 4:
-------

Count the number of cross-chunk references this file system would
need.  This is done by going through each directory and file, and
adding up the number of block groups it uses MINUS one.  So if a file
was in block groups 3, 7, and 24, then you would add 2 to the total
number of cross-chunk references.  If a file was only in block group
2, then you would add 0 to the total.


On 4/22/07, Amit Gud <gud@ksu.edu> wrote:
> Karuna sagar K wrote:
> > Hi,
> >
> > The attached code contains program to estimate the cross-chunk
> > references for ChunkFS file system (idea from Valh). Below are the
> > results:
> >
>
> Nice to see some numbers! But would be really nice to know:
>
> - what the chunk size is
> - how the files were created or, more vaguely, how 'aged' the fs is
> - what is the chunk allocation algorithm
>
>
> Best,
> AG
> --
> May the source be with you.
> http://www.cis.ksu.edu/~gud
>
>


Thanks,
Karuna
