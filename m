Return-Path: <linux-kernel-owner+w=401wt.eu-S1757882AbXFOCEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882AbXFOCEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 22:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbXFOCE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 22:04:28 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45680 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751245AbXFOCE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 22:04:28 -0400
Date: Thu, 14 Jun 2007 19:04:27 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [patch 00/14] Page cache cleanup in anticipation of Large
 Blocksize support
In-Reply-To: <20070614184013.1ff51d34.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706141855570.3571@schroedinger.engr.sgi.com>
References: <20070614193839.878721298@sgi.com> <20070614130645.cabdff1b.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706141411180.1579@schroedinger.engr.sgi.com>
 <20070614143248.736312f8.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706141436030.1797@schroedinger.engr.sgi.com>
 <20070614150417.c73fb6b9.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706141517120.2240@schroedinger.engr.sgi.com>
 <20070614154939.c94b097f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706141742580.3220@schroedinger.engr.sgi.com>
 <20070614184013.1ff51d34.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2007, Andrew Morton wrote:

> There will be files which should use 64k but which instead end up using 4k.
> 
> There will be files which should use 4k but which instead end up using 64k.
> 
> Because determining which size to use requires either operator intervention
> or kernel heuristics, both of which will be highly unreliable.
> 
> It's better to just make 4k pages go faster.

Initially its quite easy to have a filesystem for your 4k files (basically 
the distro you are running) and an archive for video / audio etc files 
that has 64k size for data. In the future filesystem may support sizes set 
per directory. Basically if things get to slow you can pull the lever.

> > Magical? There is nothing magical about doing transfers in the size that 
> > is supported by a device. That is good sense.
> 
> By magical heuristics I'm referring to the (required) tricks and guesses
> which the kernel will need to deploy to be able to guess which page-size it
> should use for each file.
> 
> Because without such heuristics, none of this new stuff which you're
> proposing would ever get used by 90% of apps on 90% of machines.

In the patchset V3 one f.e. simply formats a volume by specifying the 
desired blocksize. If one gets into trouble with fsck and other slowdown 
associated with large file I/O then they are going to be quite fast to 
format a partition with larger blocksize. Its a know technology in many 
Unixes.

The approach essentially gives one freedom to choose a page size. This is 
a tradeoff between desired speed, expected file sizes, filesystem behavior 
and acceptable fragmentation overhead. If we do this approach then I think 
we will see the mkfs.XXX  tools to automatically make intelligent choices
on which page size to use. They are all stuck at 4k at the moment.

> > Of course there is. The seeks are reduced since there are an factor 
> > of 16 less metadata blocks. fsck does not read files. It just reads 
> > metadata structures. And the larger contiguous areas the faster.
> 
> Some metadata is contiguous: inode tables, some directories (if they got
> lucky), bitmap tables.  But fsck surely reads them in a single swoop
> anyway, so there's no gain there.

The metadata needs to refer to 1/16th of the earlier pages that need to be 
tracked. metadata is shrunk significantly.
 
> Other metadata (indirect blocks) are 100% discontiguous, and reading those
> with a 64k IO into 64k of memory is completely dumb.

The effect of a larger page size is that the filesystem will 
place more meta data into a single page instead of spreading it out. 
Reading a mass of meta data with a 64k read is an intelligent choice to 
make in particular if there is a large series of such reads.
