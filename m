Return-Path: <linux-kernel-owner+w=401wt.eu-S1757767AbXFZSMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767AbXFZSMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 14:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757332AbXFZSMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 14:12:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:53245 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075AbXFZSMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 14:12:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: carsteno@de.ibm.com
Subject: Re: [Cbe-oss-dev] [patch 3/5] cell: updated driver for DDR2 memory on AXON
Date: Tue, 26 Jun 2007 19:38:06 +0200
User-Agent: KMail/1.9.6
Cc: cbe-oss-dev@ozlabs.org, Maxim Shchetynin <maxim@de.ibm.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <OF39A5D2DB.6FC50A30-ONC1257306.0051B925-C1257306.0052040B@de.ibm.com> <200706261821.06516.arnd@arndb.de> <46815286.1010808@de.ibm.com>
In-Reply-To: <46815286.1010808@de.ibm.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706261938.07112.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+DRiF+RMXl9iyQjnaQsdY8/Kty41ACqikjC7M
 h1rACSd5EByWvCs7eqzkOSiOHcN+NNsx9vVbbTmYC8ZQuwQArC
 GcyPR75oTs5aXbF+XgYNA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 June 2007, Carsten Otte wrote:
> 
> Arnd Bergmann wrote:
> > What will actually happen if you try to mount an axonram device with ext2?
> > I suppose mount should fail with a proper error code if the block size is
> > larger than 4kb, but does that happen?
> > 
> > If you have a 4k block size axonram device, the ext2 really should work
> > using XIP as expected, including the mmap() operation.
> > 
> Absolutely. What's the symptom if you try mount -o xip? I am willing 
> to fix any bugs that show in the ext2/xip code in that scenario...

The real problem is that the ->direct_access function is supposed to return
a kernel virtual address in the linear mapping, which does not make any
sense for axonram. The physical address of the underlying device is
outside of the kernel mapping, and gets mapped into the kernel virtual
space using ioremap, with flags to disallow caching.

If ->direct_access returns a physical address, the file system cannot
access the data through the kernel mapping, but if it returns the
ioremapped address, it cannot know what address to map into the
user page tables, because virt_to_page() is not defined for the
ioremap space.

Maximchose to return the physical address, which is what he needs in
his file system, but that's just not how the interface was designed
to be used.

One way to change fix the problem might be to give a flag to the
->direct_access function to ask for either the page frame number,
or the virtual address (from ioremap or the linear mapping).
It's rather ugly though, so if you have a better idea, let us
know.

Another problem is that the mmap, or no_page, function really
needs to know about the pgprot value it should use. If we add
a field to struct block_device for this, the drivers could set
it there.

	Arnd <><
