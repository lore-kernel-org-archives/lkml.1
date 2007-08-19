Return-Path: <linux-kernel-owner+w=401wt.eu-S1756393AbXHSH53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbXHSH53 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 03:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbXHSHz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 03:55:57 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:50430 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751252AbXHSHzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 03:55:52 -0400
Message-ID: <387510147.18695@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070819075410.411207640@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Sun, 19 Aug 2007 15:54:10 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: John Berthels <jjberthels@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] process memory footprint info in proc/<pid>/[s|p]maps v2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Inspired by Matt Mackall's pagemap patches and ideas, I worked up these
textual interfaces that achieve the same goals. The patches run OK
under different sized reads.

1) Add PSS into the existing /proc/<pid>/smaps:
        [PATCH 1/4] maps: PSS(proportional set size) accounting in smaps

2) Create /proc/<pid>/pmaps for page granularity mmap footprints:
        [PATCH 2/4] maps: address based vma walking
        [PATCH 3/4] maps: introduce generic_maps_open()
        [PATCH 4/4] maps: /proc/<pid>/pmaps interface - memory maps in granularity of pages

 fs/proc/base.c          |    7 
 fs/proc/internal.h      |    1 
 fs/proc/task_mmu.c      |  359 +++++++++++++++++++++++++++++---------
 fs/seq_file.c           |    1 
 include/linux/proc_fs.h |    7 
 mm/mempolicy.c          |    2 
 6 files changed, 288 insertions(+), 89 deletions(-)

In this new version, offset and len are changed to use hexical numbers.

Thank you,
Fengguang
-- 

An example output:

# cat /proc/`pidof init`/pmaps
00400000-00409000 r-xp 00000000 08:01 1058732                            /sbin/init
0       8       YRAU___ 1
00608000-00609000 rw-p 00008000 08:01 1058732                            /sbin/init
8       1       Y_A_P__ 1
00609000-0062a000 rw-p 00609000 00:00 0                                  [heap]
609     5       Y_A_P__ 1
2b7d6e277000-2b7d6e294000 r-xp 00000000 08:01 1563879                    /lib/ld-2.6.so
0       1       YRAU___ 63
1       4       YRAU___ 41
5       2       YRAU___ 55
7       1       YRAU___ 50
8       1       YRAU___ 55
9       1       YRAU___ 81
a       1       YRAU___ 57
b       2       YRAU___ 55
d       2       YRAU___ 81
f       1       YRAU___ 55
10      1       YRAU___ 43
13      1       YRAU___ 81
14      1       YRAU___ 42
15      1       YRAU___ 81
16      1       YRAU___ 56
17      1       YRAU___ 81
1a      1       YRAU___ 55
2b7d6e294000-2b7d6e297000 rw-p 2b7d6e294000 00:00 0
2b7d6e294       3       Y_A_P__ 1
2b7d6e493000-2b7d6e495000 rw-p 0001c000 08:01 1563879                    /lib/ld-2.6.so
1c      2       Y_A_P__ 1
2b7d6e495000-2b7d6e4d0000 r-xp 00000000 08:01 1400920                    /lib/libsepol.so.1
0       1       YRAU___ 5
1       2       YRAU___ 3
3       1       YRAU___ 5
4       1       YRAU___ 3
30      1       YRAU___ 3
2b7d6e4d0000-2b7d6e6d0000 ---p 0003b000 08:01 1400920                    /lib/libsepol.so.1
2b7d6e6d0000-2b7d6e6d1000 rw-p 0003b000 08:01 1400920                    /lib/libsepol.so.1
3b      1       Y_A_P__ 1
2b7d6e6d1000-2b7d6e6db000 rw-p 2b7d6e6d1000 00:00 0
2b7d6e6db000-2b7d6e6f1000 r-xp 00000000 08:01 1400922                    /lib/libselinux.so.1
0       1       YRAU___ 9
1       3       YRAU___ 5
4       1       YRAU___ 4
a       1       YRAU___ 4
c       1       YRAU___ 3
f       1       YRAU___ 4
10      1       YRAU___ 3
12      2       YRAU___ 4
2b7d6e6f1000-2b7d6e8f0000 ---p 00016000 08:01 1400922                    /lib/libselinux.so.1
2b7d6e8f0000-2b7d6e8f2000 rw-p 00015000 08:01 1400922                    /lib/libselinux.so.1
15      2       Y_A_P__ 1
2b7d6e8f2000-2b7d6e8f3000 rw-p 2b7d6e8f2000 00:00 0
2b7d6e8f2       1       Y_A_P__ 1
2b7d6e8f3000-2b7d6ea40000 r-xp 00000000 08:01 1564031                    /lib/libc-2.6.so
0       2       YRAU___ 81
2       1       YRAU___ 80
3       1       YRAU___ 81
4       1       YRAU___ 72
5       1       YRAU___ 77
6       1       YRAU___ 79
7       1       YRAU___ 73
8       1       YRAU___ 79
9       1       YRAU___ 78
a       1       YRAU___ 77
b       1       YRAU___ 72
c       1       YRAU___ 75
d       1       YRAU___ 81
e       1       YRAU___ 72
f       1       YRAU___ 78
10      1       YRAU___ 81
11      1       YRAU___ 78
12      1       YRAU___ 80
13      1       YRAU___ 78
14      2       YRAU___ 81
16      1       YRAU___ 49
17      6       YRAU___ 41
1d      1       YRAU___ 80
2a      1       YRAU___ 44
2b      1       YRAU___ 69
2c      1       YRAU___ 28
31      1       YRAU___ 79
32      1       YRAU___ 49
33      1       YRAU___ 73
34      1       YRAU___ 57
35      1       YRAU___ 67
42      1       YRAU___ 77
43      3       YRAU___ 78
46      1       YRAU___ 77
47      1       YRAU___ 70
48      1       YRAU___ 15
4d      1       YRAU___ 78
5f      1       YRAU___ 78
60      1       YRAU___ 75
61      1       YRAU___ 72
62      1       YRAU___ 67
63      1       YRAU___ 59
68      1       YRAU___ 63
69      1       YRAU___ 61
6a      1       YRAU___ 63
6b      1       YRAU___ 75
6c      1       YRAU___ 76
6d      1       YRAU___ 81
6e      1       YRAU___ 77
6f      1       YRAU___ 79
70      1       YRAU___ 44
71      1       YRAU___ 79
72      1       YRAU___ 78
73      1       YRAU___ 79
74      1       YRAU___ 46
75      1       YRAU___ 78
76      1       YRAU___ 60
78      1       YRAU___ 79
79      1       YRAU___ 81
7a      1       YRAU___ 80
7e      1       YRAU___ 41
8a      1       YRAU___ 36
8b      1       YRAU___ 72
8c      1       YRAU___ 28
8d      1       YRAU___ 21
91      2       YRAU___ 19
99      1       YRAU___ 62
9a      1       YRAU___ 76
9b      1       YRAU___ 72
c4      1       YRAU___ 80
c5      1       YRAU___ 82
c6      1       YRAU___ 81
cb      1       YRAU___ 42
cc      1       YRAU___ 79
cd      1       YRAU___ 26
cf      1       YRAU___ 12
d0      1       YRAU___ 77
d1      1       YRAU___ 38
d2      1       YRAU___ 45
d3      1       YRAU___ 66
d4      1       YRAU___ 71
e0      1       YRAU___ 52
106     1       YRAU___ 33
107     1       YRAU___ 14
108     1       YRAU___ 63
109     1       YRAU___ 57
10b     1       YRAU___ 70
10c     1       YRAU___ 63
118     1       YRAU___ 65
119     1       YRAU___ 78
11a     1       YRAU___ 69
11b     1       YRAU___ 68
11e     2       YRAU___ 62
120     1       YRAU___ 74
121     1       YRAU___ 42
125     1       YRAU___ 17
2b7d6ea40000-2b7d6ec40000 ---p 0014d000 08:01 1564031                    /lib/libc-2.6.so
2b7d6ec40000-2b7d6ec43000 r--p 0014d000 08:01 1564031                    /lib/libc-2.6.so
14d     3       Y_A_P__ 1
2b7d6ec43000-2b7d6ec45000 rw-p 00150000 08:01 1564031                    /lib/libc-2.6.so
150     2       Y_A_P__ 1
2b7d6ec45000-2b7d6ec4b000 rw-p 2b7d6ec45000 00:00 0
2b7d6ec45       6       Y_A_P__ 1
2b7d6ec4b000-2b7d6ec4d000 r-xp 00000000 08:01 1564037                    /lib/libdl-2.6.so
0       1       YRAU___ 51
1       1       YRAU___ 39
2b7d6ec4d000-2b7d6ee4d000 ---p 00002000 08:01 1564037                    /lib/libdl-2.6.so
2b7d6ee4d000-2b7d6ee4f000 rw-p 00002000 08:01 1564037                    /lib/libdl-2.6.so
2       2       Y_A_P__ 1
2b7d6ee4f000-2b7d6ee50000 rw-p 2b7d6ee4f000 00:00 0
2b7d6ee4f       1       Y_A_P__ 1
7fff3c81d000-7fff3c832000 rw-p 7ffffffea000 00:00 0                      [stack]
7fffffffa       1       Y_A_P__ 1
7fffffffc       2       Y_A_P__ 1
7fffffffe       1       YRA_P__ 1
7fff3c9fe000-7fff3ca00000 r-xp 7fff3c9fe000 00:00 0                      [vdso]
0       1       YR_____ 55
