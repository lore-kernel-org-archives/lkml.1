Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbXKUNQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbXKUNQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 08:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750728AbXKUNQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 08:16:39 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:21322 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbXKUNQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 08:16:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=ur4d4XJcohnSlfajKZUqpRqeQryfNx3A7osoLWaIWXZDrHt9MU3P8h0iU8xRdlJzBu5jXi+4d14kW7I2nDAmoTLWPHRZaESSYSa7iQN5m6o920zsUe+PSMPOun6VlhfYSZolDNvBGWAOvOClJbA0ASVpOImmh7cCSlCUrlLZFJw=
Message-ID: <47442FA9.6020600@gmail.com>
Date: Wed, 21 Nov 2007 18:16:25 +0500
From: "Alexander E. Patrakov" <patrakov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ru-RU; rv:1.8.0.13pre) Gecko/20070505 Iceape/1.0.9 (Debian-1.0.11~pre071022-0etch1+lenny1) Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Nix <nix@esperi.org.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>, Herbert Xu <herbert@gondor.apana.org.au>,
       David Miller <davem@davemloft.net>, xiyou.wangcong@gmail.com,
       goodmenkernel@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Is there any word about this bug in gcc ?
References: <E1IuMnZ-0003o3-00@gondolin.me.apana.org.au>	<4742831F.9040408@zytor.com> <877ikc1v3a.fsf@hades.wkstn.nix>
In-Reply-To: <877ikc1v3a.fsf@hades.wkstn.nix>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nix wrote:

> I've grepped all the source on my system (1148 expanded upstream source
> tarballs or git/cvs/svn trees including the Linux kernel, most of GNOME,
> and all of KDE and X.org) and found that hits are extremely rare: not as
> rare as calls to seekdir() and telldir() :) but rare. (Quite a lot of
> things multiply by negative constants *inside* a call to abs(), but this
> should be unaffected.)

I implemented a different approach: patched gcc with the official fix plus a 
call to emit a warning (see below), and recompiled the whole LFS LiveCD (see the 
list of packages at 
http://wiki.linuxfromscratch.org/livecd/browser/trunk/packages). Only libtheora 
emitted a warning.

> Certain hits:
> 
> ./nethack/3.4.3/src/cmd.c:        else if(x < -2*abs(y))
> ./nethack/3.4.3/src/cmd.c:        else if(y < -2*abs(x))

Sure, this is a hit, but nethack is not on my LiveCD.

> Possible hits (I'm not sure what the folder would do with this: the
> extra level of brackets in the way might affect things but I don't think
> so):
> 
> ./libtheora/libtheora/lib/enc/pp.c:      TmpMod = 32 + QValue - 2*(abs(Src[j+Pitch]-Src[j]));
> ./libtheora/libtheora/lib/enc/pp.c:      TmpMod = 32 + QValue - 2*(abs(Src[j+1]-Src[j]));

This did emit a warning, I have already reported it: 
https://trac.xiph.org/ticket/1260

> ./xmms/modules/projectM-0.94.20/main.c:   wave_x_temp=-2*0.4142*(abs(abs(wave_mystery)-.5)-.5);
> ./xmms/modules/projectM-0.94.20/main.c:   wave_x_temp=-2*0.4142*(abs(abs(wave_mystery)-.5)-.5);

Not a hit, probably due to conversions between int and double.


--- trunk/gcc/fold-const.c	2007/11/17 13:46:53	130257
+++ trunk/gcc/fold-const.c	2007/11/17 14:22:42	130258
@@ -6095,6 +6095,9 @@
              }
            break;
          }
+      /* If the constant is negative, we cannot simplify this.  */
+      if (tree_int_cst_sgn (c) == -1)
+        { warning(0, "Unpatched gcc miscompiles this"); break; }
        /* FALLTHROUGH */
      case NEGATE_EXPR:
        if ((t1 = extract_muldiv (op0, c, code, wide_type, strict_overflow_p))

-- 
Alexander E. Patrakov
