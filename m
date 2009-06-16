Return-Path: <linux-kernel-owner+w=401wt.eu-S1758072AbZFPM2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072AbZFPM2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 08:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755418AbZFPM2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 08:28:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:5336 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbZFPM2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 08:28:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,228,1243839600"; 
   d="scan'208";a="155072812"
Date: Tue, 16 Jun 2009 20:28:14 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jake Ellowitz <ellowitz@uchicago.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "tj@kernel.org" <tj@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [Bug #13463] Poor SSD performance
Message-ID: <20090616122814.GA7524@localhost>
References: <sIiXQlfwS3D.A.81.dj7KKB@chimera> <AN6kEAA5GQ.A.23.sj7KKB@chimera> <20090610063746.GA26773@localhost> <20090611031153.GA7007@localhost> <4A371AED.5080800@uchicago.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A371AED.5080800@uchicago.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jake,

On Tue, Jun 16, 2009 at 12:09:17PM +0800, Jake Ellowitz wrote:
> Dear Fengguang,
> 
> Thanks so much for the attention you paid to this problem. I did not 
> want to respond until I got a chance to give the new kernel a shot to 
> see if the bug was still present. It appears not to be -- hdparm and dd 
> both register read speeds between 200 and 220 MB/s as opposed to the 70 
> to 80 MB/s I was getting with kernel 2.6.29. So, I guess this strange 
> bug has sort of resolved itself.

That's great!  (if convenient I'd recommend you to try the blktrace
tool on 2.6.29, it's easy to use :)

Thanks,
Fengguang

> Wu Fengguang wrote:
> > On Wed, Jun 10, 2009 at 02:37:46PM +0800, Wu Fengguang wrote:
> >   
> >>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13463
> >>> Subject		: Poor SSD performance
> >>> Submitter	: Jake <ellowitz@uchicago.edu>
> >>> Date		: 2009-06-05 17:37 (3 days old)
> >>>       
> >> Hi Jake,
> >>
> >> Could you collect some blktrace data for the dd commands on new/old
> >> kernels?
> >>
> >> dd if=/dev/sda of=/dev/null bs=1M count=1024 iflag=direct
> >> dd if=/dev/sda of=/dev/null bs=1M count=1024
> >>     
> >
> > I managed to get a SanDisk SSD for testing, and observes that
> >
> > - one must increase read_ahead_kb to at least max_sectors_kb or better
> >   "bs=1M" to make a fair comparison
> > - with increased readahead size, the dd reported throughputs are
> >   75MB/s vs 77MB/s, while the blktrace reported throughputs are
> >   75MB/s vs 75MB/s (buffered IO vs direct IO).
> >
> > Here are details.
> >
> > The dd throughputs are equal for rotational hard disks, but differs
> > for this SanDisk SSD (with default RA parameters):
> >
> >         % dd if=/dev/sda of=/dev/null iflag=direct bs=1M count=1024
> >         1073741824 bytes (1.1 GB) copied, 13.905 s, 77.2 MB/s
> >         1073741824 bytes (1.1 GB) copied, 13.9029 s, 77.2 MB/s
> >
> >         % dd if=/dev/sda of=/dev/null bs=1M count=1024             
> >         1073741824 bytes (1.1 GB) copied, 14.7294 s, 72.9 MB/s
> >         1073741824 bytes (1.1 GB) copied, 14.8647 s, 72.2 MB/s
> >
> > Here is the blktrace summary:
> >
> >    dd                                           dd-direct
> > --------------------------------------------------------------------------------------
> >   CPU0 (sda):                               |  CPU0 (sda):
> >    Reads Queued:       9,888,   39,552KiB   |   Reads Queued:          84,   43,008KiB   
> >    Read Dispatches:      302,   38,588KiB   |   Read Dispatches:       84,   43,008KiB   
> >    Reads Requeued:         0                |   Reads Requeued:         0                
> >    Reads Completed:      337,   44,600KiB   |   Reads Completed:       83,   42,496KiB   
> >    Read Merges:        9,574,   38,296KiB   |   Read Merges:            0,        0KiB   
> >    Read depth:             2                |   Read depth:             2                
> >    IO unplugs:           313                |   IO unplugs:            42                
> >   CPU1 (sda):                               |  CPU1 (sda):
> >    Reads Queued:      11,840,   47,360KiB   |   Reads Queued:          96,   49,152KiB   
> >    Read Dispatches:      372,   48,196KiB   |   Read Dispatches:       96,   49,152KiB   
> >    Reads Requeued:         0                |   Reads Requeued:         0                
> >    Reads Completed:      337,   42,312KiB   |   Reads Completed:       96,   49,152KiB   
> >    Read Merges:       11,479,   45,916KiB   |   Read Merges:            0,        0KiB   
> >    Read depth:             2                |   Read depth:             2                
> >    IO unplugs:           372                |   IO unplugs:            48                
> >                                             |  
> >   Total (sda):                              |  Total (sda):
> >    Reads Queued:      21,728,   86,912KiB   |   Reads Queued:         180,   92,160KiB   
> >    Read Dispatches:      674,   86,784KiB   |   Read Dispatches:      180,   92,160KiB   
> >    Reads Requeued:         0                |   Reads Requeued:         0                
> >    Reads Completed:      674,   86,912KiB   |   Reads Completed:      179,   91,648KiB   
> >    Read Merges:       21,053,   84,212KiB   |   Read Merges:            0,        0KiB   
> >    IO unplugs:           685                |   IO unplugs:            90                
> >                                             |  
> >   Throughput (R/W): 69,977KiB/s / 0KiB/s    |  Throughput (R/W): 75,368KiB/s / 0KiB/s    
> >   Events (sda): 46,804 entries              |  Events (sda): 1,158 entries               
> >
> >
> > Another obvious difference is IO size.
> > One is read_ahead_kb=128K, another is max_sectors_kb=512K:
> >
> > dd:
> >   8,0    0    13497     0.804939305     0  C   R 782592 + 256 [0]
> >   8,0    0    13498     0.806713692     0  C   R 782848 + 256 [0]
> >   8,0    1    16275     0.808488708     0  C   R 783104 + 256 [0]
> >   8,0    0    13567     0.810261350     0  C   R 783360 + 256 [0]
> >   8,0    0    13636     0.812036226     0  C   R 783616 + 256 [0]
> >   8,0    1    16344     0.813806353     0  C   R 783872 + 256 [0]
> >   8,0    1    16413     0.815578436     0  C   R 784128 + 256 [0]
> >   8,0    0    13705     0.817347935     0  C   R 784384 + 256 [0]
> >
> > dd-direct:
> >   8,0    0      428     0.998831975     0  C   R 357376 + 1024 [0]
> >   8,0    1      514     1.005683404     0  C   R 358400 + 1024 [0]
> >   8,0    1      515     1.012402554     0  C   R 359424 + 1024 [0]
> >   8,0    0      440     1.019303850     0  C   R 360448 + 1024 [0]
> >   8,0    1      526     1.026024048     0  C   R 361472 + 1024 [0]
> >   8,0    1      538     1.032875967     0  C   R 362496 + 1024 [0]
> >   8,0    0      441     1.039595815     0  C   R 363520 + 1024 [0]
> >
> > The non-direct dd throughput can improve with 512K and 1M readahead size,
> > but still a bit slower than the direct dd case:
> >         1073741824 bytes (1.1 GB) copied, 14.1619 s, 75.8 MB/s
> >         1073741824 bytes (1.1 GB) copied, 14.1517 s, 75.9 MB/s
> >
> >    dd-512k                                     dd-direct2
> > -------------------------------------------------------------------------------------
> >   Total (sda):                             |  Total (sda):
> >    Reads Queued:      23,808,   95,232KiB  |   Reads Queued:         178,   91,136KiB  
> >    Read Dispatches:      215,   95,232KiB  |   Read Dispatches:      178,   91,136KiB  
> >    Reads Requeued:         0               |   Reads Requeued:         0               
> >    Reads Completed:      215,   95,232KiB  |   Reads Completed:      177,   90,624KiB  
> >    Read Merges:       23,593,   94,372KiB  |   Read Merges:            0,        0KiB  
> >    IO unplugs:           236               |   IO unplugs:            89               
> >                                            |  
> >   Throughput (R/W): 75,222KiB/s / 0KiB/s   |  Throughput (R/W): 75,520KiB/s / 0KiB/s   
> >   Events (sda): 48,687 entries             |  Events (sda): 1,145 entries              
> >
> > Interestingly, the throughput reported by blktrace is almost the same,
> > whereas the dd report favors the dd-direct case.
> >
> > More parameters.
> >
> > [   10.137350] scsi 3:0:0:0: Direct-Access     ATA      SanDisk SSD SATA 1.13 PQ: 0 ANSI: 5
> > [   10.147137] sd 3:0:0:0: [sda] 61500000 512-byte hardware sectors: (31.4 GB/29.3 GiB)
> > [   10.155060] sd 3:0:0:0: [sda] Write Protect is off
> > [   10.159922] sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
> > [   10.165179] sd 3:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> > [   10.174994]  sda:
> >
> >
> > /dev/sda:
> >
> >  Model=SanDisk SSD SATA 5000 2.5               , FwRev=1.13    , SerialNo=         81402200246
> >  Config={ Fixed }
> >  RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=4
> >  BuffType=unknown, BuffSize=0kB, MaxMultSect=1, MultSect=?1?
> >  CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=61500000
> >  IORDY=yes, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
> >  PIO modes:  pio0 pio1 pio2 pio3 pio4 
> >  DMA modes:  mdma0 mdma1 mdma2 
> >  UDMA modes: udma0 udma1 udma2 udma3 udma4 *udma5 
> >  AdvancedPM=yes: disabled (255) WriteCache=disabled
> >  Drive conforms to: unknown:  ATA/ATAPI-2,3,4,5,6,7
> >
> >  * signifies the current active mode
> >
> >
> > /sys/block/sda/queue/nr_requests:128
> > /sys/block/sda/queue/read_ahead_kb:128
> > /sys/block/sda/queue/max_hw_sectors_kb:32767
> > /sys/block/sda/queue/max_sectors_kb:512
> > /sys/block/sda/queue/scheduler:noop [cfq] 
> > /sys/block/sda/queue/hw_sector_size:512
> > /sys/block/sda/queue/rotational:1
> > /sys/block/sda/queue/nomerges:0
> > /sys/block/sda/queue/rq_affinity:0
> > /sys/block/sda/queue/iostats:1
> > /sys/block/sda/queue/iosched/quantum:4
> > /sys/block/sda/queue/iosched/fifo_expire_sync:124
> > /sys/block/sda/queue/iosched/fifo_expire_async:248
> > /sys/block/sda/queue/iosched/back_seek_max:16384
> > /sys/block/sda/queue/iosched/back_seek_penalty:2
> > /sys/block/sda/queue/iosched/slice_sync:100
> > /sys/block/sda/queue/iosched/slice_async:40
> > /sys/block/sda/queue/iosched/slice_async_rq:2
> > /sys/block/sda/queue/iosched/slice_idle:8
> >
> > Thanks,
> > Fengguang
> >   
