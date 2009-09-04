Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbZIDHWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbZIDHWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756606AbZIDHWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:22:31 -0400
Received: from mail-yx0-f182.google.com ([209.85.210.182]:43311 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602AbZIDHWa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 03:22:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HKRvUX+EflZy0h2CA1ls/ZLEQnj3aMp33806rS43sJ/vzhFLPPzRQi72VfIfIRvQ8+
         cT/GUIcuRHBu/QyIgmV5nYO2EFymmcuxinCHsh29v9RzjbT7eVwQsq7ewvQwavSTH9IT
         lNrQc02/qzspE/i01TELq07SEnzn2GpWeSfmo=
MIME-Version: 1.0
In-Reply-To: <x49ws4gvthg.fsf@segfault.boston.devel.redhat.com>
References: <4e5e476b0909030407k8a7b534v42bdffcad06127bd@mail.gmail.com>
	 <x49ljkwxjvr.fsf@segfault.boston.devel.redhat.com>
	 <x49ab1cxcma.fsf@segfault.boston.devel.redhat.com>
	 <4e5e476b0909030947m2423d0cdr5fd2b3de261b2da6@mail.gmail.com>
	 <x49ws4gvthg.fsf@segfault.boston.devel.redhat.com>
Date: Fri, 4 Sep 2009 09:22:31 +0200
Message-ID: <4e5e476b0909040022o6138218dte877093332d830dd@mail.gmail.com>
Subject: Re: [RFC] cfq: adapt slice to number of processes doing I/O
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

On Thu, Sep 3, 2009 at 7:16 PM, Jeff Moyer<jmoyer@redhat.com> wrote:
> Corrado Zoccolo <czoccolo@gmail.com> writes:
>
>> Hi Jeff,
>> can you share the benchmark?
>
> Of course, how miserly of me!
>
> http://people.redhat.com/jmoyer/cfq-regression-tests-0.0.1.tar.gz
>
>> I think I have to fix the min slice to consider priority, too, to
>> respect the priorities when there are many processes.
>>
>> For the fairness at a single priority level, my tests show that
>> fairness is improved with the patches (comparing minimum and maximum
>> bandwidth for a set of 32 processes):
>>
>> Original:
>> Run status group 0 (all jobs):
>>    READ: io=14192KiB, aggrb=480KiB/s, minb=7KiB/s, maxb=20KiB/s,
>> mint=30001msec, maxt=30258msec
>>
>> Run status group 1 (all jobs):
>>    READ: io=829292KiB, aggrb=27816KiB/s, minb=723KiB/s,
>> maxb=1004KiB/s, mint=30004msec, maxt=30529msec
>>
>> Adaptive:
>> Run status group 0 (all jobs):
>>    READ: io=14444KiB, aggrb=488KiB/s, minb=12KiB/s, maxb=17KiB/s,
>> mint=30003msec, maxt=30298msec
>>
>> Run status group 1 (all jobs):
>>    READ: io=721324KiB, aggrb=24140KiB/s, minb=689KiB/s, maxb=795KiB/s,
>> mint=30003msec, maxt=30598msec
>>
>> Are you using random think times? This could explain the discrepancy.
>
> No, it's just a sync read benchmark.  It's the be4-x-8.fio job file in
> the tarball mentioned above.  Note that the run-time is only 10 seconds,
> so maybe that's not enough to get accurate data?  If you try increasing
> it, be careful that you don't read in the entire file and wrap back
> around, as this is a buffered read test, that will skew the results.
>
I could reproduce the skew on my setup, but with a different pattern than yours.
I think the reason is, in my case, that, since the files are very
large (and the fs partially filled), they are allocated on places with
different read speed.
Even cutting file size by half, in order to fit the benchmark on my disk, I get:

[root@et2 cfq-regression-tests]# for i in `seq 1 8`; do sync; echo 3 >
/proc/sys/vm/drop_caches; dd if=/media/lacie/testfile$i of=/dev/null
bs=1M count=30; done
30+0 records in
30+0 records out
31457280 bytes (31 MB) copied, 0,978737 s, 32,1 MB/s
30+0 records in
30+0 records out
31457280 bytes (31 MB) copied, 0,971206 s, 32,4 MB/s
30+0 records in
30+0 records out
31457280 bytes (31 MB) copied, 1,04638 s, 30,1 MB/s
30+0 records in
30+0 records out
31457280 bytes (31 MB) copied, 1,18266 s, 26,6 MB/s
30+0 records in
30+0 records out
31457280 bytes (31 MB) copied, 1,32781 s, 23,7 MB/s
30+0 records in
30+0 records out
31457280 bytes (31 MB) copied, 1,33056 s, 23,6 MB/s
30+0 records in
30+0 records out
31457280 bytes (31 MB) copied, 1,71092 s, 18,4 MB/s
30+0 records in
30+0 records out
31457280 bytes (31 MB) copied, 1,56802 s, 20,1 MB/s

Original cfq gives:
/home/corrado/cfq-regression-tests/cfq_orig/be4-x-8.fio
/home/corrado/cfq-regression-tests
total priority: 800
total data transferred: 179072
class	prio	ideal	xferred	%diff
be	4	22384	28148	25
be	4	22384	29428	31
be	4	22384	27380	22
be	4	22384	23524	5
be	4	22384	20964	-7
be	4	22384	22004	-2
be	4	22384	12020	-47
be	4	22384	15604	-31

patched cfq is a bit more skewed, but follows the same pattern:
/home/corrado/cfq-regression-tests/cfq_adapt/be4-x-8.fio
/home/corrado/cfq-regression-tests
total priority: 800
total data transferred: 204088
class	prio	ideal	xferred	%diff
be	4	25511	34020	33
be	4	25511	34020	33
be	4	25511	32484	27
be	4	25511	28388	11
be	4	25511	24628	-4
be	4	25511	24940	-3
be	4	25511	10276	-60
be	4	25511	15332	-40
/home/corrado/cfq-regression-tests

I think it is more skewed because the seek time, with a smaller slice,
impacts more on the amount of transferred data for slower transfer
rates, as shown below:
The amount of data transferred per slice is given by:
(1)  slice = seek + amount * rate
if we multiply slice by alpha < 1, we can transfer a different amount
of data (amount1):
(2)  alpha* slice = seek + amount1 * rate
substituting slice from (1) into (2), to express amount1 as a function
of amount:
alpha* (seek + amount *rate) = seek + amount1 *rate
amount1 = amount - (1-alpha)* seek / rate
where we see that decreasing rate, increases the impact of seek time.

Your data, though, seems very different from mine, in fact vanilla
doesn't show the same difference.
Can you try running vanilla with smaller base slices, to see if the
same effect can be seen there?
echo 15 > /sys/block/sdb/queue/iosched/slice_async
echo 37 > /sys/block/sdb/queue/iosched/slice_sync
If this doesn't exhibit the same pattern, then maybe the problem is
that the number of busy queues observed by the processes is
consistently different, resulting in unequal time slices.
In that case, I'll add some averaging.

I also added a "sync; echo 3 > /proc/sys/vm/drop_caches" in ioprio.sh
before each test. It is not strictly necessary, because you already
unmount the test FS, but helps reducing the pressure on VM, so that
doing I/O on our files doesn't cause dependent I/O on others as well
to free up space.

Thanks,
Corrado

> Cheers,
> Jeff
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
