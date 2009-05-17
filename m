Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761AbZEQNPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbZEQNPW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 09:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbZEQNPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 09:15:05 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:49844 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbZEQNPB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 09:15:01 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: unresponsiveness on linux desktop during file copy
Date: Sun, 17 May 2009 08:14:50 -0500
User-Agent: KMail/1.9.9
References: <93655eb70905151007v5f9bb34aj34be4b65ffeb02a4@mail.gmail.com> <93655eb70905162130k13ebd627o5eba2582508a1c07@mail.gmail.com> <20090517045800.GA32723@localhost>
In-Reply-To: <20090517045800.GA32723@localhost>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ray Lee <ray-lk@madrabbit.org>, Rik van Riel <riel@redhat.com>,
       Satish Eerpini <eerpini@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905170814.52776.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat May 16 2009, you wrote:
> On Sun, May 17, 2009 at 12:30:28PM +0800, Satish Eerpini wrote:
> > > I've prepared a rolled up patch for you, run time tested.  It should
> > > protect all of the above pages from being evicted by large file copies.
> > >
> > > The attached patch is for 2.6.29.
> >
> > I applied the patch , but the number don seem to show much difference
> 
> The numbers listed in your email? No the most relevant numbers are
> memory and disk ones.
> 
> For my part, the number of mapped pages keeps stable when there is an
> ongoing background file copy:
> 
> % ls -l /b/sparse
> -rw-r--r-- 1 root root 98T 2009-04-29 22:38 /b/sparse
> % cp /b/sparse /dev/null&
> % for i in `seq 1 100`; do grep Mapped /proc/meminfo; sleep 1; done
> Mapped:            22764 kB
> Mapped:            22796 kB
> Mapped:            22756 kB
> Mapped:            22716 kB
> Mapped:            22800 kB
> Mapped:            22788 kB
> Mapped:            22804 kB
> Mapped:            22808 kB
> Mapped:            22748 kB
> Mapped:            22708 kB
> Mapped:            22916 kB
> Mapped:            22944 kB
> Mapped:            22944 kB
> Mapped:            22944 kB
> Mapped:            22944 kB
> Mapped:            22944 kB
> Mapped:            22832 kB
> Mapped:            22812 kB
> Mapped:            22812 kB
> Mapped:            22792 kB
> Mapped:            22772 kB
> Mapped:            22860 kB
> Mapped:            22860 kB
> Mapped:            22748 kB
> Mapped:            22808 kB
> Mapped:            22868 kB
> Mapped:            22956 kB
> Mapped:            22956 kB
> Mapped:            22832 kB
> Mapped:            22832 kB
> Mapped:            22980 kB
> Mapped:            22980 kB
> Mapped:            22980 kB
> Mapped:            22980 kB
> Mapped:            22872 kB
> Mapped:            22872 kB
> Mapped:            22900 kB
> Mapped:            22792 kB
> Mapped:            22920 kB
> Mapped:            22812 kB
> Mapped:            22812 kB
> Mapped:            22752 kB
> Mapped:            22864 kB
> Mapped:            22972 kB
> Mapped:            22860 kB
> Mapped:            22796 kB
> Mapped:            22900 kB
> Mapped:            22888 kB
> Mapped:            22888 kB
> Mapped:            22888 kB
> Mapped:            22764 kB
> 
> > , following are the statistics with the patched kernel, could
> > something else be causing the huge iowait,  :
> >
> > Linux 2.6.29 (satish) 	05/17/2009
> >
> > 09:57:14 AM     CPU     %user     %nice   %system   %iowait    %steal     %idle
> > 09:57:18 AM     all     12.93      0.00     10.25     33.44      0.00     43.38
> > 09:57:21 AM     all     13.32      0.00     28.09     24.40      0.00     34.19
> > 09:57:24 AM     all     10.79      0.00      4.76     75.56      0.00      8.89
> > 09:57:26 AM     all     11.46      0.00      8.01     35.64      0.00     44.90
> > 09:57:30 AM     all     11.68      0.00      8.88     35.05      0.00     44.39
> > Average:        all     12.03      0.00     11.94     40.81      0.00     35.22
> 
> The iowait is high. Do you have "iostat -x 5' numbers?
> 
> > and
> >
> > hdparm -tT /dev/sda
> >
> > /dev/sda:
> >  Timing cached reads:   1332 MB in  2.00 seconds = 666.35 MB/sec
> >  Timing buffered disk reads:   24 MB in  3.32 seconds =   7.23 MB/sec
> 
> That's pretty slow numbers. On my laptop:
> 
> # hdparm -tT /dev/sda
> 
> /dev/sda:
>  Timing cached reads:   10266 MB in  1.98 seconds = 5188.46 MB/sec
>  Timing buffered disk reads:  138 MB in  3.01 seconds =  45.90 MB/sec
> 

I see (on 2.6.30-rc6, no patches):

# hdparm -tT /dev/sda (The internal, low-power, low performance hdd):

/dev/sda:
 Timing cached reads:   492 MB in  2.00 seconds = 245.83 MB/sec
 Timing buffered disk reads:   74 MB in  3.05 seconds =  24.26 MB/sec

# hdparm -tT /dev/sdb (A Class-6, SDHC card):

/dev/sdb:
 Timing cached reads:   472 MB in  2.01 seconds = 235.28 MB/sec
 Timing buffered disk reads:   40 MB in  3.13 seconds =  12.79 MB/sec

And the only thing going on -
(once you deduct the effect of getting this output) - nothing:

top - 08:09:25 up 9 min,  1 user,  load average: 0.24, 0.40, 0.25
Tasks:  86 total,   1 running,  85 sleeping,   0 stopped,   0 zombie
Cpu(s):  2.9%us,  4.2%sy,  0.8%ni, 59.9%id, 32.2%wa,  0.0%hi,  0.1%si,  0.0%st
Mem:    447040k total,   242996k used,   204044k free,    73516k buffers
Swap:  2199324k total,        0k used,  2199324k free,    79868k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 3359 root      20   0  2444 1048  824 R  3.8  0.2   0:00.04 top
 3360 root      20   0  3376  888  744 S  1.9  0.2   0:00.01 less
    1 root      20   0  3084 1884  564 S  0.0  0.4   0:01.59 init
    2 root      15  -5     0    0    0 S  0.0  0.0   0:00.00 kthreadd

Mike
> Thanks,
> Fengguang
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


