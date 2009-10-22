Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360AbZJVIpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbZJVIpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 04:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbZJVIpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 04:45:31 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:35989 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbZJVIpa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 04:45:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XVAgvr+AEgwfA6dH2rKteh++yd24VMHRruOMRLlyQPkUVh0I3K/Qf7R39TvoaZ+nkm
         sE5RUDNHhwKDWb1H7QKsfYd2iMr/GW9wtQFnB4SA4qeILMCYmf6Pz0eKqarSlkZjjcod
         SQ5DkxEAiPTKdsuZ7kTYwT0u6ox/4Pmbhfkjg=
MIME-Version: 1.0
In-Reply-To: <x49ljj470ig.fsf@segfault.boston.devel.redhat.com>
References: <x49d44hx6uu.fsf@segfault.boston.devel.redhat.com>
	 <4e5e476b0910211433o670baec9o5a51dbfcbdcec936@mail.gmail.com>
	 <x49ljj470ig.fsf@segfault.boston.devel.redhat.com>
Date: Thu, 22 Oct 2009 10:45:34 +0200
Message-ID: <4e5e476b0910220145t300fe3fbo6ca7b623214d0a20@mail.gmail.com>
Subject: Re: [patch,rfc] cfq: merge cooperating cfq_queues
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: jens.axboe@oracle.com, Linux Kernel Mailing <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
On Thu, Oct 22, 2009 at 2:09 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Corrado Zoccolo <czoccolo@gmail.com> writes:
>
> Hi, Corrado!  Thanks for looking at the patch.
>
>> Hi Jeff,
> [...]
>> I'm not sure that 3 broken userspace programs justify increasing the
>> complexity of a core kernel part as the I/O scheduler.
>
> I think it's wrong to call the userspace programs broken.  They worked
> fine when CFQ was quantum based, and they work well with noop and
> deadline.

So they didn't work well with anticipatory, that was the default from
2.6.0 to 2.6.17,
and with CFQ with time slices, that was the default from 2.6.18 up to now.
I think enough time has passed to start fixing those programs.
>  Further, the patch I posted is fairly trivial, in my opinion.
Yes. We should see if also the un-merging part is so simple, then.

>> The original close cooperator code is not limited to those programs.
>> It can actually result in a better overall scheduling on rotating
>> media, since it can help with transient close relationships (and
>> should probably be disabled on non-rotating ones).
>> Merging queues, instead, can lead to bad results in case of false
>> positives. I'm thinking for examples to two programs that are loading
>> shared libraries (that are close on disk, being in the same dir) on
>> startup, and end up being tied to the same queue.
>
> The idea is not to leave cfqq's merged indefinitely.  I'm putting
> together a follow-on patch that will split the queues back up when they
> are no longer working on the same area of the disk.
>
Yes, this would help to mitigate the impact on false positives.

>> Can't the userspace programs be fixed to use the same I/O context for
>> their threads?
>> qemu already has a bug report for it
>> (https://bugzilla.redhat.com/show_bug.cgi?id=498242).
>
> I submitted a patch to dump to address this.  I think the SCSI target
> mode driver folks also patched their code.  The qemu folks are working
> on a couple of different fixes to the problem.  That leaves nfsd, which
> I could certainly try to whip into shape, but I wonder if there are
> others.
>
Good.
>
>> For the I/O pattern, instead, sorting all requests in a single queue
>> may still be preferable, since they will be at least sorted in disk
>> order, instead of the random order given by which thread in the pool
>> received the request.
>> This is, though, an argument in favor of using CLONE_IO inside nfsd,
>> since having a single queue, with proper priority, will always give a
>> better overall performance.
>
> Well, I started to work on a patch to nfsd that would share and unshare
> I/O contexts based on the client with which the request was associated.
> So, much like there is the shared readahead state, there would now be a
> shared I/O scheduler state.  However, believe it or not, it is much
> simpler to do in the I/O scheduler.  But maybe that's because cfq is my
> hammer.  ;-)

I think fixing nfsd at least for TCP should be easy. In TCP case, each
client has a private thread pool, so you can just share the I/O
context once, when creating those threads, and forget it.

For the UDP case, would just reducing idle window fix the problem? Or
the problem is not really the idling, but the bad I/O pattern?

>
> Thanks again for your review Corrado.  It is much appreciated.

Thanks.
Corrado

> Cheers,
> Jeff
>
