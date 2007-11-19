Return-Path: <linux-kernel-owner+w=401wt.eu-S1753777AbXKSWW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777AbXKSWW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756200AbXKSWWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:22:10 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:57166 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074AbXKSWWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:22:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=C6gzDU4zKHDC0MjeZrdKR2u1cloVZjM1CuXuY1CY3n3PF5fOXIuzfzjRoANu5gTcaHrWyz+n2AzxyFEuLqZ8CloP+QWeJHgytA5/KB88ueCIi69Q7IZMO9PTP7+g24fROzcCFrorVcT6gDSwWV31NP9vk89LlNuMOrmDqSRxRwg=
Message-ID: <b647ffbd0711191422q6be59c44gfbc72f0fc3167768@mail.gmail.com>
Date: Mon, 19 Nov 2007 23:22:06 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Micah Dowty" <micah@vmware.com>
Subject: Re: High priority tasks break SMP balancer?
Cc: "Ingo Molnar" <mingo@elte.hu>, "Christoph Lameter" <clameter@sgi.com>,
       "Kyle Moffett" <mrmacman_g4@mac.com>, "Cyrus Massoumi" <cyrusm@gmx.net>,
       "LKML Kernel" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, "Mike Galbraith" <efault@gmx.de>,
       "Paul Menage" <menage@google.com>,
       "Peter Williams" <pwil3058@bigpond.net.au>
In-Reply-To: <20071119185116.GA28173@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0711151328090.29711@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0711151830260.31691@schroedinger.engr.sgi.com>
	 <20071116024408.GA20322@vmware.com> <20071116060700.GD16273@elte.hu>
	 <b647ffbd0711160248v444d8f64ic72a17fcb56adc6d@mail.gmail.com>
	 <20071116221404.GC31527@vmware.com>
	 <b647ffbd0711161526p2faf5abt2457084f1996c735@mail.gmail.com>
	 <20071117010352.GA13666@vmware.com>
	 <b647ffbd0711171110q9f695e1qb42ba73dc23b626d@mail.gmail.com>
	 <20071119185116.GA28173@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/11/2007, Micah Dowty <micah@vmware.com> wrote:
> [ ... ]
>
> micah@micah-64:~$ cat /proc/schedstat
> version 14
> timestamp 4366722208
> cpu0 0 0 0 785868111 0 828020771 12621812 22703872 14096041 9504937730116 23603703739504 815398959
> domain0 03 8766051 8760123 95 14544377 6374 0 13 8760110 7369 6771 0 20835105 605 0 1 6770 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 7026998 0 24826
> cpu1 0 0 0 783505304 0 860700497 26129151 41776419 34749418 10682815341474 1753703225423 834571346
> domain0 03 8685595 8677710 224 7037051 8127 0 76 8677634 7500 7320 7 471762 179 0 8 7312 ===> 0 0 0 0 0 0 0 0 <=== 1 0 1 0 0 0 0 0 0 8607831 0 36753

> micah@micah-64:~$ cat /proc/schedstat
> version 14
> timestamp 4366723231
> cpu0 0 0 0 785868111 0 828021128 12621812 22703965 14096130 9509029340381 23603703795868 815399316
> domain0 03 8766051 8760123 95 14544377 6374 0 13 8760110 7374 6776 0 20835105 605 0 1 6775 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 7027010 0 24826
> cpu1 0 0 0 783505304 0 860708521 26132612 41780521 34753508 10683770853336 1753758309667 834575909
> domain0 03 8685718 8677833 224 7037051 8127 0 76 8677757 7500 7320 7 471762 179 0 8 7312 ===> 0 0 0 0 0 0 0 0 <=== 1 0 1 0 0 0 0 0 0 8607835 0 36753

You seem to have a configuration with domains which don't have
SD_BALANCE_NEWIDLE  on (CONFIG_NUMA?) as there are no events (all
zeros above) for CPU_NEWLY_IDLE.

this one is being triggered whenever a cpu becomes idle (schedule()
--> idle_balance() --> load_balance_newidle()).

(this flag is a bit #1 == 2)

cat /proc/sys/kernel/sched_domain/cpu0/domain0/flags

?

it can be changed with "echo new_value > ..."

does a change of it make any difference?

moreover, /proc/sys/kernel/sched_domain/cpu1/domain0/newidle_idx seems
to be responsible for a source of the load for calculating the busiest
group. e.g. with newidle_idx == 0, the current load on the queue is
used instead of cpu_load[].


>
> Thanks,
> --Micah
>

-- 
Best regards,
Dmitry Adamushko
