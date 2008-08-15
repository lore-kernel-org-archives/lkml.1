Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbYHOGsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbYHOGsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 02:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbYHOGsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 02:48:32 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:41081 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbYHOGsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 02:48:32 -0400
Date: Fri, 15 Aug 2008 07:48:52 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: oops in proc_sys_compare
In-Reply-To: <20080815045149.GC28946@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0808150735290.970@blonde.site>
References: <Pine.LNX.4.64.0808141908290.15191@blonde.site>
 <20080815045149.GC28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2008, Al Viro wrote:
> On Thu, Aug 14, 2008 at 07:31:06PM +0100, Hugh Dickins wrote:
> > I got this oops below, after several hours of swap-heavy kernel builds
> > in tmpfs, on 2.6.27-rc1-mm1 a couple of weeks ago.  Tried to reproduce
> > it without success, then got a very similar trace (not saved) from
> > 2.6.27-rc3 itself doing the same test yesterday: again oopsing in
> > proc_sys_compare on address -16, looks like it's trying for
> > PROC_I(dentry->d_inode)->sysctl but d_inode is NULL.
> > 
> > I looked to see what's been going on in fs/proc recently, and your
> > [PATCH] sanitize proc_sysctl 9043476f726802f4b00c96d0c4f418dde48d1304
> > does sound like it might be implicated.  I've only seen this on
> > PowerPC G5, similar tests on x86_32 and _64 haven't shown it:
> > maybe a memory barrier needed somewhere?
>  
> Bloody interesting.  We never create negative hashed dentries in there and
> AFAICS we should never get d_delete() called on those...  Missing barrier
> would mean serious trouble in dcache.c and not just for /proc/sys...
> 
> Are you sure about oops decoding?  At least disassembly of proc_sys_compare()
> in the kernel image in question would be nice to see...

Here it is: I'd changed config meanwhile, so this is from a rebuild,
but symbol addresses fit exactly with the trace (and the 2.6.27-rc1-mm1
fs/proc/proc_sysctl.c is identical to that in 2.6.27-rc3 or current git).
I did try "objdump -Sd" at first, but that just looked more confusing.

c000000000121e7c <.proc_sys_compare>:
proc_sys_compare():
/home/hugh/26271E1/fs/proc/proc_sysctl.c:383
c000000000121e7c:	7c 08 02 a6 	mflr    r0
c000000000121e80:	fb e1 ff f0 	std     r31,-16(r1)
c000000000121e84:	7c a9 2b 78 	mr      r9,r5
c000000000121e88:	7c 9f 23 78 	mr      r31,r4
c000000000121e8c:	f8 01 00 10 	std     r0,16(r1)
c000000000121e90:	f8 21 ff 81 	stdu    r1,-128(r1)
/home/hugh/26271E1/fs/proc/proc_sysctl.c:385
c000000000121e94:	60 00 00 00 	nop
c000000000121e98:	80 a4 00 04 	lwz     r5,4(r4)
c000000000121e9c:	80 09 00 04 	lwz     r0,4(r9)
c000000000121ea0:	7f 80 28 00 	cmpw    cr7,r0,r5
c000000000121ea4:	40 9e 00 3c 	bne-    cr7,c000000000121ee0 <.proc_sys_compare+0x64>
/home/hugh/26271E1/fs/proc/proc_sysctl.c:387
c000000000121ea8:	e8 89 00 08 	ld      r4,8(r9)
c000000000121eac:	e8 7f 00 08 	ld      r3,8(r31)
c000000000121eb0:	4b f0 aa 45 	bl      c00000000002c8f4 <.memcmp>
c000000000121eb4:	60 00 00 00 	nop
c000000000121eb8:	2f a3 00 00 	cmpdi   cr7,r3,0
c000000000121ebc:	40 9e 00 24 	bne-    cr7,c000000000121ee0 <.proc_sys_compare+0x64>
PROC_I():
/home/hugh/26271E1/fs/proc/proc_sysctl.c:384
c000000000121ec0:	e9 3f ff e0 	ld      r9,-32(r31)
c000000000121ec4:	e8 69 ff f0 	ld      r3,-16(r9)
c000000000121ec8:	4b f2 f8 4d 	bl      c000000000051714 <.sysctl_is_seen>
c000000000121ecc:	60 00 00 00 	nop
proc_sys_compare():
/home/hugh/26271E1/fs/proc/proc_sysctl.c:389
c000000000121ed0:	7c 63 00 34 	cntlzw  r3,r3
c000000000121ed4:	54 63 d9 7e 	rlwinm  r3,r3,27,5,31
c000000000121ed8:	78 63 00 20 	clrldi  r3,r3,32
c000000000121edc:	48 00 00 08 	b       c000000000121ee4 <.proc_sys_compare+0x68>
c000000000121ee0:	38 60 00 01 	li      r3,1
/home/hugh/26271E1/fs/proc/proc_sysctl.c:390
c000000000121ee4:	38 21 00 80 	addi    r1,r1,128
c000000000121ee8:	e8 01 00 10 	ld      r0,16(r1)
c000000000121eec:	eb e1 ff f0 	ld      r31,-16(r1)
c000000000121ef0:	7c 08 03 a6 	mtlr    r0
c000000000121ef4:	4e 80 00 20 	blr
