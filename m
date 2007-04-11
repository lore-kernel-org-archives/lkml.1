Return-Path: <linux-kernel-owner+w=401wt.eu-S1750951AbXDKH2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750951AbXDKH2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 03:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbXDKH2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 03:28:40 -0400
Received: from mx1.lost-oasis.net ([212.85.153.8]:56012 "EHLO
	mx1.lost-oasis.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbXDKH2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 03:28:38 -0400
X-Greylist: delayed 3209 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Apr 2007 03:28:38 EDT
To: davem@davemloft.net (David Miller)
Cc: drraid@gmail.com, linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: Kernel 2.6.20.4 Unaligned address
References: <1f8291090704101602q41e30a7doe79f3606643b628b@mail.gmail.com>
	<20070410.160607.58453654.davem@davemloft.net>
X-Face: %JOeya=Dg!}[/#Go&*&cQ+)){p1c8}u\Fg2Q3&)kothIq|JnWoVzJtCFo~4X<uJ\9cHK'.w 3:{EoxBR
From: Mathieu Chouquet-Stringer <ml2news@free.fr>
Organization: Uh?
Date: 11 Apr 2007 08:35:05 +0200
In-Reply-To: <20070410.160607.58453654.davem@davemloft.net>
Message-ID: <m3fy77xvty.fsf@bigip.bigip.mine.nu>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

        Hello,

davem@davemloft.net (David Miller) writes:
> Please report sparc platform bugs to sparclinux@vger.kernel.org next
> time, thank you.
> 
> Meanwhile I'll take a look at this one.

I have a similar problem on an U5 [*] running 2.6.21-rc6-gbbef6181 :

Kernel unaligned access at TPC[6c9950] svc_udp_recvfrom+0x21c/0x3f0
Kernel unaligned access at TPC[6c9950] svc_udp_recvfrom+0x21c/0x3f0
Kernel unaligned access at TPC[6c9950] svc_udp_recvfrom+0x21c/0x3f0
Kernel unaligned access at TPC[6c9950] svc_udp_recvfrom+0x21c/0x3f0
Kernel unaligned access at TPC[6c9950] svc_udp_recvfrom+0x21c/0x3f0


Disassembling vmlinux gives me that:
0x006c993c <svc_udp_recvfrom+512>:      call  0x5999c8 <clear_bit>
0x006c9940 <svc_udp_recvfrom+516>:      clr  %o0
0x006c9944 <svc_udp_recvfrom+520>:      call  0x6c7d4c <svc_sock_enqueue>
0x006c9948 <svc_udp_recvfrom+524>:      mov  %l3, %o0
0x006c994c <svc_udp_recvfrom+528>:      ld  [ %l1 + 0x88 ], %g2
0x006c9950 <svc_udp_recvfrom+532>:      ldx  [ %l5 + 8 ], %g3
0x006c9954 <svc_udp_recvfrom+536>:      mov  0x11, %g1
0x006c9958 <svc_udp_recvfrom+540>:      add  %g2, -8, %i0
0x006c995c <svc_udp_recvfrom+544>:      st  %g1, [ %l4 + 0xdc8 ]
0x006c9960 <svc_udp_recvfrom+548>:      cmp  %g3, 8
0x006c9964 <svc_udp_recvfrom+552>:      be,pn   %xcc, 0x6c999c<svc_udp_recvfrom+608>


The same stuff but using objdump this time:
                        21c4: R_SPARC_WDISP30   clear_bit
    21c8:       90 10 20 00     clr  %o0
    21cc:       7f ff f9 02     call  5d4 <svc_sock_enqueue>
    21d0:       90 10 00 13     mov  %l3, %o0
    21d4:       c4 04 60 88     ld  [ %l1 + 0x88 ], %g2
    21d8:       c6 5d 60 08     ldx  [ %l5 + 8 ], %g3
    21dc:       82 10 20 11     mov  0x11, %g1
    21e0:       b0 00 bf f8     add  %g2, -8, %i0
    21e4:       c2 25 2d c8     st  %g1, [ %l4 + 0xdc8 ]
    21e8:       80 a0 e0 08     cmp  %g3, 8
    21ec:       02 60 00 0e     be,pn   %xcc, 2224 <svc_udp_recvfrom+0x260>
    21f0:       f0 25 21 24     st  %i0, [ %l4 + 0x124 ]
    21f4:       40 00 00 00     call  21f4 <svc_udp_recvfrom+0x230>
                        21f4: R_SPARC_WDISP30   net_ratelimit

Looking at svc_udp_recvfrom, it all comes down to this portion of code (I
believe, unless I got it wrong):

        /*
         * Maybe more packets - kick another thread ASAP.
         */
        svc_sock_received(svsk);

        len  = skb->len - sizeof(struct udphdr);
        rqstp->rq_arg.len = len;    <=====================================

        rqstp->rq_prot = IPPROTO_UDP;

        if (cmh->cmsg_level != IPPROTO_IP ||
            cmh->cmsg_type != IP_PKTINFO) {
                if (net_ratelimit())
                        printk("rpcsvc: received unknown control message:"
                               "%d/%d\n",
                               cmh->cmsg_level, cmh->cmsg_type);
                skb_free_datagram(svsk->sk_sk, skb);
                return 0;
        }

I won't have access to this box for quite some time: I'm just unsure when I
will be able to test again any kind of patches...

I hope I've forwarded enough information though.

Cheers,
Mathieu



[*] : 
cpu             : TI UltraSparc IIi (Sabre)
fpu             : UltraSparc IIi integrated FPU
prom            : OBP 3.31.0 2001/07/25 20:36
type            : sun4u
ncpus probed    : 1
ncpus active    : 1
D$ parity tl1   : 0
I$ parity tl1   : 0
Cpu0Bogo        : 720.40
Cpu0ClkTck      : 0000000015752a00
MMU Type        : Spitfire

Kernel got compiled with:
Using built-in specs.
Target: sparc-linux-gnu
Configured with: ../src/configure -v
--enable-languages=c,c++,fortran,objc,obj-c++,treelang --prefix=/usr
--enable-shared --with-system-zlib --libexecdir=/usr/lib
--without-included-gettext --enable-threads=posix --enable-nls
--program-suffix=-4.1 --enable-__cxa_atexit --enable-clocale=gnu
--enable-libstdcxx-debug --enable-mpfr --with-cpu=v8
--enable-checking=release sparc-linux-gnu
Thread model: posix
gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)


-- 
Mathieu Chouquet-Stringer
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
