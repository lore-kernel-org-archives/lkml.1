Return-Path: <linux-kernel-owner+w=401wt.eu-S1752976AbYCYIAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbYCYIAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 04:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbYCYIAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 04:00:38 -0400
Received: from n76.bullet.mail.sp1.yahoo.com ([98.136.44.48]:24814 "HELO
	n76.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750953AbYCYIAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 04:00:37 -0400
X-Yahoo-Newman-Id: 31511.49111.bm@omp422.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=FdbJMe+zlv8vzwtTW/zfPdzbCAuDue7BN8OTnF/E47AHe2UJ617MHlpK6jocHdu0y8iPqSo12Pmi5GUelvHHbNnS6WF/E/sj6iWuIJpwA7a26QBZHHCECESDwqhk8te/1vHmkku92Hn7meh1H6/lajs/MIUS25lGcadTwASbrsg=  ;
X-YMail-OSG: v2mrRGUVM1mnKiF5as3czl4Sl9UKnUgDS7CWSuxBG3J2oLT2n9J67___s0.zivHpAcMOhUk4kB8..epnY9VuDlYx8L_4Yk8FLawys64VgJR9R1v4gS4-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/5] Generic smp_call_function(), improvements, and  smp_call_function_single()
Date: Tue, 25 Mar 2008 19:00:25 +1100
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, npiggin@suse.de,
       paulus@samba.org, tglx@linutronix.de, mingo@redhat.com,
       tony.luck@intel.com
References: <1205927772-31401-1-git-send-email-jens.axboe@oracle.com> <20080321095343.GA21409@elte.hu> <20080321131558.GA15355@kernel.dk>
In-Reply-To: <20080321131558.GA15355@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803251900.26154.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 March 2008 00:15, Jens Axboe wrote:
> On Fri, Mar 21 2008, Ingo Molnar wrote:
> > * Jens Axboe <jens.axboe@oracle.com> wrote:
> > > The patch series is also available in the 'generic-ipi' branch from
> > >
> > > git://git.kernel.dk/linux-2.6-block.git
> > >
> > > and the 'io-cpu-affinity' branch is directly based on this.
> >
> > i'm still wondering about the following fundamental bit: why not use
> > per CPU kernel threads? That way you get a fast (lockless) IPI "for
> > free" as SMP wakeups already do this.
>
> The kernel thread variant wont be any more lockless than the
> smp_call_function_single() approach, they both have to grab the
> destination queue lock. If you recall, I pushed forward on the kernel
> thread variant and even still have it online here:
>
> http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=io-cpu-affinity-kt
>hread
>
> which is pretty much identical to io-cpu-affinity, except it uses kernel
> threads for completion.
>
> The reason why I dropped the kthread approach is that it was slower.
> Time from signal to run was about 33% faster with IPI than with
> wake_up_process(). Doing benchmark runs, and the IPI approach won hands
> down in cache misses as well.

It's obviously going to be faster. The kthread approach needs an IPI
*and* a context switch on the destination CPU.

For broadcast situations, it is also going to be faster, because it
can use platform specific broadcast IPIs 

The only weird atomicity requirements of smp_call_function is due to
its terribly unscalable design. Once you have the producer provide its
own data (or accept -ENOMEM failures), then there is no problem. It's
then even possible to use it from interrupt context with not too much
more work.


> > smp_call_function() is quirky and has deep limitations on atomicity,
> > etc., so we are moving away from it and should not base more
> > functionality on it.
>
> The patchset does not build on smp_call_function(), it merely cleans
> that stuff up instead of having essentially the same code in each arch.
> As more archs are converted, it'll remove lots more code.

Also there is nothing wrong with improving the speed of the existing
implementation. The current smp_call_function is more or less unusable
for any real work because it is totally serialised.

Thanks for taking this patchset under your wing, Jens.

