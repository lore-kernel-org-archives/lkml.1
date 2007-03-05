Return-Path: <linux-kernel-owner+w=401wt.eu-S1751073AbXCEAqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751073AbXCEAqU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 19:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbXCEAqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 19:46:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:59099 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbXCEAqT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 19:46:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Mon, 5 Mar 2007 01:44:54 +0100
User-Agent: KMail/1.9.6
Cc: =?iso-8859-1?q?J=F6rn_Engel?= <joern@lazybastard.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
       alex@clusterfs.com, suzuki@in.ibm.com
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070305001621.GB18691@lazybastard.org> <CDA7A0DF-D744-416F-83B1-76C148B46A5F@cam.ac.uk>
In-Reply-To: <CDA7A0DF-D744-416F-83B1-76C148B46A5F@cam.ac.uk>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703050144.55813.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX18C7IE4YfF3Ypc/Zq7WJQsgTKtPVyu+AT5Zgz6
 5F3vD/zyHyz/IM+V1H60BucpjgakmhG/luwh4XEs/T7zo4yMD4
 Wvj8ft7I+yn/rdej/r8mA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 March 2007, Anton Altaparmakov wrote:
> An alternative would be to allocate blocks and then when the data is  
> written perform the compression and free any blocks you do not need  
> any more because the data has shrunk sufficiently.  Depending on the  
> implementation details this could potentially create horrible  
> fragmentation as you would allocate a large consecutive region and  
> then go and drop random blocks from that region thus making the file  
> fragmented.

Unfortunately, this is not as easy on logfs, because there is no point
in allocating a block when there is no data to write into it. Fragmentation
on flash media is free, but you can never modify a block in place without
erasing it first. This means it will always be written to a new location
on the next write access.

One option that might work (similar to what you describe in your other mail)
is to have a per-inode count of reserved blocks, without allocating specific
blocks for them. The journal then needs to maintain the number of total
reserved blocks for all files and keep that in sync with blocks that were
reserved for specific inodes.

	Arnd <><
