Return-Path: <linux-kernel-owner+w=401wt.eu-S1755703AbYKKJh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbYKKJh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 04:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbYKKJhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 04:37:16 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:50608 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593AbYKKJhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 04:37:15 -0500
Date: Tue, 11 Nov 2008 10:35:40 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>, linux-kernel@vger.kernel.org
Subject: Re: Slow file transfer speeds with CFQ IO scheduler in some cases
Message-ID: <20081111093540.GT26778@kernel.dk>
References: <4917263D.2090904@telenet.dn.ua> <20081110104423.GA26778@kernel.dk> <x493ahzsn8p.fsf@segfault.boston.devel.redhat.com> <20081110135618.GI26778@kernel.dk> <49186C5A.5020809@telenet.dn.ua> <20081110173504.GL26778@kernel.dk> <49187D05.9050407@telenet.dn.ua> <x491vxjqmg0.fsf@segfault.boston.devel.redhat.com> <20081111093426.GS26778@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111093426.GS26778@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11 2008, Jens Axboe wrote:
> On Mon, Nov 10 2008, Jeff Moyer wrote:
> > "Vitaly V. Bursov" <vitalyb@telenet.dn.ua> writes:
> > 
> > > Jens Axboe wrote:
> > >> On Mon, Nov 10 2008, Vitaly V. Bursov wrote:
> > >>> Jens Axboe wrote:
> > >>>> On Mon, Nov 10 2008, Jeff Moyer wrote:
> > >>>>> Jens Axboe <jens.axboe@oracle.com> writes:
> > >>>>>
> > >>>>>> http://bugzilla.kernel.org/attachment.cgi?id=18473&action=view
> > >>>>> Funny, I was going to ask the same question.  ;)  The reason Jens wants
> > >>>>> you to try this patch is that nfsd may be farming off the I/O requests
> > >>>>> to different threads which are then performing interleaved I/O.  The
> > >>>>> above patch tries to detect this and allow cooperating processes to get
> > >>>>> disk time instead of waiting for the idle timeout.
> > >>>> Precisely :-)
> > >>>>
> > >>>> The only reason I haven't merged it yet is because of worry of extra
> > >>>> cost, but I'll throw some SSD love at it and see how it turns out.
> > >>>>
> > >>> Sorry, but I get "oops" same moment nfs read transfer starts.
> > >>> I can get directory list via nfs, read files locally (not
> > >>> carefully tested, though)
> > >>>
> > >>> Dumps captured via netconsole, so these may not be completely accurate
> > >>> but hopefully will give a hint.
> > >> 
> > >> Interesting, strange how that hasn't triggered here. Or perhaps the
> > >> version that Jeff posted isn't the one I tried. Anyway, search for:
> > >> 
> > >>         RB_CLEAR_NODE(&cfqq->rb_node);
> > >> 
> > >> and add a
> > >> 
> > >>         RB_CLEAR_NODE(&cfqq->prio_node);
> > >> 
> > >> just below that. It's in cfq_find_alloc_queue(). I think that should fix
> > >> it.
> > >> 
> > >
> > > Same problem.
> > >
> > > I did make clean; make -j3; sync; on (2 times) patched kernel and it went OK
> > > but It won't boot anymore with cfq with same error...
> > >
> > > Switching cfq io scheduler at runtime (booting with "as") appears to work with
> > > two parallel local dd reads.
> > 
> > Strange, I can't reproduce a failure.  I'll keep trying.  For now, these
> > are the results I see:
> > 
> > [root@maiden ~]# mount megadeth:/export/cciss /mnt/megadeth/
> > [root@maiden ~]# dd if=/mnt/megadeth/file1 of=/dev/null bs=1M
> > 1024+0 records in
> > 1024+0 records out
> > 1073741824 bytes (1.1 GB) copied, 26.8128 s, 40.0 MB/s
> > [root@maiden ~]# umount /mnt/megadeth/
> > [root@maiden ~]# mount megadeth:/export/cciss /mnt/megadeth/
> > [root@maiden ~]# dd if=/mnt/megadeth/file1 of=/dev/null bs=1M
> > 1024+0 records in
> > 1024+0 records out
> > 1073741824 bytes (1.1 GB) copied, 23.7025 s, 45.3 MB/s
> > [root@maiden ~]# umount /mnt/megadeth/
> > 
> > Here is the patch, with the suggestion from Jens to switch the cfqq to
> > the right priority tree when the priority is changed.
> 
> I don't see the issue here either. Vitaly, are you using any openvz
> kernel patches? IIRC, they patch cfq so it could just be that your cfq
> version is incompatible with Jeff's patch.

Heh, got it to trigger about 3 seconds after sending that email! I'll
look more into it.

-- 
Jens Axboe

