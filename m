Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbXE3M6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbXE3M6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 08:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbXE3M6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 08:58:13 -0400
Received: from 1wt.eu ([62.212.114.60]:2783 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbXE3M6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 08:58:12 -0400
Date: Wed, 30 May 2007 14:58:03 +0200
From: Willy Tarreau <w@1wt.eu>
To: David Schwartz <davids@webmaster.com>
Cc: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: epoll,threading
Message-ID: <20070530125803.GB19105@1wt.eu>
References: <20070530072528.GP943@1wt.eu> <MDEHLPKNGKAHNMBLJOLKCEPKECAC.davids@webmaster.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKCEPKECAC.davids@webmaster.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 01:07:08AM -0700, David Schwartz wrote:
> 
> > In my experience, it's not much the context switch by itself which causes
> > performance degradation, but the fact that with threads, you have to put
> > mutexes everywhere. And frankly, walking a list with locks everywhere
> > is quite slower than doing it in one run at a rate of 3 or 4 cycles per
> > entry. Also, local storage in function returns is not possible anymore,
> > and some functions even need to malloc() instead of returning statically
> > allocated data. I believe this is the reason for openssl being twice as
> > slow when compiled thread-safe than in native mode.
> 
> I don't know where you got this idea from, but several experiments of mine
> failed to confirm it. Here, for example, are two identical builds of
> OpenSSL, one with 'threads' and one with 'no-threads'. Same compiler, same
> other flags, same hardware (Linux 2.6.21.2, P3-1Ghz):

I can see that your numbers are equal in both cases. You have openssl 0.9.8d,
and doing functions benchmarks. I observed this on openssl 0.9.6 + apache 1.3
+ mod_ssl. The difference in terms of hits/s was 1 to 2, just with -DREENTRANT.

Most probably some water has flowed under the bridges since... Anyway, that
makes 0.9.8 interesting to look at ;-)

Willy

> 
> OpenSSL 0.9.8d 28 Sep 2006
> built on: Wed May 30 00:55:25 PDT 2007
> options:bn(64,32) md2(int) rc4(idx,int) des(ptr,risc1,16,long) aes(partial)
> idea(int) blowfish(idx)
> compiler:
> gcc -DDSO_DLFCN -DHAVE_DLFCN_H -mcpu=pentium -DL_ENDIAN -DTERMIO -O3 -fomit-
> frame-pointer -Wall -DOPENSSL_BN_ASM_PART_WORDS -DOPENSSL_IA32_SSE2 -DSHA1_A
> SM -DMD5_ASM -DRMD160_ASM -DAES_ASM
> available timing options: TIMES TIMEB HZ=100 [sysconf value]
> timing function used: times
> The 'numbers' are in 1000s of bytes per second processed.
> type             16 bytes     64 bytes    256 bytes   1024 bytes   8192
> bytes
> md5               5295.13k    18837.99k    56614.66k   113037.65k
> 157575.85k
> des cbc          21280.46k    22224.36k    22536.87k    22626.65k
> 22686.38k
>                   sign    verify    sign/s verify/s
> rsa 1024 bits 0.007653s 0.000381s    130.7   2626.1
> 
> OpenSSL 0.9.8d 28 Sep 2006
> built on: Wed May 30 00:55:23 PDT 2007
> options:bn(64,32) md2(int) rc4(idx,int) des(ptr,risc1,16,long) aes(partial)
> idea(int) blowfish(idx)
> compiler:
> gcc -DOPENSSL_THREADS -D_REENTRANT -DDSO_DLFCN -DHAVE_DLFCN_H -mcpu=pentium 
> -DL_ENDIAN -DTERMIO -O3 -fomit-frame-pointer -Wall -DOPENSSL_BN_ASM_PART_WOR
> DS -DOPENSSL_IA32_SSE2 -DSHA1_ASM -DMD5_ASM -DRMD160_ASM -DAES_ASM
> available timing options: TIMES TIMEB HZ=100 [sysconf value]
> timing function used: times
> The 'numbers' are in 1000s of bytes per second processed.
> type             16 bytes     64 bytes    256 bytes   1024 bytes   8192
> bytes
> md5               5355.29k    18880.64k    56515.93k   113145.51k
> 157908.99k
> des cbc          21361.71k    22185.28k    22494.72k    22654.29k
> 22659.07k
>                   sign    verify    sign/s verify/s
> rsa 1024 bits 0.007612s 0.000380s    131.4   2629.5
> 
> 	DS
> 
