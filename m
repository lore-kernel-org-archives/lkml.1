Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbYCAD44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbYCAD44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 22:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbYCAD4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 22:56:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62237 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbYCAD4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 22:56:48 -0500
Date: Fri, 29 Feb 2008 22:56:45 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: paulus@samba.org, linuxppc-dev@ozlabs.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add strncmp to PowerPC
In-Reply-To: <1204340690.15052.457.camel@pasglop>
Message-ID: <Pine.LNX.4.58.0802292250490.21555@gandalf.stny.rr.com>
References: <1204301097.14759.6.camel@localhost.localdomain>
 <1204340690.15052.457.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 1 Mar 2008, Benjamin Herrenschmidt wrote:
>
> Do we have any indication that it performs better than the C one ?

See below.

>
> Ben.
>

> >
> > +_GLOBAL(strncmp)
> > +	mtctr	r5
> > +	addi	r5,r3,-1
> > +	addi	r4,r4,-1
> > +1:	lbzu	r3,1(r5)
> > +	cmpwi	1,r3,0
> > +	lbzu	r0,1(r4)
> > +	subf.	r3,r0,r3
> > +	beqlr	1
> > +	bdnzt	eq,1b
> > +	blr
> > +


And here's the objdump of the C version:

0000000000000080 <.strncmp>:
  80:   fb e1 ff f0     std     r31,-16(r1)
  84:   f8 21 ff c1     stdu    r1,-64(r1)
  88:   7c 69 1b 78     mr      r9,r3
  8c:   7c a0 2b 79     mr.     r0,r5
  90:   38 60 00 00     li      r3,0
  94:   7c 09 03 a6     mtctr   r0
  98:   7c 3f 0b 78     mr      r31,r1
  9c:   41 82 00 68     beq-    104 <.strncmp+0x84>
  a0:   89 69 00 00     lbz     r11,0(r9)
  a4:   88 04 00 00     lbz     r0,0(r4)
  a8:   7c 00 58 50     subf    r0,r0,r11
  ac:   78 00 06 20     clrldi  r0,r0,56
  b0:   2f a0 00 00     cmpdi   cr7,r0,0
  b4:   7c 00 07 74     extsb   r0,r0
  b8:   7c 03 03 78     mr      r3,r0
  bc:   40 9e 00 48     bne-    cr7,104 <.strncmp+0x84>
  c0:   2f ab 00 00     cmpdi   cr7,r11,0
  c4:   41 9e 00 40     beq-    cr7,104 <.strncmp+0x84>
  c8:   38 84 00 01     addi    r4,r4,1
  cc:   38 69 00 01     addi    r3,r9,1
  d0:   42 40 00 30     bdz-    100 <.strncmp+0x80>
  d4:   88 03 00 00     lbz     r0,0(r3)
  d8:   89 24 00 00     lbz     r9,0(r4)
  dc:   38 63 00 01     addi    r3,r3,1
  e0:   38 84 00 01     addi    r4,r4,1
  e4:   2f 20 00 00     cmpdi   cr6,r0,0
  e8:   7c 09 00 50     subf    r0,r9,r0
  ec:   78 00 06 20     clrldi  r0,r0,56
  f0:   2f a0 00 00     cmpdi   cr7,r0,0
  f4:   7c 00 07 74     extsb   r0,r0
  f8:   40 9e 00 08     bne-    cr7,100 <.strncmp+0x80>
  fc:   40 9a ff d4     bne+    cr6,d0 <.strncmp+0x50>
 100:   7c 03 03 78     mr      r3,r0
 104:   e8 21 00 00     ld      r1,0(r1)
 108:   eb e1 ff f0     ld      r31,-16(r1)
 10c:   4e 80 00 20     blr


I'll let you decide ;-)

Even if it was logically faster (which I still doubt) it's a hell of a lot
of cache lines to waste.

-- Steve

