Return-Path: <linux-kernel-owner+w=401wt.eu-S1756276AbZIQP0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276AbZIQP0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 11:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754495AbZIQP0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 11:26:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753668AbZIQP0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 11:26:53 -0400
Subject: Re: BUG avc_node: Objects remaining on kmem_cache_close()
From: Eric Paris <eparis@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: James Morris <jmorris@namei.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090917151946.GA5714@elte.hu>
References: <20090914162613.9016.79225.stgit@warthog.procyon.org.uk>
	 <alpine.LRH.2.00.0909151008440.11936@tundra.namei.org>
	 <20090916130224.GA27519@elte.hu>
	 <1253108314.5213.109.camel@dhcp231-106.rdu.redhat.com>
	 <20090916143416.GA16108@elte.hu>  <20090917151946.GA5714@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Sep 2009 11:26:09 -0400
Message-Id: <1253201169.5213.215.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-17 at 17:19 +0200, Ingo Molnar wrote:
> here's a new failure mode i havent seen before (possibly a variation of 
> the others):
> 
> [   20.036058] Freeing unused kernel memory: 1332k freed
> [   20.316099] SELinux:  Disabled at runtime.
> [   20.320059] =============================================================================
> [   20.324029] BUG avc_node: Objects remaining on kmem_cache_close()
> [   20.324029] -----------------------------------------------------------------------------
> [   20.324029] 
> [   20.324029] INFO: Slab 0xffffea0000de4230 objects=30 used=9 fp=0xffff88003f80a4c8 flags=0x4000000000000082
> [   20.324029] Pid: 1, comm: init Not tainted 2.6.31-tip-06326-g7ed9b83-dirty #14930
> [   20.324029] Call Trace:
> [   20.324029]  [<ffffffff810de4ba>] slab_err+0xb0/0xd2
> [   20.324029]  [<ffffffff810dfa58>] list_slab_objects+0xa8/0x14e
> [   20.324029]  [<ffffffff810e2d48>] kmem_cache_destroy+0x108/0x1d8
> [   20.324029]  [<ffffffff813c3e44>] avc_disable+0x37/0x4d
> [   20.324029]  [<ffffffff813ccf39>] selinux_disable+0x53/0xb5
> [   20.324029]  [<ffffffff813cd692>] sel_write_disable+0xa2/0x110
> [   20.324029]  [<ffffffff810e68c7>] vfs_write+0xc2/0x132
> [   20.324029]  [<ffffffff810e6a37>] sys_write+0x5b/0x98
> [   20.324029]  [<ffffffff810120af>] system_call_fastpath+0x16/0x1b
> [   20.324029] INFO: Object 0xffff88003f80a000 @offset=0
> [   20.324029] INFO: Allocated in avc_alloc_node+0x36/0x195 age=5072 cpu=0 pid=0
> [   20.324029] INFO: Object 0xffff88003f80a088 @offset=136
> [   20.324029] INFO: Allocated in avc_alloc_node+0x36/0x195 age=5055 cpu=0 pid=0
> [   20.324029] INFO: Object 0xffff88003f80a110 @offset=272
> [   20.324029] INFO: Allocated in avc_alloc_node+0x36/0x195 age=4981 cpu=0 pid=6
> [   20.324029] INFO: Object 0xffff88003f80a198 @offset=408
> [   20.324029] INFO: Allocated in avc_alloc_node+0x36/0x195 age=4229 cpu=0 pid=1
> [   20.324029] INFO: Object 0xffff88003f80a220 @offset=544
> [   20.324029] INFO: Allocated in avc_alloc_node+0x36/0x195 age=4215 cpu=0 pid=1
> [   20.324029] INFO: Object 0xffff88003f80a2a8 @offset=680
> [   20.324029] INFO: Allocated in avc_alloc_node+0x36/0x195 age=4215 cpu=0 pid=1
> [   20.324029] INFO: Object 0xffff88003f80a330 @offset=816
> [   20.324029] INFO: Allocated in avc_alloc_node+0x36/0x195 age=89 cpu=0 pid=1
> [   20.324029] INFO: Object 0xffff88003f80a3b8 @offset=952
> [   20.324029] INFO: Allocated in avc_alloc_node+0x36/0x195 age=57 cpu=0 pid=1
> [   20.324029] INFO: Object 0xffff88003f80a440 @offset=1088
> [   20.324029] INFO: Allocated in avc_alloc_node+0x36/0x195 age=48 cpu=0 pid=1
> [   20.324031] SLUB avc_node: kmem_cache_destroy called for cache that still has objects.
> [   20.328031] Pid: 1, comm: init Not tainted 2.6.31-tip-06326-g7ed9b83-dirty #14930
> [   20.332031] Call Trace:
> [   20.334489]  [<ffffffff810e2db7>] kmem_cache_destroy+0x177/0x1d8
> [   20.336032]  [<ffffffff813c3e44>] avc_disable+0x37/0x4d
> [   20.340033]  [<ffffffff813ccf39>] selinux_disable+0x53/0xb5
> [   20.344032]  [<ffffffff813cd692>] sel_write_disable+0xa2/0x110
> [   20.348032]  [<ffffffff810e68c7>] vfs_write+0xc2/0x132
> [   20.352032]  [<ffffffff810e6a37>] sys_write+0x5b/0x98
> [   20.356033]  [<ffffffff810120af>] system_call_fastpath+0x16/0x1b
> [   20.368209] SELinux:  Unregistering netfilter hooks
> [   20.372051] type=1404 audit(1253208317.372:2): selinux=0 auid=4294967295 ses=4294967295

Same thing as your last report.  I have a fix, but I can't seem to test
it because of the bug report I sent you last night.  Chicken?  Egg?
(you can work around with selinux=0)

-Eric

