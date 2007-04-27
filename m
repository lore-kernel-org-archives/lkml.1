Return-Path: <linux-kernel-owner+w=401wt.eu-S1755599AbXD0K6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbXD0K6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 06:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755596AbXD0K6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 06:58:44 -0400
Received: from lazybastard.de ([212.112.238.170]:39363 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593AbXD0K6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 06:58:42 -0400
Date: Fri, 27 Apr 2007 12:53:34 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Valerie Henson <val_henson@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, David Chinner <dgc@sgi.com>,
       Amit Gud <gud@ksu.edu>, Nikita Danilov <nikita@clusterfs.com>,
       David Lang <david.lang@digitalinsight.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       riel@surriel.com, zab@zabbo.net, arjan@infradead.org,
       suparna@in.ibm.com, brandon@ifup.org, karunasagark@gmail.com
Subject: Re: [RFC][PATCH] ChunkFS: fs fission for faster fsck
Message-ID: <20070427105334.GB22949@lazybastard.org>
References: <Pine.LNX.4.64.0704230544450.1682@camaro.cis.ksu.edu> <17965.60841.900376.524639@gargle.gargle.HOWL> <Pine.LNX.4.63.0704241123200.7701@qynat.qvtvafvgr.pbz> <17966.23512.363955.141489@gargle.gargle.HOWL> <462E7C47.8080604@ksu.edu> <20070425105434.GX32602149@melbourne.sgi.com> <20070425230344.GC16129@nifty> <20070426084738.GA21666@atrey.karlin.mff.cuni.cz> <20070427050742.GC20286@nifty>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070427050742.GC20286@nifty>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 April 2007 22:07:43 -0700, Valerie Henson wrote:
>
>             What's important is that each continuation inode have a
> back pointer to the parent and that there is some structure for
> quickly looking up the continuation inode for a given file offset.
> Suggestions for data structures that work well in this situation are
> welcome. :)

All this would get easier if continuation inodes were known to be rare.
You can ditch the doubly-linked list in favor of a pointer to the main
inode then - traversing the list again is cheap, after all.  And you can
just try to read the same block once for every continuation inode.

If those lists can get long and you need a mapping from offset to
continuation inode on the medium, you are basically fscked.  Storing the
mapping requires space.  You need the mapping only when space (in some
chunk) gets tight and you allocate continuation inodes.  So either you
don't need the mapping or you don't have a good place to put it.

Having a mapping in memory is also questionable.  Either you scan the
whole file on first access and spend a long time for large files.  Or
you create the mapping on the fly.  In that case the page cache will
already give you a 90% solution for free.

You should spend a lot of effort trying to minimize cnodes. ;)

Jörn

-- 
To recognize individual spam features you have to try to get into the
mind of the spammer, and frankly I want to spend as little time inside
the minds of spammers as possible.
-- Paul Graham
