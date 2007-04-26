Return-Path: <linux-kernel-owner+w=401wt.eu-S1755092AbXDZWZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbXDZWZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 18:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbXDZWZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 18:25:44 -0400
Received: from lazybastard.de ([212.112.238.170]:45053 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbXDZWZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 18:25:42 -0400
Date: Fri, 27 Apr 2007 00:21:13 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: David Chinner <dgc@sgi.com>
Cc: Valerie Henson <val_henson@linux.intel.com>, Amit Gud <gud@ksu.edu>,
       Nikita Danilov <nikita@clusterfs.com>,
       David Lang <david.lang@digitalinsight.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       riel@surriel.com, zab@zabbo.net, arjan@infradead.org,
       suparna@in.ibm.com, brandon@ifup.org, karunasagark@gmail.com
Subject: Re: [RFC][PATCH] ChunkFS: fs fission for faster fsck
Message-ID: <20070426222112.GA18172@lazybastard.org>
References: <Pine.LNX.4.64.0704230544450.1682@camaro.cis.ksu.edu> <17965.60841.900376.524639@gargle.gargle.HOWL> <Pine.LNX.4.63.0704241123200.7701@qynat.qvtvafvgr.pbz> <17966.23512.363955.141489@gargle.gargle.HOWL> <462E7C47.8080604@ksu.edu> <20070425105434.GX32602149@melbourne.sgi.com> <20070425230344.GC16129@nifty> <20070426004740.GE65285596@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070426004740.GE65285596@melbourne.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 April 2007 10:47:40 +1000, David Chinner wrote:
> 
> This assumes that you know a chunk has been corrupted, though.
> How do you find that out?

Option 1: you notice something odd while serving userspace.
Option 2: a checking/scrubbing daemon of some sorts.

The first will obviously miss any corruption in data that is not touched
for a long time (ever?).

> > What you need to make this go fast is (1) a pre-made list of which
> > chunks have links with which other chunks,
> 
> So you add a new on-disk structure that needs to be kept up to
> date? How do you trust that structure to be correct if you are
> not journalling it?

Only chance I see is to treat this list as hints.  It should contain all
chunks that possibly have links.  It may also contain chunks that don't
have links.  By keeping strict FFS-style ordering of all relevant
writes, any mismatch should only cost fsck time.

Managing this list appears to be less than trivial.  Might actually be
easier to have LogFS-style rmap for each object in the filesystem.

> What happens if fsfuzzer trashes part
> of this table as well and you can't trust it?

If you have 5000 redundant copies of data and all get corrupted, you are
doomed.  I don't expect my filesystem to recover after having written
0x00 over the whole device.

Being able to recover a single corruption happening anywhere on the
device is already a huge step forward.  Of course most current
filesystems wouldn't even be able to detect all possible corruptions.
That alone would be a step forward.

One of the smart things of ZFS is to checksum everything.  Among the
Linux filesystems only JFFS2 seems to do it, but it cannot distinguish
between corrupted data and incomplete writes before a crash.  It
definitely costs performance, but that is the price one has to pay if
errors are to be detected.

Jörn

-- 
Do not stop an army on its way home.
-- Sun Tzu
