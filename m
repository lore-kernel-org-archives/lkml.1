Return-Path: <linux-kernel-owner+w=401wt.eu-S932541AbXIQWYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541AbXIQWYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 18:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757426AbXIQWYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 18:24:00 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:47229 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbXIQWX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 18:23:59 -0400
To: linux-kernel@vger.kernel.org
Subject: [2.6.22.6] nfsd: fh_verify() `malloc failure' with lots of free memory leads to NFS hang
From: Nix <nix@esperi.org.uk>
Emacs: because editing your files should be a traumatic experience.
Date: Mon, 17 Sep 2007 23:23:46 +0100
Message-ID: <874phtkk25.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-dcc1-Metrics: hades 1182; Body=1 Fuz1=1 Fuz2=1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Back in early 2006 I reported persistent hangs on the NFS server,
whereby all of a sudden about ten minutes after boot my primary NFS
server would cease responding to NFS requests until it was rebooted.
<http://www.ussg.iu.edu/hypermail/linux/kernel/0601.3/1631.html>

That time, the problem vanished when I switched to NFS-over-TCP:
<http://www.ussg.iu.edu/hypermail/linux/kernel/0601.3/1773.html>

Well, I just rebooted --- post-glibc-upgrade from 2.5 to 2.6.1, no
kernel upgrade or anything, so this bug has been latent during at
least my last three weeks of uptime. And it's back. (I've been
seeing strange long pauses doing things like ls, and I suspect
they are related: see below.)

/proc/sys/nfsd/exports on the freezing server:

# Version 1.1
# Path Client(Flags) # IPs
/usr/packages.bin/non-free      hades.wkstn.nix(rw,no_root_squash,async,wdelay,no_subtree_check,uuid=90a98d8a:a8be4806:aea3a4e1:fe3437a0)
/home/.loki.wkstn.nix   esperi.srvr.nix(rw,root_squash,async,wdelay,no_subtree_check,uuid=8ff32fd3:a6114840:ab968da8:25b41721)
/home/.loki.wkstn.nix   hades.wkstn.nix(rw,no_root_squash,async,wdelay,no_subtree_check,uuid=8ff32fd3:a6114840:ab968da8:25b41721)
/usr/lib/X11/fonts      hades.wkstn.nix(ro,root_squash,async,wdelay,uuid=87553c5b:d84740fc:b7d9f7e8:4f749689)
/usr/share/xplanet      hades.wkstn.nix(ro,root_squash,async,wdelay,uuid=87553c5b:d84740fc:b7d9f7e8:4f749689)
/usr/share/xemacs       hades.wkstn.nix(rw,no_root_squash,async,wdelay,uuid=87553c5b:d84740fc:b7d9f7e8:4f749689)
/usr/packages   hades.wkstn.nix(rw,no_root_squash,async,wdelay,no_subtree_check,uuid=2a35f82a:cca144df:a1123587:23527f53)

I turned on ALL-class nfsd debugging and here's what I see as it freezes
up:

Sep 17 22:57:00 loki warning: kernel: nfsd_dispatch: vers 3 proc 1
Sep 17 22:57:00 loki warning: kernel: nfsd: GETATTR(3)  36: 01070001 000fb001 00000000 d32ff38f 404811a6 a88d96ab
Sep 17 22:57:00 loki warning: kernel: nfsd: fh_verify(36: 01070001 000fb001 00000000 d32ff38f 404811a6 a88d96ab)
Sep 17 22:57:44 loki warning: kernel: nfsd_dispatch: vers 3 proc 4
Sep 17 22:57:44 loki warning: kernel: nfsd: ACCESS(3)   36: 01070001 000fb001 00000000 d32ff38f 404811a6 a88d96ab 0x1f
Sep 17 22:57:44 loki warning: kernel: nfsd: fh_verify(36: 01070001 000fb001 00000000 d32ff38f 404811a6 a88d96ab)
Sep 17 22:57:45 loki warning: kernel: nfsd: Dropping request due to malloc failure!
Sep 17 22:57:52 loki warning: kernel: nfsd_dispatch: vers 3 proc 4
Sep 17 22:57:52 loki warning: kernel: nfsd: ACCESS(3)   36: 01070001 000fb001 00000000 d32ff38f 404811a6 a88d96ab 0x1f
Sep 17 22:57:52 loki warning: kernel: nfsd: fh_verify(36: 01070001 000fb001 00000000 d32ff38f 404811a6 a88d96ab)
Sep 17 22:57:52 loki warning: kernel: nfsd: Dropping request due to malloc failure!
Sep 17 22:57:55 loki warning: kernel: nfsd_dispatch: vers 3 proc 4
Sep 17 22:57:55 loki warning: kernel: nfsd: ACCESS(3)   36: 01070001 000fb001 00000000 d32ff38f 404811a6 a88d96ab 0x1f
Sep 17 22:57:55 loki warning: kernel: nfsd: fh_verify(36: 01070001 000fb001 00000000 d32ff38f 404811a6 a88d96ab)
Sep 17 22:57:55 loki warning: kernel: nfsd: Dropping request due to malloc failure!
Sep 17 22:58:50 hades notice: kernel: nfs: server loki not responding, still trying
Sep 17 22:58:50 hades notice: kernel: nfs: server loki not responding, still trying
Sep 17 22:58:55 hades notice: kernel: nfs: server loki not responding, still trying
Sep 17 22:59:40 hades notice: kernel: nfs: server loki not responding, still trying


>From then on, *every* fh_verify() request fails the same way, and
obviously if you can't verify any fds you can't do much with NFS.

Looking back in the log I see intermittent malloc failures starting
almost as soon as I've booted (allowing a couple of minutes for me to
turn debugging on):

Sep 17 22:25:50 hades notice: kernel: nfs: server loki OK
[...]
Sep 17 22:28:09 loki warning: kernel: nfsd_dispatch: vers 3 proc 19
Sep 17 22:28:09 loki warning: kernel: nfsd: FSINFO(3)   28: 00070001 000fb001 00000000 d32ff38f 404811a6 a88d96ab
Sep 17 22:28:09 loki warning: kernel: nfsd: fh_verify(28: 00070001 000fb001 00000000 d32ff38f 404811a6 a88d96ab)
Sep 17 22:28:09 loki warning: kernel: nfsd: Dropping request due to malloc failure!

A while later we start seeing runs of malloc failures, which I think
correlated with the unexplained pauses in NFS response:

Sep 17 22:33:59 loki warning: kernel: nfsd_dispatch: vers 3 proc 6
Sep 17 22:33:59 loki warning: kernel: nfsd: READ(3) 44: 02070001 0001ce75 00000000 5b3c5587 fc4047d8 e8f7d9b7 20480 bytes at 4096
Sep 17 22:33:59 loki warning: kernel: nfsd: fh_verify(44: 02070001 0001ce75 00000000 5b3c5587 fc4047d8 e8f7d9b7)
Sep 17 22:33:59 loki warning: kernel: nfsd: Dropping request due to malloc failure!
Sep 17 22:33:59 loki warning: kernel: nfsd_dispatch: vers 3 proc 6
Sep 17 22:33:59 loki warning: kernel: nfsd: READ(3) 44: 02070001 0001ce75 00000000 5b3c5587 fc4047d8 e8f7d9b7 28672 bytes at 53248
Sep 17 22:33:59 loki warning: kernel: nfsd: fh_verify(44: 02070001 0001ce75 00000000 5b3c5587 fc4047d8 e8f7d9b7)
Sep 17 22:33:59 loki warning: kernel: nfsd: Dropping request due to malloc failure!
Sep 17 22:33:59 loki warning: kernel: nfsd_dispatch: vers 3 proc 6
Sep 17 22:33:59 loki warning: kernel: nfsd: READ(3) 44: 02070001 0001ce75 00000000 5b3c5587 fc4047d8 e8f7d9b7 8192 bytes at 86016
Sep 17 22:33:59 loki warning: kernel: nfsd: fh_verify(44: 02070001 0001ce75 00000000 5b3c5587 fc4047d8 e8f7d9b7)
Sep 17 22:33:59 loki warning: kernel: nfsd: Dropping request due to malloc failure!
Sep 17 22:33:59 loki warning: kernel: nfsd_dispatch: vers 3 proc 6
Sep 17 22:33:59 loki warning: kernel: nfsd: READ(3) 44: 02070001 0001ce75 00000000 5b3c5587 fc4047d8 e8f7d9b7 8192 bytes at 98304
Sep 17 22:33:59 loki warning: kernel: nfsd: fh_verify(44: 02070001 0001ce75 00000000 5b3c5587 fc4047d8 e8f7d9b7)
Sep 17 22:33:59 loki warning: kernel: nfsd: Dropping request due to malloc failure!
Sep 17 22:33:59 loki warning: kernel: nfsd_dispatch: vers 3 proc 6
Sep 17 22:33:59 loki warning: kernel: nfsd: READ(3) 44: 02070001 0001ce75 00000000 5b3c5587 fc4047d8 e8f7d9b7 65536 bytes at 110592
Sep 17 22:33:59 loki warning: kernel: nfsd: fh_verify(44: 02070001 0001ce75 00000000 5b3c5587 fc4047d8 e8f7d9b7)
Sep 17 22:33:59 loki warning: kernel: nfsd: Dropping request due to malloc failure!
Sep 17 22:33:59 loki warning: kernel: nfsd_dispatch: vers 3 proc 6
Sep 17 22:33:59 loki warning: kernel: nfsd: READ(3) 44: 02070001 0001ce75 00000000 5b3c5587 fc4047d8 e8f7d9b7 65536 bytes at 176128
Sep 17 22:33:59 loki warning: kernel: nfsd: fh_verify(44: 02070001 0001ce75 00000000 5b3c5587 fc4047d8 e8f7d9b7)
Sep 17 22:33:59 loki warning: kernel: nfsd: Dropping request due to malloc failure!
Sep 17 22:33:59 loki warning: kernel: nfsd_dispatch: vers 3 proc 6
Sep 17 22:33:59 loki warning: kernel: nfsd: READ(3) 44: 02070001 0001ce75 00000000 5b3c5587 fc4047d8 e8f7d9b7 65536 bytes at 241664
Sep 17 22:33:59 loki warning: kernel: nfsd: fh_verify(44: 02070001 0001ce75 00000000 5b3c5587 fc4047d8 e8f7d9b7)
Sep 17 22:33:59 loki warning: kernel: nfsd: Dropping request due to malloc failure!
Sep 17 22:33:59 loki warning: kernel: nfsd_dispatch: vers 3 proc 6
Sep 17 22:33:59 loki warning: kernel: nfsd: READ(3) 44: 02070001 0001ce75 00000000 5b3c5587 fc4047d8 e8f7d9b7 53248 bytes at 307200
Sep 17 22:33:59 loki warning: kernel: nfsd: fh_verify(44: 02070001 0001ce75 00000000 5b3c5587 fc4047d8 e8f7d9b7)
Sep 17 22:33:59 loki warning: kernel: nfsd: Dropping request due to malloc failure!
Sep 17 22:33:59 loki warning: kernel: nfsd_dispatch: vers 3 proc 6
Sep 17 22:33:59 loki warning: kernel: nfsd: READ(3) 44: 02070001 0001ce75 00000000 5b3c5587 fc4047d8 e8f7d9b7 8192 bytes at 397312
Sep 17 22:33:59 loki warning: kernel: nfsd: fh_verify(44: 02070001 0001ce75 00000000 5b3c5587 fc4047d8 e8f7d9b7)
Sep 17 22:33:59 loki warning: kernel: nfsd: Dropping request due to malloc failure!
Sep 17 22:33:59 loki warning: kernel: nfsd_dispatch: vers 3 proc 6
Sep 17 22:33:59 loki warning: kernel: nfsd: READ(3) 44: 02070001 0001ce75 00000000 5b3c5587 fc4047d8 e8f7d9b7 12288 bytes at 413696
Sep 17 22:33:59 loki warning: kernel: nfsd: fh_verify(44: 02070001 0001ce75 00000000 5b3c5587 fc4047d8 e8f7d9b7)
Sep 17 22:33:59 loki warning: kernel: nfsd: Dropping request due to malloc failure!
Sep 17 22:33:59 loki warning: kernel: nfsd_dispatch: vers 3 proc 6
Sep 17 22:33:59 loki warning: kernel: nfsd: READ(3) 44: 02070001 0001ce75 00000000 5b3c5587 fc4047d8 e8f7d9b7 42652 bytes at 430080
Sep 17 22:33:59 loki warning: kernel: nfsd: fh_verify(44: 02070001 0001ce75 00000000 5b3c5587 fc4047d8 e8f7d9b7)
Sep 17 22:33:59 loki warning: kernel: nfsd: Dropping request due to malloc failure!
Sep 17 22:34:02 loki warning: kernel: found domain hades.wkstn.nix
Sep 17 22:34:02 loki warning: kernel: found fsidtype 7
Sep 17 22:34:02 loki warning: kernel: found fsid length 24
Sep 17 22:34:02 loki warning: kernel: Path seems to be </usr/lib/X11/fonts>
Sep 17 22:34:02 loki warning: kernel: Found the path /usr/lib/X11/fonts
Sep 17 22:34:02 loki warning: kernel: nfsd_dispatch: vers 3 proc 6
Sep 17 22:34:02 loki warning: kernel: nfsd: READ(3) 44: 02070001 0001ce75 00000000 5b3c5587 fc4047d8 e8f7d9b7 42652 bytes at 430080
Sep 17 22:34:02 loki warning: kernel: nfsd: fh_verify(44: 02070001 0001ce75 00000000 5b3c5587 fc4047d8 e8f7d9b7)
Sep 17 22:34:02 loki warning: kernel: nfsd_dispatch: vers 3 proc 6

Fifteen minutes after that the whole thing seized up with malloc
failures as the only response.

We've obviously got some sort of resource leak (although why it's
suddenly appeared I have no idea). There's buckets of memory, though.
The system's not swapping or under especially high memory pressure
(indeed as I've just rebooted it and hardly started anything but the
usual daemon swarm and LVM/MD stuff, it's under rather *low* pressure by
its standards). (Dumps of /proc/meminfo, /proc/zoneinfo and
/proc/slabinfo below.)


I note that this error can be caused by both ENOMEM and EAGAIN, and that
there are numerous points in fh_verify() whose failure can lead to this
error. I'm just instrumenting them now so I can tell which is failing.



MemTotal:       321172 kB
MemFree:          6152 kB
Buffers:          2540 kB
Cached:         106840 kB
SwapCached:          0 kB
Active:         277004 kB
Inactive:         4692 kB
SwapTotal:     1851368 kB
SwapFree:      1851188 kB
Dirty:             160 kB
Writeback:           0 kB
AnonPages:      172340 kB
Mapped:          72692 kB
Slab:            12764 kB
SReclaimable:     4852 kB
SUnreclaim:       7912 kB
PageTables:       2616 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   2011952 kB
Committed_AS:   492284 kB
VmallocTotal:   712684 kB
VmallocUsed:      2648 kB
VmallocChunk:   710008 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
Hugepagesize:     4096 kB

Node 0, zone      DMA
  pages free     337
        min      28
        low      35
        high     42
        scanned  0 (a: 23 i: 24)
        spanned  4096
        present  4064
    nr_free_pages 337
    nr_inactive  0
    nr_active    2811
    nr_anon_pages 1788
    nr_mapped    885
    nr_file_pages 1023
    nr_dirty     0
    nr_writeback 0
    nr_slab_reclaimable 47
    nr_slab_unreclaimable 32
    nr_page_table_pages 11
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 421
        protection: (0, 301)
  pagesets
    cpu: 0 pcp: 0
              count: 0
              high:  0
              batch: 1
    cpu: 0 pcp: 1
              count: 0
              high:  0
              batch: 1
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         0
Node 0, zone   Normal
  pages free     1227
        min      541
        low      676
        high     811
        scanned  0 (a: 0 i: 0)
        spanned  77804
        present  77197
    nr_free_pages 1227
    nr_inactive  5698
    nr_active    61811
    nr_anon_pages 40341
    nr_mapped    19329
    nr_file_pages 27174
    nr_dirty     13
    nr_writeback 0
    nr_slab_reclaimable 1049
    nr_slab_unreclaimable 2047
    nr_page_table_pages 698
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 4904
        protection: (0, 0)
  pagesets
    cpu: 0 pcp: 0
              count: 66
              high:  90
              batch: 15
    cpu: 0 pcp: 1
              count: 5
              high:  30
              batch: 7
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         4096

# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
jbd_4k                 0      0   4096    1    1 : tunables   24   12    0 : slabdata      0      0      0
jbd_1k                 0      0   1024    4    1 : tunables   54   27    0 : slabdata      0      0      0
jbd_2k                 0      0   2048    2    1 : tunables   24   12    0 : slabdata      0      0      0
raid5-md2            512    517    344   11    1 : tunables   54   27    0 : slabdata     47     47      0
raid5-md1            512    517    344   11    1 : tunables   54   27    0 : slabdata     47     47      0
rpc_buffers            8      8   2048    2    1 : tunables   24   12    0 : slabdata      4      4      0
rpc_tasks              8     24    160   24    1 : tunables  120   60    0 : slabdata      1      1      0
rpc_inode_cache       20     20    384   10    1 : tunables   54   27    0 : slabdata      2      2      0
bridge_fdb_cache       8     59     64   59    1 : tunables  120   60    0 : slabdata      1      1      0
UNIX                  91    100    384   10    1 : tunables   54   27    0 : slabdata     10     10      0
dm-snapshot-in       128    134     56   67    1 : tunables  120   60    0 : slabdata      2      2      0
dm-snapshot-ex         0      0     16  203    1 : tunables  120   60    0 : slabdata      0      0      0
dm-crypt_io            0      0     36  101    1 : tunables  120   60    0 : slabdata      0      0      0
dm_tio              4366   4669     16  203    1 : tunables  120   60    0 : slabdata     23     23      0
dm_io               4366   4563     20  169    1 : tunables  120   60    0 : slabdata     27     27      0
uhci_urb_priv          4    127     28  127    1 : tunables  120   60    0 : slabdata      1      1      0
scsi_cmd_cache        39     39    288   13    1 : tunables   54   27    0 : slabdata      3      3      0
cfq_io_context       250    288     80   48    1 : tunables  120   60    0 : slabdata      6      6      0
cfq_queue            247    264     88   44    1 : tunables  120   60    0 : slabdata      6      6      0
mqueue_inode_cache      1      8    480    8    1 : tunables   54   27    0 : slabdata      1      1      0
fuse_request           0      0    360   11    1 : tunables   54   27    0 : slabdata      0      0      0
fuse_inode             0      0    352   11    1 : tunables   54   27    0 : slabdata      0      0      0
nfs_write_data        36     36    448    9    1 : tunables   54   27    0 : slabdata      4      4      0
nfs_read_data         32     36    416    9    1 : tunables   54   27    0 : slabdata      4      4      0
nfs_inode_cache       15     21    560    7    1 : tunables   54   27    0 : slabdata      3      3      0
nfs_page               0      0     64   59    1 : tunables  120   60    0 : slabdata      0      0      0
isofs_inode_cache      0      0    324   12    1 : tunables   54   27    0 : slabdata      0      0      0
hugetlbfs_inode_cache      1     13    296   13    1 : tunables   54   27    0 : slabdata      1      1      0
ext2_inode_cache       5      9    424    9    1 : tunables   54   27    0 : slabdata      1      1      0
ext2_xattr             0      0     44   84    1 : tunables  120   60    0 : slabdata      0      0      0
journal_handle         1    169     20  169    1 : tunables  120   60    0 : slabdata      1      1      0
journal_head          98    360     52   72    1 : tunables  120   60    0 : slabdata      5      5      0
revoke_table          20    254     12  254    1 : tunables  120   60    0 : slabdata      1      1      0
revoke_record          0      0     16  203    1 : tunables  120   60    0 : slabdata      0      0      0
ext3_inode_cache    2392   3429    440    9    1 : tunables   54   27    0 : slabdata    381    381      0
ext3_xattr             0      0     44   84    1 : tunables  120   60    0 : slabdata      0      0      0
reiser_inode_cache    172    180    384   10    1 : tunables   54   27    0 : slabdata     18     18      0
configfs_dir_cache      0      0     48   78    1 : tunables  120   60    0 : slabdata      0      0      0
dnotify_cache          1    169     20  169    1 : tunables  120   60    0 : slabdata      1      1      0
dquot                 17     30    128   30    1 : tunables  120   60    0 : slabdata      1      1      0
inotify_event_cache      0      0     28  127    1 : tunables  120   60    0 : slabdata      0      0      0
inotify_watch_cache      4     92     40   92    1 : tunables  120   60    0 : slabdata      1      1      0
kioctx                 1     24    160   24    1 : tunables  120   60    0 : slabdata      1      1      0
kiocb                  0      0    160   24    1 : tunables  120   60    0 : slabdata      0      0      0
fasync_cache           3    203     16  203    1 : tunables  120   60    0 : slabdata      1      1      0
shmem_inode_cache    950    950    396   10    1 : tunables   54   27    0 : slabdata     95     95      0
posix_timers_cache      0      0    100   39    1 : tunables  120   60    0 : slabdata      0      0      0
uid_cache             15     59     64   59    1 : tunables  120   60    0 : slabdata      1      1      0
UDP-Lite               0      0    480    8    1 : tunables   54   27    0 : slabdata      0      0      0
tcp_bind_bucket       37    203     16  203    1 : tunables  120   60    0 : slabdata      1      1      0
inet_peer_cache        1     59     64   59    1 : tunables  120   60    0 : slabdata      1      1      0
ip_fib_alias          12    113     32  113    1 : tunables  120   60    0 : slabdata      1      1      0
ip_fib_hash           11    113     32  113    1 : tunables  120   60    0 : slabdata      1      1      0
ip_dst_cache          31     90    256   15    1 : tunables  120   60    0 : slabdata      6      6      0
arp_cache              5     30    128   30    1 : tunables  120   60    0 : slabdata      1      1      0
RAW                    2      9    448    9    1 : tunables   54   27    0 : slabdata      1      1      0
UDP                   29     32    480    8    1 : tunables   54   27    0 : slabdata      4      4      0
tw_sock_TCP            0      0     96   40    1 : tunables  120   60    0 : slabdata      0      0      0
request_sock_TCP       0      0     64   59    1 : tunables  120   60    0 : slabdata      0      0      0
TCP                   45     49   1056    7    2 : tunables   24   12    0 : slabdata      7      7      0
eventpoll_pwq          2    101     36  101    1 : tunables  120   60    0 : slabdata      1      1      0
eventpoll_epi          2     40     96   40    1 : tunables  120   60    0 : slabdata      1      1      0
sgpool-128             2      2   2048    2    1 : tunables   24   12    0 : slabdata      1      1      0
sgpool-64              2      4   1024    4    1 : tunables   54   27    0 : slabdata      1      1      0
sgpool-32              2      8    512    8    1 : tunables   54   27    0 : slabdata      1      1      0
sgpool-16              2     15    256   15    1 : tunables  120   60    0 : slabdata      1      1      0
sgpool-8              30     30    128   30    1 : tunables  120   60    0 : slabdata      1      1      0
scsi_io_context        0      0    104   37    1 : tunables  120   60    0 : slabdata      0      0      0
blkdev_ioc            96    113     32  113    1 : tunables  120   60    0 : slabdata      1      1      0
blkdev_queue          26     27    892    9    2 : tunables   54   27    0 : slabdata      3      3      0
blkdev_requests      142    242    176   22    1 : tunables  120   60    0 : slabdata     11     11      0
biovec-256           274    274   3072    2    2 : tunables   24   12    0 : slabdata    137    137      0
biovec-128           274    275   1536    5    2 : tunables   24   12    0 : slabdata     55     55      0
biovec-64            274    275    768    5    1 : tunables   54   27    0 : slabdata     55     55      0
biovec-16            274    280    192   20    1 : tunables  120   60    0 : slabdata     14     14      0
biovec-4             274    295     64   59    1 : tunables  120   60    0 : slabdata      5      5      0
biovec-1             321    609     16  203    1 : tunables  120   60    0 : slabdata      3      3      0
bio                  319    354     64   59    1 : tunables  120   60    0 : slabdata      6      6      0
sock_inode_cache     178    187    352   11    1 : tunables   54   27    0 : slabdata     17     17      0
skbuff_fclone_cache      9     12    320   12    1 : tunables   54   27    0 : slabdata      1      1      0
skbuff_head_cache     75    120    160   24    1 : tunables  120   60    0 : slabdata      5      5      0
file_lock_cache        4     42     92   42    1 : tunables  120   60    0 : slabdata      1      1      0
proc_inode_cache     168    168    312   12    1 : tunables   54   27    0 : slabdata     14     14      0
sigqueue               8     27    144   27    1 : tunables  120   60    0 : slabdata      1      1      0
radix_tree_node     1734   3250    288   13    1 : tunables   54   27    0 : slabdata    250    250      0
bdev_cache            44     45    416    9    1 : tunables   54   27    0 : slabdata      5      5      0
sysfs_dir_cache     3254   3276     48   78    1 : tunables  120   60    0 : slabdata     42     42      0
mnt_cache             67     90    128   30    1 : tunables  120   60    0 : slabdata      3      3      0
inode_cache          801    871    296   13    1 : tunables   54   27    0 : slabdata     67     67      0
dentry              4131   6300    128   30    1 : tunables  120   60    0 : slabdata    210    210      0
filp                1332   1392    160   24    1 : tunables  120   60    0 : slabdata     58     58      0
names_cache            4      4   4096    1    1 : tunables   24   12    0 : slabdata      4      4      0
idr_layer_cache      152    174    136   29    1 : tunables  120   60    0 : slabdata      6      6      0
buffer_head         4991  27144     52   72    1 : tunables  120   60    0 : slabdata    377    377      0
mm_struct            126    126    416    9    1 : tunables   54   27    0 : slabdata     14     14      0
vm_area_struct     12759  13570     84   46    1 : tunables  120   60    0 : slabdata    295    295      0
fs_cache             108    113     32  113    1 : tunables  120   60    0 : slabdata      1      1      0
files_cache           93    100    192   20    1 : tunables  120   60    0 : slabdata      5      5      0
signal_cache         135    135    416    9    1 : tunables   54   27    0 : slabdata     15     15      0
sighand_cache        129    129   1312    3    1 : tunables   24   12    0 : slabdata     43     43      0
task_struct          135    135   1280    3    1 : tunables   24   12    0 : slabdata     45     45      0
anon_vma            1179   1356      8  339    1 : tunables  120   60    0 : slabdata      4      4      0
pid                  150    202     36  101    1 : tunables  120   60    0 : slabdata      2      2      0
size-4194304(DMA)      0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
size-4194304           0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
size-2097152(DMA)      0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0
size-2097152           0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0
size-1048576(DMA)      0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0
size-1048576           0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0
size-524288(DMA)       0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0
size-524288            0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0
size-262144(DMA)       0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0
size-262144            0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0
size-131072(DMA)       0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0
size-131072            0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0
size-65536(DMA)        0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0
size-65536             1      1  65536    1   16 : tunables    8    4    0 : slabdata      1      1      0
size-32768(DMA)        0      0  32768    1    8 : tunables    8    4    0 : slabdata      0      0      0
size-32768             0      0  32768    1    8 : tunables    8    4    0 : slabdata      0      0      0
size-16384(DMA)        0      0  16384    1    4 : tunables    8    4    0 : slabdata      0      0      0
size-16384             0      0  16384    1    4 : tunables    8    4    0 : slabdata      0      0      0
size-8192(DMA)         0      0   8192    1    2 : tunables    8    4    0 : slabdata      0      0      0
size-8192              5      5   8192    1    2 : tunables    8    4    0 : slabdata      5      5      0
size-4096(DMA)         0      0   4096    1    1 : tunables   24   12    0 : slabdata      0      0      0
size-4096             96     96   4096    1    1 : tunables   24   12    0 : slabdata     96     96      0
size-2048(DMA)         0      0   2048    2    1 : tunables   24   12    0 : slabdata      0      0      0
size-2048            126    134   2048    2    1 : tunables   24   12    0 : slabdata     67     67      0
size-1024(DMA)         0      0   1024    4    1 : tunables   54   27    0 : slabdata      0      0      0
size-1024            128    128   1024    4    1 : tunables   54   27    0 : slabdata     32     32      0
size-512(DMA)          0      0    512    8    1 : tunables   54   27    0 : slabdata      0      0      0
size-512             416    416    512    8    1 : tunables   54   27    0 : slabdata     52     52      0
size-256(DMA)          0      0    256   15    1 : tunables  120   60    0 : slabdata      0      0      0
size-256             446    465    256   15    1 : tunables  120   60    0 : slabdata     31     31      0
size-192(DMA)          0      0    192   20    1 : tunables  120   60    0 : slabdata      0      0      0
size-192             133    140    192   20    1 : tunables  120   60    0 : slabdata      7      7      0
size-128(DMA)          0      0    128   30    1 : tunables  120   60    0 : slabdata      0      0      0
size-128             707   1140    128   30    1 : tunables  120   60    0 : slabdata     38     38      0
size-96(DMA)           0      0     96   40    1 : tunables  120   60    0 : slabdata      0      0      0
size-96              517    800     96   40    1 : tunables  120   60    0 : slabdata     20     20      0
size-64(DMA)           0      0     64   59    1 : tunables  120   60    0 : slabdata      0      0      0
size-32(DMA)           0      0     32  113    1 : tunables  120   60    0 : slabdata      0      0      0
size-64             3140   3776     64   59    1 : tunables  120   60    0 : slabdata     64     64      0
size-32             2339   2825     32  113    1 : tunables  120   60    0 : slabdata     25     25      0
kmem_cache           143    160     96   40    1 : tunables  120   60    0 : slabdata      4      4      0
