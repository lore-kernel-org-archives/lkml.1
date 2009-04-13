Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873AbZDMU34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbZDMU34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 16:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbZDMU3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 16:29:46 -0400
Received: from are.twiddle.net ([75.149.56.221]:53255 "EHLO are.twiddle.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151AbZDMU3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 16:29:45 -0400
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Apr 2009 16:29:45 EDT
Message-ID: <49E39F3D.4060501@twiddle.net>
Date: Mon, 13 Apr 2009 13:23:25 -0700
From: Richard Henderson <rth@twiddle.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Matt Turner <mattst88@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Jay Estabrook <jay.estabrook@hp.com>,
       Oliver Falk <oliver@linux-kernel.at>, linuxppc-dev@ozlabs.org
Subject: Re: alpha: half done futex implementation
References: <b4198de60904111755u5c2078c7xcc689dbd78aeb957@mail.gmail.com>
In-Reply-To: <b4198de60904111755u5c2078c7xcc689dbd78aeb957@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Turner wrote:
> Hi,
> 
> Going on Richard's advice, I've tried to write an alpha futex
> implementation based on the powerpc futex.h.
> 
> I've gotten this far.. :\
> 

#define __futex_atomic_op(insn, ret, oldval, uaddr, oparg) \
      __asm__ __volatile(             \
      __ASM_MB                        \
      "1: ldl_l   %0,0(%3)\n"         \
          insn                        \
      "2: stl_c   %1,0(%3)\n"         \
      "   beq     %1,4f\n"            \
      "   mov     $31,%1\n"           \
      "3: .subsection 2\n"            \
      "4: br      1b\n"               \
      "   .previous\n"                \
      ".section __ex_table,\"a\"\n"   \
      "   .long   1b-.\n"             \
      "   lda     %0,3b-1b(%2)\n"     \
      "   .long   2b-.\n"             \
      "   lda     %0,3b-2b(%2)\n"     \
      "   .previous\n"                \
      : "=&r" (oldval), "=&r"(ret)    \
      : "r" (uaddr), "r"(oparg)       \
      : "memory")

   switch (op) {
     case FUTEX_OP_SET:
       __futex_atomic_op("mov %0,%1", ret, oldval, uaddr, oparg);
       break;
     case FUTEX_OP_ADD:
       __futex_atomic_op("addl %0,%4,%1\n", ret, oldval, uaddr, oparg);
       break;
     case FUTEX_OP_OR:
       __futex_atomic_op("or %0,%4,%1\n", ret, oldval, uaddr, oparg);
       break;
     case FUTEX_OP_ANDN:
       __futex_atomic_op("andnot %0,%4,%1\n", ret, oldval, uaddr, oparg);
       break;
     case FUTEX_OP_XOR:
       __futex_atomic_op("xor %0,%4,%1\n", ret, oldval, uaddr, oparg);
       break;
     default:
       ret = -ENOSYS;
   }


Also, there's a bug in the powerpc implementation.  It appears that 
oparg is clobbered, and if stwcx fails the operation will be repeated 
with incorrect inputs.


r~



