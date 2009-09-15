Return-Path: <linux-kernel-owner+w=401wt.eu-S1758202AbZIOHoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202AbZIOHoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 03:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbZIOHom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 03:44:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49485 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbZIOHol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 03:44:41 -0400
Date: Tue, 15 Sep 2009 09:44:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Eric Paris <eparis@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       James Morris <jmorris@namei.org>, Thomas Liu <tliu@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [origin tree SLAB corruption #2] BUG kmalloc-64: Poison
	overwritten, INFO: Allocated in bdi_alloc_work+0x2b/0x100 age=175
	cpu=1 pid=3514
Message-ID: <20090915074425.GA13689@elte.hu>
References: <alpine.LRH.2.00.0909071215530.3222@tundra.namei.org> <20090912072450.GA6767@elte.hu> <1252808939.13780.30.camel@dhcp231-106.rdu.redhat.com> <20090914071631.GA24801@elte.hu> <alpine.LFD.2.01.0909140725470.3654@localhost.localdomain> <20090914162902.GF6773@linux.vnet.ibm.com> <20090914171037.GG14984@kernel.dk> <20090915065707.GA3435@elte.hu> <20090915071158.GA31392@elte.hu> <20090915072433.GS14984@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915072433.GS14984@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Tue, Sep 15 2009, Ingo Molnar wrote:
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > Hard to tell whether it's BDI, RCU or something else - sadly this is 
> > > the only incident i've managed to log so far. (We'd be all much 
> > > happier if boxes crashed left and right! ;)
> > > 
> > > -tip's been carrying the RCU changes for a long(er) time which would 
> > > reduce the chance of this being RCU related. [ It's still possible 
> > > though: if it's a bug with a probability of hitting this box on these 
> > > workloads with a chance of 1:20,000 or worse. ]
> > > 
> > > Plus it triggered shortly after i updated -tip to latest -git which 
> > > had the BDI bits - which would indicate the BDI stuff - or just about 
> > > anything else in -git for that matter - or something older in -tip. 
> > > Every day without having hit this crash once more broadens the range 
> > > of plausible possibilities.
> > > 
> > > In any case, i'll refrain from trying to fit a line on a single point 
> > > of measurement ;-)
> > 
> > Ha! I should have checked all logs of today before writing that, not 
> > just that box's logs.
> > 
> > Another testbox triggered the SLAB corruption yesternight:
> > 
> > [   13.598011] Freeing unused kernel memory: 2820k freed
> > [   13.602011] Write protecting the kernel read-only data: 13528k
> > [   13.649011] Not activating Mandatory Access Control now since /sbin/tomoyo-init doesn't exist.
> > [   14.391012] =============================================================================
> > [   14.391012] BUG kmalloc-96: Poison overwritten
> > [   14.391012] -----------------------------------------------------------------------------
> > [   14.391012] 
> > [   14.391012] INFO: 0xffff88003da4a950-0xffff88003da4a988. First byte 0x0 instead of 0x6b
> > [   14.391012] INFO: Allocated in bdi_alloc_work+0x20/0x83 age=6 cpu=0 pid=3191
> > [   14.391012] INFO: Freed in bdi_work_free+0x1b/0x2f age=4 cpu=0 pid=3193
> > [   14.391012] INFO: Slab 0xffffea000190ae10 objects=24 used=13 fp=0xffff88003da4a930 flags=0x200000000000c3
> > [   14.391012] INFO: Object 0xffff88003da4a930 @offset=2352 fp=0xffff88003da4a888
> > [   14.391012] 
> > [   14.391012] Bytes b4 0xffff88003da4a920:  52 a4 fb ff 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a R???....ZZZZZZZZ
> > [   14.391012]   Object 0xffff88003da4a930:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> > [   14.391012]   Object 0xffff88003da4a940:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> > [   14.391012]   Object 0xffff88003da4a950:  00 0c 47 3d 00 88 ff ff be 22 11 81 ff ff ff ff ..G=..???"..????
> > [   14.391012]   Object 0xffff88003da4a960:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> > [   14.391012]   Object 0xffff88003da4a970:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> > [   14.391012]   Object 0xffff88003da4a980:  6b 6b 6b 6b 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b a5 kkkkkkkkjkkkkkk?
> > [   14.391012]  Redzone 0xffff88003da4a990:  bb bb bb bb bb bb bb bb                         ????????        
> > [   14.391012]  Padding 0xffff88003da4a9d0:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
> > [   14.391012] Pid: 3193, comm: mount Not tainted 2.6.31-tip-02377-g78907f0-dirty #88876
> > [   14.391012] Call Trace:
> > [   14.391012]  [<ffffffff810e6bef>] print_trailer+0x140/0x149
> > [   14.391012]  [<ffffffff810e70db>] check_bytes_and_report+0xb7/0xf7
> > [   14.391012]  [<ffffffff810e71ec>] check_object+0xd1/0x1b4
> > [   14.391012]  [<ffffffff81112078>] ? bdi_alloc_work+0x20/0x83
> > [   14.391012]  [<ffffffff810e7bee>] alloc_debug_processing+0x7b/0xf7
> > [   14.391012]  [<ffffffff810e9842>] __slab_alloc+0x23e/0x282
> > [   14.391012]  [<ffffffff81112078>] ? bdi_alloc_work+0x20/0x83
> > [   14.391012]  [<ffffffff81112078>] ? bdi_alloc_work+0x20/0x83
> > [   14.391012]  [<ffffffff810e9a8f>] kmem_cache_alloc+0xa1/0x13f
> > [   14.391012]  [<ffffffff81112078>] bdi_alloc_work+0x20/0x83
> > [   14.391012]  [<ffffffff81112ae2>] bdi_writeback_all+0x66/0x133
> > [   14.391012]  [<ffffffff810788b8>] ? mark_held_locks+0x4d/0x6b
> > [   14.391012]  [<ffffffff81872268>] ? __mutex_unlock_slowpath+0x12d/0x163
> > [   14.391012]  [<ffffffff81078b45>] ? trace_hardirqs_on_caller+0x11c/0x140
> > [   14.391012]  [<ffffffff815c35e5>] ? usbfs_fill_super+0x0/0xa8
> > [   14.391012]  [<ffffffff81112c87>] writeback_inodes_sb+0x75/0x83
> > [   14.391012]  [<ffffffff8111652d>] __sync_filesystem+0x30/0x6b
> > [   14.391012]  [<ffffffff81116705>] sync_filesystem+0x3a/0x51
> > [   14.391012]  [<ffffffff810f4b23>] do_remount_sb+0x5b/0x11f
> > [   14.391012]  [<ffffffff810f59a3>] get_sb_single+0x92/0xad
> > [   14.391012]  [<ffffffff815c2f01>] usb_get_sb+0x1b/0x1d
> > [   14.391012]  [<ffffffff810f5786>] vfs_kern_mount+0x9e/0x122
> > [   14.391012]  [<ffffffff810f5871>] do_kern_mount+0x4c/0xec
> > [   14.391012]  [<ffffffff8110dd15>] do_mount+0x1e9/0x236
> > [   14.391012]  [<ffffffff8110dde6>] sys_mount+0x84/0xc6
> > [   14.391012]  [<ffffffff8187333a>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> > [   14.391012]  [<ffffffff8100b642>] system_call_fastpath+0x16/0x1b
> > [   14.391012] FIX kmalloc-96: Restoring 0xffff88003da4a950-0xffff88003da4a988=0x6b
> > [   14.391012] 
> > [   14.391012] FIX kmalloc-96: Marking all objects used
> > [   20.597016] usb usb2: uevent
> > [   20.606016] usb 2-0:1.0: uevent
> > [   20.615016] usb usb3: uevent
> > [   20.622016] usb 3-0:1.0: uevent
> > [   20.631016] usb usb4: uevent
> > 
> > Different hardware, different config, but still in bdi_alloc_work().
> > 
> > - Which excludes cosmic rays and freak hardware from the list of 
> >   possibilities.
> > 
> > - I'd also say RCU is out too as this incident was 500 iterations after 
> >   the BDI merge - preceded by a streak of 3000+ successful iterations on 
> >   that same box with all of -tip (including the RCU changes).
> > 
> > - Random memory corruption is probably out as well - the chance of 
> >   hitting a BDI data structure twice accidentally is low.
> > 
> > - It's also two completely different versions of distros - the 
> >   user-space of the two testboxes affected is 2 years apart or so.
> > 
> > - It's a single CPU box - SMP races are out as well.
> > 
> > This points towards this being a BDI bug with about ~80% confidence 
> > statistically - or [with a lower probability] a SLAB bug. (both failing 
> > configs had CONFIG_SLUB=y. But SLUB is the best in detecting corrupted 
> > data structures so that alone does not tell much.)
> 
> Hmmm, at least this reproduces more consistently. Can I talk you into 
> trying to pull in:
> 
>   git://git.kernel.dk/linux-2.6-block.git writeback
> 
> and see if it reproduces there? That path has been cleaned up 
> considerably there.

I gave it a test-pull - and the bug does not trigger anymore.

Note, that may not mean much: your tree is based on a fresh upstream 
tree so it pulled a lot of new stuff into -tip that i have yet to 
test/validate. It also changed the kernel image size/layout considerably 
and this bug seems to be a very narrow to hit race of sorts.

	Ingo
