Return-Path: <linux-kernel-owner+w=401wt.eu-S1751810AbZIQKJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbZIQKJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 06:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbZIQKJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 06:09:00 -0400
Received: from sip.m2j.com.br ([65.111.177.132]:40767 "EHLO www.m2j.com.br"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751483AbZIQKI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 06:08:59 -0400
X-Greylist: delayed 748 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2009 06:08:59 EDT
Message-ID: <4AB207C6.4020107@m2j.com.br>
Date: Thu, 17 Sep 2009 06:56:22 -0300
From: Marcelo Pacheco <marcelo@m2j.com.br>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: buffered reads on /dev/sdXY use buffers instead of cache memory ?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried googling this for 2 hours, found nothing that answers this
I think the answers to some of the questions posed here will be of
interest to a lot of people

Kernel: 2.6.27.29-0.1-pae from OpenSuse 11.1
All disks are using noop scheduler
8GB RAM total (all available to linux)

<7>free_area_init_node: node 0, pgdat f2a00000, node_mem_map f2a02000
<7>  DMA zone: 3964 pages, LIFO batch:0
<7>  Normal zone: 223300 pages, LIFO batch:31
<7>  HighMem zone: 1827956 pages, LIFO batch:31

2x 500GB SAS disks using true hardware RAID-1 (/dev/sda is the mirror)
# lspci -v -s 03:00.0
03:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068E
PCI-Express Fusion-MPT SAS (rev 08)
        Subsystem: Dell SAS 6/iR Adapter RAID Controller
        Flags: bus master, fast devsel, latency 0, IRQ 214
        I/O ports at ec00 [size=256]
        Memory at df7ec000 (64-bit, non-prefetchable) [size=16K]
        Memory at df7f0000 (64-bit, non-prefetchable) [size=64K]
        Expansion ROM at df600000 [disabled] [size=1M]
        Capabilities: [50] Power Management version 2
        Capabilities: [68] Express Endpoint, MSI 00
        Capabilities: [98] Message Signalled Interrupts: Mask- 64bit+
Count=1/1 Enable+
        Capabilities: [b0] MSI-X: Enable- Mask- TabSize=1
        Capabilities: [100] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO+ CmpltAbrt+
UnxCmplt+ RxOF- MalfTLP- ECRC- UnsupReq+ ACSVoil-
                UESvrt: DLP+ SDES- TLP+ FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC+ UnsupReq- ACSVoil-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr-
                CESta:  RxErr- BadTLP+ BadDLLP+ Rollover+ Timeout+
NonFatalErr-
                AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+
ChkEn-
        Kernel driver in use: mptsas
        Kernel modules: mptsas

Bellow is the output from two consecutive calls to dd, to read the first
2GB from /dev/sda3 (my / reiserfs partition), using 32MB read requests
If I reduce the test to 512MB, then I get faster (cached) results, but
cached memory shrinks instead of rises, and buffers covers the 512MB
transfered
It looks like buffers are limited to Low (first 960MB) memory, while
cache aren't
replacing /dev/sda3 with a large file also caches things (increasing
cached content instead of buffers)

1 - reading the device never allocate regular cache entries, uses
buffers only ?
2 - perhaps this is a 32-bit controller, so it can't allocate buffers on
high memory ?
3 - Or the driver is limited to 32-bit addressing ?
4 - Would all memory be available for buffering if I were running 64-bit
linux ?


Two consecutive runs reading 1GB using dd (1024 x 1024k reads) and free
output before/after, notice the 2nd run is actually a little slower

# free; time dd if=/dev/sda3 of=/dev/zero bs=1024k count=1024; free
             total       used       free     shared    buffers     cached
Mem:       4096328    4052904      43424          0     622000    2630088
-/+ buffers/cache:     800816    3295512
Swap:       987956          4     987952
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 9.99695 s, 107 MB/s

real    0m10.002s
user    0m0.000s
sys     0m2.548s
             total       used       free     shared    buffers     cached
Mem:       4096328    4072664      23664          0     734292    2536400
-/+ buffers/cache:     801972    3294356
Swap:       987956          4     987952


# free; time dd if=/dev/sda3 of=/dev/zero bs=1024k count=1024; free
             total       used       free     shared    buffers     cached
Mem:       4096328    4074492      21836          0     734296    2538936
-/+ buffers/cache:     801260    3295068
Swap:       987956          4     987952
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 11.2107 s, 95.8 MB/s

real    0m11.311s
user    0m0.004s
sys     0m2.800s
             total       used       free     shared    buffers     cached
Mem:       4096328    4075980      20348          0     735128    2539608
-/+ buffers/cache:     801244    3295084
Swap:       987956          4     987952

