Return-Path: <linux-kernel-owner+w=401wt.eu-S1750741AbXCEAhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750741AbXCEAhn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 19:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750835AbXCEAhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 19:37:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:52945 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbXCEAhk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 19:37:40 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?J=C3=B6rn_Engel?= <joern@lazybastard.org>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Mon, 5 Mar 2007 01:36:36 +0100
User-Agent: KMail/1.9.6
Cc: Ulrich Drepper <drepper@redhat.com>, Anton Altaparmakov <aia21@cam.ac.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
       alex@clusterfs.com, suzuki@in.ibm.com
References: <20070117094658.GA17390@amitarora.in.ibm.com> <45EB4A55.3060908@redhat.com> <20070305001621.GB18691@lazybastard.org>
In-Reply-To: <20070305001621.GB18691@lazybastard.org>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703050136.37181.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX1+ymGbHvMo2CeqvK/CrxH9X9vRqSYDC/HVFHn3
 2Rr7LOT6vLL4v6vXlwLlQXK1Oi2Uue7qi1ycBm72WJAxtY3PPX
 AARky4C484W6gPW2Nt/lA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 March 2007, Jörn Engel wrote:
> That actually causes an interesting problem for compressing filesystems.
> The space consumed by blocks depends on their contents and how well it
> compresses.  At the moment, the only option I see to support
> posix_fallocate for LogFS is to set an inode flag disabling compression,
> then allocate the blocks.
> 
> But if the file already contains large amounts of compressed data, I
> have a problem.  Disabling compression for a range within a file is not
> supported, so I can only return an error.  But which one?

Using the current glibc implementation on a compressed file system ideally
should be a very expensive no-op because you won't actually allocate much
space for a file when writing zeroes to it. You also don't benefit of a
contiguous allocation in logfs, since flash has uniform seek times over
all the medium.

I'd suggest you implement posix_fallocate as an real nop and just return
success without doing anything. You could also return ENOSPC in case
the blocks requested by posix_fallocate don't fit on the medium without
compression, but that is more or less just guesswork (like statfs is).

	Arnd <><
