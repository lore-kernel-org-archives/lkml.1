Return-Path: <linux-kernel-owner+w=401wt.eu-S1755119AbXKVUVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbXKVUVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 15:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbXKVUVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 15:21:23 -0500
Received: from waste.org ([66.93.16.53]:38993 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbXKVUVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 15:21:22 -0500
Date: Thu, 22 Nov 2007 14:19:25 -0600
From: Matt Mackall <mpm@selenic.com>
To: Jie Chen <chen@jlab.org>
Cc: Simon Holm Th??gersen <odie@cs.aau.dk>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
Subject: Re: Possible bug from kernel 2.6.22 and above
Message-ID: <20071122201925.GH17536@waste.org>
References: <4744966C.900@jlab.org> <4744ADA9.7040905@cosmosbay.com> <4744E0DC.7050808@jlab.org> <1195698770.11808.4.camel@odie.local> <4744F042.4070002@jlab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4744F042.4070002@jlab.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2007 at 09:58:10PM -0500, Jie Chen wrote:
> Simon Holm Th??gersen wrote:
> >ons, 21 11 2007 kl. 20:52 -0500, skrev Jie Chen:
> 
> >There is a backport of the CFS scheduler to 2.6.21, see
> >http://lkml.org/lkml/2007/11/19/127
> >
> Hi, Simon:
> 
> I will try that after the thanksgiving holiday to find out whether the 
> odd behavior will show up using 2.6.21 with back ported CFS.
> 
> >>>>Kernel 2.6.21
> >>>>Number of Threads              2          4           6         8
> >>>>SpinLock (Time micro second)   10.5618    10.58538    10.5915   10.643
> >>>>                  (Overhead)   0.073      0.05746     0.102805 0.154563
> >>>>Barrier (Time micro second)    11.020410  11.678125   11.9889   12.38002
> >>>>                 (Overhead)    0.531660   1.1502      1.500112 1.891617
> >>>>
> >>>>Each thread is bound to a particular core using pthread_setaffinity_np.
> >>>>
> >>>>Kernel 2.6.23.8
> >>>>Number of Threads              2          4           6         8
> >>>>SpinLock (Time micro second)   14.849915  17.117603   14.4496   10.5990
> >>>>                 (Overhead)    4.345417   6.617207    3.949435  0.110985
> >>>>Barrier (Time micro second)    19.462255  20.285117   16.19395  12.37662
> >>>>                 (Overhead)    8.957755   9.784722    5.699590  1.869518
> >>>>
> 
> >
> >
> >Simon Holm Th??gersen
> >
> >
> I just ran a simple test to prove that the problem may be related to 
> load balance of the scheduler. I first started 6 processes using 
> "taskset -c 2 donothing&; taskset -c 3 donothing&; ..., taskset -c 7 
> donothing". These 6 processes will run on core 2 to 7. Then I started my 
> test program using two threads bound to core 0 and 1. Here is the result:
> 
> Two threads on Kernel 2.6.23.8:
> SpinLock (Time micro second)             10.558255
>          (Overhead)                      0.068965
> Barrier  (Time micro second)             10.865520
>          (Overhead)                      0.376230
> 
> Similarly, I started 4 donothing processes on core 4, 5, 6 and 7, and 
> ran the test program. I have the following result:
> 
> Four threads on Kernel 2.6.23.8:
> SpinLock (Time micro second)             10.579413
>          (Overhead)                      0.090023
> Barrier  (Time micro second)             11.363193
>          (Overhead)                      0.873803
> 
> Finally, here is the result for 6 threads with two donothing processes 
> running on core 6 and 7:
> 
> Six threads on Kernel 2.6.23.8:
> SpinLock (Time micro second)             10.590030
>          (Overhead)                      0.100940
> Barrier  (Time micro second)             11.977548
>          (Overhead)                      1.488458
> 
> Now the above results are very much similar to the results obtained for 
> the kernel 2.6.21. I hope this helps you guys in some ways. Thank you.

Yes, this really does look like a scheduling regression. I've added
Ingo to the cc: list. Next time you should pick a more descriptive
subject line - we've got lots of email about possible bugs.

-- 
Mathematics is the supreme nostalgia of our time.
