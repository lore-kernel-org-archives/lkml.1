Return-Path: <linux-kernel-owner+w=401wt.eu-S1759616AbXLLQqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759616AbXLLQqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 11:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756068AbXLLQqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 11:46:21 -0500
Received: from phunq.net ([64.81.85.152]:40467 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752125AbXLLQqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 11:46:20 -0500
From: Daniel Phillips <phillips@phunq.net>
To: linux-kernel@vger.kernel.org
Subject: A peek at the future of storage
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
Date: Wed, 12 Dec 2007 08:46:18 -0800
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200712120846.18320.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The imminent demise of rotating media storage has been predicted for 
many years now, and here is a device that aims to help turn that 
fantasy into fact: 

   http://www.violin-memory.com/products/violin1010.html

Well.  At least if you have the money, and are not bothered by the fact 
that that big box of ram in the picture (2U) only stores the same 
amount of data as a typical $100 sata disk.  But if you are the proud 
owner of a disk-bound application that cannot be scaled any other way, 
a device like this is going to be interesting to you right now.  Maybe 
in ten years time everybody will have something like this in their 
laptop.

The characteristics of a solid state disk such as this one are very 
interesting, and needless to say, somewhat different from rotating 
media.

Here is the big one:

    Seek time = 0

And this one is not so bad:

    Transfer latency = a handful of microseconds

And to round it out:

    Write bandwidth = about 1,000 MB/sec
    Read bandwidth = about 1,500 MB/sec

Violin gets these numbers because their device is essentially a huge 
ramdisk connected to a host server by a PCI-e 8x external bus.  Well, 
this is not just a box of DRAM, it is a box of raided (raid 3!) 
hot-swappable DRAM, and it runs Linux as a high level supervisor.  So 
to put it mildly, this is an interesting piece of equipment.

We had the good fortune to be able to run some preliminary benchmarks on 
one of the first of these machines off the production line.  As the 
Zumastor team (http://zumastor.org), naturally we were interested in 
the performance effect on our NAS application, which consists of knfsd 
running on top of a ddsnap virtual block device.

Using a run of the mill rackmount server connected to the Violin box, we 
found Ext3 capable of roughly 500 MB/Sec write speed and 650 MB/Sec 
read, for large linear transfers.  So some bandwidth got lost 
somewhere, but unfortunately we did not have time to go hunting and see 
where it went.  Still, hundreds of megabytes of read and write 
bandwidth are hardly something to sneeze at.  We went on to some higher 
level tests.

The thing that interested us most was, what would be the bottom line 
effect on NFS serving performance, with and without volume 
snapshotting.  We planned to compare this to the same machine serving 
data off a single sata disk.  It would have been nice to compare to, 
say, a 5 disk array as well, but unfortunately such a configuration 
could not be set up in the time available.  Later.

Ddsnap is a seek intensive storage application because it has to 
maintain a fairly complex data structure on disk, which may have to be 
updated on every write.  Those updates have to be durable, so add in 
the cost of a journal or moral equivalent.  This creates a scary amount 
of seek activity under heavy write loads.  So what happens on a solid 
state disk?  Obviously, things improve a lot.

Now a word about how one measures NFS performance.  Total throughput 
with lots of simulated clients?  One would think.  But actually, the 
fashion is to measure transaction latency for some given number of 
transactions per second.  Which is logical when you think about it: 
total throughput may well increase when you throw more traffic at a 
server, but what use is that if latency goes through the roof?  To know 
more about the esoterica of NFS benchmarking, see here:

    http://www.spec.org/sfs97r1/docs/sfs-3.0v11.html

The fstress test we use is an open source effort kindly contributed by 
Jeff Chase and Darrell Anderson of Duke University.  Thankyou very 
much, Jeff and Darrell.

    http://www.cs.duke.edu/ari/fstress/

I cannot attest to any particular relationsip between Spec SFS and 
fstress results.  So please do not compare our fstress numbers to 
commercially published Spec SFS results.  Though they attempt to 
measure much the same thing, the algorithms are not precisely the same, 
and that might cause results of fstress to be quite different from Spec 
SFS on the same hardware.  So, did I say, please do not compare these 
results to commercially published Spec SFS results?  Thankyou :-)

We ran three fstress tests:

  1. NFS served directly from an Ext3 volume
  2. NFS served from a ddsnap virtual volume with no snapshots
  3. NFS served from a ddsnap virtual volume holding one snapshot

Server Hardware:

    HP DL-385 with 8GB of RAM
    2 x dual-core opterons 2220
    Single SAS disk
    Violin 1010 connected via PCI-e 8x
    Chelsio 10GigE directly connected to client

Client hardware:

    Dell precision 380 with 10GigE

Test results using the Violin SSD device:

    http://zumastor.org/graphs/fstress.violin.jpg

We see that at 20,000 NFS operations per second, latency is only 6 
milliseconds per NFS operation on raw Ext3 and 9 milliseconds on a 
snapshotted virtual volume.  Unfortunately, we were unable to test 
higher transaction rates this time because instability with the 10 Gige 
network connection that could not be tracked down in the time that we 
had.  Until we have a chance to perform further tests, we can only 
guess how high the performance scales before latency goes vertical.

For comparison, we ran the same tests using a single sata disk in place 
of the Violin SSD:

    http://zumastor.org/graphs/fstress.sata.jpg

Here, network interface instability cut short our fstress runs, so we 
only got a few data points for snapshotted volumes.   However, as far 
as it goes, the relationship between raw, virtual and snapshotted 
latency looks similar to the results on the Violin SSD.   The raw 
results were obtained up to 2,000 operations per second, and there we 
already see 160 ms latency.  That is 20 times more latency at one tenth 
the operations per second.  So roughly speaking, the Violin SSD versus 
the sata disk speeds the whole system up by a factor of 200.  Pretty 
cool, hmm?

We learned a lot from these tests.  The first and most important news 
from our point of view is that snapshotting via ddsnap does not have a 
particularly horrible effect on NFS serving performance, either at the 
low end or the high end of the hardware performance spectrum.  This was 
a big relief for us, because we always worried that the copy-on-write 
strategy that was adopted for ddsnap can exhibit rather large write 
performance artifacts, over 10 times worse performance in some cases 
than a raw disk.  In practice, the awful write performance of NFS in 
general hides a lot of that write slowness, disk cache hides some more, 
and the relatively low balance of writes in the fstress algorithm hides 
yet more.  The gap between snapshotted and unsnapshotted performance 
seems to get wider on the SSD if anything, a counterintuitive result 
that is possibly explained by data bandwidth considerations as 
discussed below.

The next thing we learned is that a solid state disk makes NFS serving 
go an awful lot faster, other things being equal.  The news here is 
that all of the following turned out to scale very well: Ext3, the 
block layer, knfsd, networking, device mapper and ddsnap.  Personally, 
I was quite surprised at how well knfsd scales.  It seems to me that 
the popular wisdom has always been that our knfsd is something of a 
turtle, but when I went to read the code to find out why, I just could 
not find any glaring reason why that should be so.  And lo, we now see 
that it just ain't so.  Big kudos to all those who have worked on the 
code over the years to turn it into a great performer.  Very thrifty 
with CPU too.

A third thing we learned, is that we can run on at dizzying speeds under 
stupifying load for as long as we had time to test, without 
deadlocking. This was only possible due to our fixing instabilities in 
core kernel, which ties into another thread we have seen here on lkml 
recently.

Incidentally, we ran our tests with 128 knfsd threads.  The default of 8 
threads produces miserable performance on the SSD, which gave us a good 
scare on our initial test run.  It would be very nice to implement an 
algorithm to scale the knfsd thread pool automatically, in order to 
eliminate this class of thing that can go wrong.  If somebody became 
inspired to take on that little project that would be great, otherwise 
it is in our pipeline for, hmm, Christmas delivery.  (Exactly which 
Christmas is left unspecified.)

Now, it is really nice that just throwing an SSD at our software makes 
it run really fast, but naturally we want our software to go even 
faster.  Up till now, filesystem (and fancy virtual block device) 
optimization has been mainly about reducing seeks, because seeking is 
the big performance killer.  This is completely irrelevant with an SSD, 
because there is no seek time.  That brings the second biggest eater of 
performance to the top of the list: total data transfered per 
operation.  So to get even more performance out of the SSD, we must cut 
down the total data transferred.  In the case of ddsnap, that is not 
very hard, mainly because my initial design was pretty lazy about 
writing out lots of metadata blocks on each snapshot update.  I knew 
those writes would mostly go to nearby places, thus not adding a lot of 
extra seeks.  Now, with an eye to making SSD work better, we intend to 
amortize some of that traffic using a logical journaling strategy.  
This and other ideas waiting in the wings should cut metadata traffic 
by half or more.

So what does the arrival of SSD mean for filesystem development in 
general?  Fortunately, reducing total data transfers is also a good 
thing for rotating media, so long as the reduction is not obtained by 
adding more seeks.  The flip side is, reducing total data transfers 
suddenly becomes a lot more important.  Hence, Zumastor team will 
concentrate on optimizing ddsnap for both SSD and rotating media.  For 
pragmatic reasons, most optimization work will continue to be directed 
at the latter, but experience with this hardware has certainly changed 
our thinking about where we are headed in the long run.

Warm thanks to all who read this far and thanks to Violin Memory for 
providing us access to this very interesting hardware.

Daniel
