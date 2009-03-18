Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbZCRMpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbZCRMpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 08:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbZCRMpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 08:45:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36047 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbZCRMpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 08:45:25 -0400
Date: Wed, 18 Mar 2009 13:45:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Joerg Roedel <joerg.roedel@amd.com>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] dma-debug: add additional checks
Message-ID: <20090318124509.GA20102@elte.hu>
References: <1237223130-26519-1-git-send-email-joerg.roedel@amd.com> <20090317120112.GP6159@amd.com> <20090318093847.GC5879@elte.hu> <20090318112324.GB32233@elte.hu> <1237376327.5069.253.camel@laptop> <20090318121940.GT6159@amd.com> <1237379290.5069.341.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237379290.5069.341.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2009-03-18 at 13:19 +0100, Joerg Roedel wrote:
> > On Wed, Mar 18, 2009 at 12:38:47PM +0100, Peter Zijlstra wrote:
> > > On Wed, 2009-03-18 at 12:23 +0100, Ingo Molnar wrote:
> > > > another -tip testbox started triggering:
> > > > 
> > > >   BUG: MAX_LOCKDEP_ENTRIES too low!
> > > > 
> > > > it triggers due to CONFIG_DMA_API_DEBUG=y. Config attached.
> > > 
> > > 
> > > I still have this laying about.. could be we're just at the limit due to
> > > lock bloat in the kernel, could be dma_api_debug is doing something
> > > all-together iffy
> > 
> > I had a look and the maximum locking depth in dma-debug code was two.
> > Attached patch reduces this to one.
> > 
> > From d28fc4a308bf66ed98c68e1db18e4e1434206541 Mon Sep 17 00:00:00 2001
> > From: Joerg Roedel <joerg.roedel@amd.com>
> > Date: Wed, 18 Mar 2009 13:15:20 +0100
> > Subject: [PATCH] dma-debug: serialize locking in unmap path
> > 
> > Impact: reduce maximum lockdepth to one
> > 
> > This patch reduces the maximum spin lock depth from two to one in the
> > dma-debug code.
> 
> While appreciated, this failure is not about lock depth, but about 
> lock entries, that is items in the dependency chains.
> 
> Of course, these two are not unrelated, deeper lock hierarchies 
> lead to longer chains -> more entries.
> 
> Assuming dma api debug doesn't do anything spectaculary odd, I'd 
> say we've just lock bloated the kernel and might need to increase 
> this static array a bit.

appears to be the case:

BUG: MAX_LOCKDEP_ENTRIES too low!
turning off the locking correctness validator.
Pid: 7508, comm: sshd Not tainted 2.6.29-rc8-tip-02759-g4bb5a10-dirty #21037
Call Trace:
 [<ffffffff802679aa>] add_lock_to_list+0x53/0xba
 [<ffffffff8065b0e9>] ? add_dma_entry+0x2f/0x5d
 [<ffffffff80269398>] check_prev_add+0x14b/0x1c7
 [<ffffffff8026985d>] validate_chain+0x449/0x4f7
 [<ffffffff80269b96>] __lock_acquire+0x28b/0x302
 [<ffffffff80269d07>] lock_acquire+0xfa/0x11e
 [<ffffffff8065b0e9>] ? add_dma_entry+0x2f/0x5d
 [<ffffffff80c9cf77>] _spin_lock_irqsave+0x4c/0x84
 [<ffffffff8065b0e9>] ? add_dma_entry+0x2f/0x5d
 [<ffffffff8065b0e9>] add_dma_entry+0x2f/0x5d
 [<ffffffff8065bbd6>] debug_dma_map_page+0x110/0x11f
 [<ffffffff807f2775>] pci_map_single+0xb5/0xc7
 [<ffffffff807f36d7>] nv_start_xmit_optimized+0x174/0x49c
 [<ffffffff80269fbd>] ? __lock_acquired+0x182/0x1a7
 [<ffffffff80af7d20>] dev_hard_start_xmit+0xd4/0x147
 [<ffffffff80b11c08>] __qdisc_run+0xf4/0x200
 [<ffffffff80af80b0>] dev_queue_xmit+0x21f/0x32a
 [<ffffffff80b3051f>] ip_finish_output2+0x205/0x24e
 [<ffffffff80b305c9>] ip_finish_output+0x61/0x63
 [<ffffffff80b3066d>] ip_output+0xa2/0xab
 [<ffffffff80b2dfaf>] ip_local_out+0x65/0x67
 [<ffffffff80b30122>] ip_queue_xmit+0x2f0/0x37b
 [<ffffffff80267542>] ? register_lock_class+0x20/0x304
 [<ffffffff80b40320>] tcp_transmit_skb+0x655/0x694
 [<ffffffff80b42924>] tcp_write_xmit+0x2e2/0x3b6
 [<ffffffff80b42a48>] __tcp_push_pending_frames+0x2f/0x61
 [<ffffffff80b35320>] tcp_push+0x86/0x88
 [<ffffffff80b377a5>] tcp_sendmsg+0x7a4/0x8aa
 [<ffffffff80ae9206>] __sock_sendmsg+0x5e/0x67
 [<ffffffff80ae92fc>] sock_aio_write+0xed/0xfd
 [<ffffffff802d89e6>] do_sync_write+0xec/0x132
 [<ffffffff8025d09b>] ? autoremove_wake_function+0x0/0x3d
 [<ffffffff8026a688>] ? __lock_release+0xba/0xd3
 [<ffffffff80241369>] ? get_parent_ip+0x16/0x46
 [<ffffffff80242fef>] ? sub_preempt_count+0x67/0x7a
 [<ffffffff80604287>] ? security_file_permission+0x16/0x18
 [<ffffffff802d9275>] vfs_write+0xbf/0xe6
 [<ffffffff802d936a>] sys_write+0x4c/0x74
 [<ffffffff8020bd6b>] system_call_fastpath+0x16/0x1b
[  OK  ]

so we need to bump up the limits some more.

	Ingo
