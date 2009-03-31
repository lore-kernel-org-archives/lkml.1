Return-Path: <linux-kernel-owner+w=401wt.eu-S1761654AbZCaWnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761654AbZCaWnD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 18:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755704AbZCaWmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 18:42:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbZCaWmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 18:42:50 -0400
Date: Tue, 31 Mar 2009 18:42:34 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Christoph Hellwig <hch@infradead.org>
cc: viro@zeniv.linux.org.uk,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix bmap-vs-truncate race
In-Reply-To: <20090331175451.GA19484@infradead.org>
Message-ID: <Pine.LNX.4.64.0903311728530.32061@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0903301518120.23576@hs20-bc2-1.build.redhat.com>
 <20090331175451.GA19484@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009, Christoph Hellwig wrote:

> On Mon, Mar 30, 2009 at 03:20:24PM -0400, Mikulas Patocka wrote:
> > Hi
> > 
> > I'm submitting this patch for 2.6.30 merge window.
> 
> Please not.  i_alloc_sem is really a horrible hack needed for a couple
> filesystems only and we should not leak it into more generic code but
> rather move the few instances into the filesystem.

Could you please document locking rules for get_block(), truncate, bmap & 
direct i/o in Documentation/filesystems/Locking ?

There is a lot of text about directories, but nothing about locking of 
block mappings.

I was living under an impression that get_block() cannot be called on a 
block that is being truncated. That's what read/write/direct-io vs 
truncate seems to guarante --- truncate will first lower i_size 
(preventing any new pages past i_size from being created), then destroy 
any existing pages past i_size (that includes waiting for pagelock until 
all get_blocks on that page end) and finally truncate the metadata on the 
filesystem.

So there should be no situation when you truncate block and call get_block 
on it simultaneously. If get_block can race with truncate, document it.

There are filesystems that don't do any locking on get_block() (for 
example UFS, HPFS; FAT does it only for bmap and doesn't do it for general 
accesses) and other filesystems verify indirect block chains obsessively 
if they were truncated under get_block (why? because of bmap? or some 
other possibility?) --- so the rules should really be documented.

Mikulas
