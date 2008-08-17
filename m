Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbYHQR7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbYHQR7V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 13:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbYHQR7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 13:59:13 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:36567 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbYHQR7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 13:59:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=rIrxLfF1WMUq8UJ7/xjMnxiHrIkiuWhxYNVY9lz9YSqr1SWdTi68o5XN8AsyKwinIu
         VpcaIEeLTt5wFbslVTKKQyTEom2B2Svy6YvTGnXHNez4osBD6UQG3TTg61nNdX5JgGh9
         nHrs3i0r1vxBfx7PskoQxcDUDnGquBJK0U83E=
Message-ID: <f2b895370808171059x4bd0296frf50b07ae7af21375@mail.gmail.com>
Date: Sun, 17 Aug 2008 19:59:10 +0200
From: "Marc Villemade" <mastachand@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [Follow-up] Physical memory disappeared from /proc/meminfo
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

(I apologize in advance for this long email)

While looking for answers to my memory problems i've been having for
some time now, i've stumbled onto these posts:

Dated last year :
http://kerneltrap.org/mailarchive/linux-kernel/2007/8/26/164909

and dated from a couple months ago:
http://kerneltrap.org/mailarchive/linux-kernel/2008/6/24/2209554

I'm having exactly the same issue but on a 2.6.20.4 vanilla kernel
(x86). /proc/meminfo shows that
MemFree+Buffers+cached+AnonPages+Slab+Mapped != MemTotal, which AFAIK
should be the case.

6_days_uptime_machine ~ # cat /proc/meminfo
MemTotal:      3106668 kB
MemFree:        678104 kB
Buffers:        120024 kB
Cached:          69892 kB
SwapCached:          0 kB
Active:         740872 kB
Inactive:      1621704 kB
HighTotal:     2227996 kB
HighFree:        21380 kB
LowTotal:       878672 kB
LowFree:        656724 kB
SwapTotal:     4192956 kB
SwapFree:      4192956 kB
Dirty:            1292 kB
Writeback:           0 kB
AnonPages:      586900 kB
Mapped:          13824 kB
Slab:            50432 kB
SReclaimable:    39092 kB
SUnreclaim:      11340 kB
PageTables:       1532 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   5746288 kB
Committed_AS:  1073624 kB
VmallocTotal:   114680 kB
VmallocUsed:      8944 kB
VmallocChunk:   105568 kB

in contrast, here's the meminfo from a machine that has been rebooted
20 hours before, in which the above mentioned figures almost add up to
MemTotal. There's 50 MB missing already which makes me think the leak
starts right away after boot up...

20_hours_uptime_machine ~ # cat /proc/meminfo
MemTotal:      3106668 kB
MemFree:       2455932 kB
Buffers:         88624 kB
Cached:          69364 kB
SwapCached:          0 kB
Active:         496772 kB
Inactive:       114680 kB
HighTotal:     2227996 kB
HighFree:      1695240 kB
LowTotal:       878672 kB
LowFree:        760692 kB
SwapTotal:     4192956 kB
SwapFree:      4192956 kB
Dirty:            1016 kB
Writeback:           0 kB
AnonPages:      395888 kB
Mapped:          13956 kB
Slab:            23400 kB
SReclaimable:    12828 kB
SUnreclaim:      10572 kB
PageTables:       1048 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   5746288 kB
Committed_AS:   988928 kB
VmallocTotal:   114680 kB
VmallocUsed:      8944 kB
VmallocChunk:   105568 kB

Over time, i've noticed that the LRU lists (active.inactive) just get
bigger and bigger and inactive especially never seems to get freed
which doesn't make a lot of sense to me. I've tried the drop_cache
thing which helps for a while (but still doesn't make the memory
accounting get back to normal), but it is not a fix, it's only a
temporary solution. I'd like to have those machines running without us
having to drop caches once in a while.


The main brain-teaser for me here is that the machines were in use
several months ago in another setup almost identical in terms of
running processes - same kernel, same running processes, only
differences are mostly network-wise and machines have not been
reinstalled - and we didn't have this kind of issues. Now, we have to
reboot the servers every other week otherwise applications just get
refused for more memory at one point. That is inexplicable to me !
Which is why i turn to you guys ;)

Looking at meminfo, something else strikes me :  if SwapCached means
that there was once something swapped out and since it is always 0 on
my machines, how can a machine apparently going out of memory, and on
which swap is on, never swaps anything ? It seems logical to me that
one can't have more memory than the system can allocate which would
make swap space on a 32 bit machine with 4Gb of RAM useless, if it
were not for the MMU. Those machines have MMU enabled (hence the 3Gb
available even though 4 are physically installed). So i should be able
to use swap. Hence why doesn't it seem to be the case when the
machines are likely running out of memory (refusing malloc() calls).
Or maybe, i'm just totally wrong about the meaning of SwapCached ??!?


I've browsed (read grep'd) throu the changelogs from 2.6.20.4 and up
to 2.6.26.3 and saw that there was a consequent amount of memory leaks
fixed during that period, but they were mostly linked to USB ( i don't
have any USB devices on these machines although usbfs is used),
NETFILTER (which i don't use) or on other architectures than x86. i
didn't see anything strikingly matching my setup. Except maybe for
some SCSI bugs (mostly linked to firmwares).

Rob Mueller in June (second refered post) had a 2.6.25.x and he still
had the problem. Would you guys know if 2.6.26 fixes this issue ? Fred
on the first thread i posted says he doesn't have the issue with a
2.6.1 but had it with 2.6.12 and 2.6.20.x.

Here is some more info on the 7 days uptime machine. I didn't include
a dmesg cause this mail is already pretty long, and it doesn't seem to
me that there is anything worth of interest in it, but i could be
totally wrong, so please let me know if you want me to send it to you
as well. I might just copy a couple of lines which look a bit
suspicious to me :

------------- from DMESG ---
PM: Writing back config space on device 0000:08:03.0 at offset 3 (was
804000, writing 804010)
PM: Writing back config space on device 0000:08:03.0 at offset 2 (was
2000000, writing 2000010)
PM: Writing back config space on device 0000:08:03.0 at offset 1 (was
2b00000, writing 2b00146)

------------------------------------------------ ZONEINFO


6_days_uptime_machine ~ # cat /proc/zoneinfo
Node 0, zone      DMA
  pages free     2827
        min      17
        low      21
        high     25
        active   0
        inactive 0
        scanned  0 (a: 9 i: 9)
        spanned  4096
        present  4064
    nr_anon_pages 0
    nr_mapped    1
    nr_file_pages 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 0
    nr_page_table_pages 0
    nr_dirty     0
    nr_writeback 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
        protection: (0, 873, 4048)
  pagesets
  all_unreclaimable: 1
  prev_priority:     12
  start_pfn:         0
Node 0, zone   Normal
  pages free     161364
        min      936
        low      1170
        high     1404
        active   33965
        inactive 7245
        scanned  0 (a: 0 i: 28)
        spanned  225280
        present  223520
    nr_anon_pages 5081
    nr_mapped    0
    nr_file_pages 31868
    nr_slab_reclaimable 9773
    nr_slab_unreclaimable 2790
    nr_page_table_pages 383
    nr_dirty     18
    nr_writeback 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 3
        protection: (0, 0, 25400)
  pagesets
    cpu: 0 pcp: 0
              count: 140
              high:  186
              batch: 31
    cpu: 0 pcp: 1
              count: 23
              high:  62
              batch: 15
  vm stats threshold: 24
    cpu: 1 pcp: 0
              count: 19
              high:  186
              batch: 31
    cpu: 1 pcp: 1
              count: 14
              high:  62
              batch: 15
  vm stats threshold: 24
    cpu: 2 pcp: 0
              count: 158
              high:  186
              batch: 31
    cpu: 2 pcp: 1
              count: 10
              high:  62
              batch: 15
  vm stats threshold: 24
    cpu: 3 pcp: 0
              count: 94
              high:  186
              batch: 31
    cpu: 3 pcp: 1
              count: 7
              high:  62
              batch: 15
  vm stats threshold: 24
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         4096
Node 0, zone  HighMem
  pages free     3175
        min      128
        low      979
        high     1831
        active   153497
        inactive 398182
        scanned  0 (a: 0 i: 0)
        spanned  819200
        present  812800
    nr_anon_pages 143849
    nr_mapped    3456
    nr_file_pages 15590
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 0
    nr_page_table_pages 0
    nr_dirty     44
    nr_writeback 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
        protection: (0, 0, 0)
  pagesets
    cpu: 0 pcp: 0
              count: 14
              high:  186
              batch: 31
    cpu: 0 pcp: 1
              count: 9
              high:  62
              batch: 15
  vm stats threshold: 36
    cpu: 1 pcp: 0
              count: 12
              high:  186
              batch: 31
    cpu: 1 pcp: 1
              count: 3
              high:  62
              batch: 15
  vm stats threshold: 36
    cpu: 2 pcp: 0
              count: 7
              high:  186
              batch: 31
    cpu: 2 pcp: 1
              count: 3
              high:  62
              batch: 15
  vm stats threshold: 36
    cpu: 3 pcp: 0
              count: 33
              high:  186
              batch: 31
    cpu: 3 pcp: 1
              count: 9
              high:  62
              batch: 15
  vm stats threshold: 36
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         229376

------------------------------------------------ LSMOD


6_days_uptime_machine ~ # lsmod
Module                  Size  Used by
iptable_nat             7172  0
nf_nat                 16172  1 iptable_nat
nf_conntrack_ipv4      14860  2 iptable_nat
nf_conntrack           51336  3 iptable_nat,nf_nat,nf_conntrack_ipv4
nfnetlink               6040  3 nf_nat,nf_conntrack_ipv4,nf_conntrack
iptable_filter          3332  1
ip_tables              11508  2 iptable_nat,iptable_filter
x_tables               12804  2 iptable_nat,ip_tables
rtc                    11184  0
bonding                84248  0
bnx2                  142960  0
zlib_inflate           15232  1 bnx2
evdev                   9088  0
raid456               119568  0
xor                    15112  1 raid456
tg3                   104712  0
e1000                 121856  0
sata_nv                15496  0
libata                 96164  1 sata_nv
usbhid                 15240  0
ohci_hcd               19852  0
uhci_hcd               22036  0
usb_storage            34312  0
ehci_hcd               28824  0
usbcore               115084  6 usbhid,ohci_hcd,uhci_hcd,usb_storage,ehci_hcd


Thanks for any information you might have that would help me figure
this out. We've been having this problem for two months now, and it's
getting very infuriating not to be able to fix it or even understand
where the problem stems from. If you need any more information, i'd be
happy to hand it to you. Just ask !

Cheers

Marc Villemade
