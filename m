Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbZBCQN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbZBCQN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 11:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbZBCQNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 11:13:20 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:4661 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbZBCQNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 11:13:19 -0500
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent
	VM_LOCKED file segments
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mikos Szeredi <miklos@szeredi.hu>
In-Reply-To: <Pine.LNX.4.64.0901311216250.6763@blonde.anvils>
References: <bb4a86c70901281151w4300605r3882461cd6e9774a@mail.gmail.com>
	 <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain>
	 <1233259410.2315.75.camel@lts-notebook>
	 <alpine.LFD.2.00.0901291228250.3123@localhost.localdomain>
	 <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain>
	 <bb4a86c70901291447k5c5e90cfg34877b745825f5e2@mail.gmail.com>
	 <alpine.LFD.2.00.0901291806340.3054@localhost.localdomain>
	 <20090130055639.GA30950@suse.de>
	 <alpine.LFD.2.00.0901300811260.3150@localhost.localdomain>
	 <Pine.LNX.4.64.0901301724010.1563@blonde.anvils>
	 <alpine.LFD.2.00.0901300946360.3150@localhost.localdomain>
	 <1233345190.908.36.camel@lts-notebook>
	 <alpine.LFD.2.00.0901301159500.3150@localhost.localdomain>
	 <Pine.LNX.4.64.0901302048360.18677@blonde.anvils>
	 <1233351412.908.69.camel@lts-notebook>
	 <alpine.LFD.2.00.0901301426390.3150@localhost.localdomain>
	 <Pine.LNX.4.64.0901311216250.6763@blonde.anvils>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 03 Feb 2009 11:13:30 -0500
Message-Id: <1233677610.15321.129.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-31 at 12:35 +0000, Hugh Dickins wrote:
<snip>
> I have by now recalled why I chose to play those VM_ACCOUNT games:
> 	/* We set VM_ACCOUNT in a shared mapping's vm_flags, to inform
> 	 * shmem_zero_setup (perhaps called through /dev/zero's ->mmap)
> 	 * that memory reservation must be checked; but that reservation
> 	 * belongs to shared memory object, not to vma: so now clear it.
> We need a way to communicate not-MAP_NORESERVE to shmem.c, and we don't
> just need it in the explicit shmem_zero_setup() case, we also need it
> for the (probably rare nowadays) case when mmap() is working on file
          ^^^^^^^^^^^^^^^^^^^^^^^^
> /dev/zero (drivers/char/mem.c mmap_zero()), rather than using MAP_ANON.


This reminded me of something I'd seen recently looking
at /proc/<pid>/[numa]_maps for <a large commercial database> on
Linux/x86_64: 

2adadf247000-2adadf2b2000 rwxp 2adadf247000 00:00 0
2adadf2b2000-2adadf2b3000 rwxs 00000000 68:31 55362966                   <some file != /dev/zero>
2adadf2b9000-2adadf2c0000 rwxp 00000000 00:0e 4072                       /dev/zero
2adadf2c0000-2adadf2d0000 rwxp 00000000 00:0e 4072                       /dev/zero
2adadf2d0000-2adadf2e0000 rwxp 00000000 00:0e 4072                       /dev/zero
2adadf2e0000-2adadf2f0000 rwxp 00000000 00:0e 4072                       /dev/zero
2adadf2f0000-2adadf300000 rwxp 00000000 00:0e 4072                       /dev/zero
2adadf300000-2adadf310000 rwxp 00000000 00:0e 4072                       /dev/zero
2adadf310000-2adadf320000 rwxp 00000000 00:0e 4072                       /dev/zero
2adadf320000-2adadf330000 rwxp 00000000 00:0e 4072                       /dev/zero
2adadf330000-2adadf339000 rwxp 00077000 00:0e 4072                       /dev/zero
2adadf353000-2adadf35a000 r-xp 00000000 69:02 1228822                    /lib64/libnss_compat-2.4.so
2adadf35a000-2adadf459000 ---p 00007000 69:02 1228822                    /lib64/libnss_compat-2.4.so
2adadf459000-2adadf45b000 rwxp 00006000 69:02 1228822                    /lib64/libnss_compat-2.4.so
2adadf45b000-2adadf464000 r-xp 00000000 69:02 1228830                    /lib64/libnss_nis-2.4.so
2adadf464000-2adadf564000 ---p 00009000 69:02 1228830                    /lib64/libnss_nis-2.4.so
2adadf564000-2adadf566000 rwxp 00009000 69:02 1228830                    /lib64/libnss_nis-2.4.so
2adadf566000-2adadf570000 r-xp 00000000 69:02 1228826                    /lib64/libnss_files-2.4.so
2adadf570000-2adadf66f000 ---p 0000a000 69:02 1228826                    /lib64/libnss_files-2.4.so
2adadf66f000-2adadf671000 rwxp 00009000 69:02 1228826                    /lib64/libnss_files-2.4.so
2adadf671000-2adadf681000 rwxp 00000000 00:0e 4072                       /dev/zero
2adadf681000-2adadf6a1000 rwxp 00000000 00:0e 4072                       /dev/zero
2adadf6a1000-2adadf6b1000 rwxp 00000000 00:0e 4072                       /dev/zero
2adadf6b1000-2adadf6c1000 rwxp 00000000 00:0e 4072                       /dev/zero
2adadf6c1000-2adadf6d1000 rwxp 00000000 00:0e 4072                       /dev/zero
2adadf6d1000-2adadf6e1000 rwxp 00000000 00:0e 4072                       /dev/zero
2adadf6e1000-2adadf6f1000 rwxp 00000000 00:0e 4072                       /dev/zero
2adadf6f1000-2adadf701000 rwxp 00000000 00:0e 4072                       /dev/zero
2adadf701000-2adadf711000 rwxp 00000000 00:0e 4072                       /dev/zero
2adadf711000-2adadf721000 rwxp 00000000 00:0e 4072                       /dev/zero
2adadf721000-2adadf731000 rwxp 00000000 00:0e 4072                       /dev/zero
2adadf731000-2adadf741000 rwxp 00000000 00:0e 4072                       /dev/zero

<and so on, for another 90 lines until>

7fffcdd36000-7fffcdd4e000 rwxp 7fffcdd36000 00:00 0                      [stack]
ffffffffff600000-ffffffffffe00000 ---p 00000000 00:00 0                  [vdso]

For portability between Linux and various Unix-like systems that don't
support MAP_ANON*, perhaps?

Anyway, from the addresses and permissions, these all look potentially
mergeable.  The offset is preventing merging, right?  I guess that's one
of the downsides of mapping /dev/zero rather than using MAP_ANONYMOUS?

Makes one wonder whether it would be worthwhile [not to mention
possible] to rework mmap_zero() to mimic MAP_ANONYMOUS...

Lee

