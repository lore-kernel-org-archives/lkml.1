Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbYKJSoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbYKJSoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 13:44:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbYKJSoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 13:44:15 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:44117 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836AbYKJSoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 13:44:14 -0500
Date: Mon, 10 Nov 2008 19:42:42 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Slow file transfer speeds with CFQ IO scheduler in some cases
Message-ID: <20081110184241.GO26778@kernel.dk>
References: <4917263D.2090904@telenet.dn.ua> <20081110104423.GA26778@kernel.dk> <x493ahzsn8p.fsf@segfault.boston.devel.redhat.com> <20081110135618.GI26778@kernel.dk> <49186C5A.5020809@telenet.dn.ua> <20081110173504.GL26778@kernel.dk> <49187D05.9050407@telenet.dn.ua> <20081110182928.GN26778@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081110182928.GN26778@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10 2008, Jens Axboe wrote:
> On Mon, Nov 10 2008, Vitaly V. Bursov wrote:
> > Jens Axboe wrote:
> > > On Mon, Nov 10 2008, Vitaly V. Bursov wrote:
> > >> Jens Axboe wrote:
> > >>> On Mon, Nov 10 2008, Jeff Moyer wrote:
> > >>>> Jens Axboe <jens.axboe@oracle.com> writes:
> > >>>>
> > >>>>> http://bugzilla.kernel.org/attachment.cgi?id=18473&action=view
> > >>>> Funny, I was going to ask the same question.  ;)  The reason Jens wants
> > >>>> you to try this patch is that nfsd may be farming off the I/O requests
> > >>>> to different threads which are then performing interleaved I/O.  The
> > >>>> above patch tries to detect this and allow cooperating processes to get
> > >>>> disk time instead of waiting for the idle timeout.
> > >>> Precisely :-)
> > >>>
> > >>> The only reason I haven't merged it yet is because of worry of extra
> > >>> cost, but I'll throw some SSD love at it and see how it turns out.
> > >>>
> > >> Sorry, but I get "oops" same moment nfs read transfer starts.
> > >> I can get directory list via nfs, read files locally (not
> > >> carefully tested, though)
> > >>
> > >> Dumps captured via netconsole, so these may not be completely accurate
> > >> but hopefully will give a hint.
> > > 
> > > Interesting, strange how that hasn't triggered here. Or perhaps the
> > > version that Jeff posted isn't the one I tried. Anyway, search for:
> > > 
> > >         RB_CLEAR_NODE(&cfqq->rb_node);
> > > 
> > > and add a
> > > 
> > >         RB_CLEAR_NODE(&cfqq->prio_node);
> > > 
> > > just below that. It's in cfq_find_alloc_queue(). I think that should fix
> > > it.
> > > 
> > 
> > Same problem.
> > 
> > I did make clean; make -j3; sync; on (2 times) patched kernel and it went OK
> > but It won't boot anymore with cfq with same error...
> > 
> > Switching cfq io scheduler at runtime (booting with "as") appears to work with
> > two parallel local dd reads.
> > 
> > But when NFS server starts up:
> > 
> > [  469.000105] BUG: unable to handle kernel
> > NULL pointer dereference
> > at 0000000000000000
> > [  469.000305] IP:
> > [<ffffffff81111f2a>] rb_erase+0x124/0x290
> > ...
> > 
> > [  469.001905] Pid: 2296, comm: md1_raid5 Not tainted 2.6.27.5 #4
> > [  469.001982] RIP: 0010:[<ffffffff81111f2a>]
> > [<ffffffff81111f2a>] rb_erase+0x124/0x290
> > ...
> > [  469.002509] Call Trace:
> > [  469.002509]  [<ffffffff8110a0b9>] ? rb_erase_init+0x9/0x17
> > [  469.002509]  [<ffffffff8110a0ff>] ? cfq_prio_tree_add+0x38/0xa8
> > [  469.002509]  [<ffffffff8110b13d>] ? cfq_add_rq_rb+0xb5/0xc8
> > [  469.002509]  [<ffffffff8110b1aa>] ? cfq_insert_request+0x5a/0x356
> > [  469.002509]  [<ffffffff811000a1>] ? elv_insert+0x14b/0x218
> > [  469.002509]  [<ffffffff810ab757>] ? bio_phys_segments+0xf/0x15
> > [  469.002509]  [<ffffffff811028dc>] ? __make_request+0x3b9/0x3eb
> > [  469.002509]  [<ffffffff8110120c>] ? generic_make_request+0x30b/0x346
> > [  469.002509]  [<ffffffff811baaf4>] ? raid5_end_write_request+0x0/0xb8
> > [  469.002509]  [<ffffffff811b8ade>] ? ops_run_io+0x16a/0x1c1
> > [  469.002509]  [<ffffffff811ba534>] ? handle_stripe5+0x9b5/0x9d6
> > [  469.002509]  [<ffffffff811bbf08>] ? handle_stripe+0xc3a/0xc6a
> > [  469.002509]  [<ffffffff810296e5>] ? pick_next_task_fair+0x8d/0x9c
> > [  469.002509]  [<ffffffff81253792>] ? thread_return+0x3a/0xaa
> > [  469.002509]  [<ffffffff811bc2ce>] ? raid5d+0x396/0x3cd
> > [  469.002509]  [<ffffffff81253bd8>] ? schedule_timeout+0x1e/0xad
> > [  469.002509]  [<ffffffff811c716f>] ? md_thread+0xdd/0xf9
> > [  469.002509]  [<ffffffff81044f9c>] ? autoremove_wake_function+0x0/0x2e
> > [  469.002509]  [<ffffffff811c7092>] ? md_thread+0x0/0xf9
> > [  469.002509]  [<ffffffff81044e80>] ? kthread+0x47/0x73
> > [  469.002509]  [<ffffffff8102f867>] ? schedule_tail+0x28/0x60
> > [  469.002509]  [<ffffffff8100cda9>] ? child_rip+0xa/0x11
> > [  469.002509]  [<ffffffff81044e39>] ? kthread+0x0/0x73
> > [  469.002509]  [<ffffffff8100cd9f>] ? child_rip+0x0/0x11
> > ...
> > [  469.002509] RIP
> > [<ffffffff81111f2a>] rb_erase+0x124/0x290
> > [  469.002509]  RSP <ffff88011d4c7a58>
> > [  469.002509] CR2: 0000000000000000
> > [  469.002509] ---[ end trace acdef779aeb56048 ]---
> > 
> > 
> > "Best" result I got with NFS was
> > avg-cpu:  %user   %nice %system %iowait  %steal   %idle
> >            0,00    0,00    0,20    0,65    0,00   99,15
> > 
> > Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
> > sda              11,30     0,00    7,60    0,00   245,60     0,00    32,32     0,01    1,18   0,79   0,60
> > sdb              12,10     0,00    8,00    0,00   246,40     0,00    30,80     0,01    1,62   0,62   0,50
> > 
> > and it lasted around 30 seconds.
> 
> OK, I'll throw some NFS at this patch in the morning and do some
> measurements as well, so it can get queued up.

I spotted a bug - if the ioprio of a process gets changed, it needs to
be repositioned in the cooperator tree or we'll end up doing erase on a
wrong root. Perhaps that is what is biting you here.

-- 
Jens Axboe

