Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbYKLTES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbYKLTES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 14:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbYKLTEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 14:04:06 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:49041 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbYKLTEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 14:04:04 -0500
Date: Wed, 12 Nov 2008 20:02:28 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>, linux-kernel@vger.kernel.org
Subject: Re: Slow file transfer speeds with CFQ IO scheduler in some cases
Message-ID: <20081112190227.GS26778@kernel.dk>
References: <4917263D.2090904@telenet.dn.ua> <20081110104423.GA26778@kernel.dk> <x493ahzsn8p.fsf@segfault.boston.devel.redhat.com> <20081110135618.GI26778@kernel.dk> <x491vxgkd61.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x491vxgkd61.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12 2008, Jeff Moyer wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
> 
> > On Mon, Nov 10 2008, Jeff Moyer wrote:
> >> Jens Axboe <jens.axboe@oracle.com> writes:
> >> 
> >> > On Sun, Nov 09 2008, Vitaly V. Bursov wrote:
> >> >> Hello,
> >> >> 
> >> >> I'm building small server system with openvz kernel and have ran into
> >> >> some IO performance problems. Reading a single file via NFS delivers
> >> >> around 9 MB/s over gigabit network, but while reading, say, 2 different
> >> >> or same file 2 times at the same time I get >60MB/s.
> >> >> 
> >> >> Changing IO scheduler to deadline or anticipatory fixes problem.
> >> >> 
> >> >> Tested kernels:
> >> >>   OpenVZ RHEL5 028stab059.3 (9 MB/s with HZ=100, 20MB/s with HZ=1000
> >> >>                  fast local reads)
> >> >>   Vanilla 2.6.27.5 (40 MB/s with HZ=100, slow local reads)
> >> >> 
> >> >> Vanilla performs better in worst case but I believe 40 is still low
> >> >> concerning test results below.
> >> >
> >> > Can you check with this patch applied?
> >> >
> >> > http://bugzilla.kernel.org/attachment.cgi?id=18473&action=view
> >> 
> >> Funny, I was going to ask the same question.  ;)  The reason Jens wants
> >> you to try this patch is that nfsd may be farming off the I/O requests
> >> to different threads which are then performing interleaved I/O.  The
> >> above patch tries to detect this and allow cooperating processes to get
> >> disk time instead of waiting for the idle timeout.
> >
> > Precisely :-)
> >
> > The only reason I haven't merged it yet is because of worry of extra
> > cost, but I'll throw some SSD love at it and see how it turns out.
> 
> OK, I'm not actually able to reproduce the horrible 9MB/s reported by
> Vitaly.  Here are the numbers I see.
> 
> Single dd performing a cold cache read of a 1GB file from an
> nfs server.  read_ahead_kb is 128 (the default) for all tests.
> cfq-cc denotes that the cfq scheduler was patched with the close
> cooperator patch.  All numbers are in MB/s.
> 
> nfsd threads|   1  |  2   |  4   |  8  
> ----------------------------------------
> deadline    | 65.3 | 52.2 | 46.7 | 46.1
> cfq         | 64.1 | 57.8 | 53.3 | 46.9
> cfq-cc      | 65.7 | 55.8 | 52.1 | 40.3
> 
> So, in my configuration, cfq and deadline both degrade in performance as
> the number of nfsd threads is increased.  The close cooperator patch
> seems to hurt a bit more at 8 threads, instead of helping;  I'm not sure
> why that is.
> 
> Now, the workload that showed most slowdown for cfq with respect to
> other I/O schedulers was using dump(8) to backup a file system.  Here
> are the numbers for that:
> 
> deadline  82241 kB/s
> cfq	  34143 kB/s
> cfq-cc    82241 kB/s
> 
> And a customer actually went to the trouble to write a test to approximate
> dump(8)'s I/O patterns.  For that test, we also see a big speedup (as
> expected):
> 
> deadline  87157 kB/s
> cfq       20218 kB/s
> cfq-cc    87056 kB/s
> 
> Jens, if you have any canned fio workloads that you use for regression
> testing, please pass them my way and I'll give them a go on some SAN
> storage.

I already talked about this with Jeff on irc, but I guess should post it
here as well.

nfsd aside (which does seem to have some different behaviour skewing the
results), the original patch came about because dump(8) has a really
stupid design that offloads IO to a number of processes. This basically
makes fairly sequential IO more random with CFQ, since each process gets
its own io context. My feeling is that we should fix dump instead of
introducing a fair bit of complexity (and slowdown) in CFQ. I'm not
aware of any other good programs out there that would do something
similar, so I don't think there's a lot of merrit to spending cycles on
detecting cooperating processes.

Jeff will take a look at fixing dump instead, and I may have promised
him that santa will bring him something nice this year if he does (since
I'm sure it'll be painful on the eyes).

-- 
Jens Axboe

