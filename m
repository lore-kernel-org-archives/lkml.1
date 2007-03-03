Return-Path: <linux-kernel-owner+w=401wt.eu-S1750880AbXCCHs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750880AbXCCHs1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 02:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750935AbXCCHs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 02:48:26 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:39378 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbXCCHs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 02:48:26 -0500
Message-ID: <45E92837.3030807@cosmosbay.com>
Date: Sat, 03 Mar 2007 08:48:07 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: David Lang <dlang@digitalinsight.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: dynamic linking files slow fork down significantly
References: <Pine.LNX.4.63.0703021647070.24792@qynat.qvtvafvgr.pbz>
In-Reply-To: <Pine.LNX.4.63.0703021647070.24792@qynat.qvtvafvgr.pbz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sat, 03 Mar 2007 08:48:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Lang a écrit :
> I have a fork-heavy workload (a proxy that forks per connection, I know 
> it's not the most efficiant design) and I discovered a 2x performance 
> difference between a static and dynamicly linked version of the same 
> program (2200 connections/sec vs 4700 connections/sec)
> 
> I know that there is overhead on program startup, but didn't expect to 
> find it on a fork with no exec. If I has been asked I would have guessed 
> that the static version would have been slower due to the need to mark 
> more memory as COW.
> 
> what is it that costs so much with dynamic libraries on a fork/clone?
> 

man ld.so

        LD_BIND_NOW
               If set to non-empty string, causes the dynamic linker to resolve
               all symbols at program startup  instead  of  deferring  function
               call resolval to the point when they are first referenced.


If you do :
export LD_BIND_NOW=1
before starting your dynamicaly linked version, do you get different numbers ?

If some symbols are resolved dynamically after your forks(), the dynamic 
linker has to dirty some parts of memory and each child gets its own copy of 
modified pages. The cpu cost is not factorized, and memory needs are larger, 
so cpu caches are less efficient.

With LD_BIND_NOW=1, the initial exec of your programm will be a litle bit 
longer, but in the end you win.

You may see effect of immediate binding with ldd command :
Its -r option asks to do the full binding :

# time ldd ./groff
         libstdc++.so.5 => /usr/lib/libstdc++.so.5 (0xf7ea0000)
         libm.so.6 => /lib/tls/libm.so.6 (0xf7e7e000)
         libgcc_s.so.1 => /lib/libgcc_s.so.1 (0xf7e73000)
         libc.so.6 => /lib/tls/libc.so.6 (0x42000000)
         /lib/ld-linux.so.2 => /lib/ld-linux.so.2 (0xf7f5d000)
0.00user 0.00system 0:00.00elapsed 80%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+696minor)pagefaults 0swaps

# time ldd -r ./groff
         libstdc++.so.5 => /usr/lib/libstdc++.so.5 (0xf7e8f000)
         libm.so.6 => /lib/tls/libm.so.6 (0xf7e6d000)
         libgcc_s.so.1 => /lib/libgcc_s.so.1 (0xf7e62000)
         libc.so.6 => /lib/tls/libc.so.6 (0x42000000)
         /lib/ld-linux.so.2 => /lib/ld-linux.so.2 (0xf7f4c000)
0.00user 0.00system 0:00.00elapsed 50%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+777minor)pagefaults 0swaps

You can see 777 pagefaults instead of 696 on this example.

