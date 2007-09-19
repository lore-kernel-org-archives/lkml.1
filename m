Return-Path: <linux-kernel-owner+w=401wt.eu-S1760979AbXISSW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760979AbXISSW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 14:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbXISSWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 14:22:18 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:45080 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752092AbXISSWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 14:22:17 -0400
Date: Wed, 19 Sep 2007 14:22:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@muc.de>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 4/7] Immediate Values - i386 Optimization
Message-ID: <20070919182214.GB7428@Krystal>
References: <20070918210747.828804366@polymtl.ca> <20070918210853.588573678@polymtl.ca> <46F04856.3010808@goop.org> <46F04D53.6040903@zytor.com> <46F050E8.5020206@goop.org> <20070919130122.GA21750@Krystal> <46F14A58.60904@zytor.com> <46F15CB8.6010408@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <46F15CB8.6010408@goop.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:13:23 up 51 days, 18:32,  3 users,  load average: 0.41, 0.80, 1.20
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> H. Peter Anvin wrote:
> > Mathieu Desnoyers wrote:
> >   
> >> Ok, let's have a good look at what we want:
> >>
> >> 1 - get a pointer to the beginning of the immediate value within the
> >>     instruction.
> >> 2 - make sure that the immediate value, within the instruction, is
> >>     written to atomically wrt all CPUs, even on older architectures
> >>     where non aligned writes are not atomic.
> >>
> >>     
> >
> > I think you'll find that even on modern architectures cross-cacheline
> > writes aren't atomic.
> >   
> 
> Cross-cache-line, sure.  But what about just not sizeof aligned?  If its
> enough to avoid cross-cache-line, then that's simpler.
> 

Being sizeof aligned on a cache-line (e.g. 32 bytes boundaries) is a
superset of being aligned on sizeof multiples (e.g. 4 bytes). Therefore,
if we declare data of a certain size not aligned on the sizeof
boundaries, we won't be aligned on cache-lines neither. (unless I am
utterly wrong..) :)

> Which is something I was going to comment on: Mathieu, you try to align
> the constant itself, but you don't prevent the instruction overall from
> crossing a cache line.  Given how delicate all this stuff is, it seems
> like a good idea to do that.
> 

We just can't, for movl is 5 bytes in total : 1 byte for opcode, 4
bytes for the immediate value. But since we do not modify the opcode at
all, CPUs will either see the old or new immediate value (each of those
will be coherent because of the atomic update) and, in every case, they
will use it with the same opcode that haven't been touched.

> 
> >> * 4 bytes
> >> B8 + rd         MOV r32, imm32   (1 byte opcode)
> >> C7 /0           MOV r/m32, imm32 (2 bytes opcode)
> >> (the 2 bytes opcode can be a problem)
> >>
> >>     
> >
> > If gas generates the C7 opcodes by default, then that's a bug, nothing less.
> >   
> 
> Well, in this case, it might be preferred if it brings the constant into
> alignment without explicit padding :)
> 

It will need explicit padding too. We would have to align the 4 bytes
immediate value on 4 bytes multiples. Therefore, this 2 bytes opcode
followed by 4 bytes immediate value would have to be aligned on
(4 bytes - 2) boundaries.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
