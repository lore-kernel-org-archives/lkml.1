Return-Path: <linux-kernel-owner+w=401wt.eu-S1763535AbXF1SDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763535AbXF1SDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 14:03:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759676AbXF1SCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 14:02:55 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:29035 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294AbXF1SCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 14:02:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ZW0Evyis2EbeVay8bRMjsHwNp0xSFnZA5i7g3ANmiIF6E78NsBRlnW4NBCPVsiCYC8e4XRkH+V6pu9FfPJYu6I/VD/KkV1er/aIgGszwLgU774pEMBQiPyN61NhUyLOelAkRCQssoVEf7vl/NhxUR+giCQ2NHBAUlOS5jgnrDAc=
Message-ID: <e9c3a7c20706281102l5db2e91alf465e7983d68f284@mail.gmail.com>
Date: Thu, 28 Jun 2007 11:02:53 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Christoph Hellwig" <hch@infradead.org>,
       "john stultz" <johnstul@us.ibm.com>, "Oleg Nesterov" <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Dipankar Sarma" <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
       "Jeff Garzik" <jeff@garzik.org>
In-Reply-To: <Pine.LNX.4.58.0706280823020.19012@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070622040014.234651401@goodmis.org>
	 <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org>
	 <20070622204058.GA11777@elte.hu>
	 <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org>
	 <20070622215953.GA22917@elte.hu>
	 <e9c3a7c20706251846v17347ab2n4a1d314734528c95@mail.gmail.com>
	 <1182823276.5493.240.camel@localhost.localdomain>
	 <e9c3a7c20706251912i77ac75a0o60981590a08c34e6@mail.gmail.com>
	 <Pine.LNX.4.58.0706280823020.19012@gandalf.stny.rr.com>
X-Google-Sender-Auth: 8f2f311bed2f80a6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/28/07, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Hi Dan,
>
> On Mon, 25 Jun 2007, Dan Williams wrote:
>
> > Yes you are right, ARM does not flush L1 when prev==next in switch_mm.
> >
> > > Perhaps something else is at fault here.
> > >
> > I'll try and dig a bit deeper...
>
> BTW:
>
>  static int __init iop_adma_init (void)
>  {
> +       iop_adma_workqueue = create_workqueue("iop-adma");
> +       if (!iop_adma_workqueue)
> +               return -ENODEV;
> +
>
> Could you also try upping the prio of all the "iop-adma" threads?
>
Unfortunately setting the thread to real time priority makes
throughput slightly worse.  Instead of floating around 35MB/s the
resync speed is stuck around 30MB/s:

[ iop-adma: hi-prio workqueue based callbacks ]
iq81340mc:~# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md0 : active raid5 sdd[4] sdc[2] sdb[1] sda[0]
      468872448 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
      [>....................]  recovery =  3.9% (6107424/156290816)
finish=84.9min speed=29448K/sec

The iop-adma tasklet cleans up any completed descriptors and in the
process calls any attached callbacks.  For the raid5 resync case the
callback is simply:

static void ops_complete_check(void *stripe_head_ref)
{
        struct stripe_head *sh = stripe_head_ref;
        int pd_idx = sh->pd_idx;

        pr_debug("%s: stripe %llu\n", __FUNCTION__,
                (unsigned long long)sh->sector);

        if (test_and_clear_bit(STRIPE_OP_MOD_DMA_CHECK, &sh->ops.pending) &&
                sh->ops.zero_sum_result == 0)
                set_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);

        set_bit(STRIPE_OP_CHECK, &sh->ops.complete);
        set_bit(STRIPE_HANDLE, &sh->state);
        release_stripe(sh);
}


[ iop-adma: tasklet based callbacks ]
iq81340mc:~# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md0 : active raid5 sdd[4] sdc[2] sdb[1] sda[0]
      468872448 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
      [=>...................]  recovery =  5.1% (8024248/156290816)
finish=47.9min speed=51486K/sec

--
Dan
