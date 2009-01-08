Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbZAHCRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbZAHCRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 21:17:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbZAHCQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 21:16:52 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:45220 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbZAHCQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 21:16:51 -0500
Date: Thu, 8 Jan 2009 02:16:26 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Ingo Molnar <mingo@elte.hu>
cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [3/5] Mark complex bitops.h inlines as __always_inline
In-Reply-To: <20090107131846.GF3529@elte.hu>
Message-ID: <Pine.LNX.4.64.0901080119260.30224@blonde.anvils>
References: <200901051236.281008835@firstfloor.org>
 <20090104233640.6A7453E6653@basil.firstfloor.org>
 <Pine.LNX.4.64.0901061847110.29408@blonde.anvils> <20090107131846.GF3529@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2009, Ingo Molnar wrote:
> 
> > Hugh Dickins noticed that released gcc versions building the kernel with 
> > CONFIG_OPTIMIZE_INLINING=y don't inline some of the bitops - sometimes 
> > generating very inefficient pageflag tests, and many instances of 
> > constant_test_bit().
> 
> Could you quantify that please?
> 
> We really dont want to reintroduce __always_inline just for performance / 
> code size reasons. If GCC messes up and makes a larger / more inefficient 
> kernel, GCC will be fixed. CONFIG_OPTIMIZE_INLINING is default-off, so 
> enable it only if it improves your kernel.

I'm happy with the config option defaulting off, but the Kconfig help
text seems too optimistic, and I doubt defconfigs should say Y yet.

http://lkml.org/lkml/2008/11/14/203 CONFIG_OPTIMIZE_INLINING fun
was my original mail to you on this: somewhat rambling, but worth
looking at just for the laughable 4.2.1 Page disassemblies.

Quantification: you may have a better idea of what numbers to look
at, but here are some.

I've tried "make defconfig" on 2.6.28 x86_32 kernel trees, building
first with the openSUSE 10.3 version of gcc 4.2.1, then the openSUSE
11.1 version of gcc 4.3.2 (Fedora 10 and Ubuntu 8.10 versions gave
similar results, though I didn't go very far with those), then the
latest gcc 4.4 snapshot.  I was building x86_64 a few weeks ago,
and that gave similar results.

I've built five configs: vmlinux.nn is the defconfig, except for
CONFIG_CC_OPTIMIZE_FOR_SIZE and CONFIG_OPTIMIZE_INLINING both off;
vmlinux.yn has SIZE=y, vmlinux.ny has INLINING=y, vmlinux.yy is the
actual defconfig with both y, vmlinux.yya is that with Andi's bitops
patch applied.

For background I'm showing "size" output, and the number of lines in
System.map (supposing that to give some idea of how much inlining).

Then how many "Page" lines appear in System.map: ideally none, a
few are okay, but lots mean it's being stupid about PageLocked etc -
4.2.1 SIZE=y INLINING=y is afflicted by that, the rest are okay.

Then how many "constant_test_bit"s (each sized 27 bytes): clearly
Andi's patch eliminates those.  Contrary to expectations, 4.4 does
little better than 4.3.2 with them; and though 4.2.1's yy case is
worst, its ny case is actually much better than with 4.3 and 4.4
(or maybe there's a different interpretation than numbers suggest).

I think these numbers show that that even gcc 4.4 is not yet ready
for CONFIG_OPTIMIZE_INLINING=y, but that Andi's patch helps in one
important area.  grep for something else and maybe a different story.

gcc version 4.2.1 (SUSE Linux):

   text	   data	    bss	    dec	    hex	filename
6847905	1151180	 622592	8621677	 838e6d	vmlinux.nn
45069	wc -l <System.map.nn
0	grep -c Page System.map.nn
0	grep -c constant_test_bit System.map.nn

   text	   data	    bss	    dec	    hex	filename
6848053	1151180	 622592	8621825	 838f01	vmlinux.ny
45130	wc -l <System.map.ny
0	grep -c Page System.map.ny
5	grep -c constant_test_bit System.map.ny

   text	   data	    bss	    dec	    hex	filename
5921243	1124336	 618496	7664075	 74f1cb	vmlinux.yn
44949	wc -l <System.map.yn
0	grep -c Page System.map.yn
0	grep -c constant_test_bit System.map.yn

   text	   data	    bss	    dec	    hex	filename
5906470	1124336	 618496	7649302	 74b816	vmlinux.yy
49223	wc -l <System.map.yy
98	grep -c Page System.map.yy
228	grep -c constant_test_bit System.map.yy

   text	   data	    bss	    dec	    hex	filename
5877907	1124336	 618496	7620739	 744883	vmlinux.yya
48786	wc -l <System.map.yya
98	grep -c Page System.map.yya
0	grep -c constant_test_bit System.map.yya

gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux):

   text	   data	    bss	    dec	    hex	filename
7017366	1151180	 622592	8791138	 862462	vmlinux.nn
43755	wc -l <System.map.nn
0	grep -c Page System.map.nn
0	grep -c constant_test_bit System.map.nn

   text	   data	    bss	    dec	    hex	filename
7014542	1151180	 622592	8788314	 86195a	vmlinux.ny
44165	wc -l <System.map.ny
2	grep -c Page System.map.ny
79	grep -c constant_test_bit System.map.ny

   text	   data	    bss	    dec	    hex	filename
5965795	1124336	 618496	7708627	 759fd3	vmlinux.yn
43790	wc -l <System.map.yn
0	grep -c Page System.map.yn
0	grep -c constant_test_bit System.map.yn

   text	   data	    bss	    dec	    hex	filename
5917632	1124336	 618496	7660464	 74e3b0	vmlinux.yy
44816	wc -l <System.map.yy
4	grep -c Page System.map.yy
151	grep -c constant_test_bit System.map.yy

   text	   data	    bss	    dec	    hex	filename
5898313	1124336	 618496	7641145	 749839	vmlinux.yya
44602	wc -l <System.map.yya
0	grep -c Page System.map.yya
0	grep -c constant_test_bit System.map.yya

gcc version 4.4.0 20090102 (experimental) (GCC)

   text	   data	    bss	    dec	    hex	filename
6960329	1151180	 622592	8734101	 854595	vmlinux.nn
44121	wc -l <System.map.nn
0	grep -c Page System.map.nn
0	grep -c constant_test_bit System.map.nn

   text	   data	    bss	    dec	    hex	filename
6952421	1151180	 622592	8726193	 8526b1	vmlinux.ny
44564	wc -l <System.map.ny
1	grep -c Page System.map.ny
60	grep -c constant_test_bit System.map.ny

   text	   data	    bss	    dec	    hex	filename
5897459	1124336	 618496	7640291	 7494e3	vmlinux.yn
44149	wc -l <System.map.yn
0	grep -c Page System.map.yn
0	grep -c constant_test_bit System.map.yn

   text	   data	    bss	    dec	    hex	filename
5843498	1124336	 618496	7586330	 73c21a	vmlinux.yy
45655	wc -l <System.map.yy
4	grep -c Page System.map.yy
148	grep -c constant_test_bit System.map.yy

   text	   data	    bss	    dec	    hex	filename
5816020	1124336	 618496	7558852	 7356c4	vmlinux.yya
45452	wc -l <System.map.yya
0	grep -c Page System.map.yya
0	grep -c constant_test_bit System.map.yya

Hugh
