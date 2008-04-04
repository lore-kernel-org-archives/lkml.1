Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbYDDKfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbYDDKfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 06:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbYDDKew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 06:34:52 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:45512 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbYDDKev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 06:34:51 -0400
Date: Fri, 4 Apr 2008 12:34:50 +0200
From: Jan Kara <jack@suse.cz>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, David Chinner <dgc@sgi.com>,
       lkml <linux-kernel@vger.kernel.org>, marcelo <marcelo@kvack.org>
Subject: Re: BUG: ext3 hang in transaction commit
Message-ID: <20080404103450.GC477@atrey.karlin.mff.cuni.cz>
References: <20080326231612.GC103491721@sgi.com> <20080403100742.GA16314@atrey.karlin.mff.cuni.cz> <1207235335.8514.843.camel@twins> <20080403161500.GA21434@dmt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080403161500.GA21434@dmt>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

> On Thu, Apr 03, 2008 at 05:08:55PM +0200, Peter Zijlstra wrote:
> > 
> > Marcelo has seen something similar, kjournald got stuck and the rest of
> > userspace piled on top of it.
> > 
> > The softlockup watchdog triggered because kjournald got stuck in D state
> > for over 2 minutes. However Marcelo told me that it did get going
> > eventually...
> > 
> > He had a rather easy to reproduce case IIRC, I'll let him tell you more
> > about it :-)
> 
> Run iozone (-t 4) with a sufficiently large file size under a KVM guest
> with a disk file residing in an ext3 filesystem with ordered data mode.
> 
> There's nothing special in this testcase, boils down to the QEMU process
> writing data to a file.
  Yes, this just means, generate tons of ordered data.

> Issue is not seen under "writeback" mode. While fsync latency in ordered
> data mode is known to be bad, _2 minutes_ feels more like a DoS rather
> than latency issue to me.
> 
> vmstat 2 output on the host shows that the first write pass (initial
> writers and rewriters) blasts at full disk speed:
  OK, here the data is generated nicely ordered on disk...

>  0  2      0 6552980 748972 662876    0    0    58 69838  322 9912  5  6 78 10  0
>  1  1      0 6493620 779452 693596    0    0    10 54884  417 7032  1  3 78 17  0
>  1  2      0 6322968 870556 772156    0    0    58 43042  379 12651  4  7 77 12  0
>  1  1      0 6248416 915004 806428    0    0    20 37600  367 7800  2  4 71 23  0
>  1  0      0 5981148 1070300 906120    0    0    88    64  243 19734  8 10 80  1  0
>  0  4      0 5875992 1165220 906700    0    0    80 62620  332 13192  5  7 76 13  0
>  0  4      0 5867244 1177440 906724    0    0    10 66728  385 2753  1  2 66 31  0
>  0  2      0 5792912 1252668 907900    0    0    86 26288  401 12130  4  6 72 18  0
>  2  0      0 5760280 1290860 908092    0    0    18 34704  487 7130  2  3 80 15  0
> 
> But in the "mixed workload" stage write throughtput slows down drastically:
  And here we get random access to the file which we currently translate
to random access on transaction commit (as the commit code writes out
the data in the order in which they were dirtied).

>  0  2      0 5666016 468036 1823052    0    0     0  1248  433 8236  5  5 83  7  0
>  0  2      0 5666016 468036 1823052    0    0     0  3162  899  679  0  0 78 22  0
>  0  2      0 5666016 468036 1823052    0    0     0  3290  864  829  0  0 76 24  0
>  0  2      0 5666024 468036 1823052    0    0     0  3414  925 2170  1  1 79 19  0
>  1  1      0 5665528 468036 1823052    0    0     0  3148  854 7935  6  6 83  4  0
>  0  2      0 5665024 468036 1823052    0    0     0  2570  799 4065  3  4 80 13  0
>  0  2      0 5665024 468036 1823052    0    0     0  2462  779  464  0  0 88 12  0
>  0  2      0 5664908 468036 1823052    0    0     0  2458  794 1028  0  0 88 12  0
>  1  1      0 5664908 468036 1823052    0    0     0  2548  799 4153  2  2 87  9  0
> 
> Which can be seen in the iozone performance inside the guest:
> 
>         Children see throughput for 4 mixed workload    =  106073.50 KB/sec
>         Parent sees throughput for 4 mixed workload     =    2560.13 KB/sec
>         Min throughput per process                      =    3700.33 KB/sec
>         Max throughput per process                      =   66393.62 KB/sec
>         Avg throughput per process                      =   26518.38 KB/sec
>         Min xfer                                        =   44424.00 KB
> 
> And this is when fsync becomes nasty.
  Could you get for me movies from Seekwatcher (taken on the host) -
http://oss.oracle.com/~mason/seekwatcher/
  That should confirm my suspicion. Actually, if writing data in the bad
order is really the problem than my rewrite of ordered mode in JBD can
substantially help this workload (I can send you the patches if you dare
to try something really experimental ;).

> blktrace output shows that the maximum latency for a single write
> request io complete is 1.5 seconds, which is similar to what is seen
> under "writeback" mode.
> 
> I reduced hung_task_timeout_secs to 30 for this report, but vim and
> rsyslogd have been seen hung up to 120 seconds.
> 

<snip traces of processes waiting for commit>

> As Peter mentioned it eventually gets out of this state (after several
> minutes) and fsync instances complete.
  Yes, that is just a combined effect of *lots* of ordered data
accumulated in one transaction (we don't limit amount of ordered data in
a transaction in any way) and writing them out during transaction order
in a random order.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
