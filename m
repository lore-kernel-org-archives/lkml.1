Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbZIPHyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbZIPHyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 03:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbZIPHyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 03:54:13 -0400
Received: from james.oetiker.ch ([213.144.138.195]:50115 "EHLO
	james.oetiker.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbZIPHyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 03:54:13 -0400
Date: Wed, 16 Sep 2009 09:54:12 +0200 (CEST)
From: Tobias Oetiker <tobi@oetiker.ch>
To: Corrado Zoccolo <czoccolo@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: unfair io behaviour for high load interactive use still present
 in 2.6.31
In-Reply-To: <4e5e476b0909160029l296efe2fk7b873ac68f6bb6a3@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0909160935240.14727@sebohet.brgvxre.pu>
References: <alpine.DEB.2.00.0909150844140.19305@sebohet.brgvxre.pu>  <4e5e476b0909150753k699a2f5awadc666a9b3afebfa@mail.gmail.com>  <alpine.DEB.2.00.0909152305030.14727@sebohet.brgvxre.pu> <4e5e476b0909160029l296efe2fk7b873ac68f6bb6a3@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463760128-146789849-1253087653=:14727"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463760128-146789849-1253087653=:14727
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

HI Corrado,

Today Corrado Zoccolo wrote:

> Hi Tobias,
> On Tue, Sep 15, 2009 at 11:07 PM, Tobias Oetiker <tobi@oetiker.ch> wrote:
> >
> > Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> > ---------------------------------------------------------------------------------------------------------
> > dm-18             0.00     0.00    0.00 2566.80     0.00    10.03     8.00  2224.74  737.62   0.39 100.00
> > dm-18             0.00     0.00    9.60  679.00     0.04     2.65     8.00   400.41 1029.73   1.35  92.80
> > dm-18             0.00     0.00    0.00 2080.80     0.00     8.13     8.00   906.58  456.45   0.48 100.00
> > dm-18             0.00     0.00    0.00 2349.20     0.00     9.18     8.00  1351.17  491.44   0.43 100.00
> > dm-18             0.00     0.00    3.80  665.60     0.01     2.60     8.00   906.72 1098.75   1.39  93.20
> > dm-18             0.00     0.00    0.00 1811.20     0.00     7.07     8.00  1008.23  725.34   0.55 100.00
> > dm-18             0.00     0.00    0.00 2632.60     0.00    10.28     8.00  1651.18  640.61   0.38 100.00
> >
>
> Good.
> The high await is normal for writes, especially since you get so many
> queued requests.
> can you post the output of "grep -r .  /sys/block/_device_/queue/" and
> iostat for your real devices?
> This should not affect reads, that will preempt writes with cfq.

/sys/block/sdc/queue/nr_requests:128
/sys/block/sdc/queue/read_ahead_kb:128
/sys/block/sdc/queue/max_hw_sectors_kb:2048
/sys/block/sdc/queue/max_sectors_kb:512
/sys/block/sdc/queue/scheduler:noop anticipatory deadline [cfq]
/sys/block/sdc/queue/hw_sector_size:512
/sys/block/sdc/queue/logical_block_size:512
/sys/block/sdc/queue/physical_block_size:512
/sys/block/sdc/queue/minimum_io_size:512
/sys/block/sdc/queue/optimal_io_size:0
/sys/block/sdc/queue/rotational:1
/sys/block/sdc/queue/nomerges:0
/sys/block/sdc/queue/rq_affinity:0
/sys/block/sdc/queue/iostats:1
/sys/block/sdc/queue/iosched/quantum:4
/sys/block/sdc/queue/iosched/fifo_expire_sync:124
/sys/block/sdc/queue/iosched/fifo_expire_async:248
/sys/block/sdc/queue/iosched/back_seek_max:16384
/sys/block/sdc/queue/iosched/back_seek_penalty:2
/sys/block/sdc/queue/iosched/slice_sync:100
/sys/block/sdc/queue/iosched/slice_async:40
/sys/block/sdc/queue/iosched/slice_async_rq:2
/sys/block/sdc/queue/iosched/slice_idle:8

but as I said in my original post. I have done extensive tests,
twiddly all the knobs I know of and the only thing that never
changed, was that as soon as writers come into play, the readers
get starved pretty thorowly.

> >
> > in the read/write test the write rate stais down, but the rMB/s is even worse and the await is also way up,
> > so I guess the bad performance is not to blame on the the cache in the controller ...
> >
> > Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> > ---------------------------------------------------------------------------------------------------------
> > dm-18             0.00     0.00    0.00 1225.80     0.00     4.79     8.00  1050.49  807.38   0.82 100.00
> > dm-18             0.00     0.00    0.00 1721.80     0.00     6.73     8.00  1823.67  807.20   0.58 100.00
> > dm-18             0.00     0.00    0.00 1128.00     0.00     4.41     8.00   617.94  832.52   0.89 100.00
> > dm-18             0.00     0.00    0.00  838.80     0.00     3.28     8.00   873.04 1056.37   1.19 100.00
> > dm-18             0.00     0.00   39.60  347.80     0.15     1.36     8.00   590.27 1880.05   2.57  99.68
> > dm-18             0.00     0.00    0.00 1626.00     0.00     6.35     8.00   983.85  452.72   0.62 100.00
> > dm-18             0.00     0.00    0.00 1117.00     0.00     4.36     8.00  1047.16 1117.78   0.90 100.00
> > dm-18             0.00     0.00    0.00 1319.20     0.00     5.15     8.00   840.64  573.39   0.76 100.00
> >
>
> This is interesting. it seems no reads are happening at all here.
> I suspect that this and your observation that the real read throughput
> is much higher, can be explained because your readers mostly read from
> the page cache.


> Can you describe better how the test workload is structured,
> especially regarding cache?
> How do you say that some tars are just readers, and some are just
> writers? I suppose you pre-fault-in the input for writers, and you
> direct output to /dev/null for readers? Are all readers reading from
> different directories?

they are NOT ... what I do is this (http://tobi.oetiker.ch/fspunisher).

* get a copy of the linux kernel source an place it on tmpfs

* unpack 4 copies of the linux kernel for each reader process

* sync and echo 3 >/proc/sys/vm/drop_caches  (this should loose all
  cache)

* start the readers, each on its private copy of the kernel source,
  as prepared above writing their output to /dev/null.

* start an equal amount of tars unpacking the kernel archive from
  tmpfs into separate directories, next to the readers source
  directories.

the goal of this exercise is to simulate independent writers and
readers while excluding the cache as much as possible since I want
to see how the system deals with accessing the actual disk device
and not the local cache.
>
> Few things to check:
> * are the cpus saturated during the test?
nope

> * are the readers mostly in state 'D', or 'S', or 'R'?

they are almost alway in D (same as the writers) sleeping for IO

> * did you try 'as' I/O scheduler?

yes, this helps the readers a bit
but it does not help the 'smoothness'
of the system operation

> * how big are your volumes?

100 G

> * what is the average load on the system?

24 (or however many tars I start since they al want to run all the
time and are all waiting for IO)

> * with i/o controller patches, what happens if you put readers in one
> domain and writers in the other?

will try ... note though that this would have to happen
automatically since I can not know before hand who writes and who
reads ...

> Are you willing to test some patches? I'm working on patches to reduce
> read latency, that may be interesting to you.

by all means ... to repeat my goal, I want to see the readers not
starved by the writers, also I have a hunch that the handling of
metadata updates/access in the filesystem may play a role here.
In the dd tests these do not play a role but in real life I find
that often the problem is getting at the file, not reading the file
once I have it ... this is especially tricky to test since there is
good caching on this and this can pretty quickly distort the
results if not handled carefully.

cheers
tobi

-- 
Tobi Oetiker, OETIKER+PARTNER AG, Aarweg 15 CH-4600 Olten, Switzerland
http://it.oetiker.ch tobi@oetiker.ch ++41 62 775 9902 / sb: -9900
---1463760128-146789849-1253087653=:14727--
