Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358AbZJVAJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbZJVAJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 20:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbZJVAJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 20:09:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbZJVAJL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 20:09:11 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: jens.axboe@oracle.com, Linux Kernel Mailing <linux-kernel@vger.kernel.org>
Subject: Re: [patch,rfc] cfq: merge cooperating cfq_queues
References: <x49d44hx6uu.fsf@segfault.boston.devel.redhat.com>
	<4e5e476b0910211433o670baec9o5a51dbfcbdcec936@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 21 Oct 2009 20:09:11 -0400
In-Reply-To: <4e5e476b0910211433o670baec9o5a51dbfcbdcec936@mail.gmail.com>
	(Corrado Zoccolo's message of "Wed, 21 Oct 2009 23:33:36 +0200")
Message-ID: <x49ljj470ig.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

Hi, Corrado!  Thanks for looking at the patch.

> Hi Jeff,
[...]
> I'm not sure that 3 broken userspace programs justify increasing the
> complexity of a core kernel part as the I/O scheduler.

I think it's wrong to call the userspace programs broken.  They worked
fine when CFQ was quantum based, and they work well with noop and
deadline.  Further, the patch I posted is fairly trivial, in my opinion.

> The original close cooperator code is not limited to those programs.
> It can actually result in a better overall scheduling on rotating
> media, since it can help with transient close relationships (and
> should probably be disabled on non-rotating ones).
> Merging queues, instead, can lead to bad results in case of false
> positives. I'm thinking for examples to two programs that are loading
> shared libraries (that are close on disk, being in the same dir) on
> startup, and end up being tied to the same queue.

The idea is not to leave cfqq's merged indefinitely.  I'm putting
together a follow-on patch that will split the queues back up when they
are no longer working on the same area of the disk.

> Can't the userspace programs be fixed to use the same I/O context for
> their threads?
> qemu already has a bug report for it
> (https://bugzilla.redhat.com/show_bug.cgi?id=498242).

I submitted a patch to dump to address this.  I think the SCSI target
mode driver folks also patched their code.  The qemu folks are working
on a couple of different fixes to the problem.  That leaves nfsd, which
I could certainly try to whip into shape, but I wonder if there are
others.

>> The next step will be to break apart the cfqq's when the I/O patterns
>> are no longer sequential.  This is not very important for dump(8), but
>> for NFSd, this could make a big difference.  The problem with sharing
>> the cfq_queue when the NFSd threads are no longer serving requests from
>> a single client is that instead of having 8 scheduling entities, NFSd
>> only gets one.  This could considerably hurt performance when serving
>> shares to multiple clients, though I don't have a test to show this yet.
>
> I think it will hurt performance only if it is competing with other
> I/O. In that case, having 8 scheduling entities will get 8 times more
> disk share (but this can be fixed by adjusting the nfsd I/O priority).

It may be common that nfsd is the only thing accessing the device, good
point.

> For the I/O pattern, instead, sorting all requests in a single queue
> may still be preferable, since they will be at least sorted in disk
> order, instead of the random order given by which thread in the pool
> received the request.
> This is, though, an argument in favor of using CLONE_IO inside nfsd,
> since having a single queue, with proper priority, will always give a
> better overall performance.

Well, I started to work on a patch to nfsd that would share and unshare
I/O contexts based on the client with which the request was associated.
So, much like there is the shared readahead state, there would now be a
shared I/O scheduler state.  However, believe it or not, it is much
simpler to do in the I/O scheduler.  But maybe that's because cfq is my
hammer.  ;-)

Thanks again for your review Corrado.  It is much appreciated.

Cheers,
Jeff
