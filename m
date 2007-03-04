Return-Path: <linux-kernel-owner+w=401wt.eu-S1751498AbXCDInJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498AbXCDInJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 03:43:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbXCDInJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 03:43:09 -0500
Received: from warden-p.diginsite.com ([208.29.163.248]:45566 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751498AbXCDInI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 03:43:08 -0500
Date: Sun, 4 Mar 2007 00:22:25 -0800 (PST)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: dynamic linking files slow fork down significantly
In-Reply-To: <45E92837.3030807@cosmosbay.com>
Message-ID: <Pine.LNX.4.63.0703040012070.26326@qynat.qvtvafvgr.pbz>
References: <Pine.LNX.4.63.0703021647070.24792@qynat.qvtvafvgr.pbz>
 <45E92837.3030807@cosmosbay.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2024032638-1172996545=:26326"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2024032638-1172996545=:26326
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Sat, 3 Mar 2007, Eric Dumazet wrote:

> David Lang a écrit :
>> I have a fork-heavy workload (a proxy that forks per connection, I know 
>> it's not the most efficiant design) and I discovered a 2x performance 
>> difference between a static and dynamicly linked version of the same 
>> program (2200 connections/sec vs 4700 connections/sec)
>> 
>> I know that there is overhead on program startup, but didn't expect to find 
>> it on a fork with no exec. If I has been asked I would have guessed that 
>> the static version would have been slower due to the need to mark more 
>> memory as COW.
>> 
>> what is it that costs so much with dynamic libraries on a fork/clone?
>> 
>
> man ld.so
>
>       LD_BIND_NOW
>              If set to non-empty string, causes the dynamic linker to 
> resolve
>              all symbols at program startup  instead  of  deferring 
> function
>              call resolval to the point when they are first referenced.
>
>
> If you do :
> export LD_BIND_NOW=1
> before starting your dynamicaly linked version, do you get different numbers 
> ?

slightly, with LD_BIND_NOW=1 the dynamicly linked version goes up to 3000 
connections/sec, gaining back about half the difference.

> If some symbols are resolved dynamically after your forks(), the dynamic 
> linker has to dirty some parts of memory and each child gets its own copy of 
> modified pages. The cpu cost is not factorized, and memory needs are larger, 
> so cpu caches are less efficient.

thanks, this makes sense.

> With LD_BIND_NOW=1, the initial exec of your programm will be a litle bit 
> longer, but in the end you win.

definantly, any cost that can be moved to startup instead of the per-connection 
handling pays off _very_ quickly

> You may see effect of immediate binding with ldd command :
> Its -r option asks to do the full binding :
>
> # time ldd ./groff
>        libstdc++.so.5 => /usr/lib/libstdc++.so.5 (0xf7ea0000)
>        libm.so.6 => /lib/tls/libm.so.6 (0xf7e7e000)
>        libgcc_s.so.1 => /lib/libgcc_s.so.1 (0xf7e73000)
>        libc.so.6 => /lib/tls/libc.so.6 (0x42000000)
>        /lib/ld-linux.so.2 => /lib/ld-linux.so.2 (0xf7f5d000)
> 0.00user 0.00system 0:00.00elapsed 80%CPU (0avgtext+0avgdata 0maxresident)k
> 0inputs+0outputs (0major+696minor)pagefaults 0swaps
>
> # time ldd -r ./groff
>        libstdc++.so.5 => /usr/lib/libstdc++.so.5 (0xf7e8f000)
>        libm.so.6 => /lib/tls/libm.so.6 (0xf7e6d000)
>        libgcc_s.so.1 => /lib/libgcc_s.so.1 (0xf7e62000)
>        libc.so.6 => /lib/tls/libc.so.6 (0x42000000)
>        /lib/ld-linux.so.2 => /lib/ld-linux.so.2 (0xf7f4c000)
> 0.00user 0.00system 0:00.00elapsed 50%CPU (0avgtext+0avgdata 0maxresident)k
> 0inputs+0outputs (0major+777minor)pagefaults 0swaps
>
> You can see 777 pagefaults instead of 696 on this example.

the version of time on my system (debian 3.1) doesn't give me the cpu or 
pagefault info, just the times. where should I get the version that gives more 
info? (although I don't think I can apply it directly to my troubleshooting as 
the work is all being done in child processes).

David Lang
--8323328-2024032638-1172996545=:26326--
