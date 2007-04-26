Return-Path: <linux-kernel-owner+w=401wt.eu-S1031407AbXDZSOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031407AbXDZSOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031415AbXDZSOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:14:20 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2121 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031407AbXDZSOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:14:18 -0400
Message-ID: <4630EBFA.9000207@shadowen.org>
Date: Thu, 26 Apr 2007 19:14:18 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>
CC: Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm2 -- PPC link failure
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org> <4630A662.8090502@shadowen.org> <4630ABF2.1040305@shadowen.org>
In-Reply-To: <4630ABF2.1040305@shadowen.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> Andy Whitcroft wrote:
>> Getting a link failure on a ppc64 system:
>>
>>   LD      .tmp_vmlinux1
>> init/built-in.o(.init.text+0x32e4): In function `.rd_load_image':
>> : undefined reference to `.__kmalloc_size_too_large'
>> fs/built-in.o(.text+0xa6fe0): In function `.ext3_fill_super':
>> : undefined reference to `.__kmalloc_size_too_large'
>> fs/built-in.o(.text+0xc1fe0): In function `.ext2_fill_super':
>> : undefined reference to `.__kmalloc_size_too_large'
>> fs/built-in.o(.text+0xf6a1c): In function `.nfs4_proc_lookup':
>> : undefined reference to `.__kmalloc_size_too_large'
>> fs/built-in.o(.text+0x104104): In function `.nfs_idmap_new':
>> : undefined reference to `.__kmalloc_size_too_large'
>> fs/built-in.o(.text+0x105520): more undefined references to
>> `.__kmalloc_size_too_large' follow
>> make: *** [.tmp_vmlinux1] Error 1
> 
> Ok, this is a SLUB related link failure.  Am investigating if PPC simply
> needs larger allocs and needs CONFIG_LARGE_ALLOCS, of if this is an
> inlining issue.

Ok this is confirmed as an inlining issue.  With the compiler below on
ppc64 we get the above link failure:

  gcc version 3.3.3 (SuSE Linux)

What seems to happen is that although the optimiser is capable of
collapsing the kmalloc_index() call it then fails to collapse
kmalloc_slab().  This leads to the never used reference to
__kmalloc_size_too_large() and the link failure.  From my testing this
seems to occur at sizes >= 32k.  At 16k all of the code collapses
correctly, at 32k it does not.  I am not entirely sure what to think at
this point, it is cirtainly not at all clear why the 32k version fails
and the 16k succeeds they are almost identical.

Either way it seems to me that assuming the optimiser will remove the
code is perhaps over optimistic.  Perhaps it would make more sense to
put a BUG() in here.  Though that points out the anomaly that the
kmalloc() for constants has different semantics to that for variable values?

Comments?

-apw
