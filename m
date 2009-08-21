Return-Path: <linux-kernel-owner+w=401wt.eu-S932124AbZHUG6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbZHUG6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 02:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754684AbZHUG6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 02:58:10 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50265 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713AbZHUG6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 02:58:08 -0400
Date: Fri, 21 Aug 2009 08:58:09 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, benh@kernel.crashing.org,
       bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 0/6] Lazy workqueues
Message-ID: <20090821065809.GU12579@kernel.dk>
References: <1250763604-24355-1-git-send-email-jens.axboe@oracle.com> <4A8D47B8.6070001@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="iq/fWD14IMVFWBCD"
Content-Disposition: inline
In-Reply-To: <4A8D47B8.6070001@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iq/fWD14IMVFWBCD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 20 2009, Tejun Heo wrote:
> Hello, Jens.
> 
> Jens Axboe wrote:
> > After yesterdays rant on having too many kernel threads and checking
> > how many I actually have running on this system (531!), I decided to 
> > try and do something about it.
> 
> Heh... that's a lot.  How many cpus do you have there?  Care to share
> the output of "ps -ef"?

That system has 64 cpus. ps -ef attached.

> > My goal was to retain the workqueue interface instead of coming up with
> > a new scheme that required conversion (or converting to slow_work which,
> > btw, is an awful name :-). I also wanted to retain the affinity
> > guarantees of workqueues as much as possible.
> > 
> > So this is a first step in that direction, it's probably full of races
> > and holes, but should get the idea across. It adds a
> > create_lazy_workqueue() helper, similar to the other variants that we
> > currently have. A lazy workqueue works like a normal workqueue, except
> > that it only (by default) starts a core thread instead of threads for
> > all online CPUs. When work is queued on a lazy workqueue for a CPU
> > that doesn't have a thread running, it will be placed on the core CPUs
> > list and that will then create and move the work to the right target.
> > Should task creation fail, the queued work will be executed on the
> > core CPU instead. Once a lazy workqueue thread has been idle for a
> > certain amount of time, it will again exit.
> 
> Yeap, the approach seems simple and nice and resolves the problem of
> too many idle workers.

I think so too :-)

> > The patch boots here and I exercised the rpciod workqueue and
> > verified that it gets created, runs on the right CPU, and exits a while
> > later. So core functionality should be there, even if it has holes.
> > 
> > With this patchset, I am now down to 280 kernel threads on one of my test
> > boxes. Still too many, but it's a start and a net reduction of 251
> > threads here, or 47%!
> 
> I'm trying to find out whether the perfect concurrency idea I talked
> about on the other thread can be implemented in reasonable manner.
> Would you mind holding for a few days before investing too much effort
> into expanding this one to handle multiple workers?

No problem, I'll just get the races closed up in the existing version.

I think we basically have two classes of users here - one that the
existing workqueue scheme works well for, high performance work
execution where CPU affinity matters. The other is just slow work
execution (like the libata pio task stuff), which would be better
handled by a generic thread pool implementation. I think we should start
converting those users to slow_work, in fact I think I'll try libata to
try and set a good example :-)

-- 
Jens Axboe


--iq/fWD14IMVFWBCD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ps-ef.txt"

UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  3 09:53 ?        00:00:06 init [2]  
root         2     0  0 09:53 ?        00:00:00 [kthreadd]
root         3     2  0 09:53 ?        00:00:00 [migration/0]
root         4     2  0 09:53 ?        00:00:00 [ksoftirqd/0]
root         5     2  0 09:53 ?        00:00:00 [watchdog/0]
root         6     2  0 09:53 ?        00:00:00 [migration/1]
root         7     2  0 09:53 ?        00:00:00 [ksoftirqd/1]
root         8     2  0 09:53 ?        00:00:00 [watchdog/1]
root         9     2  0 09:53 ?        00:00:00 [migration/2]
root        10     2  0 09:53 ?        00:00:00 [ksoftirqd/2]
root        11     2  0 09:53 ?        00:00:00 [watchdog/2]
root        12     2  0 09:53 ?        00:00:00 [migration/3]
root        13     2  0 09:53 ?        00:00:00 [ksoftirqd/3]
root        14     2  0 09:53 ?        00:00:00 [watchdog/3]
root        15     2  0 09:53 ?        00:00:00 [migration/4]
root        16     2  0 09:53 ?        00:00:00 [ksoftirqd/4]
root        17     2  0 09:53 ?        00:00:00 [watchdog/4]
root        18     2  0 09:53 ?        00:00:00 [migration/5]
root        19     2  0 09:53 ?        00:00:00 [ksoftirqd/5]
root        20     2  0 09:53 ?        00:00:00 [watchdog/5]
root        21     2  0 09:53 ?        00:00:00 [migration/6]
root        22     2  0 09:53 ?        00:00:00 [ksoftirqd/6]
root        23     2  0 09:53 ?        00:00:00 [watchdog/6]
root        24     2  0 09:53 ?        00:00:00 [migration/7]
root        25     2  0 09:53 ?        00:00:00 [ksoftirqd/7]
root        26     2  0 09:53 ?        00:00:00 [watchdog/7]
root        27     2  0 09:53 ?        00:00:00 [migration/8]
root        28     2  0 09:53 ?        00:00:00 [ksoftirqd/8]
root        29     2  0 09:53 ?        00:00:00 [watchdog/8]
root        30     2  0 09:53 ?        00:00:00 [migration/9]
root        31     2  0 09:53 ?        00:00:00 [ksoftirqd/9]
root        32     2  0 09:53 ?        00:00:00 [watchdog/9]
root        33     2  0 09:53 ?        00:00:00 [migration/10]
root        34     2  0 09:53 ?        00:00:00 [ksoftirqd/10]
root        35     2  0 09:53 ?        00:00:00 [watchdog/10]
root        36     2  0 09:53 ?        00:00:00 [migration/11]
root        37     2  0 09:53 ?        00:00:00 [ksoftirqd/11]
root        38     2  0 09:53 ?        00:00:00 [watchdog/11]
root        39     2  0 09:53 ?        00:00:00 [migration/12]
root        40     2  0 09:53 ?        00:00:00 [ksoftirqd/12]
root        41     2  0 09:53 ?        00:00:00 [watchdog/12]
root        42     2  0 09:53 ?        00:00:00 [migration/13]
root        43     2  0 09:53 ?        00:00:00 [ksoftirqd/13]
root        44     2  0 09:53 ?        00:00:00 [watchdog/13]
root        45     2  0 09:53 ?        00:00:00 [migration/14]
root        46     2  0 09:53 ?        00:00:00 [ksoftirqd/14]
root        47     2  0 09:53 ?        00:00:00 [watchdog/14]
root        48     2  0 09:53 ?        00:00:00 [migration/15]
root        49     2  0 09:53 ?        00:00:00 [ksoftirqd/15]
root        50     2  0 09:53 ?        00:00:00 [watchdog/15]
root        51     2  0 09:53 ?        00:00:00 [migration/16]
root        52     2  0 09:53 ?        00:00:00 [ksoftirqd/16]
root        53     2  0 09:53 ?        00:00:00 [watchdog/16]
root        54     2  0 09:53 ?        00:00:00 [migration/17]
root        55     2  0 09:53 ?        00:00:00 [ksoftirqd/17]
root        56     2  0 09:53 ?        00:00:00 [watchdog/17]
root        57     2  0 09:53 ?        00:00:00 [migration/18]
root        58     2  0 09:53 ?        00:00:00 [ksoftirqd/18]
root        59     2  0 09:53 ?        00:00:00 [watchdog/18]
root        60     2  0 09:53 ?        00:00:00 [migration/19]
root        61     2  0 09:53 ?        00:00:00 [ksoftirqd/19]
root        62     2  0 09:53 ?        00:00:00 [watchdog/19]
root        63     2  0 09:53 ?        00:00:00 [migration/20]
root        64     2  0 09:53 ?        00:00:00 [ksoftirqd/20]
root        65     2  0 09:53 ?        00:00:00 [watchdog/20]
root        66     2  0 09:53 ?        00:00:00 [migration/21]
root        67     2  0 09:53 ?        00:00:00 [ksoftirqd/21]
root        68     2  0 09:53 ?        00:00:00 [watchdog/21]
root        69     2  0 09:53 ?        00:00:00 [migration/22]
root        70     2  0 09:53 ?        00:00:00 [ksoftirqd/22]
root        71     2  0 09:53 ?        00:00:00 [watchdog/22]
root        72     2  0 09:53 ?        00:00:00 [migration/23]
root        73     2  0 09:53 ?        00:00:00 [ksoftirqd/23]
root        74     2  0 09:53 ?        00:00:00 [watchdog/23]
root        75     2  0 09:53 ?        00:00:00 [migration/24]
root        76     2  0 09:53 ?        00:00:00 [ksoftirqd/24]
root        77     2  0 09:53 ?        00:00:00 [watchdog/24]
root        78     2  0 09:53 ?        00:00:00 [migration/25]
root        79     2  0 09:53 ?        00:00:00 [ksoftirqd/25]
root        80     2  0 09:53 ?        00:00:00 [watchdog/25]
root        81     2  0 09:53 ?        00:00:00 [migration/26]
root        82     2  0 09:53 ?        00:00:00 [ksoftirqd/26]
root        83     2  0 09:53 ?        00:00:00 [watchdog/26]
root        84     2  0 09:53 ?        00:00:00 [migration/27]
root        85     2  0 09:53 ?        00:00:00 [ksoftirqd/27]
root        86     2  0 09:53 ?        00:00:00 [watchdog/27]
root        87     2  0 09:53 ?        00:00:00 [migration/28]
root        88     2  0 09:53 ?        00:00:00 [ksoftirqd/28]
root        89     2  0 09:53 ?        00:00:00 [watchdog/28]
root        90     2  0 09:53 ?        00:00:00 [migration/29]
root        91     2  0 09:53 ?        00:00:00 [ksoftirqd/29]
root        92     2  0 09:53 ?        00:00:00 [watchdog/29]
root        93     2  0 09:53 ?        00:00:00 [migration/30]
root        94     2  0 09:53 ?        00:00:00 [ksoftirqd/30]
root        95     2  0 09:53 ?        00:00:00 [watchdog/30]
root        96     2  0 09:53 ?        00:00:00 [migration/31]
root        97     2  0 09:53 ?        00:00:00 [ksoftirqd/31]
root        98     2  0 09:53 ?        00:00:00 [watchdog/31]
root        99     2  0 09:53 ?        00:00:00 [migration/32]
root       100     2  0 09:53 ?        00:00:00 [ksoftirqd/32]
root       101     2  0 09:53 ?        00:00:00 [watchdog/32]
root       102     2  0 09:53 ?        00:00:00 [migration/33]
root       103     2  0 09:53 ?        00:00:00 [ksoftirqd/33]
root       104     2  0 09:53 ?        00:00:00 [watchdog/33]
root       105     2  0 09:53 ?        00:00:00 [migration/34]
root       106     2  0 09:53 ?        00:00:00 [ksoftirqd/34]
root       107     2  0 09:53 ?        00:00:00 [watchdog/34]
root       108     2  0 09:53 ?        00:00:00 [migration/35]
root       109     2  0 09:53 ?        00:00:00 [ksoftirqd/35]
root       110     2  0 09:53 ?        00:00:00 [watchdog/35]
root       111     2  0 09:53 ?        00:00:00 [migration/36]
root       112     2  0 09:53 ?        00:00:00 [ksoftirqd/36]
root       113     2  0 09:53 ?        00:00:00 [watchdog/36]
root       114     2  0 09:53 ?        00:00:00 [migration/37]
root       115     2  0 09:53 ?        00:00:00 [ksoftirqd/37]
root       116     2  0 09:53 ?        00:00:00 [watchdog/37]
root       117     2  0 09:53 ?        00:00:00 [migration/38]
root       118     2  0 09:53 ?        00:00:00 [ksoftirqd/38]
root       119     2  0 09:53 ?        00:00:00 [watchdog/38]
root       120     2  0 09:53 ?        00:00:00 [migration/39]
root       121     2  0 09:53 ?        00:00:00 [ksoftirqd/39]
root       122     2  0 09:53 ?        00:00:00 [watchdog/39]
root       123     2  0 09:53 ?        00:00:00 [migration/40]
root       124     2  0 09:53 ?        00:00:00 [ksoftirqd/40]
root       125     2  0 09:53 ?        00:00:00 [watchdog/40]
root       126     2  0 09:53 ?        00:00:00 [migration/41]
root       127     2  0 09:53 ?        00:00:00 [ksoftirqd/41]
root       128     2  0 09:53 ?        00:00:00 [watchdog/41]
root       129     2  0 09:53 ?        00:00:00 [migration/42]
root       130     2  0 09:53 ?        00:00:00 [ksoftirqd/42]
root       131     2  0 09:53 ?        00:00:00 [watchdog/42]
root       132     2  0 09:53 ?        00:00:00 [migration/43]
root       133     2  0 09:53 ?        00:00:00 [ksoftirqd/43]
root       134     2  0 09:53 ?        00:00:00 [watchdog/43]
root       135     2  0 09:53 ?        00:00:00 [migration/44]
root       136     2  0 09:53 ?        00:00:00 [ksoftirqd/44]
root       137     2  0 09:53 ?        00:00:00 [watchdog/44]
root       138     2  0 09:53 ?        00:00:00 [migration/45]
root       139     2  0 09:53 ?        00:00:00 [ksoftirqd/45]
root       140     2  0 09:53 ?        00:00:00 [watchdog/45]
root       141     2  0 09:53 ?        00:00:00 [migration/46]
root       142     2  0 09:53 ?        00:00:00 [ksoftirqd/46]
root       143     2  0 09:53 ?        00:00:00 [watchdog/46]
root       144     2  0 09:53 ?        00:00:00 [migration/47]
root       145     2  0 09:53 ?        00:00:00 [ksoftirqd/47]
root       146     2  0 09:53 ?        00:00:00 [watchdog/47]
root       147     2  0 09:53 ?        00:00:00 [migration/48]
root       148     2  0 09:53 ?        00:00:00 [ksoftirqd/48]
root       149     2  0 09:53 ?        00:00:00 [watchdog/48]
root       150     2  0 09:53 ?        00:00:00 [migration/49]
root       151     2  0 09:53 ?        00:00:00 [ksoftirqd/49]
root       152     2  0 09:53 ?        00:00:00 [watchdog/49]
root       153     2  0 09:53 ?        00:00:00 [migration/50]
root       154     2  0 09:53 ?        00:00:00 [ksoftirqd/50]
root       155     2  0 09:53 ?        00:00:00 [watchdog/50]
root       156     2  0 09:53 ?        00:00:00 [migration/51]
root       157     2  0 09:53 ?        00:00:00 [ksoftirqd/51]
root       158     2  0 09:53 ?        00:00:00 [watchdog/51]
root       159     2  0 09:53 ?        00:00:00 [migration/52]
root       160     2  0 09:53 ?        00:00:00 [ksoftirqd/52]
root       161     2  0 09:53 ?        00:00:00 [watchdog/52]
root       162     2  0 09:53 ?        00:00:00 [migration/53]
root       163     2  0 09:53 ?        00:00:00 [ksoftirqd/53]
root       164     2  0 09:53 ?        00:00:00 [watchdog/53]
root       165     2  0 09:53 ?        00:00:00 [migration/54]
root       166     2  0 09:53 ?        00:00:00 [ksoftirqd/54]
root       167     2  0 09:53 ?        00:00:00 [watchdog/54]
root       168     2  0 09:53 ?        00:00:00 [migration/55]
root       169     2  0 09:53 ?        00:00:00 [ksoftirqd/55]
root       170     2  0 09:53 ?        00:00:00 [watchdog/55]
root       171     2  0 09:53 ?        00:00:00 [migration/56]
root       172     2  0 09:53 ?        00:00:00 [ksoftirqd/56]
root       173     2  0 09:53 ?        00:00:00 [watchdog/56]
root       174     2  0 09:53 ?        00:00:00 [migration/57]
root       175     2  0 09:53 ?        00:00:00 [ksoftirqd/57]
root       176     2  0 09:53 ?        00:00:00 [watchdog/57]
root       177     2  0 09:53 ?        00:00:00 [migration/58]
root       178     2  0 09:53 ?        00:00:00 [ksoftirqd/58]
root       179     2  0 09:53 ?        00:00:00 [watchdog/58]
root       180     2  0 09:53 ?        00:00:00 [migration/59]
root       181     2  0 09:53 ?        00:00:00 [ksoftirqd/59]
root       182     2  0 09:53 ?        00:00:00 [watchdog/59]
root       183     2  0 09:53 ?        00:00:00 [migration/60]
root       184     2  0 09:53 ?        00:00:00 [ksoftirqd/60]
root       185     2  0 09:53 ?        00:00:00 [watchdog/60]
root       186     2  0 09:53 ?        00:00:00 [migration/61]
root       187     2  0 09:53 ?        00:00:00 [ksoftirqd/61]
root       188     2  0 09:53 ?        00:00:00 [watchdog/61]
root       189     2  0 09:53 ?        00:00:00 [migration/62]
root       190     2  0 09:53 ?        00:00:00 [ksoftirqd/62]
root       191     2  0 09:53 ?        00:00:00 [watchdog/62]
root       192     2  0 09:53 ?        00:00:00 [migration/63]
root       193     2  0 09:53 ?        00:00:00 [ksoftirqd/63]
root       194     2  0 09:53 ?        00:00:00 [watchdog/63]
root       195     2  0 09:53 ?        00:00:00 [events/0]
root       196     2  0 09:53 ?        00:00:00 [events/1]
root       197     2  0 09:53 ?        00:00:00 [events/2]
root       198     2  0 09:53 ?        00:00:00 [events/3]
root       199     2  0 09:53 ?        00:00:00 [events/4]
root       200     2  0 09:53 ?        00:00:00 [events/5]
root       201     2  0 09:53 ?        00:00:00 [events/6]
root       202     2  0 09:53 ?        00:00:00 [events/7]
root       203     2  0 09:53 ?        00:00:00 [events/8]
root       204     2  0 09:53 ?        00:00:00 [events/9]
root       205     2  0 09:53 ?        00:00:00 [events/10]
root       206     2  0 09:53 ?        00:00:00 [events/11]
root       207     2  0 09:53 ?        00:00:00 [events/12]
root       208     2  0 09:53 ?        00:00:00 [events/13]
root       209     2  0 09:53 ?        00:00:00 [events/14]
root       210     2  0 09:53 ?        00:00:00 [events/15]
root       211     2  0 09:53 ?        00:00:00 [events/16]
root       212     2  0 09:53 ?        00:00:00 [events/17]
root       213     2  0 09:53 ?        00:00:00 [events/18]
root       214     2  0 09:53 ?        00:00:00 [events/19]
root       215     2  0 09:53 ?        00:00:00 [events/20]
root       216     2  0 09:53 ?        00:00:00 [events/21]
root       217     2  0 09:53 ?        00:00:00 [events/22]
root       218     2  0 09:53 ?        00:00:00 [events/23]
root       219     2  0 09:53 ?        00:00:00 [events/24]
root       220     2  0 09:53 ?        00:00:00 [events/25]
root       221     2  0 09:53 ?        00:00:00 [events/26]
root       222     2  0 09:53 ?        00:00:00 [events/27]
root       223     2  0 09:53 ?        00:00:00 [events/28]
root       224     2  0 09:53 ?        00:00:00 [events/29]
root       225     2  0 09:53 ?        00:00:00 [events/30]
root       226     2  0 09:53 ?        00:00:00 [events/31]
root       227     2  0 09:53 ?        00:00:00 [events/32]
root       228     2  0 09:53 ?        00:00:00 [events/33]
root       229     2  0 09:53 ?        00:00:00 [events/34]
root       230     2  0 09:53 ?        00:00:00 [events/35]
root       231     2  0 09:53 ?        00:00:00 [events/36]
root       232     2  0 09:53 ?        00:00:00 [events/37]
root       233     2  0 09:53 ?        00:00:00 [events/38]
root       234     2  0 09:53 ?        00:00:00 [events/39]
root       235     2  0 09:53 ?        00:00:00 [events/40]
root       236     2  0 09:53 ?        00:00:00 [events/41]
root       237     2  0 09:53 ?        00:00:00 [events/42]
root       238     2  0 09:53 ?        00:00:00 [events/43]
root       239     2  0 09:53 ?        00:00:00 [events/44]
root       240     2  0 09:53 ?        00:00:00 [events/45]
root       241     2  0 09:53 ?        00:00:00 [events/46]
root       242     2  0 09:53 ?        00:00:00 [events/47]
root       243     2  0 09:53 ?        00:00:00 [events/48]
root       244     2  0 09:53 ?        00:00:00 [events/49]
root       245     2  0 09:53 ?        00:00:00 [events/50]
root       246     2  0 09:53 ?        00:00:00 [events/51]
root       247     2  0 09:53 ?        00:00:00 [events/52]
root       248     2  0 09:53 ?        00:00:00 [events/53]
root       249     2  0 09:53 ?        00:00:00 [events/54]
root       250     2  0 09:53 ?        00:00:00 [events/55]
root       251     2  0 09:53 ?        00:00:00 [events/56]
root       252     2  0 09:53 ?        00:00:00 [events/57]
root       253     2  0 09:53 ?        00:00:00 [events/58]
root       254     2  0 09:53 ?        00:00:00 [events/59]
root       255     2  0 09:53 ?        00:00:00 [events/60]
root       256     2  0 09:53 ?        00:00:00 [events/61]
root       257     2  0 09:53 ?        00:00:00 [events/62]
root       258     2  0 09:53 ?        00:00:00 [events/63]
root       259     2  0 09:53 ?        00:00:00 [khelper]
root       264     2  0 09:53 ?        00:00:00 [async/mgr]
root       432     2  0 09:53 ?        00:00:00 [sync_supers]
root       434     2  0 09:53 ?        00:00:00 [bdi-default]
root       435     2  0 09:53 ?        00:00:00 [kblockd/0]
root       436     2  0 09:53 ?        00:00:00 [kblockd/1]
root       437     2  0 09:53 ?        00:00:00 [kblockd/2]
root       438     2  0 09:53 ?        00:00:00 [kblockd/3]
root       439     2  0 09:53 ?        00:00:00 [kblockd/4]
root       440     2  0 09:53 ?        00:00:00 [kblockd/5]
root       441     2  0 09:53 ?        00:00:00 [kblockd/6]
root       442     2  0 09:53 ?        00:00:00 [kblockd/7]
root       443     2  0 09:53 ?        00:00:00 [kblockd/8]
root       444     2  0 09:53 ?        00:00:00 [kblockd/9]
root       445     2  0 09:53 ?        00:00:00 [kblockd/10]
root       446     2  0 09:53 ?        00:00:00 [kblockd/11]
root       447     2  0 09:53 ?        00:00:00 [kblockd/12]
root       448     2  0 09:53 ?        00:00:00 [kblockd/13]
root       449     2  0 09:53 ?        00:00:00 [kblockd/14]
root       450     2  0 09:53 ?        00:00:00 [kblockd/15]
root       451     2  0 09:53 ?        00:00:00 [kblockd/16]
root       452     2  0 09:53 ?        00:00:00 [kblockd/17]
root       453     2  0 09:53 ?        00:00:00 [kblockd/18]
root       454     2  0 09:53 ?        00:00:00 [kblockd/19]
root       455     2  0 09:53 ?        00:00:00 [kblockd/20]
root       456     2  0 09:53 ?        00:00:00 [kblockd/21]
root       457     2  0 09:53 ?        00:00:00 [kblockd/22]
root       458     2  0 09:53 ?        00:00:00 [kblockd/23]
root       459     2  0 09:53 ?        00:00:00 [kblockd/24]
root       460     2  0 09:53 ?        00:00:00 [kblockd/25]
root       461     2  0 09:53 ?        00:00:00 [kblockd/26]
root       462     2  0 09:53 ?        00:00:00 [kblockd/27]
root       463     2  0 09:53 ?        00:00:00 [kblockd/28]
root       464     2  0 09:53 ?        00:00:00 [kblockd/29]
root       465     2  0 09:53 ?        00:00:00 [kblockd/30]
root       466     2  0 09:53 ?        00:00:00 [kblockd/31]
root       467     2  0 09:53 ?        00:00:00 [kblockd/32]
root       468     2  0 09:53 ?        00:00:00 [kblockd/33]
root       469     2  0 09:53 ?        00:00:00 [kblockd/34]
root       470     2  0 09:53 ?        00:00:00 [kblockd/35]
root       471     2  0 09:53 ?        00:00:00 [kblockd/36]
root       472     2  0 09:53 ?        00:00:00 [kblockd/37]
root       473     2  0 09:53 ?        00:00:00 [kblockd/38]
root       474     2  0 09:53 ?        00:00:00 [kblockd/39]
root       475     2  0 09:53 ?        00:00:00 [kblockd/40]
root       476     2  0 09:53 ?        00:00:00 [kblockd/41]
root       477     2  0 09:53 ?        00:00:00 [kblockd/42]
root       478     2  0 09:53 ?        00:00:00 [kblockd/43]
root       479     2  0 09:53 ?        00:00:00 [kblockd/44]
root       480     2  0 09:53 ?        00:00:00 [kblockd/45]
root       481     2  0 09:53 ?        00:00:00 [kblockd/46]
root       482     2  0 09:53 ?        00:00:00 [kblockd/47]
root       483     2  0 09:53 ?        00:00:00 [kblockd/48]
root       484     2  0 09:53 ?        00:00:00 [kblockd/49]
root       485     2  0 09:53 ?        00:00:00 [kblockd/50]
root       486     2  0 09:53 ?        00:00:00 [kblockd/51]
root       487     2  0 09:53 ?        00:00:00 [kblockd/52]
root       488     2  0 09:53 ?        00:00:00 [kblockd/53]
root       489     2  0 09:53 ?        00:00:00 [kblockd/54]
root       490     2  0 09:53 ?        00:00:00 [kblockd/55]
root       491     2  0 09:53 ?        00:00:00 [kblockd/56]
root       492     2  0 09:53 ?        00:00:00 [kblockd/57]
root       493     2  0 09:53 ?        00:00:00 [kblockd/58]
root       494     2  0 09:53 ?        00:00:00 [kblockd/59]
root       495     2  0 09:53 ?        00:00:00 [kblockd/60]
root       496     2  0 09:53 ?        00:00:00 [kblockd/61]
root       497     2  0 09:53 ?        00:00:00 [kblockd/62]
root       498     2  0 09:53 ?        00:00:00 [kblockd/63]
root       500     2  0 09:53 ?        00:00:00 [kacpid]
root       501     2  0 09:53 ?        00:00:00 [kacpi_notify]
root       502     2  0 09:53 ?        00:00:00 [kacpi_hotplug]
root       720     2  0 09:53 ?        00:00:00 [ata/0]
root       721     2  0 09:53 ?        00:00:00 [ata_aux]
root       723     2  0 09:53 ?        00:00:00 [kseriod]
root       757     2  0 09:53 ?        00:00:00 [kondemand/0]
root      1287     2  0 09:53 ?        00:00:00 [khungtaskd]
root      1288     2  0 09:53 ?        00:00:00 [kswapd0]
root      1335     2  0 09:53 ?        00:00:00 [aio/0]
root      1349     2  0 09:53 ?        00:00:00 [nfsiod]
root      2154     2  0 09:53 ?        00:00:00 [scsi_eh_0]
root      2181     2  0 09:53 ?        00:00:00 [scsi_eh_1]
root      2184     2  0 09:53 ?        00:00:00 [scsi_eh_2]
root      2186     2  0 09:53 ?        00:00:00 [scsi_eh_3]
root      2188     2  0 09:53 ?        00:00:00 [scsi_eh_4]
root      2190     2  0 09:53 ?        00:00:00 [scsi_eh_5]
root      2192     2  0 09:53 ?        00:00:00 [scsi_eh_6]
root      2223     2  0 09:53 ?        00:00:00 [kpsmoused]
root      2227     2  0 09:53 ?        00:00:00 [rpciod/0]
root      2245     2  0 09:53 ?        00:00:00 [kondemand/1]
root      2246     2  0 09:53 ?        00:00:00 [kondemand/2]
root      2247     2  0 09:53 ?        00:00:00 [kondemand/4]
root      2278     2  0 09:53 ?        00:00:00 [kondemand/36]
root      2279     2  0 09:53 ?        00:00:00 [kondemand/39]
root      2301     2  0 09:53 ?        00:00:00 [kondemand/63]
root      2304     2  0 09:53 ?        00:00:00 [kondemand/43]
root      2308     2  0 09:53 ?        00:00:00 [kondemand/37]
root      2309     2  0 09:53 ?        00:00:00 [kondemand/32]
root      2310     2  0 09:53 ?        00:00:00 [kondemand/8]
root      2313     2  0 09:53 ?        00:00:00 [kjournald]
root      2314     2  0 09:53 ?        00:00:00 [kondemand/44]
root      2317     2  0 09:53 ?        00:00:00 [kondemand/41]
root      2322     2  0 09:53 ?        00:00:00 [kondemand/52]
root      2327     2  0 09:53 ?        00:00:00 [kondemand/60]
root      2329     2  0 09:53 ?        00:00:00 [kondemand/48]
root      2331     2  0 09:53 ?        00:00:00 [kondemand/56]
root      2352     2  0 09:53 ?        00:00:00 [kondemand/28]
root      2369     2  0 09:53 ?        00:00:00 [kondemand/16]
root      2383     1  1 09:53 ?        00:00:03 udevd --daemon
root      2392     2  0 09:53 ?        00:00:00 [kondemand/40]
root      2395     2  0 09:53 ?        00:00:00 [kondemand/45]
root      2398     2  0 09:53 ?        00:00:00 [kondemand/11]
root      2401     2  0 09:53 ?        00:00:00 [kondemand/33]
root      2427     2  0 09:53 ?        00:00:00 [kondemand/49]
root      2437     2  0 09:53 ?        00:00:00 [kondemand/47]
root      2442     2  0 09:53 ?        00:00:00 [kondemand/13]
root      2447     2  0 09:53 ?        00:00:00 [kondemand/51]
root      2451     2  0 09:53 ?        00:00:00 [kondemand/55]
root      2452     2  0 09:53 ?        00:00:00 [kondemand/59]
root      2474     2  0 09:53 ?        00:00:00 [kondemand/53]
root      2480     2  0 09:53 ?        00:00:00 [kondemand/57]
root      2515     2  0 09:53 ?        00:00:00 [kondemand/7]
root      2564     2  0 09:53 ?        00:00:00 [kondemand/61]
root      2577     2  0 09:53 ?        00:00:00 [kondemand/35]
root      3648     2  0 09:53 ?        00:00:00 [ksuspend_usbd]
root      3655     2  0 09:53 ?        00:00:00 [khubd]
root      3710     2  0 09:53 ?        00:00:00 [mpt_poll_0]
root      3711     2  0 09:53 ?        00:00:00 [mpt/0]
root      3873     2  0 09:53 ?        00:00:00 [kondemand/20]
root      3901     2  0 09:53 ?        00:00:00 [usbhid_resumer]
root      3931     2  0 09:53 ?        00:00:00 [kondemand/29]
root      3932     2  0 09:53 ?        00:00:00 [kondemand/5]
root      3987     2  0 09:53 ?        00:00:00 [kondemand/9]
root      4094     2  0 09:53 ?        00:00:00 [scsi_eh_7]
root      4109     2  0 09:53 ?        00:00:00 [kondemand/12]
root      4130     2  0 09:53 ?        00:00:00 [kondemand/17]
root      4132     2  0 09:53 ?        00:00:00 [kondemand/21]
root      4199     2  0 09:53 ?        00:00:00 [kondemand/25]
root      4459     2  0 09:54 ?        00:00:00 [kjournald]
root      4525     2  0 09:54 ?        00:00:00 [flush-8:0]
root      4543     1  0 09:54 ?        00:00:00 dhclient3 -pf /var/run/dhclient.eth0.pid -lf /var/lib/dhcp3/dhclient.eth0.leases eth0
daemon    4560     1  0 09:54 ?        00:00:00 /sbin/portmap
statd     4571     1  0 09:54 ?        00:00:00 /sbin/rpc.statd
root      4732     1  0 09:54 ?        00:00:00 /usr/sbin/rsyslogd -c3
root      4743     1  0 09:54 ?        00:00:00 /usr/sbin/acpid
root      4756     1  0 09:54 ?        00:00:00 /usr/sbin/sshd
101       5061     1  0 09:54 ?        00:00:00 /usr/sbin/exim4 -bd -q30m
daemon    5088     1  0 09:54 ?        00:00:00 /usr/sbin/atd
root      5108     1  0 09:54 ?        00:00:00 /usr/sbin/cron
root      5125     1  0 09:54 tty1     00:00:00 /sbin/getty 38400 tty1
root      5126     1  0 09:54 tty2     00:00:00 /sbin/getty 38400 tty2
root      5127     1  0 09:54 tty3     00:00:00 /sbin/getty 38400 tty3
root      5128     1  0 09:54 tty4     00:00:00 /sbin/getty 38400 tty4
root      5129     1  0 09:54 tty5     00:00:00 /sbin/getty 38400 tty5
root      5130     1  0 09:54 tty6     00:00:00 /sbin/getty 38400 tty6
root      5159     2  0 09:55 ?        00:00:00 [kondemand/38]
root      5182  4756  1 09:56 ?        00:00:00 sshd: axboe [priv]
axboe     5186  5182  0 09:56 ?        00:00:00 sshd: axboe@pts/0
axboe     5187  5186  0 09:56 pts/0    00:00:00 -bash
axboe     5190  5187  0 09:56 pts/0    00:00:00 ps -ef

--iq/fWD14IMVFWBCD--
