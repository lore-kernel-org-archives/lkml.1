Return-Path: <linux-kernel-owner+w=401wt.eu-S1758753AbYDRReg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753AbYDRReg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 13:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758524AbYDRReS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 13:34:18 -0400
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:42054 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514AbYDRReQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 13:34:16 -0400
Date: Fri, 18 Apr 2008 20:35:48 +0300 (MET DST)
From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
X-X-Sender: szaka@dhcppc2
To: Bob Copeland <me@bobcopeland.com>
cc: Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
In-Reply-To: <b6c5339f0804180651m2a291755ke093bda3bea1d2b4@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0804181958560.29728@dhcppc2>
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com> 
 <20080412170304.54f139e2.akpm@linux-foundation.org>  <20080413033344.GA27494@hash.localnet>
  <20080412205544.5e12a7d4.akpm@linux-foundation.org>  <20080413080130.GA9622@infradead.org>
  <20080413012001.8d7967f4.akpm@linux-foundation.org>  <20080413082815.GA20108@infradead.org>
  <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu>  <20080414004521.GA30489@hash.localnet>
  <Pine.LNX.4.61.0804181302180.29728@dhcppc2>
 <b6c5339f0804180651m2a291755ke093bda3bea1d2b4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 18 Apr 2008, Bob Copeland wrote:
> 
> Like I said it was anecdotal (copy 20 gigs of X) in both.  I'm sure a
> good portion of it is my fault, such as doing unnecessary malloc & copies
> in omfs_fuse.  I have put exactly zero effort into making it fast so far.

I also don't advocate any solution, only interested in the FUSE myth 
busting and making it easier to use and develop for, i.e. having the best 
possible performance with zero effort.

I checked both solutions quickly, I think they are nicely written.

The kernel driver had 30 MB/s with 10% CPU usage, the FUSE version had 
6 MB/s with high I/O waiting.

The major reason seems to be that the FUSE version reads heavily from the 
block device during pure write operations, while the kernel driver never. 
There can be several non-exclusive explanations.

One of them, as you wrote, the functionality is not exactly the same, the 
FUSE one does more. If it's relevant or not, you should know. If anything 
is involved with reading from multiply places regularly then it's relevant.

Moreover when you're writing to a block device from user space then the 
size and position of the block should be page aligned, otherwise you end up 
doing unwanted synchronous reads instead of the believed asynchronous 
writes. Solving this issue for the most common cases resulted a sometimes 
over 10 fold write speedup in ntfs-3g. But of course it would be nice if 
the kernel just provided this for everybody.

Btw, mkomfs.c is missing a '#define _FILE_OFFSET_BITS 64' which is needed 
to open LFS files.

        Szaka

--
NTFS-3G:  http://ntfs-3g.org
