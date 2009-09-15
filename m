Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbZIOOx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbZIOOx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 10:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbZIOOxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 10:53:20 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:25536 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495AbZIOOxP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 10:53:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cbTgZNi6ItLCM6vKz4ls9vBD8sVHFvVDmto4SzH7gMnGpVnJ3KKNZp0S5+v68SnCOg
         GXvBfyxOmeQAy8N5HScVzyQV8jANjbYqBM9+/4TJzt2XhHprpAx6eqODen28Y94NqUN5
         /zoywihoNxfmO4WpM6w9dL6Knhhnw0cXdz+kI=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0909150844140.19305@sebohet.brgvxre.pu>
References: <alpine.DEB.2.00.0909150844140.19305@sebohet.brgvxre.pu>
Date: Tue, 15 Sep 2009 16:53:18 +0200
Message-ID: <4e5e476b0909150753k699a2f5awadc666a9b3afebfa@mail.gmail.com>
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

On Tue, Sep 15, 2009 at 9:30 AM, Tobias Oetiker <tobi@oetiker.ch> wrote:
> Experts,
>
> We run several busy NFS file servers with Areca HW Raid + LVM2 + ext3
>
> We find that the read bandwidth falls dramatically as well as the
> response times going up to several seconds as soon as the system
> comes under heavy write strain.
>
> With the release of 2.6.31 and all the io fixes that went in there,
> I was hoping for a solution and set out to do some tests ...
>
> I have seen the io problem posted on LKML a few times, and normally
> it is simulated by running several concurrent dd processes one
> reading and one writing. It seems that cfq with a low slice_async
> can deal pretty well with competing dds.
>
> Unfortunately our use case is not users running dd but rather a lot
> of processes accessing many small to medium sized files for reading
> and writing.
>
> I have written a test program that unpacks Linux 2.6.30.5 a few
> times into a file system, flushes the cache and then tars it up
> again while unpacking some more tars in parallel. While this is
> running I use iostat to watch the activity on the block devices. As
> I am interested in interactive performance of the system, the await
> row as well as the rMB/s row are of special interest to me
>
>  iostat -m -x 5
>
> Even with a low 'resolution' of 5 seconds, the performance figures
> are jumping all over the place. This concurs with the user
> experience when working with the system interactively.
>
> I tried to optimize the configuration systematically turning all
> the knobs I know of (/proc/sys/vm, /sys/block/*/queue/scheduler,
> data=journal, data=ordered, external journal on a ssd device) one
> at a time. I found that cfq helps the read performance quite a lot
> as far as total run-time is concerned, but the jerky nature of the
> measurements does not change, and also the read performance keeps
> dropping dramatically as soon as it is in competition with writers.
>
> I would love to get some hints on how to make such a setup perform
> without these huge performance fluctuations.
>
> While testing, I saw that iostat reports huge wMB/s numbers and
> ridiculously low rMB/s numbers. Looking at the actual amount of
> data in the tar files as well as the run time of the tar processes
> the numbers MB/s numbers reported by iostat do seem strange. The
> read numbers are too low and the write numbers are too high.
>
>  12 * 1.3 GB reading in 270s = 14 MB/s sustained
>  12 * 0.3 GB writing in 180s = 1.8 MB/s sustained
>
> Since I am looking at relative performance figures this does not
> matter so much, but it is still a bit disconcerting.
>
> My tests script is available on http://tobi.oetiker.ch/fspunisher/
>
> Below is an excerpt from iostat while the test is in full swing:
>
> * 2.6.31 (8 cpu x86_64, 24 GB Ram)
> * scheduler = cfq
> * iostat -m -x dm-5 5
> * running in parallel on 3 lvm logical volumes
>  on a single physical volume
>
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> ---------------------------------------------------------------------------------------------------------
> dm-5             0.00     0.00   26.60 7036.60     0.10    27.49     8.00   669.04   91.58   0.09  66.96
> dm-5             0.00     0.00   63.80 2543.00     0.25     9.93     8.00  1383.63  539.28   0.36  94.64
> dm-5             0.00     0.00   78.00 5084.60     0.30    19.86     8.00  1007.41  195.12   0.15  77.36
> dm-5             0.00     0.00   44.00 5588.00     0.17    21.83     8.00   516.27   91.69   0.17  95.44
> dm-5             0.00     0.00    0.00 6014.20     0.00    23.49     8.00  1331.42   66.25   0.13  76.48
> dm-5             0.00     0.00   28.80 4491.40     0.11    17.54     8.00  1000.37  412.09   0.17  78.24
> dm-5             0.00     0.00   36.60 6486.40     0.14    25.34     8.00   765.12  128.07   0.11  72.16
> dm-5             0.00     0.00   33.40 5095.60     0.13    19.90     8.00   431.38   43.78   0.17  85.20
>
> for comparison these are the numbers for seen when running the test
> with just the writing enabled
>
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> ---------------------------------------------------------------------------------------------------------
> dm-5             0.00     0.00    4.00 12047.40    0.02    47.06     8.00   989.81   79.55   0.07  79.20
> dm-5             0.00     0.00    3.40 12399.00    0.01    48.43     8.00   977.13   72.15   0.05  58.08
> dm-5             0.00     0.00    3.80 13130.00    0.01    51.29     8.00  1130.48   95.11   0.04  58.48
> dm-5             0.00     0.00    2.40 5109.20     0.01    19.96     8.00   427.75   47.41   0.16  79.92
> dm-5             0.00     0.00    3.20    0.00     0.01     0.00     8.00   290.33 148653.75 282.50  90.40
> dm-5             0.00     0.00    3.40 5103.00     0.01    19.93     8.00   168.75   33.06   0.13  67.84
>
> And also with just the reading:
>
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> ---------------------------------------------------------------------------------------------------------
> dm-5             0.00     0.00  463.80    0.00     1.81     0.00     8.00     3.90    8.41   2.16 100.00
> dm-5             0.00     0.00  434.20    0.00     1.70     0.00     8.00     3.89    8.95   2.30 100.00
> dm-5             0.00     0.00  540.80    0.00     2.11     0.00     8.00     3.88    7.18   1.85 100.00
> dm-5             0.00     0.00  591.60    0.00     2.31     0.00     8.00     3.84    6.50   1.68  99.68
> dm-5             0.00     0.00  793.20    0.00     3.10     0.00     8.00     3.81    4.80   1.26 100.00
> dm-5             0.00     0.00  592.80    0.00     2.32     0.00     8.00     3.84    6.47   1.68  99.60
> dm-5             0.00     0.00  578.80    0.00     2.26     0.00     8.00     3.85    6.66   1.73 100.00
> dm-5             0.00     0.00  771.00    0.00     3.01     0.00     8.00     3.81    4.93   1.30  99.92
>

>From the numbers, it appears that your controller (or the disks) is
lying about writes. They get cached (service time around 0.1ms) and
reported as completed. When the cache is full, or a flush is issued,
you get >200ms delay.
Reads, instead, have a more reasonable service time of around 2ms.

Can you disable write cache, and see if the response times for writes
become reasonable?

> I also tested 2.6.31 for what happens when I run the same 'load' on a single lvm
> logical volume. Interestingly enough it is even worse than when doing it on three
> volumes:
>
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> ---------------------------------------------------------------------------------------------------------
> dm-5             0.00     0.00   19.20 4566.80     0.07    17.84     8.00  2232.12  486.87   0.22  99.92
> dm-5             0.00     0.00    6.80 9410.40     0.03    36.76     8.00  1827.47  187.99   0.10  92.00
> dm-5             0.00     0.00    4.00    0.00     0.02     0.00     8.00   685.26 185618.40 249.60  99.84
> dm-5             0.00     0.00    4.20 4968.20     0.02    19.41     8.00  1426.45  286.86   0.20  99.84
> dm-5             0.00     0.00   10.60 9886.00     0.04    38.62     8.00   167.57    5.74   0.09  88.72
> dm-5             0.00     0.00    5.00    0.00     0.02     0.00     8.00  1103.98 242774.88 199.68  99.84
> dm-5             0.00     0.00   38.20 14794.60    0.15    57.79     8.00  1171.75   74.25   0.06  87.20
>
> I also tested 2.6.31 with io-controller v9 patches. It seems to help a
> bit with the read rate, but the figures still jumps all over the place
>
> * 2.6.31 with io-controller patches v9 (8 cpu x86_64, 24 GB Ram)
> * fairness set to 1 on all block devices
> * scheduler = cfq
> * iostat -m -x dm-5 5
> * running in parallel on 3 lvm logical volumes
>  on a single physical volume
>
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> ---------------------------------------------------------------------------------------------------------
> dm-5              0.00     0.00  412.00 1640.60     1.61     6.41     8.00  1992.54 1032.27   0.49  99.84
> dm-5              0.00     0.00  362.40  576.40     1.42     2.25     8.00   456.13  612.67   1.07 100.00
> dm-5              0.00     0.00  211.80 1004.40     0.83     3.92     8.00  1186.20  995.00   0.82 100.00
> dm-5              0.00     0.00   44.20  719.60     0.17     2.81     8.00   788.56  574.81   1.31  99.76
> dm-5              0.00     0.00    0.00 1274.80     0.00     4.98     8.00  1584.07 1317.32   0.78 100.00
> dm-5              0.00     0.00    0.00  946.91     0.00     3.70     8.00   989.09  911.30   1.05  99.72
> dm-5              0.00     0.00    7.20 2526.00     0.03     9.87     8.00  2085.57  201.72   0.37  92.88
>
>
> For completeness sake I did the tests on 2.4.24 as well not much different.
>
> * 2.6.24 (8 cpu x86_64, 24 GB Ram)
> * scheduler = cfq
> * iostat -m -x dm-5 5
> * running in parallel on 3 lvm logical volumes
>  situated on a single physical volume
>
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> ---------------------------------------------------------------------------------------------------------
> dm-5              0.00     0.00  144.60 5498.00     0.56    21.48     8.00  1215.82  215.48   0.14  76.80
> dm-5              0.00     0.00   30.00 9831.40     0.12    38.40     8.00  1729.16  142.37   0.09  88.60
> dm-5              0.00     0.00   27.60 4126.40     0.11    16.12     8.00  2245.24  618.77   0.21  86.00
> dm-5              0.00     0.00    2.00 3981.20     0.01    15.55     8.00  1069.07  268.40   0.23  91.60
> dm-5              0.00     0.00   40.60   13.20     0.16     0.05     8.00     3.98   74.83  15.02  80.80
> dm-5              0.00     0.00    5.60 5085.20     0.02    19.86     8.00  2586.65  508.10   0.18  94.00
> dm-5              0.00     0.00   20.80 5344.60     0.08    20.88     8.00   985.51  148.96   0.17  92.60
>
>
> cheers
> tobi
>
> --
> Tobi Oetiker, OETIKER+PARTNER AG, Aarweg 15 CH-4600 Olten, Switzerland
> http://it.oetiker.ch tobi@oetiker.ch ++41 62 775 9902 / sb: -9900
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
