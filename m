Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbZJUVdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbZJUVdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 17:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754590AbZJUVdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 17:33:33 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:38497 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480AbZJUVdc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 17:33:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=m2fzqAZ7/scrQdyamEAIW1sxmQkszvRs+vyjTvNOdpk0Cfs1mVsEN73kKAYhVsbs69
         5Ufe6c4Y5vX5hewSSGaeUEaw6BcZejyTiGUuG7wH4MC72ALKYaGEMvVV9v+Ij3NxfA0q
         jAg2Xtru+y7On5T7XUarZ+tNRgABzuvxtPg7Y=
MIME-Version: 1.0
In-Reply-To: <x49d44hx6uu.fsf@segfault.boston.devel.redhat.com>
References: <x49d44hx6uu.fsf@segfault.boston.devel.redhat.com>
Date: Wed, 21 Oct 2009 23:33:36 +0200
Message-ID: <4e5e476b0910211433o670baec9o5a51dbfcbdcec936@mail.gmail.com>
Subject: Re: [patch,rfc] cfq: merge cooperating cfq_queues
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: jens.axboe@oracle.com, Linux Kernel Mailing <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,
On Tue, Oct 20, 2009 at 8:23 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Hi,
>
> This is a follow-up patch to the original close cooperator support for
> CFQ.  The problem is that some programs (NFSd, dump(8), iscsi target
> mode driver, qemu) interleave sequential I/Os between multiple threads
> or processes.  The result is that there are large delays due to CFQs
> idling logic that leads to very low throughput.  The original patch
> addresses these problems by detecting close cooperators and allowing
> them to jump ahead in the scheduling order.  This doesn't work 100% of
> the time, unfortunately, and you can have some processes in the group
> getting way ahead (LBA-wise) of the others, leading to a lot of seeks.
>
> This patch addresses the problems in the current implementation by
> merging cfq_queue's of close cooperators.  The results are encouraging:
>
I'm not sure that 3 broken userspace programs justify increasing the
complexity of a core kernel part as the I/O scheduler.
The original close cooperator code is not limited to those programs.
It can actually result in a better overall scheduling on rotating
media, since it can help with transient close relationships (and
should probably be disabled on non-rotating ones).
Merging queues, instead, can lead to bad results in case of false
positives. I'm thinking for examples to two programs that are loading
shared libraries (that are close on disk, being in the same dir) on
startup, and end up being tied to the same queue.
Can't the userspace programs be fixed to use the same I/O context for
their threads?
qemu already has a bug report for it
(https://bugzilla.redhat.com/show_bug.cgi?id=498242).

> read-test2 emulates the I/O patterns of dump(8).  The following results
> are taken from 50 runs of patched, 16 runs of unpatched (I got impatient):
>
>               Average   Std. Dev.
> ----------------------------------
> Patched CFQ:   88.81773  0.9485
> Vanilla CFQ:   12.62678  0.24535
>
> Single streaming reader over NFS, results in MB/s are the average of 2
> runs.
>
>              |patched|
> nfsd's|  cfq  |  cfq  | deadline
> ------+-------+-------+---------
>  1   |  45   |  45   | 36
>  2   |  57   |  60   | 60
>  4   |  38   |  49   | 50
>  8   |  34   |  40   | 49
>  16  |  34   |  43   | 53
>
> The next step will be to break apart the cfqq's when the I/O patterns
> are no longer sequential.  This is not very important for dump(8), but
> for NFSd, this could make a big difference.  The problem with sharing
> the cfq_queue when the NFSd threads are no longer serving requests from
> a single client is that instead of having 8 scheduling entities, NFSd
> only gets one.  This could considerably hurt performance when serving
> shares to multiple clients, though I don't have a test to show this yet.

I think it will hurt performance only if it is competing with other
I/O. In that case, having 8 scheduling entities will get 8 times more
disk share (but this can be fixed by adjusting the nfsd I/O priority).
For the I/O pattern, instead, sorting all requests in a single queue
may still be preferable, since they will be at least sorted in disk
order, instead of the random order given by which thread in the pool
received the request.
This is, though, an argument in favor of using CLONE_IO inside nfsd,
since having a single queue, with proper priority, will always give a
better overall performance.

Corrado

> So, please take this patch as an rfc, and any discussion on detecting
> that I/O patterns are no longer sequential at the cfqq level (not the
> cic, as multiple cic's now point to the same cfqq) would be helpful.
>
> Cheers,
> Jeff
>
