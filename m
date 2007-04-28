Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbXD1KHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbXD1KHt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 06:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756136AbXD1KHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 06:07:49 -0400
Received: from lazybastard.de ([212.112.238.170]:40812 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710AbXD1KHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 06:07:47 -0400
Date: Sat, 28 Apr 2007 12:03:20 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Valerie Henson <val_henson@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, David Chinner <dgc@sgi.com>,
       Amit Gud <gud@ksu.edu>, Nikita Danilov <nikita@clusterfs.com>,
       David Lang <david.lang@digitalinsight.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       riel@surriel.com, zab@zabbo.net, arjan@infradead.org,
       suparna@in.ibm.com, brandon@ifup.org, karunasagark@gmail.com
Subject: Re: [RFC][PATCH] ChunkFS: fs fission for faster fsck
Message-ID: <20070428100319.GA25493@lazybastard.org>
References: <17965.60841.900376.524639@gargle.gargle.HOWL> <Pine.LNX.4.63.0704241123200.7701@qynat.qvtvafvgr.pbz> <17966.23512.363955.141489@gargle.gargle.HOWL> <462E7C47.8080604@ksu.edu> <20070425105434.GX32602149@melbourne.sgi.com> <20070425230344.GC16129@nifty> <20070426084738.GA21666@atrey.karlin.mff.cuni.cz> <20070427050742.GC20286@nifty> <20070427105334.GB22949@lazybastard.org> <20070428065006.GA21945@nifty>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070428065006.GA21945@nifty>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 April 2007 23:50:06 -0700, Valerie Henson wrote:
> 
> Any mapping structure will have to be pre-allocated.

How much space would you allocate for it then?  The required size surely
depends on the file size and fragmentation.

> So in my secret heart of hearts, I do indeed hope that cnodes are rare
> enough that we don't actually have to do anything smart to make them
> go fast.  Either having no fast lookup structure or creating it in
> memory as needed would be the nicest solution.  However, since I can't
> guarantee this will be the case, it's nice to have some idea of what
> we'll do if this does become important.

You go slow and slower.  Or you can defragment/clean the filesystem.
Fragmented filesystems being slow is hardly news to anyone.  ChunkFS
will be slower than others, so the reasons to fight fragmentation weigh
heavier.

What you can do:
- If two files 1 and 2 contain blocks in chunks A and B, move file 1
  blocks to chunk A and file 2 blocks to chunk B until one of the files
  only spans a single chunk.
- Same as above with longer chains like file 1 in chunks (A,B), file 2
  in chunks (B,C), file 3 in chunks (A,C).
- When writing to file 1 in chunk A but running out of space in chunk A,
  move some cross-chunk file over instead of writing file 1 blocks to
  chunk B.

The first two can hope to use some idle times (if they exist), the third
will make writes go slower in order to speed up future reads.

There ain't no such thing as a free lunch. :)

Jörn

-- 
I can say that I spend most of my time fixing bugs even if I have lots
of new features to implement in mind, but I give bugs more priority.
-- Andrea Arcangeli, 2000
