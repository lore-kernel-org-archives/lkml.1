Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbZBJRcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbZBJRcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 12:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbZBJRci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 12:32:38 -0500
Received: from rn-out-0910.google.com ([64.233.170.185]:43408 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbZBJRch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 12:32:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CnuTBxrq/4/JKNNObOWySa9RJ//mCvYfUxDNnWHnpdql7ByoVhon7kL1Uwk6SQYXrT
         FNwQrxywM1rkhkNm6zjwqvMFfKeRVadQrNZorCQgdTHXQoC3lCPHzVxbAFKhviY8YDx5
         OXFXhaB2elhOOggIUdp5UsIoK3QTZDszXinEQ=
MIME-Version: 1.0
In-Reply-To: <1234281602.23438.96.camel@twins>
References: <b6a2d2e20902091130ha452a97rcfaa2972bfdbe710@mail.gmail.com>
	 <1234209174.5951.165.camel@laptop>
	 <b6a2d2e20902091204p2391799p160ce13971e9f779@mail.gmail.com>
	 <1234271177.23438.24.camel@twins>
	 <b6a2d2e20902100646q6c7073cse86b8f5790a120ac@mail.gmail.com>
	 <1234281602.23438.96.camel@twins>
Date: Tue, 10 Feb 2009 17:32:34 +0000
Message-ID: <b6a2d2e20902100932i475c1ee8va99de6e433a6d89a@mail.gmail.com>
Subject: Re: cgroup, RT reservation per core(s)?
From: Rolando Martins <rolando.martins@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/10/09, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2009-02-10 at 14:46 +0000, Rolando Martins wrote:
>  >
>  > >  I've never actually tried anything like this, let me know if it
>  > >  works ;-)
>  > >
>  >
>  > Thanks Peter, it works!
>
>  > I am thinking for different strategies to be used in my rt middleware
>  > project, and I think there is a limitation.
>  > If I wanted to have some RT on the B cpuset, I couldn't because I
>  > assigned A.cpu.rt_runtime_ns = root.cpu.rt_runtime_ns (then subdivided
>  > the A cpuset, with 2,3,4, each one having A.cpu.rt_runtime_ns/3).
>
>
> Try it, you can run RT proglets in B.
>
>  You get n*utilization per schedule domain, where n is the number of cpus
>  in it.
>
>  So you still have 200% left in B, even if you use 200% of A.
>
>
>  > This happens because there is a
>  > global /proc/sys/kernel/sched_rt_runtime_us and
>  > /proc/sys/kernel/sched_rt_period_us.
>
>
> These globals don't actually do much (except provide a global cap) in
>  the cgroup case.
>
>
>  > What do you think about adding a separate tuple (runtime,period) for
>  > each core/cpu?
>
>
> > Does this make sense? ;)
>
>  That's going to give me a horrible head-ache trying to load-balance
>  stuff.
>
Sorry Peter, but I didn't think before typing;)
I was looking at the cgroups as more integrated (rigid;) ) infrastructure,
and therefore using only a mount point for all the operations... :x

Now I got everything working properly! Thanks for the support.

For helping others:

mkdir /dev/cpuset
mount -t cgroup -o cpuset none /dev/cpuset
cd /dev/cpuset
echo 0 > cpuset.sched_load_balance
mkdir A
echo 0-1 > A/cpuset.cpus
echo 0 > A/cpuset.mems
mkdir B
echo 2-3 > B/cpuset.cpus
echo 0 > B/cpuset.mems


mount -t cgroup -o cpu none /dev/sched_domain
cd /dev/sched_domain
mkdir 1
echo cpu.rt_runtime_ns > 1/cpu.rt_runtime_ns
mkdir 1/2
echo 33333 > 1/2/cpu.rt_runtime_ns
mkdir 1/3
echo 33333 > 1/3/cpu.rt_runtime_ns
mkdir 1/4
echo 33333 > 1/3/cpu.rt_runtime_ns

For example, setting the current shell to a specific cpuset(A) and sched(1/2):

echo $$ > /dev/cpuset/A/tasks
echo $$ > /dev/sched_domain/1/2/tasks
"execute program"


Peter, can you confirm this code? ;)

Thanks!
Rol
