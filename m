Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbZJBPmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbZJBPmH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 11:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbZJBPmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 11:42:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbZJBPmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 11:42:04 -0400
Date: Fri, 2 Oct 2009 11:40:20 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, riel@redhat.com
Subject: Re: IO scheduler based IO controller V10
Message-ID: <20091002154020.GC4494@redhat.com>
References: <200910021255.27689.czoccolo@gmail.com> <20091002124921.GA4494@redhat.com> <4e5e476b0910020827s23e827b1n847c64e355999d4a@mail.gmail.com> <1254497520.10392.11.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254497520.10392.11.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 05:32:00PM +0200, Mike Galbraith wrote:
> On Fri, 2009-10-02 at 17:27 +0200, Corrado Zoccolo wrote:
> > On Fri, Oct 2, 2009 at 2:49 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > > On Fri, Oct 02, 2009 at 12:55:25PM +0200, Corrado Zoccolo wrote:
> > >
> > > Actually I am not touching this code. Looking at the V10, I have not
> > > changed anything here in idling code.
> > 
> > I based my analisys on the original patch:
> > http://lkml.indiana.edu/hypermail/linux/kernel/0907.1/01793.html
> > 
> > Mike, can you confirm which version of the fairness patch did you use
> > in your tests?
> 
> That would be this one-liner.
> 

Ok. Thanks. Sorry, I got confused and thought that you are using "io
controller patches" with fairness=1.

In that case, Corrado's suggestion of refining it further and disabling idling
for seeky process only on non-rotational media (SSD and hardware RAID), makes
sense to me.

Thanks
Vivek
  
> o CFQ provides fair access to disk in terms of disk time used to processes.
>   Fairness is provided for the applications which have their think time with
>   in slice_idle (8ms default) limit.
> 
> o CFQ currently disables idling for seeky processes. So even if a process
>   has think time with-in slice_idle limits, it will still not get fair share
>   of disk. Disabling idling for a seeky process seems good from throughput
>   perspective but not necessarily from fairness perspecitve.
> 
> 0 Do not disable idling based on seek pattern of process if a user has set
>   /sys/block/<disk>/queue/iosched/fairness = 1.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  block/cfq-iosched.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/block/cfq-iosched.c
> ===================================================================
> --- linux-2.6.orig/block/cfq-iosched.c
> +++ linux-2.6/block/cfq-iosched.c
> @@ -1953,7 +1953,7 @@ cfq_update_idle_window(struct cfq_data *
>  	enable_idle = old_idle = cfq_cfqq_idle_window(cfqq);
>  
>  	if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
> -	    (cfqd->hw_tag && CIC_SEEKY(cic)))
> +	    (!cfqd->cfq_fairness && cfqd->hw_tag && CIC_SEEKY(cic)))
>  		enable_idle = 0;
>  	else if (sample_valid(cic->ttime_samples)) {
>  		if (cic->ttime_mean > cfqd->cfq_slice_idle)
> 
