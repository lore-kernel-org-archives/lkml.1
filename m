Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbZIPH3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbZIPH3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 03:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbZIPH3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 03:29:05 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:4868 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbZIPH3D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 03:29:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hmkCkb1TjdWOl1KPosI3OTGRb4W2eIS8k8PKigQIW9Y4siZz9ewp6M6eaKgZ6fLncs
         HcMz1IEP+f03N05qyXpmuM5aNVDKpKc8pvzhg7iSprdpfV0I6JKjflVEQA4W0W/nFHHT
         2Ab+tV+bhcRc/nN4aZHZj3dM9DpbC8lx+dhgk=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0909152305030.14727@sebohet.brgvxre.pu>
References: <alpine.DEB.2.00.0909150844140.19305@sebohet.brgvxre.pu>
	 <4e5e476b0909150753k699a2f5awadc666a9b3afebfa@mail.gmail.com>
	 <alpine.DEB.2.00.0909152305030.14727@sebohet.brgvxre.pu>
Date: Wed, 16 Sep 2009 09:29:05 +0200
Message-ID: <4e5e476b0909160029l296efe2fk7b873ac68f6bb6a3@mail.gmail.com>
Subject: Re: unfair io behaviour for high load interactive use still present 
	in 2.6.31
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Tobias Oetiker <tobi@oetiker.ch>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tobias,
On Tue, Sep 15, 2009 at 11:07 PM, Tobias Oetiker <tobi@oetiker.ch> wrote:
> Today Corrado Zoccolo wrote:
>
>> On Tue, Sep 15, 2009 at 9:30 AM, Tobias Oetiker <tobi@oetiker.ch> wrote:
>> > Below is an excerpt from iostat while the test is in full swing:
>> >
>> > * 2.6.31 (8 cpu x86_64, 24 GB Ram)
>> > * scheduler = cfq
>> > * iostat -m -x dm-5 5
>> > * running in parallel on 3 lvm logical volumes
>> >  on a single physical volume
>> >
>> > Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
>> > ---------------------------------------------------------------------------------------------------------
>> > dm-5             0.00     0.00   26.60 7036.60     0.10    27.49     8.00   669.04   91.58   0.09  66.96
>> > dm-5             0.00     0.00   63.80 2543.00     0.25     9.93     8.00  1383.63  539.28   0.36  94.64
>> > dm-5             0.00     0.00   78.00 5084.60     0.30    19.86     8.00  1007.41  195.12   0.15  77.36
>> > dm-5             0.00     0.00   44.00 5588.00     0.17    21.83     8.00   516.27   91.69   0.17  95.44
>> > dm-5             0.00     0.00    0.00 6014.20     0.00    23.49     8.00  1331.42   66.25   0.13  76.48
>> > dm-5             0.00     0.00   28.80 4491.40     0.11    17.54     8.00  1000.37  412.09   0.17  78.24
>> > dm-5             0.00     0.00   36.60 6486.40     0.14    25.34     8.00   765.12  128.07   0.11  72.16
>> > dm-5             0.00     0.00   33.40 5095.60     0.13    19.90     8.00   431.38   43.78   0.17  85.20
>> >
>> > for comparison these are the numbers for seen when running the test
>> > with just the writing enabled
>> >
>> > Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
>> > ---------------------------------------------------------------------------------------------------------
>> > dm-5             0.00     0.00    4.00 12047.40    0.02    47.06     8.00   989.81   79.55   0.07  79.20
>> > dm-5             0.00     0.00    3.40 12399.00    0.01    48.43     8.00   977.13   72.15   0.05  58.08
>> > dm-5             0.00     0.00    3.80 13130.00    0.01    51.29     8.00  1130.48   95.11   0.04  58.48
>> > dm-5             0.00     0.00    2.40 5109.20     0.01    19.96     8.00   427.75   47.41   0.16  79.92
>> > dm-5             0.00     0.00    3.20    0.00     0.01     0.00     8.00   290.33 148653.75 282.50  90.40
>> > dm-5             0.00     0.00    3.40 5103.00     0.01    19.93     8.00   168.75   33.06   0.13  67.84
>> >
>>
>> From the numbers, it appears that your controller (or the disks) is
>> lying about writes. They get cached (service time around 0.1ms) and
>> reported as completed. When the cache is full, or a flush is issued,
>> you get >200ms delay.
>> Reads, instead, have a more reasonable service time of around 2ms.
>>
>> Can you disable write cache, and see if the response times for writes
>> become reasonable?
>
> sure can ... the write-only results look like this. As you have predicted,
> the wMB has gone down to more realistic levels ... but also the await has gone way up.
>
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> ---------------------------------------------------------------------------------------------------------
> dm-18             0.00     0.00    0.00 2566.80     0.00    10.03     8.00  2224.74  737.62   0.39 100.00
> dm-18             0.00     0.00    9.60  679.00     0.04     2.65     8.00   400.41 1029.73   1.35  92.80
> dm-18             0.00     0.00    0.00 2080.80     0.00     8.13     8.00   906.58  456.45   0.48 100.00
> dm-18             0.00     0.00    0.00 2349.20     0.00     9.18     8.00  1351.17  491.44   0.43 100.00
> dm-18             0.00     0.00    3.80  665.60     0.01     2.60     8.00   906.72 1098.75   1.39  93.20
> dm-18             0.00     0.00    0.00 1811.20     0.00     7.07     8.00  1008.23  725.34   0.55 100.00
> dm-18             0.00     0.00    0.00 2632.60     0.00    10.28     8.00  1651.18  640.61   0.38 100.00
>

Good.
The high await is normal for writes, especially since you get so many
queued requests.
can you post the output of "grep -r .  /sys/block/_device_/queue/" and
iostat for your real devices?
This should not affect reads, that will preempt writes with cfq.

>
> in the read/write test the write rate stais down, but the rMB/s is even worse and the await is also way up,
> so I guess the bad performance is not to blame on the the cache in the controller ...
>
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> ---------------------------------------------------------------------------------------------------------
> dm-18             0.00     0.00    0.00 1225.80     0.00     4.79     8.00  1050.49  807.38   0.82 100.00
> dm-18             0.00     0.00    0.00 1721.80     0.00     6.73     8.00  1823.67  807.20   0.58 100.00
> dm-18             0.00     0.00    0.00 1128.00     0.00     4.41     8.00   617.94  832.52   0.89 100.00
> dm-18             0.00     0.00    0.00  838.80     0.00     3.28     8.00   873.04 1056.37   1.19 100.00
> dm-18             0.00     0.00   39.60  347.80     0.15     1.36     8.00   590.27 1880.05   2.57  99.68
> dm-18             0.00     0.00    0.00 1626.00     0.00     6.35     8.00   983.85  452.72   0.62 100.00
> dm-18             0.00     0.00    0.00 1117.00     0.00     4.36     8.00  1047.16 1117.78   0.90 100.00
> dm-18             0.00     0.00    0.00 1319.20     0.00     5.15     8.00   840.64  573.39   0.76 100.00
>

This is interesting. it seems no reads are happening at all here.
I suspect that this and your observation that the real read throughput
is much higher, can be explained because your readers mostly read from
the page cache.
Can you describe better how the test workload is structured,
especially regarding cache?
How do you say that some tars are just readers, and some are just
writers? I suppose you pre-fault-in the input for writers, and you
direct output to /dev/null for readers? Are all readers reading from
different directories?

Few things to check:
* are the cpus saturated during the test?
* are the readers mostly in state 'D', or 'S', or 'R'?
* did you try 'as' I/O scheduler?
* how big are your volumes?
* what is the average load on the system?
* with i/o controller patches, what happens if you put readers in one
domain and writers in the other?

Are you willing to test some patches? I'm working on patches to reduce
read latency, that may be interesting to you.

Corrado

> cheers
> tobi
>
> --
> Tobi Oetiker, OETIKER+PARTNER AG, Aarweg 15 CH-4600 Olten, Switzerland
> http://it.oetiker.ch tobi@oetiker.ch ++41 62 775 9902 / sb: -9900



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
