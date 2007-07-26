Return-Path: <linux-kernel-owner+w=401wt.eu-S932132AbXGZIBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132AbXGZIBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 04:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756829AbXGZIBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 04:01:41 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:35763 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755423AbXGZIBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 04:01:38 -0400
Message-Id: <1185436893.18946.1202118935@webmail.messagingengine.com>
X-Sasl-Enc: NE5DMeYdf0JG4bM6yCrvf6eZ7316RRwYVv14rUUFdrV0 1185436893
From: "Robert Mueller" <robm@fastmail.fm>
To: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org
Cc: "Bron Gondwana" <brong@fastmail.fm>, "Oleg Drokin" <green@linuxhacker.ru>,
       "Chris Mason" <mason@suse.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
Subject: Memory leaking behaviour in 2.6.20.11, reiserfs related?
Reply-To: robm@fastmail.fm
Date: Thu, 26 Jul 2007 18:01:33 +1000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

We've been seeing some kernel memory leak behaviour in 2.6.20.11. After 
running for just over a week, one of our machines was showing almost all 
it's memory being used, even though we'd exited all the main services on
the machine. The machine is a newish IBM x3550 with a Xeon 5130 processor
and 12G of RAM. We're using a x86 kernel with PAE rather than x86_64, but 
haven't had a problem like this on other machines, though they are 8G and 
Prescott based. It's being used for cyrus IMAP serving and has about 35 
reiserfs volumes mounted on it. The result after a week is that memory looks 
like this. 

[root@imap10 ~]$ free
             total       used       free     shared    buffers     cached
Mem:      12466708   11690804     775904          0     560060     714292
-/+ buffers/cache:   10416452    2050256
Swap:      2048276      49952    1998324

But a complete process list only shows.

[root@imap10 ~]$ ps auxw
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.0   1948   640 ?        Ss   Jul17   0:01 init [2]
root         2  0.0  0.0      0     0 ?        S    Jul17   0:03 [migration/0]
root         3  0.0  0.0      0     0 ?        SN   Jul17   0:00 [ksoftirqd/0]
root         4  0.0  0.0      0     0 ?        S    Jul17   0:00 [watchdog/0]
root         5  0.0  0.0      0     0 ?        S    Jul17   0:01 [migration/1]
root         6  0.0  0.0      0     0 ?        SN   Jul17   0:00 [ksoftirqd/1]
root         7  0.0  0.0      0     0 ?        S    Jul17   0:00 [watchdog/1]
root         8  0.0  0.0      0     0 ?        S<   Jul17   0:00 [events/0]
root         9  0.0  0.0      0     0 ?        S<   Jul17   0:00 [events/1]
root        10  0.0  0.0      0     0 ?        S<   Jul17   0:00 [khelper]
root        11  0.0  0.0      0     0 ?        S<   Jul17   0:00 [kthread]
root       117  0.0  0.0      0     0 ?        S<   Jul17   0:00 [kblockd/0]
root       118  0.0  0.0      0     0 ?        S<   Jul17   0:00 [kblockd/1]
root       119  0.0  0.0      0     0 ?        S<   Jul17   0:00 [kacpid]
root       228  0.0  0.0      0     0 ?        S<   Jul17   0:00 [ata/0]
root       229  0.0  0.0      0     0 ?        S<   Jul17   0:00 [ata/1]
root       230  0.0  0.0      0     0 ?        S<   Jul17   0:00 [ata_aux]
root       231  0.0  0.0      0     0 ?        S<   Jul17   0:00 [kseriod]
root       261  0.0  0.0      0     0 ?        S<   Jul17   6:26 [kswapd0]
root       262  0.0  0.0      0     0 ?        S<   Jul17   0:00 [aio/0]
root       263  0.0  0.0      0     0 ?        S<   Jul17   0:00 [aio/1]
root       913  0.0  0.0      0     0 ?        S<   Jul17   0:00 [scsi_eh_0]
root       914  0.0  0.0      0     0 ?        S<   Jul17   0:00 [aacraid]
root       937  0.0  0.0      0     0 ?        S<   Jul17   0:00 [scsi_eh_1]
root      1035  0.0  0.0      0     0 ?        S<   Jul17   0:00 [scsi_eh_2]
root      1131  0.0  0.0      0     0 ?        S<   Jul17   0:00 [kpsmoused]
root      1134  0.0  0.0      0     0 ?        S    Jul17   0:00 [kirqd]
root      2326  0.0  0.0      0     0 ?        S<   Jul17   0:00 [ksuspend_usbd]
root      2329  0.0  0.0      0     0 ?        S<   Jul17   0:00 [khubd]
root      2686  0.0  0.0      0     0 ?        S<   Jul17   0:03 [kjournald]
root      2864  0.0  0.0   2180   612 ?        S<s  Jul17   0:00 udevd --daemon
root      4573  0.0  0.0      0     0 ?        S<   Jul17   0:54 [reiserfs/0]
root      4574  0.0  0.0      0     0 ?        S<   Jul17   0:46 [reiserfs/1]
daemon    5023  0.0  0.0   1684   364 ?        Ss   Jul17   0:00 /sbin/portmap
root      5140  0.0  0.0   1628   628 ?        Ss   Jul17   4:49 /sbin/syslogd
root      5146  0.0  0.0   1580   396 ?        Ss   Jul17   0:00 /sbin/klogd -x
111       5168  0.0  0.0   2248   816 ?        Ss   Jul17   0:00 /usr/bin/dbus-daemon --system
112       5176  0.0  0.0  10432  8868 ?        Ss   Jul17   0:00 /usr/sbin/hald
root      5177  0.0  0.0   2888  1036 ?        S    Jul17   0:00 hald-runner
112       5183  0.0  0.0   2020   844 ?        S    Jul17   0:00 hald-addon-acpi: listening on acpi kernel interface /proc/acpi/event
root      5215  0.0  0.0   1812   624 ?        S    Jul17   0:00 hald-addon-storage: polling /dev/sda
root      5221  0.0  0.0   1812   620 ?        S    Jul17   0:08 hald-addon-storage: polling /dev/hda
root      5229  0.0  0.0   1572   384 ?        Ss   Jul17   0:00 /usr/sbin/irqbalance
root      5244  0.0  0.0   4928  1112 ?        Ss   Jul17   0:00 /usr/sbin/sshd
statd     5280  0.0  0.0   1760   728 ?        Ss   Jul17   0:00 /sbin/rpc.statd
ntp       5293  0.0  0.0   4028  1220 ?        Ss   Jul17   0:00 /usr/sbin/ntpd -p /var/run/ntpd.pid -u 110:109 -g
root      5362  0.0  0.0   6692  4948 ?        Ss   Jul17   0:02 /usr/sbin/munin-node
root      5402  0.0  0.0   1576   496 tty1     Ss+  Jul17   0:00 /sbin/getty 38400 tty1
root      5404  0.0  0.0   1576   496 tty2     Ss+  Jul17   0:00 /sbin/getty 38400 tty2
root      5405  0.0  0.0   1576   496 tty3     Ss+  Jul17   0:00 /sbin/getty 38400 tty3
root      5406  0.0  0.0   1572   492 tty4     Ss+  Jul17   0:00 /sbin/getty 38400 tty4
root      5408  0.0  0.0   1576   496 tty5     Ss+  Jul17   0:00 /sbin/getty 38400 tty5
root      5410  0.0  0.0   1572   492 tty6     Ss+  Jul17   0:00 /sbin/getty 38400 tty6
root      5411  0.0  0.0   2640  1272 ?        Ss   Jul17   0:00 /bin/sh /command/svscanboot
root      5436  0.0  0.0   1596   356 ?        S    Jul17   0:00 svscan /service
root      5438  0.0  0.0   1420   248 ?        S    Jul17   0:00 readproctitle service errors: .....................................................................
root      5449  0.0  0.0   1432   300 ?        S    Jul17   0:00 supervise dnscache
root      5450  0.0  0.0   1432   304 ?        S    Jul17   0:00 supervise log
dnslog    5456  0.0  0.0   1576   368 ?        S    Jul17   0:07 multilog t ./main
root      6189  0.0  0.0   1432   304 ?        S    Jul17   0:00 supervise backupcyrusd
root      6223  0.0  0.0   1428   300 ?        S    Jul17   0:00 supervise popschedule
root      6243  0.0  0.0   1428   300 ?        S    Jul17   0:00 supervise postfixpolicyproxy
root      6252  0.0  0.0   1432   304 ?        S    Jul17   0:00 supervise rated
root      6288  0.0  0.0   1428   300 ?        S    Jul17   0:00 supervise vfsd
root      6323  0.0  0.0   1428   300 ?        S    Jul17   0:00 supervise vfsproxy
root      6407  0.0  0.0   1428   300 ?        S    Jul17   0:00 supervise notifyd
root     13463  0.0  0.0   2224   896 pts/3    R+   02:40   0:00 ps auxw
root     26582  0.0  0.0   7484  2148 ?        Ss   02:31   0:00 sshd: root@pts/0
root     26586  0.0  0.0   2840  1688 pts/0    Ss+  02:31   0:00 -bash
root     29155  0.0  0.0      0     0 ?        S    Jul25   0:18 [pdflush]
root     29700  0.0  0.0   7640  2164 ?        Ss   02:32   0:00 sshd: root@pts/1
root     29704  0.0  0.0   2840  1692 pts/1    Ss+  02:32   0:00 -bash
root     30012  0.0  0.0   7488  2152 ?        Ss   02:32   0:00 sshd: root@pts/3
root     30016  0.0  0.0   2836  1656 pts/3    Ss   02:32   0:00 -bash
root     30402  0.1  0.0      0     0 ?        S    Jul25   1:15 [pdflush]

This is pretty much a vanilla kernel, with just one patch to work around
a deadlock problem in the reiserfs_file_write code that I think isn't
fixed.

http://lists.linuxcoding.com/kernel/2006-q1/msg32508.html

The patch basically bypasses all the code to use do_sync_write. We haven't
noticed it as a performance issue. I haven't tested if the deadlock
problem has been fixed since 2.6.16, but with this patch there definitely
isn't a problem, so we haven't been particularly keen to find out.

--- linux-2.6.19.2/fs/reiserfs/file.c   2006-11-29 16:57:37.000000000 -0500
+++ linux-2.6.19.2-syncwrite/fs/reiserfs/file.c 2007-02-02 01:01:36.000000000 -0500
@@ -1358,6 +1358,8 @@
        if (file->f_flags & O_DIRECT)
                return do_sync_write(file, buf, count, ppos);

+       return do_sync_write(file, buf, count, ppos);
+
        if (unlikely((ssize_t) count < 0))
                return -EINVAL;

One other thing that is probably relevant, is that we saw some of these
error messages in the dmesg log.

BUG: at fs/reiserfs/inode.c:2868 reiserfs_releasepage()
 [<c0199ecb>] reiserfs_releasepage+0xa3/0xa8
 [<c0199e28>] reiserfs_releasepage+0x0/0xa8
 [<c013c8e9>] try_to_release_page+0x2c/0x40
 [<c0141386>] pagevec_strip+0x52/0x54
 [<c0141fa0>] shrink_active_list+0x2c0/0x3d1
 [<c0142b33>] shrink_zone+0xd8/0xf5
 [<c014307c>] kswapd+0x322/0x423
 [<c012b4e4>] autoremove_wake_function+0x0/0x37
 [<c0142d5a>] kswapd+0x0/0x423
 [<c012b362>] kthread+0xae/0xd3
 [<c012b2b4>] kthread+0x0/0xd3
 [<c010383b>] kernel_thread_helper+0x7/0x1c
 =======================

[root@imap10 proc]$ dmesg | grep fs/reiserfs/inode.c | wc -l
38

All of them show basically the same trace as above.

There's a dump of the kernel config available here:
http://robm.fastmail.fm/kernel/2007-07-26/config.txt

Here's a dump of just about everything from /proc that I thought might be useful

[root@imap10 ~]$ cat /proc/meminfo
MemTotal:     12466708 kB
MemFree:        739752 kB
Buffers:        560436 kB
Cached:         754096 kB
SwapCached:       4540 kB
Active:        9878988 kB
Inactive:      1594924 kB
HighTotal:    11663148 kB
HighFree:       725192 kB
LowTotal:       803560 kB
LowFree:         14560 kB
SwapTotal:     2048276 kB
SwapFree:      1998324 kB
Dirty:          130036 kB
Writeback:           0 kB
AnonPages:       12828 kB
Mapped:           4396 kB
Slab:           223012 kB
SReclaimable:   192724 kB
SUnreclaim:      30288 kB
PageTables:        636 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   8281628 kB
Committed_AS:    79208 kB
VmallocTotal:   118776 kB
VmallocUsed:     24536 kB
VmallocChunk:    93532 kB

[root@imap10 ~]$ cat /proc/slabinfo
slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
ip_fib_alias           8    113     32  113    1 : tunables  120   60    8 : slabdata      1      1      0
ip_fib_hash            8    113     32  113    1 : tunables  120   60    8 : slabdata      1      1      0
jbd_4k                 0      0   4096    1    1 : tunables   24   12    8 : slabdata      0      0      0
uhci_urb_priv          0      0     28  127    1 : tunables  120   60    8 : slabdata      0      0      0
rpc_buffers            8      8   2048    2    1 : tunables   24   12    8 : slabdata      4      4      0
rpc_tasks              8     20    192   20    1 : tunables  120   60    8 : slabdata      1      1      0
rpc_inode_cache        0      0    448    9    1 : tunables   54   27    8 : slabdata      0      0      0
UNIX                  20     36    448    9    1 : tunables   54   27    8 : slabdata      4      4      0
ip_conntrack_expect      0      0     96   40    1 : tunables  120   60    8 : slabdata      0      0      0
ip_conntrack          65    684    212   18    1 : tunables  120   60    8 : slabdata     38     38      0
xt_hashlimit           0      0     64   59    1 : tunables  120   60    8 : slabdata      0      0      0
flow_cache             0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
aic94xx_ascb           0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
aic94xx_dma_token      0      0     16  203    1 : tunables  120   60    8 : slabdata      0      0      0
scsi_cmd_cache        45     96    320   12    1 : tunables   54   27    8 : slabdata      8      8      6
sas_task               0      0    320   12    1 : tunables   54   27    8 : slabdata      0      0      0
cfq_ioc_pool           0      0     92   42    1 : tunables  120   60    8 : slabdata      0      0      0
cfq_pool               0      0     96   40    1 : tunables  120   60    8 : slabdata      0      0      0
mqueue_inode_cache      1      7    576    7    1 : tunables   54   27    8 : slabdata      1      1      0
udf_inode_cache        0      0    400   10    1 : tunables   54   27    8 : slabdata      0      0      0
nfs_write_data        36     36    448    9    1 : tunables   54   27    8 : slabdata      4      4      0
nfs_read_data         32     36    448    9    1 : tunables   54   27    8 : slabdata      4      4      0
nfs_inode_cache        0      0    604    6    1 : tunables   54   27    8 : slabdata      0      0      0
nfs_page               0      0     64   59    1 : tunables  120   60    8 : slabdata      0      0      0
isofs_inode_cache      0      0    372   10    1 : tunables   54   27    8 : slabdata      0      0      0
ext2_inode_cache       0      0    472    8    1 : tunables   54   27    8 : slabdata      0      0      0
ext2_xattr             0      0     48   78    1 : tunables  120   60    8 : slabdata      0      0      0
journal_handle         3    169     20  169    1 : tunables  120   60    8 : slabdata      1      1      0
journal_head         323    720     52   72    1 : tunables  120   60    8 : slabdata      9     10    228
revoke_table           2    254     12  254    1 : tunables  120   60    8 : slabdata      1      1      0
revoke_record          0    203     16  203    1 : tunables  120   60    8 : slabdata      0      1      0
ext3_inode_cache    1127   1296    500    8    1 : tunables   54   27    8 : slabdata    162    162      0
ext3_xattr             0      0     48   78    1 : tunables  120   60    8 : slabdata      0      0      0
reiser_inode_cache  21496  40833    428    9    1 : tunables   54   27    8 : slabdata   4537   4537      0
dnotify_cache          1    169     20  169    1 : tunables  120   60    8 : slabdata      1      1      0
eventpoll_pwq          0      0     36  101    1 : tunables  120   60    8 : slabdata      0      0      0
eventpoll_epi          0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
inotify_event_cache      0      0     28  127    1 : tunables  120   60    8 : slabdata      0      0      0
inotify_watch_cache      1     92     40   92    1 : tunables  120   60    8 : slabdata      1      1      0
kioctx                 0      0    192   20    1 : tunables  120   60    8 : slabdata      0      0      0
kiocb                  0      0    192   20    1 : tunables  120   60    8 : slabdata      0      0      0
fasync_cache           0      0     16  203    1 : tunables  120   60    8 : slabdata      0      0      0
shmem_inode_cache   1587   1701    440    9    1 : tunables   54   27    8 : slabdata    189    189      0
posix_timers_cache      0      0     88   44    1 : tunables  120   60    8 : slabdata      0      0      0
uid_cache              5     59     64   59    1 : tunables  120   60    8 : slabdata      1      1      0
ip_mrt_cache           0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
UDP-Lite               0      0    512    7    1 : tunables   54   27    8 : slabdata      0      0      0
tcp_bind_bucket       11    203     16  203    1 : tunables  120   60    8 : slabdata      1      1      0
inet_peer_cache        0      0     64   59    1 : tunables  120   60    8 : slabdata      0      0      0
secpath_cache          0      0     32  113    1 : tunables  120   60    8 : slabdata      0      0      0
xfrm_dst_cache         0      0    320   12    1 : tunables   54   27    8 : slabdata      0      0      0
ip_dst_cache          33     90    256   15    1 : tunables  120   60    8 : slabdata      6      6      0
arp_cache              7     80    192   20    1 : tunables  120   60    8 : slabdata      4      4      0
RAW                    3      7    512    7    1 : tunables   54   27    8 : slabdata      1      1      0
UDP                    3      7    512    7    1 : tunables   54   27    8 : slabdata      1      1      0
tw_sock_TCP            8     30    128   30    1 : tunables  120   60    8 : slabdata      1      1      0
request_sock_TCP       0      0     64   59    1 : tunables  120   60    8 : slabdata      0      0      0
TCP                    6     28   1152    7    2 : tunables   24   12    8 : slabdata      4      4      0
sgpool-128            32     33   2560    3    2 : tunables   24   12    8 : slabdata     11     11      0
sgpool-64             34     42   1280    3    1 : tunables   24   12    8 : slabdata     13     14      1
sgpool-32             32     36    640    6    1 : tunables   54   27    8 : slabdata      6      6      0
sgpool-16             33     36    320   12    1 : tunables   54   27    8 : slabdata      3      3      0
sgpool-8              38     80    192   20    1 : tunables  120   60    8 : slabdata      4      4      0
scsi_io_context        0      0    104   37    1 : tunables  120   60    8 : slabdata      0      0      0
blkdev_ioc             6    127     28  127    1 : tunables  120   60    8 : slabdata      1      1      0
blkdev_queue          18     20    952    4    1 : tunables   54   27    8 : slabdata      5      5      0
blkdev_requests      153    294    184   21    1 : tunables  120   60    8 : slabdata     14     14      0
biovec-256             7      8   3072    2    2 : tunables   24   12    8 : slabdata      4      4      0
biovec-128             7     10   1536    5    2 : tunables   24   12    8 : slabdata      2      2      0
biovec-64              8     15    768    5    1 : tunables   54   27    8 : slabdata      3      3      0
biovec-16              8     20    192   20    1 : tunables  120   60    8 : slabdata      1      1      0
biovec-4               9     59     64   59    1 : tunables  120   60    8 : slabdata      1      1      0
biovec-1             305   1015     16  203    1 : tunables  120   60    8 : slabdata      5      5    228
bio                  544    780    128   30    1 : tunables  120   60    8 : slabdata     24     26    228
sock_inode_cache      40     80    384   10    1 : tunables   54   27    8 : slabdata      8      8      0
skbuff_fclone_cache      2     24    320   12    1 : tunables   54   27    8 : slabdata      2      2      0
skbuff_head_cache    338   1100    192   20    1 : tunables  120   60    8 : slabdata     55     55      0
file_lock_cache       15     80     96   40    1 : tunables  120   60    8 : slabdata      2      2      0
Acpi-Operand         873   1012     40   92    1 : tunables  120   60    8 : slabdata     11     11      0
Acpi-ParseExt          0      0     44   84    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-Parse             0      0     28  127    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-State             0      0     44   84    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-Namespace       275    338     20  169    1 : tunables  120   60    8 : slabdata      2      2      0
proc_inode_cache     410   1133    360   11    1 : tunables   54   27    8 : slabdata    103    103      0
sigqueue               2     27    144   27    1 : tunables  120   60    8 : slabdata      1      1      0
radix_tree_node    31584  49751    288   13    1 : tunables   54   27    8 : slabdata   3827   3827      0
bdev_cache            47     63    512    7    1 : tunables   54   27    8 : slabdata      9      9      0
sysfs_dir_cache     7146   7224     44   84    1 : tunables  120   60    8 : slabdata     86     86      0
mnt_cache             55     60    128   30    1 : tunables  120   60    8 : slabdata      2      2      0
inode_cache         1976   2145    344   11    1 : tunables   54   27    8 : slabdata    195    195      0
dentry_cache       21496  52925    132   29    1 : tunables  120   60    8 : slabdata   1825   1825      0
filp                 578   3460    192   20    1 : tunables  120   60    8 : slabdata    173    173      7
names_cache           13     18   4096    1    1 : tunables   24   12    8 : slabdata     13     18      0
idr_layer_cache      123    145    136   29    1 : tunables  120   60    8 : slabdata      5      5      0
buffer_head       2744886 2769914     56   67    1 : tunables  120   60    8 : slabdata  41342  41342      0
mm_struct             57    135    448    9    1 : tunables   54   27    8 : slabdata     15     15      0
vm_area_struct       962   7832     88   44    1 : tunables  120   60    8 : slabdata    178    178      0
fs_cache              57    354     64   59    1 : tunables  120   60    8 : slabdata      6      6      0
files_cache           57    190    384   10    1 : tunables   54   27    8 : slabdata     19     19      0
signal_cache          91    210    384   10    1 : tunables   54   27    8 : slabdata     21     21      0
sighand_cache         85    111   1344    3    1 : tunables   24   12    8 : slabdata     37     37      0
task_struct           87    135   1312    3    1 : tunables   24   12    8 : slabdata     45     45      0
anon_vma             568  11430     12  254    1 : tunables  120   60    8 : slabdata     45     45      0
pgd                   43    678     32  113    1 : tunables  120   60    8 : slabdata      6      6      0
pmd                  136    140   4096    1    1 : tunables   24   12    8 : slabdata    136    140      0
pid                   91    808     36  101    1 : tunables  120   60    8 : slabdata      8      8      0
size-131072(DMA)       0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0
size-131072            0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0
size-65536(DMA)        0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0
size-65536             5      5  65536    1   16 : tunables    8    4    0 : slabdata      5      5      0
size-32768(DMA)        0      0  32768    1    8 : tunables    8    4    0 : slabdata      0      0      0
size-32768             0      0  32768    1    8 : tunables    8    4    0 : slabdata      0      0      0
size-16384(DMA)        0      0  16384    1    4 : tunables    8    4    0 : slabdata      0      0      0
size-16384             2      2  16384    1    4 : tunables    8    4    0 : slabdata      2      2      0
size-8192(DMA)         0      0   8192    1    2 : tunables    8    4    0 : slabdata      0      0      0
size-8192             82     82   8192    1    2 : tunables    8    4    0 : slabdata     82     82      0
size-4096(DMA)         0      0   4096    1    1 : tunables   24   12    8 : slabdata      0      0      0
size-4096            861    861   4096    1    1 : tunables   24   12    8 : slabdata    861    861      0
size-2048(DMA)         0      0   2048    2    1 : tunables   24   12    8 : slabdata      0      0      0
size-2048            385    490   2048    2    1 : tunables   24   12    8 : slabdata    245    245      0
size-1024(DMA)         0      0   1024    4    1 : tunables   54   27    8 : slabdata      0      0      0
size-1024            231    252   1024    4    1 : tunables   54   27    8 : slabdata     63     63      0
size-512(DMA)          0      0    512    8    1 : tunables   54   27    8 : slabdata      0      0      0
size-512             974   1072    512    8    1 : tunables   54   27    8 : slabdata    134    134      0
size-256(DMA)          0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
size-256             312    390    256   15    1 : tunables  120   60    8 : slabdata     26     26      0
size-128(DMA)          0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
size-128            9025  19890    128   30    1 : tunables  120   60    8 : slabdata    663    663      0
size-64(DMA)           0      0     64   59    1 : tunables  120   60    8 : slabdata      0      0      0
size-32(DMA)           0      0     32  113    1 : tunables  120   60    8 : slabdata      0      0      0
size-64             2326   3776     64   59    1 : tunables  120   60    8 : slabdata     64     64      0
size-32             6302  10509     32  113    1 : tunables  120   60    8 : slabdata     93     93      0
kmem_cache           132    150    128   30    1 : tunables  120   60    8 : slabdata      5      5      0

[root@imap10 proc]$ cat cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Xeon(R) CPU            5130  @ 2.00GHz
stepping        : 6
cpu MHz         : 2000.233
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc pni monitor ds_cpl vmx tm2 ssse3 cx16 xtpr dca lahf_lm
bogomips        : 4002.50
clflush size    : 64

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Xeon(R) CPU            5130  @ 2.00GHz
stepping        : 6
cpu MHz         : 2000.233
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc pni monitor ds_cpl vmx tm2 ssse3 cx16 xtpr dca lahf_lm
bogomips        : 4000.20
clflush size    : 64


[root@imap10 proc]$ cat buddyinfo
Node 0, zone      DMA     56      7      4      1      0      1      1      0      1      1      0
Node 0, zone   Normal   1336    256     49     10      1      1      0      0      0      1      0
Node 0, zone  HighMem  99524  12603   1252    537    330    190    109     48     25      9     11


[root@imap10 proc]$ cat modules
i2c_i801 10124 0 - Live 0xf8836000
i2c_core 19584 1 i2c_i801, Live 0xf8863000
ehci_hcd 27276 0 - Live 0xf885b000
uhci_hcd 21136 0 - Live 0xf8854000
usbcore 108680 3 ehci_hcd,uhci_hcd, Live 0xf88d1000

[root@imap10 proc]$ cat zoneinfo
Node 0, zone      DMA
  pages free     958
        min      17
        low      21
        high     25
        active   61
        inactive 273
        scanned  0 (a: 15 i: 11)
        spanned  4096
        present  4064
    nr_anon_pages 0
    nr_mapped    1
    nr_file_pages 334
    nr_slab_reclaimable 1086
    nr_slab_unreclaimable 87
    nr_page_table_pages 0
    nr_dirty     31
    nr_writeback 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 602820
        protection: (0, 873, 13192)
  pagesets
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         0
Node 0, zone   Normal
  pages free     2696
        min      936
        low      1170
        high     1404
        active   94885
        inactive 44918
        scanned  0 (a: 0 i: 0)
        spanned  225280
        present  223520
    nr_anon_pages 0
    nr_mapped    0
    nr_file_pages 139803
    nr_slab_reclaimable 47095
    nr_slab_unreclaimable 7339
    nr_page_table_pages 0
    nr_dirty     14349
    nr_writeback 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 13211869
        protection: (0, 0, 98552)
  pagesets
    cpu: 0 pcp: 0
              count: 144
              high:  186
              batch: 31
    cpu: 0 pcp: 1
              count: 47
              high:  62
              batch: 15
  vm stats threshold: 16
    cpu: 1 pcp: 0
              count: 150
              high:  186
              batch: 31
    cpu: 1 pcp: 1
              count: 60
              high:  62
              batch: 15
  vm stats threshold: 16
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         4096
Node 0, zone  HighMem
  pages free     180803
        min      128
        low      3432
        high     6737
        active   2380717
        inactive 348144
        scanned  0 (a: 0 i: 0)
        spanned  3178496
        present  3153664
    nr_anon_pages 3210
    nr_mapped    1080
    nr_file_pages 190150
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 0
    nr_page_table_pages 151
    nr_dirty     6
    nr_writeback 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 107132
        protection: (0, 0, 0)
  pagesets
    cpu: 0 pcp: 0
              count: 114
              high:  186
              batch: 31
    cpu: 0 pcp: 1
              count: 6
              high:  62
              batch: 15
  vm stats threshold: 32
    cpu: 1 pcp: 0
              count: 113
              high:  186
              batch: 31
    cpu: 1 pcp: 1
              count: 3
              high:  62
              batch: 15
  vm stats threshold: 32
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         229376


[root@imap10 proc]$ cat vmstat
nr_anon_pages 3210
nr_mapped 1081
nr_file_pages 330287
nr_slab_reclaimable 48181
nr_slab_unreclaimable 7424
nr_page_table_pages 151
nr_dirty 14386
nr_writeback 0
nr_unstable 0
nr_bounce 0
nr_vmscan_write 13921821
pgpgin 917158683
pgpgout 290273636
pswpin 1761
pswpout 52912
pgalloc_dma 5981840
pgalloc_normal 349519350
pgalloc_high 1144800149
pgfree 1500486435
pgactivate 326397897
pgdeactivate 185125484
pgfault 2978836583
pgmajfault 19685544
pgrefill_dma 3247880
pgrefill_normal 148534853
pgrefill_high 34856904
pgsteal_dma 2619431
pgsteal_normal 164677731
pgsteal_high 7200844
pgscan_kswapd_dma 4957748
pgscan_kswapd_normal 196582656
pgscan_kswapd_high 7473632
pgscan_direct_dma 14745
pgscan_direct_normal 644320
pgscan_direct_high 0
pginodesteal 39523
slabs_scanned 172962176
kswapd_steal 174009805
kswapd_inodesteal 296683999
pageoutrun 3316600
allocstall 7437
pgrotated 1675389

I tried doing a block_dump and a swapoff to see if it made any difference as well:

[root@imap10 vm]$ free
             total       used       free     shared    buffers     cached
Mem:      12466708   11728876     737832          0     560548     756064
-/+ buffers/cache:   10412264    2054444
Swap:      2048276      49952    1998324

[root@imap10 vm]$ echo 1 > block_dump
[root@imap10 vm]$ free
             total       used       free     shared    buffers     cached
Mem:      12466708   11728876     737832          0     560548     756064
-/+ buffers/cache:   10412264    2054444
Swap:      2048276      49952    1998324

[root@imap10 vm]$ swapoff -a
[root@imap10 vm]$ free
             total       used       free     shared    buffers     cached
Mem:      12466708   11774016     692692          0     560572     806912
-/+ buffers/cache:   10406532    2060176
Swap:            0          0          0

After reboot

[root@imap10 ~]$ free
             total       used       free     shared    buffers     cached
Mem:      12466708     180848   12285860          0       8464      16648
-/+ buffers/cache:     155736   12310972
Swap:      2048276          0    2048276

[root@imap10 ~]$ ps auxw
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.3  0.0   1944   636 ?        Ss   02:51   0:01 init [2]
root         2  0.0  0.0      0     0 ?        S    02:51   0:00 [migration/0]
root         3  0.0  0.0      0     0 ?        SN   02:51   0:00 [ksoftirqd/0]
root         4  0.0  0.0      0     0 ?        S    02:51   0:00 [watchdog/0]
root         5  0.0  0.0      0     0 ?        S    02:51   0:00 [migration/1]
root         6  0.0  0.0      0     0 ?        SN   02:51   0:00 [ksoftirqd/1]
root         7  0.0  0.0      0     0 ?        S    02:51   0:00 [watchdog/1]
root         8  0.0  0.0      0     0 ?        S<   02:51   0:00 [events/0]
root         9  0.0  0.0      0     0 ?        S<   02:51   0:00 [events/1]
root        10  0.0  0.0      0     0 ?        S<   02:51   0:00 [khelper]
root        11  0.0  0.0      0     0 ?        S<   02:51   0:00 [kthread]
root       117  0.0  0.0      0     0 ?        S<   02:51   0:00 [kblockd/0]
root       118  0.0  0.0      0     0 ?        S<   02:51   0:00 [kblockd/1]
root       119  0.0  0.0      0     0 ?        S<   02:51   0:00 [kacpid]
root       228  0.0  0.0      0     0 ?        S<   02:51   0:00 [ata/0]
root       229  0.0  0.0      0     0 ?        S<   02:51   0:00 [ata/1]
root       230  0.0  0.0      0     0 ?        S<   02:51   0:00 [ata_aux]
root       231  0.0  0.0      0     0 ?        S<   02:51   0:00 [kseriod]
root       259  0.0  0.0      0     0 ?        S    02:51   0:00 [pdflush]
root       260  0.0  0.0      0     0 ?        S    02:51   0:00 [pdflush]
root       261  0.0  0.0      0     0 ?        S<   02:51   0:00 [kswapd0]
root       262  0.0  0.0      0     0 ?        S<   02:51   0:00 [aio/0]
root       263  0.0  0.0      0     0 ?        S<   02:51   0:00 [aio/1]
root       913  0.0  0.0      0     0 ?        S<   02:52   0:00 [scsi_eh_0]
root       914  0.0  0.0      0     0 ?        S<   02:52   0:00 [aacraid]
root       937  0.0  0.0      0     0 ?        S<   02:52   0:00 [scsi_eh_1]
root      1035  0.0  0.0      0     0 ?        S<   02:52   0:00 [scsi_eh_2]
root      1147  0.0  0.0      0     0 ?        S<   02:52   0:00 [kpsmoused]
root      1150  0.0  0.0      0     0 ?        S    02:52   0:00 [kirqd]
root      2377  0.0  0.0      0     0 ?        S<   02:52   0:00 [ksuspend_usbd]
root      2378  0.0  0.0      0     0 ?        S<   02:52   0:00 [khubd]
root      2828  0.0  0.0      0     0 ?        S<   02:52   0:00 [kjournald]
root      3006  0.0  0.0   2184   620 ?        S<s  02:52   0:00 udevd --daemon
root      5385  0.0  0.0      0     0 ?        S<   02:55   0:00 [reiserfs/0]
root      5386  0.0  0.0      0     0 ?        S<   02:55   0:00 [reiserfs/1]
daemon    5644  0.0  0.0   1684   364 ?        Ss   02:55   0:00 /sbin/portmap
root      5762  0.0  0.0   1628   612 ?        Ss   02:55   0:00 /sbin/syslogd
root      5768  0.0  0.0   1576   380 ?        Ss   02:55   0:00 /sbin/klogd -x
111       5790  0.0  0.0   2252   812 ?        Ss   02:55   0:00 /usr/bin/dbus-daemon --system
112       5798  1.7  0.0  10596  8988 ?        Ss   02:56   0:00 /usr/sbin/hald
root      5799  0.0  0.0   2892  1036 ?        S    02:56   0:00 hald-runner
112       5805  0.0  0.0   2016   840 ?        S    02:56   0:00 hald-addon-acpi: listening on acpi kernel interface /proc/acpi/event
root      5853  0.0  0.0   1808   624 ?        S    02:56   0:00 hald-addon-storage: polling /dev/sda
root      5859  0.0  0.0   1808   620 ?        S    02:56   0:00 hald-addon-storage: polling /dev/hda
root      5867  0.0  0.0   1572   384 ?        Ss   02:56   0:00 /usr/sbin/irqbalance
root      5882  0.0  0.0   4928  1112 ?        Ss   02:56   0:00 /usr/sbin/sshd
statd     5918  0.0  0.0   1756   724 ?        Ss   02:56   0:00 /sbin/rpc.statd
ntp       5931  0.0  0.0   4024  1204 ?        Ss   02:56   0:00 /usr/sbin/ntpd -p /var/run/ntpd.pid -u 110:109 -g
root      6000  0.0  0.0   6696  4956 ?        Ss   02:56   0:00 /usr/sbin/munin-node
root      6043  0.0  0.0   1576   496 tty1     Ss+  02:56   0:00 /sbin/getty 38400 tty1
root      6045  0.0  0.0   1576   492 tty2     Ss+  02:56   0:00 /sbin/getty 38400 tty2
root      6046  0.0  0.0   1576   496 tty3     Ss+  02:56   0:00 /sbin/getty 38400 tty3
root      6048  0.0  0.0   1576   496 tty4     Ss+  02:56   0:00 /sbin/getty 38400 tty4
root      6049  0.0  0.0   1576   496 tty5     Ss+  02:56   0:00 /sbin/getty 38400 tty5
root      6051  0.0  0.0   1576   496 tty6     Ss+  02:56   0:00 /sbin/getty 38400 tty6
root      6052  0.0  0.0   2644  1276 ?        Ss   02:56   0:00 /bin/sh /command/svscanboot
root      6079  0.0  0.0   1596   352 ?        S    02:56   0:00 svscan /service
root      6080  0.0  0.0   1424   248 ?        S    02:56   0:00 readproctitle service errors: .....................................................................
root      6088  0.0  0.0   1428   296 ?        S    02:56   0:00 supervise dnscache
root      6089  0.0  0.0   1428   296 ?        S    02:56   0:00 supervise log
dnscache  6091  0.3  0.7  99552 98248 ?        S    02:56   0:00 /usr/bin/dnscache
dnslog    6092  0.0  0.0   1440   292 ?        S    02:56   0:00 multilog t ./main
root      6351  0.0  0.0   7488  2152 ?        Ss   02:56   0:00 sshd: root@pts/0
root      6355  0.0  0.0   2828  1640 pts/0    Ss+  02:56   0:00 -bash
root      6363  0.0  0.0   7488  2148 ?        Ss   02:56   0:00 sshd: root@pts/1
root      6367  0.0  0.0   2832  1644 pts/1    Ss   02:56   0:00 -bash
root      6383  0.0  0.0   2220   892 pts/1    R+   02:56   0:00 ps auxw

Any help appreciated.

Rob

----------
robm@fastmail.fm
Sign up at http://fastmail.fm for fast, ad free, IMAP accessible email

