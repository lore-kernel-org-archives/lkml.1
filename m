Return-Path: <linux-kernel-owner+w=401wt.eu-S1753714AbXJQTKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbXJQTKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762106AbXJQTJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:09:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52232 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933338AbXJQTJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:09:39 -0400
Date: Wed, 17 Oct 2007 21:09:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071017190901.GA13780@elte.hu>
References: <20071017154655.GA13394@elte.hu> <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org> <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk> <20071017172158.GH15552@kernel.dk> <20071017172932.GI15552@kernel.dk> <20071017173408.GA1960@elte.hu> <20071017174503.GA4622@elte.hu> <20071017175337.GN15552@kernel.dk> <20071017183716.GU15552@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017183716.GU15552@kernel.dk>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> @@ -777,8 +777,12 @@ struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
>  		 * sglist must be the biggest one, or we would not have
>  		 * ended up doing another loop.
>  		 */
> -		if (prev)
> +		if (prev) {
> +			struct Scsi_Host *shost = cmd->device->host;
> +
> +			BUG_ON(!shost->use_sg_chaining);
>  			sg_chain(prev, SCSI_MAX_SG_SEGMENTS, sgl);
> +		}
>  

nope, this did not help. First bootup went fine, second bootup crashed 
again (see below), without hitting the BUG_ON().

	Ingo

[   39.351198] BUG: unable to handle kernel paging request at virtual address 7ca58000
[   39.358698] printing eip: 784e9480 *pde = 00dda027 *pte = 04a58000 
[   39.364939] Oops: 0000 [#1] DEBUG_PAGEALLOC
[   39.369099] 
[   39.370573] Pid: 0, comm: swapper Not tainted (2.6.23 #9)
[   39.375944] EIP: 0060:[<784e9480>] EFLAGS: 00010087 CPU: 0
[   39.381408] EIP is at ata_qc_issue+0x90/0x380
[   39.385737] EAX: 7ca57ff0 EBX: 0000001f ECX: 7ca57ff0 EDX: 79181c20
[   39.391977] ESI: 00000020 EDI: 7ca57e00 EBP: 7b54007c ESP: 78a13e10
[   39.398217]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   39.403590] Process swapper (pid: 0, ti=78a12000 task=789753e0 task.ti=78a12000)
[   39.410781] Stack: 7ca57e00 7b540000 7b540000 00000000 7ca57fe0 7b54007c 7c991980 7b5417a4 
[   39.419101]        784c2490 784ef69e 784f21f3 7b52de98 7c991980 7b540000 7b5417a4 7c991980 
[   39.427421]        7b540000 7b524004 784f22e0 784ef380 784c2490 7c991980 00000206 7b524004 
[   39.435740] Call Trace:
[   39.438340]  [<784c2490>] scsi_done+0x0/0x20
[   39.442586]  [<784ef69e>] ata_scsi_translate+0xbe/0x140
[   39.447785]  [<784f21f3>] ata_scsi_queuecmd+0x33/0x200
[   39.452899]  [<784f22e0>] ata_scsi_queuecmd+0x120/0x200
[   39.458099]  [<784ef380>] ata_scsi_rw_xlat+0x0/0x220
[   39.463038]  [<784c2490>] scsi_done+0x0/0x20
[   39.467285]  [<784c2d12>] scsi_dispatch_cmd+0x152/0x290
[   39.472484]  [<78135c67>] trace_hardirqs_on+0x67/0xb0
[   39.477511]  [<784c8c7e>] scsi_request_fn+0x1be/0x370
[   39.482538]  [<78408086>] blk_run_queue+0x36/0x80
[   39.487217]  [<784c7520>] scsi_next_command+0x30/0x50
[   39.492243]  [<784c76ab>] scsi_end_request+0xab/0xe0
[   39.497183]  [<784c83f9>] scsi_io_completion+0xa9/0x3d0
[   39.502383]  [<78135c67>] trace_hardirqs_on+0x67/0xb0
[   39.507409]  [<78405125>] blk_done_softirq+0x45/0x80
[   39.512348]  [<78405153>] blk_done_softirq+0x73/0x80
[   39.517288]  [<7811d4c3>] __do_softirq+0x53/0xb0
[   39.521882]  [<7811d588>] do_softirq+0x68/0x70
[   39.526302]  [<78105351>] do_IRQ+0x51/0x90
[   39.530374]  [<78770a54>] _spin_unlock+0x14/0x20
[   39.534968]  [<7810290f>] restore_nocheck+0x12/0x15
[   39.539820]  [<7810f2d0>] pgd_dtor+0x0/0x50
[   39.543980]  [<7810388e>] common_interrupt+0x2e/0x40
[   39.548920]  [<7810f2d0>] pgd_dtor+0x0/0x50
[   39.553079]  [<7815f3bd>] quicklist_trim+0x5d/0x90
[   39.557846]  [<7810f2cb>] check_pgt_cache+0x1b/0x20
[   39.562698]  [<78100c52>] cpu_idle+0x32/0x60
[   39.566945]  [<78a14b35>] start_kernel+0x265/0x300
[   39.571712]  [<78a14380>] unknown_bootoption+0x0/0x1e0
[   39.576825]  =======================
[   39.580377] Code: 00 00 00 8b 45 34 a8 02 0f 84 ed 00 00 00 8b bd 88 00 00 00 31 db 89 3c 24 8b 75 3c 89 f8 c7 44 24 10 00 00 00 00 eb 1b 8d 76 00 <8b> 50 10 8d 48 10 f6 c2 01 0f 85 be 02 00 00 89 44 24 10 83 c3 
[   39.599183] EIP: [<784e9480>] ata_qc_issue+0x90/0x380 SS:ESP 0068:78a13e10
[   39.606030] Kernel panic - not syncing: Fatal exception in interrupt
