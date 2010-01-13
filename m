Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995Ab0AMQYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab0AMQYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 11:24:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570Ab0AMQYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 11:24:04 -0500
Received: from wind.enjellic.com ([209.243.13.15]:34178 "EHLO
	wind.enjellic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953Ab0AMQYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 11:24:01 -0500
X-Greylist: delayed 2090 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jan 2010 11:23:58 EST
Message-Id: <201001131548.o0DFmtrD004610@wind.enjellic.com>
From: greg@enjellic.com
Date: Wed, 13 Jan 2010 09:48:55 -0600
Reply-To: greg@enjellic.com
X-Mailer: Mail User's Shell (7.2.5 10/14/92)
To: linux-kernel@vger.kernel.org
Subject: Memory leak makes 'Blast the Bubbles' problematic.
Cc: akpm@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, hope the week is going well for everyone.

Unless I miss my guess there is some type of leak or other memory
anomaly starting in at least late model 2.6.31.x kernels.  I took a
snapshot of the behavior on 2.6.32.3 as well since I knew that
2.6.31.11 would be considered long in the tooth by all the informed
intelligentia who would be looking at this...... :-)

The machine in question is an older Dell desktop machine with a 1.7Ghz
Pentium 4 and 756 megabytes of RAM.  My wife uses it to run X and play
her Flash games in Firefox.  She started chewing on my rear end about
a month ago complaining that her games were running so slow she
couldn't stand it.  Rebooting the machine would restore proper
behavior for a short period of time.  She logs in and out of X from
text mode so the issue isn't with X and/or Firefox chewing up all the
memory.

I booted up a fresh copy of 2.6.32.3 yesterday morning and dropped all
the caches (/proc/sys/vm/drop_caches).  I told my wife to play some
games last night so I could instrument the change.  This morning I
dropped all the caches and took another snapshot of memory status and
the impact of whatever is happening seems clear, ie:


Before:
             total       used       free     shared    buffers     cached
Mem:        774644     308284     466360          0      19116     270120
-/+ buffers/cache:      19048     755596
Swap:       125368          0     125368

After:
             total       used       free     shared    buffers     cached
Mem:        774644     645648     128996          0     155772     294664
-/+ buffers/cache:     195212     579432
Swap:       125368          0     125368


I did a little bit more investigating and I'm suspicious the behavior
is secondary to updatedb running rather anything secondary to X having
been run.

The 'Before' snapshot was taken from logs the system mails me every
night at midnight.  That would have been after my wife spent a few
hours playing her Flash games but before updatedb ran.

The kernel is custom compiled for the machine.  I'm including the
.config below along with diffs showing before/after memory consumption
status.  I also included a 'ps fax' listing of what was running at the
time I took the snapshots.  I'd be happy to grab any additional
instrumentation people feel they might need.

I hope all this is helpful since whatever behavior is being tickled
makes recent kernels problematic on this caliber of hardware.  Let
alone the effects on my rear end from my beloved not being able to
play 'Blast the Bubbles' the way she would like.

Let me know if I can provide any additional information.

Best wishes for a pleasant afternoon to everyone.

Greg


/proc/meminfo diff: -------------------------------------------------------
--- meminfo.txt Tue Jan 12 11:31:48 2010
+++ -   Wed Jan 13 09:25:11 2010
@@ -1,35 +1,35 @@
 MemTotal:         774644 kB
-MemFree:          719848 kB
-Buffers:            3124 kB
-Cached:            39832 kB
+MemFree:          128800 kB
+Buffers:          155784 kB
+Cached:           294768 kB
 SwapCached:            0 kB
-Active:            15968 kB
-Inactive:          30900 kB
-Active(anon):       3912 kB
+Active:           173152 kB
+Inactive:         281488 kB
+Active(anon):       4088 kB
 Inactive(anon):        0 kB
-Active(file):      12056 kB
-Inactive(file):    30900 kB
+Active(file):     169064 kB
+Inactive(file):   281488 kB
 Unevictable:           0 kB
 Mlocked:               0 kB
 SwapTotal:        125368 kB
 SwapFree:         125368 kB
-Dirty:                12 kB
+Dirty:                 4 kB
 Writeback:             0 kB
-AnonPages:          3928 kB
-Mapped:             4172 kB
+AnonPages:          4108 kB
+Mapped:             4260 kB
 Shmem:                 0 kB
-Slab:               4312 kB
-SReclaimable:       1244 kB
-SUnreclaim:         3068 kB
-KernelStack:         536 kB
-PageTables:          400 kB
+Slab:             187472 kB
+SReclaimable:     184256 kB
+SUnreclaim:         3216 kB
+KernelStack:         592 kB
+PageTables:          444 kB
 NFS_Unstable:          0 kB
 Bounce:                0 kB
 WritebackTmp:          0 kB
 CommitLimit:      512688 kB
-Committed_AS:       9804 kB
+Committed_AS:      11676 kB
 VmallocTotal:     254124 kB
 VmallocUsed:         212 kB
 VmallocChunk:     247300 kB
-DirectMap4k:        5596 kB
-DirectMap2M:      780288 kB
+DirectMap4k:       40412 kB
+DirectMap2M:      745472 kB

---------------------------------------------------------------------------


/proc/vmstat diff: --------------------------------------------------------
--- vmstat.txt  Tue Jan 12 11:32:00 2010
+++ -   Wed Jan 13 09:26:43 2010
@@ -1,19 +1,19 @@
-nr_free_pages 179962
+nr_free_pages 32200
 nr_inactive_anon 0
-nr_active_anon 978
-nr_inactive_file 7732
-nr_active_file 3016
+nr_active_anon 1019
+nr_inactive_file 70367
+nr_active_file 42274
 nr_unevictable 0
 nr_mlock 0
-nr_anon_pages 982
-nr_mapped 1043
-nr_file_pages 10748
-nr_dirty 7
+nr_anon_pages 1024
+nr_mapped 1068
+nr_file_pages 112641
+nr_dirty 1
 nr_writeback 0
-nr_slab_reclaimable 312
-nr_slab_unreclaimable 768
-nr_page_table_pages 101
-nr_kernel_stack 67
+nr_slab_reclaimable 46065
+nr_slab_unreclaimable 801
+nr_page_table_pages 111
+nr_kernel_stack 74
 nr_unstable 0
 nr_bounce 0
 nr_vmscan_write 0
@@ -21,18 +21,18 @@
 nr_isolated_anon 0
 nr_isolated_file 0
 nr_shmem 0
-pgpgin 722038
-pgpgout 7874
+pgpgin 1100800
+pgpgout 182081
 pswpin 0
 pswpout 0
 pgalloc_dma 1
-pgalloc_normal 249842
+pgalloc_normal 1871314
 pgalloc_movable 0
-pgfree 429906
-pgactivate 7310
+pgfree 1903605
+pgactivate 49802
 pgdeactivate 0
-pgfault 148820
-pgmajfault 164
+pgfault 1769439
+pgmajfault 1161
 pgrefill_dma 0
 pgrefill_normal 0
 pgrefill_movable 0
@@ -52,11 +52,11 @@
 pageoutrun 0
 allocstall 0
 pgrotated 0
-unevictable_pgs_culled 4948
+unevictable_pgs_culled 4964
 unevictable_pgs_scanned 0
-unevictable_pgs_rescued 22818
-unevictable_pgs_mlocked 22818
-unevictable_pgs_munlocked 22818
+unevictable_pgs_rescued 22834
+unevictable_pgs_mlocked 22841
+unevictable_pgs_munlocked 22834
 unevictable_pgs_cleared 0
 unevictable_pgs_stranded 0
 unevictable_pgs_mlockfreed 0
---------------------------------------------------------------------------


/proc/zoneinfo diff: ------------------------------------------------------
--- zoneinfo.txt        Tue Jan 12 11:32:06 2010
+++ -   Wed Jan 13 09:28:15 2010
@@ -40,29 +40,29 @@
   start_pfn:         0
   inactive_ratio:    1
 Node 0, zone   Normal
-  pages free     175966
+  pages free     28218
         min      864
         low      1080
         high     1296
         scanned  0
         spanned  192375
         present  190872
-    nr_free_pages 175966
+    nr_free_pages 28218
     nr_inactive_anon 0
-    nr_active_anon 978
-    nr_inactive_file 7733
-    nr_active_file 3017
+    nr_active_anon 1022
+    nr_inactive_file 70364
+    nr_active_file 42278
     nr_unevictable 0
     nr_mlock     0
-    nr_anon_pages 982
-    nr_mapped    1043
-    nr_file_pages 10750
-    nr_dirty     4
+    nr_anon_pages 1027
+    nr_mapped    1068
+    nr_file_pages 112642
+    nr_dirty     0
     nr_writeback 0
-    nr_slab_reclaimable 312
-    nr_slab_unreclaimable 768
-    nr_page_table_pages 101
-    nr_kernel_stack 67
+    nr_slab_reclaimable 46065
+    nr_slab_unreclaimable 800
+    nr_page_table_pages 111
+    nr_kernel_stack 68
     nr_unstable  0
     nr_bounce    0
     nr_vmscan_write 0
@@ -73,7 +73,7 @@
         protection: (0, 0, 0)
   pagesets
     cpu: 0
-              count: 99
+              count: 85
               high:  186
               batch: 31
   all_unreclaimable: 0
---------------------------------------------------------------------------


/proc/slabinfo diff: ------------------------------------------------------
--- slabinfo.txt        Tue Jan 12 11:31:54 2010
+++ -   Wed Jan 13 09:29:44 2010
@@ -10,19 +10,19 @@
 dm_target_io        1792   1827     16  203    1 : tunables  120   60    0 : slabdata      9      9      0
 dm_io               1792   1859     20  169    1 : tunables  120   60    0 : slabdata     11     11      0
 uhci_urb_priv          4    127     28  127    1 : tunables  120   60    0 : slabdata      1      1      0
-scsi_sense_cache       6     30    128   30    1 : tunables  120   60    0 : slabdata      1      1      0
-scsi_cmd_cache         5     15    256   15    1 : tunables  120   60    0 : slabdata      1      1      0
+scsi_sense_cache       4     30    128   30    1 : tunables  120   60    0 : slabdata      1      1      0
+scsi_cmd_cache        15     15    256   15    1 : tunables  120   60    0 : slabdata      1      1      0
 sd_ext_cdb             2    113     32  113    1 : tunables  120   60    0 : slabdata      1      1      0
-cfq_io_context        44     44     88   44    1 : tunables  120   60    0 : slabdata      1      1      0
-cfq_queue             57     72    108   36    1 : tunables  120   60    0 : slabdata      2      2      0
+cfq_io_context        36     88     88   44    1 : tunables  120   60    0 : slabdata      2      2      0
+cfq_queue             38    108    108   36    1 : tunables  120   60    0 : slabdata      3      3      0
 bsg_cmd                0      0    284   14    1 : tunables   54   27    0 : slabdata      0      0      0
 isofs_inode_cache      0      0    316   12    1 : tunables   54   27    0 : slabdata      0      0      0
-journal_handle         4    169     20  169    1 : tunables  120   60    0 : slabdata      1      1      0
-journal_head          28     63     60   63    1 : tunables  120   60    0 : slabdata      1      1      0
+journal_handle         1    169     20  169    1 : tunables  120   60    0 : slabdata      1      1      0
+journal_head        1386   1512     60   63    1 : tunables  120   60    0 : slabdata     24     24      0
 revoke_table          16    254     12  254    1 : tunables  120   60    0 : slabdata      1      1      0
-revoke_record         16    203     16  203    1 : tunables  120   60    0 : slabdata      1      1      0
+revoke_record          0      0     16  203    1 : tunables  120   60    0 : slabdata      0      0      0
 ext2_inode_cache       0      0    404    9    1 : tunables   54   27    0 : slabdata      0      0      0
-ext3_inode_cache     826    828    420    9    1 : tunables   54   27    0 : slabdata     92     92      0
+ext3_inode_cache  305127 305127    420    9    1 : tunables   54   27    0 : slabdata  33903  33903      0
 kioctx                 0      0    256   15    1 : tunables  120   60    0 : slabdata      0      0      0
 kiocb                  0      0    256   15    1 : tunables  120   60    0 : slabdata      0      0      0
 inotify_event_private_data      0      0     16  203    1 : tunables  120   60    0 : slabdata      0      0      0
@@ -33,17 +33,17 @@
 nsproxy                0      0     24  145    1 : tunables  120   60    0 : slabdata      0      0      0
 posix_timers_cache      0      0     92   42    1 : tunables  120   60    0 : slabdata      0      0      0
 uid_cache              2     59     64   59    1 : tunables  120   60    0 : slabdata      1      1      0
-UNIX                   6     10    384   10    1 : tunables   54   27    0 : slabdata      1      1      0
+UNIX                   7     10    384   10    1 : tunables   54   27    0 : slabdata      1      1      0
 UDP-Lite               0      0    512    7    1 : tunables   54   27    0 : slabdata      0      0      0
-tcp_bind_bucket        7    113     32  113    1 : tunables  120   60    0 : slabdata      1      1      0
+tcp_bind_bucket        8    113     32  113    1 : tunables  120   60    0 : slabdata      1      1      0
 inet_peer_cache        1     59     64   59    1 : tunables  120   60    0 : slabdata      1      1      0
 ip_fib_alias           0      0     16  203    1 : tunables  120   60    0 : slabdata      0      0      0
 ip_fib_hash            9    101     36  101    1 : tunables  120   60    0 : slabdata      1      1      0
-ip_dst_cache           8     30    256   15    1 : tunables  120   60    0 : slabdata      2      2      0
+ip_dst_cache          12     15    256   15    1 : tunables  120   60    0 : slabdata      1      1      0
 arp_cache              3     30    128   30    1 : tunables  120   60    0 : slabdata      1      1      0
 RAW                    2      7    512    7    1 : tunables   54   27    0 : slabdata      1      1      0
 UDP                    4      7    512    7    1 : tunables   54   27    0 : slabdata      1      1      0
-tw_sock_TCP            0      0    128   30    1 : tunables  120   60    0 : slabdata      0      0      0
+tw_sock_TCP            2     30    128   30    1 : tunables  120   60    0 : slabdata      1      1      0
 request_sock_TCP       0      0    128   30    1 : tunables  120   60    0 : slabdata      0      0      0
 TCP                    8     14   1152    7    2 : tunables   24   12    0 : slabdata      2      2      0
 eventpoll_pwq          0      0     36  101    1 : tunables  120   60    0 : slabdata      0      0      0
@@ -52,21 +52,21 @@
 sgpool-64              2      3   1280    3    1 : tunables   24   12    0 : slabdata      1      1      0
 sgpool-32              2      6    640    6    1 : tunables   54   27    0 : slabdata      1      1      0
 sgpool-16              2     10    384   10    1 : tunables   54   27    0 : slabdata      1      1      0
-sgpool-8               5     15    256   15    1 : tunables  120   60    0 : slabdata      1      1      0
+sgpool-8              15     15    256   15    1 : tunables  120   60    0 : slabdata      1      1      0
 scsi_data_buffer       0      0     20  169    1 : tunables  120   60    0 : slabdata      0      0      0
 blkdev_queue          23     24   1176    6    2 : tunables   24   12    0 : slabdata      4      4      0
-blkdev_requests       48     60    196   20    1 : tunables  120   60    0 : slabdata      3      3      0
-blkdev_ioc            38     84     44   84    1 : tunables  120   60    0 : slabdata      1      1      0
+blkdev_requests       47     60    196   20    1 : tunables  120   60    0 : slabdata      3      3      0
+blkdev_ioc            20     84     44   84    1 : tunables  120   60    0 : slabdata      1      1      0
 fsnotify_event_holder      0      0     12  254    1 : tunables  120   60    0 : slabdata      0      0      0
 fsnotify_event         0      0     56   67    1 : tunables  120   60    0 : slabdata      0      0      0
-bio-0                150    150    128   30    1 : tunables  120   60    0 : slabdata      5      5      0
+bio-0                123    150    128   30    1 : tunables  120   60    0 : slabdata      5      5      0
 biovec-256           114    114   3072    2    2 : tunables   24   12    0 : slabdata     57     57      0
 biovec-128             0      0   1536    5    2 : tunables   24   12    0 : slabdata      0      0      0
 biovec-64              0      0    768    5    1 : tunables   54   27    0 : slabdata      0      0      0
 biovec-16              0      0    256   15    1 : tunables  120   60    0 : slabdata      0      0      0
-sock_inode_cache      26     30    384   10    1 : tunables   54   27    0 : slabdata      3      3      0
-skbuff_fclone_cache     10     10    384   10    1 : tunables   54   27    0 : slabdata      1      1      0
-skbuff_head_cache     48     60    256   15    1 : tunables  120   60    0 : slabdata      4      4      0
+sock_inode_cache      27     30    384   10    1 : tunables   54   27    0 : slabdata      3      3      0
+skbuff_fclone_cache      2     10    384   10    1 : tunables   54   27    0 : slabdata      1      1      0
+skbuff_head_cache     36     90    256   15    1 : tunables  120   60    0 : slabdata      6      6      0
 file_lock_cache        2     40     96   40    1 : tunables  120   60    0 : slabdata      1      1      0
 shmem_inode_cache      2     10    380   10    1 : tunables   54   27    0 : slabdata      1      1      0
 Acpi-Operand         635    736     40   92    1 : tunables  120   60    0 : slabdata      8      8      0
@@ -74,30 +74,30 @@
 Acpi-Parse             0      0     32  113    1 : tunables  120   60    0 : slabdata      0      0      0
 Acpi-State             0      0     44   84    1 : tunables  120   60    0 : slabdata      0      0      0
 Acpi-Namespace       307    338     20  169    1 : tunables  120   60    0 : slabdata      2      2      0
-proc_inode_cache     312    312    312   12    1 : tunables   54   27    0 : slabdata     26     26      0
+proc_inode_cache     381    384    312   12    1 : tunables   54   27    0 : slabdata     32     32      0
 sigqueue               8     27    144   27    1 : tunables  120   60    0 : slabdata      1      1      0
-radix_tree_node      791    793    288   13    1 : tunables   54   27    0 : slabdata     61     61      0
+radix_tree_node    10297  10309    288   13    1 : tunables   54   27    0 : slabdata    793    793      0
 bdev_cache            26     28    512    7    1 : tunables   54   27    0 : slabdata      4      4      0
-sysfs_dir_cache     8302   8316     44   84    1 : tunables  120   60    0 : slabdata     99     99      0
+sysfs_dir_cache     8316   8316     44   84    1 : tunables  120   60    0 : slabdata     99     99      0
 mnt_cache             23     30    128   30    1 : tunables  120   60    0 : slabdata      1      1      0
-filp                 222    240    128   30    1 : tunables  120   60    0 : slabdata      8      8      0
-inode_cache          351    351    288   13    1 : tunables   54   27    0 : slabdata     27     27      0
-dentry              1849   1860    128   30    1 : tunables  120   60    0 : slabdata     62     62      0
+filp                 210    210    128   30    1 : tunables  120   60    0 : slabdata      7      7      0
+inode_cache          416    416    288   13    1 : tunables   54   27    0 : slabdata     32     32      0
+dentry            314863 314880    128   30    1 : tunables  120   60    0 : slabdata  10496  10496      0
 names_cache            1      1   4096    1    1 : tunables   24   12    0 : slabdata      1      1      0
 key_jar                0      0    128   30    1 : tunables  120   60    0 : slabdata      0      0      0
-buffer_head         2376   2376     52   72    1 : tunables  120   60    0 : slabdata     33     33      0
-vm_area_struct       484    484     88   44    1 : tunables  120   60    0 : slabdata     11     11      0
-mm_struct             22     28    512    7    1 : tunables   54   27    0 : slabdata      4      4      0
-fs_cache              23    113     32  113    1 : tunables  120   60    0 : slabdata      1      1      0
-files_cache           24     45    256   15    1 : tunables  120   60    0 : slabdata      3      3      0
-signal_cache          67     70    512    7    1 : tunables   54   27    0 : slabdata     10     10      0
-sighand_cache         67     70   1408    5    2 : tunables   24   12    0 : slabdata     14     14      0
-task_xstate           56     88    512    8    1 : tunables   54   27    0 : slabdata     11     11      0
-task_struct           68     81    864    9    2 : tunables   54   27    0 : slabdata      9      9      0
-cred_jar             158    240    128   30    1 : tunables  120   60    0 : slabdata      8      8      0
-anon_vma             294    339      8  339    1 : tunables  120   60    0 : slabdata      1      1      0
-pid                   70    177     64   59    1 : tunables  120   60    0 : slabdata      3      3      0
-idr_layer_cache      128    130    148   26    1 : tunables  120   60    0 : slabdata      5      5      0
+buffer_head        55875  55944     52   72    1 : tunables  120   60    0 : slabdata    777    777      0
+vm_area_struct       528    528     88   44    1 : tunables  120   60    0 : slabdata     12     12      0
+mm_struct             28     28    512    7    1 : tunables   54   27    0 : slabdata      4      4      0
+fs_cache              35    113     32  113    1 : tunables  120   60    0 : slabdata      1      1      0
+files_cache           36     45    256   15    1 : tunables  120   60    0 : slabdata      3      3      0
+signal_cache          70     70    512    7    1 : tunables   54   27    0 : slabdata     10     10      0
+sighand_cache         70     70   1408    5    2 : tunables   24   12    0 : slabdata     14     14      0
+task_xstate           69     88    512    8    1 : tunables   54   27    0 : slabdata     11     11      0
+task_struct           81     81    864    9    2 : tunables   54   27    0 : slabdata      9      9      0
+cred_jar             109    240    128   30    1 : tunables  120   60    0 : slabdata      8      8      0
+anon_vma             306    339      8  339    1 : tunables  120   60    0 : slabdata      1      1      0
+pid                   83    177     64   59    1 : tunables  120   60    0 : slabdata      3      3      0
+idr_layer_cache      168    182    148   26    1 : tunables  120   60    0 : slabdata      7      7      0
 size-4194304(DMA)      0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
 size-4194304           0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
 size-2097152(DMA)      0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0
@@ -119,19 +119,19 @@
 size-8192(DMA)         0      0   8192    1    2 : tunables    8    4    0 : slabdata      0      0      0
 size-8192              4      4   8192    1    2 : tunables    8    4    0 : slabdata      4      4      0
 size-4096(DMA)         0      0   4096    1    1 : tunables   24   12    0 : slabdata      0      0      0
-size-4096             33     33   4096    1    1 : tunables   24   12    0 : slabdata     33     33      0
+size-4096             34     34   4096    1    1 : tunables   24   12    0 : slabdata     34     34      0
 size-2048(DMA)         0      0   2048    2    1 : tunables   24   12    0 : slabdata      0      0      0
-size-2048             66     70   2048    2    1 : tunables   24   12    0 : slabdata     35     35      0
+size-2048             67     68   2048    2    1 : tunables   24   12    0 : slabdata     34     34      0
 size-1024(DMA)         0      0   1024    4    1 : tunables   54   27    0 : slabdata      0      0      0
-size-1024            120    120   1024    4    1 : tunables   54   27    0 : slabdata     30     30      0
+size-1024            124    124   1024    4    1 : tunables   54   27    0 : slabdata     31     31      0
 size-512(DMA)          0      0    512    8    1 : tunables   54   27    0 : slabdata      0      0      0
-size-512             232    232    512    8    1 : tunables   54   27    0 : slabdata     29     29      0
+size-512             240    240    512    8    1 : tunables   54   27    0 : slabdata     30     30      0
 size-256(DMA)          0      0    256   15    1 : tunables  120   60    0 : slabdata      0      0      0
-size-256             859    870    256   15    1 : tunables  120   60    0 : slabdata     58     58      0
+size-256             870    870    256   15    1 : tunables  120   60    0 : slabdata     58     58      0
 size-128(DMA)          0      0    128   30    1 : tunables  120   60    0 : slabdata      0      0      0
-size-128            1390   1410    128   30    1 : tunables  120   60    0 : slabdata     47     47      0
+size-128            1470   1470    128   30    1 : tunables  120   60    0 : slabdata     49     49      0
 size-64(DMA)           0      0     64   59    1 : tunables  120   60    0 : slabdata      0      0      0
 size-32(DMA)           0      0     32  113    1 : tunables  120   60    0 : slabdata      0      0      0
-size-64             2322   2419     64   59    1 : tunables  120   60    0 : slabdata     41     41      0
-size-32             5942   5989     32  113    1 : tunables  120   60    0 : slabdata     53     53      0
+size-64             3515   3658     64   59    1 : tunables  120   60    0 : slabdata     62     62      0
+size-32             5931   6102     32  113    1 : tunables  120   60    0 : slabdata     54     54      0
 kmem_cache           134    150    128   30    1 : tunables  120   60    0 : slabdata      5      5      0
---------------------------------------------------------------------------


Kernel config: ------------------------------------------------------------
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.32.3
# Sat Jan  9 17:17:35 2010
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_TREE_PREEMPT_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=32
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=14
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set
# CONFIG_CGROUPS is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
# CONFIG_RELAY is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
# CONFIG_PERF_EVENTS is not set
# CONFIG_PERF_COUNTERS is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_API_DEBUG=y

#
# GCOV-based kernel profiling
#
# CONFIG_SLOW_WORK is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
CONFIG_MPENTIUM4=y
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_X86_UP_APIC=y
CONFIG_X86_UP_IOAPIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
# CONFIG_X86_CPU_DEBUG is not set
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_PROC_MM=y
# CONFIG_PROC_MM_DUMPABLE is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_HAVE_MLOCK=y
CONFIG_HAVE_MLOCKED_PAGE_BIT=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=y
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set

#
# Power management and ACPI options
#
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_SYSFS_POWER=y
# CONFIG_ACPI_PROC_EVENT is not set
CONFIG_ACPI_AC=y
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_LEGACY is not set
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
# CONFIG_PCI_IOV is not set
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_MMAP is not set
CONFIG_UNIX=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_ISL29003 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_SCH is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
# CONFIG_MD_LINEAR is not set
# CONFIG_MD_RAID0 is not set
CONFIG_MD_RAID1=y
# CONFIG_MD_RAID10 is not set
# CONFIG_MD_RAID456 is not set
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
# CONFIG_DM_CRYPT is not set
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_MIRROR=y
# CONFIG_DM_LOG_USERSPACE is not set
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# You can enable one or both FireWire driver stacks.
#

#
# See the help texts for more information.
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=y
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_PHYLIB is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=y
# CONFIG_TYPHOON is not set
# CONFIG_ETHOC is not set
# CONFIG_DNET is not set
# CONFIG_NET_TULIP is not set
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_E100 is not set
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R6040 is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SMSC9420 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_KS8842 is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
# CONFIG_ATL2 is not set
# CONFIG_NETDEV_1000 is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_RTC=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_STUB is not set
# CONFIG_SCx200_ACB is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set

#
# PPS support
#
# CONFIG_PPS is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_HWMON is not set
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_AB3100_CORE is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
CONFIG_VGA_ARB=y
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=y
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_SEQUENCER=y
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
# CONFIG_SND_HRTIMER is not set
# CONFIG_SND_RTCTIMER is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_AC97_CODEC=y
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
# CONFIG_SND_AC97_POWER_SAVE is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
CONFIG_SND_INTEL8X0=y
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SIS7019 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_USB is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=y
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_KYE=y
CONFIG_HID_GYRATION=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LOGITECH=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_NTRIG=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TOPSEED=y
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set

#
# TI VLYNQ
#
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_FS_POSIX_ACL is not set
# CONFIG_XFS_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
# CONFIG_ZISOFS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="cp437"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_UTF8 is not set
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_4KSTACKS is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
# CONFIG_IMA is not set
# CONFIG_CRYPTO is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=y
# CONFIG_CRC16 is not set
# CONFIG_CRC_T10DIF is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y
---------------------------------------------------------------------------

Process listing at snapshot times: ----------------------------------------
  PID TTY      STAT   TIME COMMAND
    2 ?        S      0:00 [kthreadd]
    3 ?        S      0:00  \_ [ksoftirqd/0]
    4 ?        S      0:00  \_ [events/0]
    5 ?        S      0:00  \_ [khelper]
   10 ?        S      0:00  \_ [async/mgr]
  129 ?        S      0:00  \_ [sync_supers]
  131 ?        S      0:00  \_ [bdi-default]
  132 ?        S      0:00  \_ [kblockd/0]
  133 ?        S      0:00  \_ [kacpid]
  134 ?        S      0:00  \_ [kacpi_notify]
  135 ?        S      0:00  \_ [kacpi_hotplug]
  190 ?        S      0:00  \_ [ata/0]
  191 ?        S      0:00  \_ [ata_aux]
  192 ?        S      0:00  \_ [ksuspend_usbd]
  197 ?        S      0:00  \_ [khubd]
  200 ?        S      0:00  \_ [kseriod]
  244 ?        S      0:00  \_ [kswapd0]
  245 ?        S      0:00  \_ [aio/0]
  868 ?        S      0:00  \_ [scsi_eh_0]
  870 ?        S      0:00  \_ [scsi_eh_1]
  898 ?        S      0:00  \_ [kpsmoused]
  900 ?        S      0:00  \_ [kstriped]
  902 ?        S      0:00  \_ [ksnapd]
  930 ?        S      0:00  \_ [usbhid_resumer]
  990 ?        S      0:00  \_ [md3_raid1]
  996 ?        S      0:00  \_ [md2_raid1]
 1002 ?        S      0:00  \_ [md1_raid1]
 1006 ?        S      0:00  \_ [md0_raid1]
 1008 ?        S      0:00  \_ [kjournald]
 1078 ?        S      0:00  \_ [kdmflush]
 1084 ?        S      0:00  \_ [kdmflush]
 1092 ?        S      0:00  \_ [kdmflush]
 1099 ?        S      0:00  \_ [kdmflush]
 1106 ?        S      0:00  \_ [kdmflush]
 1112 ?        S      0:00  \_ [kdmflush]
 1120 ?        S      0:00  \_ [kdmflush]
 1178 ?        S      0:00  \_ [kjournald]
 1251 ?        S      0:00  \_ [kjournald]
 1252 ?        S      0:00  \_ [kjournald]
 1253 ?        S      0:00  \_ [kjournald]
 1254 ?        S      0:00  \_ [kjournald]
 1255 ?        S      0:00  \_ [kjournald]
 1256 ?        S      0:00  \_ [kjournald]
 1489 ?        S      0:00  \_ [flush-253:3]
 1490 ?        S      0:00  \_ [flush-9:0]
 1496 ?        S      0:00  \_ [flush-9:2]
    1 ?        Ss     0:00 Init 5     
 1258 ?        Ss     0:00 /usr/sbin/crond
 1259 ?        Ss     0:00 /usr/sbin/syslogd -n -m 0
 1260 ?        Ss     0:00 /usr/sbin/klogd -n -c 1 -s
 1261 ?        Ss     0:00 /usr/sbin/gpm -m /dev/input/mouse -t exps2
 1262 ?        Ss     0:00 lpd MAIN        
 1280 ?        Ss     0:00  \_ lpd Waiting     
 1263 tty1     Ss+    0:00 /sbin/getty -h tty1 VC
 1264 tty2     Ss+    0:00 /sbin/getty -h tty2 VC
 1265 tty3     Ss+    0:00 /sbin/getty -h tty3 VC
 1266 tty4     Ss+    0:00 /sbin/getty -h tty4 VC
 1267 tty5     Ss+    0:00 /sbin/getty -h tty5 VC
 1268 ?        Ss     0:00 /usr/sbin/portmap
 1269 ?        Ss     0:00 /usr/sbin/inetd
 1482 ?        S      0:00  \_ klogind -k -c -e
 1483 pts/0    Ss     0:00      \_ login -p -h wind-p -f greg
 1484 pts/0    S      0:00          \_ -bash
 1497 pts/0    R+     0:00              \_ ps fax
 1270 ?        Ss     0:00 /usr/sbin/ntpd -n -A
 1271 ?        Ss     0:00 sendmail: accepting connections
 1272 ?        Ss     0:00 /usr/sbin/sshd -D
---------------------------------------------------------------------------

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"More people are killed every year by pigs than by sharks, which shows
 you how good we are at evaluating risk."
                                -- Bruce Schneier
                                   Beyond Fear
