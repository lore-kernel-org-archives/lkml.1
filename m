Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbXD0E61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbXD0E61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 00:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755321AbXD0E61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 00:58:27 -0400
Received: from mga06.intel.com ([134.134.136.21]:18045 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755312AbXD0E6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 00:58:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,457,1170662400"; 
   d="scan'208";a="234872245"
Date: Thu, 26 Apr 2007 21:58:25 -0700
From: Valerie Henson <val_henson@linux.intel.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: Amit Gud <gud@ksu.edu>, Nikita Danilov <nikita@clusterfs.com>,
       David Lang <david.lang@digitalinsight.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       riel@surriel.com, zab@zabbo.net, arjan@infradead.org,
       suparna@in.ibm.com, brandon@ifup.org, karunasagark@gmail.com
Subject: Re: [RFC][PATCH] ChunkFS: fs fission for faster fsck
Message-ID: <20070427045824.GB20286@nifty>
References: <Pine.LNX.4.64.0704230544450.1682@camaro.cis.ksu.edu> <17965.60841.900376.524639@gargle.gargle.HOWL> <Pine.LNX.4.63.0704241123200.7701@qynat.qvtvafvgr.pbz> <17966.23512.363955.141489@gargle.gargle.HOWL> <Pine.LNX.4.63.0704241222110.7701@qynat.qvtvafvgr.pbz> <17967.15531.450627.972572@gargle.gargle.HOWL> <20070425224710.GB16129@nifty> <20070426141455.GA6155@c2.user-mode-linux.org> <4630CAEC.2050909@ksu.edu> <20070426160504.GA7970@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426160504.GA7970@c2.user-mode-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 12:05:04PM -0400, Jeff Dike wrote:
> 
> No, I'm referring to a different file.  The scenario is that you have
> a growing file in a nearly full disk with files being deleted (and
> thus space being freed) such that allocations for the growing file
> bounce back and forth between chunks.

This is an excellent question.  I call this the ping-pong problem.
The solution is as Amit describes: You have a maximum of one
continuation inode per file per chunk, and you require sparse files.
Here's an example, spelled out:

Allocate file 1 in chunk A.
Grow file 1.
Chunk A fills up.
Allocate continuation inode for file 1 in chunk B.
Chunk A gets some free space.
Chunk B fills up.
Pick chunk A for allocating next block of file 1.
Try to look up a continuation inode for file 1 in chunk A.
Continuation inode for file 1 found in chunk A!
Attach newly allocated block to existing inode for file 1 in chunk A.

This is why the file format inside each chunk needs to support sparse
files.

I have a presentation that has a series of slides on problems and
potential resolutions that might help:

http://infohost.nmt.edu/~val/review/chunkfs_presentation.pdf

-VAL
