Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbZFDPVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbZFDPVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 11:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbZFDPU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 11:20:56 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:56432 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbZFDPUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 11:20:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qk1BzTpXacFkRKjeeuhSJWOGu1LLsph74/MEP1/XOQyWcFKTtqN83qM7s9/4CUsJ5M
         pt9f98Satbrxs5dIVptj/iY18XVf6M0VWdfQMbx/9+IoHpSh+EIahU0t0rD8qzK1frml
         mfbvSsw6xnWz4LcECV8EWig4OzDuWxousYsPI=
Date: Thu, 4 Jun 2009 17:20:44 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, tytso@mit.edu,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v9
Message-ID: <20090604152040.GA6007@nowhere>
References: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,


On Thu, May 28, 2009 at 01:46:33PM +0200, Jens Axboe wrote:
> Hi,
> 
> Here's the 9th version of the writeback patches. Changes since v8:
> 
> - Fix a bdi_work on-stack allocation hang. I hope this fixes Ted's
>   issue.
> - Get rid of the explicit wait queues, we can just use wake_up_process()
>   since it's just for that one task.
> - Add separate "sync_supers" thread that makes sure that the dirty
>   super blocks get written. We cannot safely do this from bdi_forker_task(),
>   as that risks deadlocking on ->s_umount. Artem, I implemented this
>   by doing the wake ups from a timer so that it would be easier for you
>   to just deactivate the timer when there are no super blocks.
> 
> For ease of patching, I've put the full diff here:
> 
>   http://kernel.dk/writeback-v9.patch
> 
> and also stored this in a writeback-v9 branch that will not change,
> you can pull that into Linus tree from here:
> 
>   git://git.kernel.dk/linux-2.6-block.git writeback-v9
> 
>  block/blk-core.c            |    1 +
>  drivers/block/aoe/aoeblk.c  |    1 +
>  drivers/char/mem.c          |    1 +
>  fs/btrfs/disk-io.c          |   24 +-
>  fs/buffer.c                 |    2 +-
>  fs/char_dev.c               |    1 +
>  fs/configfs/inode.c         |    1 +
>  fs/fs-writeback.c           |  804 ++++++++++++++++++++++++++++-------
>  fs/fuse/inode.c             |    1 +
>  fs/hugetlbfs/inode.c        |    1 +
>  fs/nfs/client.c             |    1 +
>  fs/ntfs/super.c             |   33 +--
>  fs/ocfs2/dlm/dlmfs.c        |    1 +
>  fs/ramfs/inode.c            |    1 +
>  fs/super.c                  |    3 -
>  fs/sync.c                   |    2 +-
>  fs/sysfs/inode.c            |    1 +
>  fs/ubifs/super.c            |    1 +
>  include/linux/backing-dev.h |   73 ++++-
>  include/linux/fs.h          |   11 +-
>  include/linux/writeback.h   |   15 +-
>  kernel/cgroup.c             |    1 +
>  mm/Makefile                 |    2 +-
>  mm/backing-dev.c            |  518 ++++++++++++++++++++++-
>  mm/page-writeback.c         |  151 +------
>  mm/pdflush.c                |  269 ------------
>  mm/swap_state.c             |    1 +
>  mm/vmscan.c                 |    2 +-
>  28 files changed, 1286 insertions(+), 637 deletions(-)
> 


I've just tested it on UP in a single disk.

I've run two parallels dbench tests on two partitions and
tried it with this patch and without.

I used 30 proc each during 600 secs.

You can see the result in attachment.
And also there:

http://kernel.org/pub/linux/kernel/people/frederic/dbench.pdf
http://kernel.org/pub/linux/kernel/people/frederic/bdi-writeback-hda1.log
http://kernel.org/pub/linux/kernel/people/frederic/bdi-writeback-hda3.log
http://kernel.org/pub/linux/kernel/people/frederic/pdflush-hda1.log
http://kernel.org/pub/linux/kernel/people/frederic/pdflush-hda3.log


As you can see, bdi writeback is faster than pdflush on hda1 and slower
on hda3. But, well that's not the point.

What I can observe here is the difference on the standard deviation
for the rate between two parallel writers on a same device (but
two different partitions, then superblocks).

With pdflush, the distributed rate is much better balanced than
with bdi writeback in a single device.

I'm not sure why. Is there something in these patches that makes
several bdi flusher threads for a same bdi not well balanced
between them?

Frederic.

--pf9I7BMVVzbSWLtt
Content-Type: application/pdf
Content-Disposition: attachment; filename="dbench.pdf"
Content-Transfer-Encoding: base64

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
OJVTEeX2u19xbtQAmgrVocQ6IHO8nARdNZ1Gj9T5aVGRNxl+gVbfVSH2/Eu6seusGgUCCL+x
tw0FwuvC2jRAVALTJjwEXFKS65Ynq8wf5bqfFk9qqHEMt1fnxnXHqwGWZhEWe43ePdlL1Gwi
X8z6VGJ6R6lZXS3FR1okwUc/mLz4jDEIYQL/xrngfEbxiLHRiWMotcjK7EfdAYMKi0TqtfDC
1iWXA3GQ/sRm1pHysBQEHKPbojzasJntrhbOkc4A1c8OZvBSSYlYaipLZJXDJ67WtE76diF1
h6NUIEvgdHcbOhZpmhon+NXn+am1P7FMd3sOno+FEd2S+y2Acw+ruoitKU+XEIdw2dYhQmPS
MXnlylf7mDtGMoj9OCvDbwEItq1HMD/TSNT7VUnaVNSMn5utwO8sW6O+g2Wk1xy/0TGvoVdF
d3+QQU04ELcy2oOv+nxutfCjY6xD2bn4TPcA07Wxw9b+/BVJvhg8Gd08W1Nf4s6YmCg09qAU
aoeOPYpaQHfdXCxOUweEoN04muRICzgzidM9uN7iiad0Lyi5MG6Mq7y7kPblmdTw3PT7mnBm
46gDwl3RP1kjrZp8G727cepkJgCgVzWZ3Psxs+ne73xWY9RhQBAq3oBooTOvaX1fktklLLt6
4lrp30j8ccSMIUubfVHi9IUp+tCGV1TrsWGweYBXwon1YuCswmBZtLh+YITKQ5zFbYJPiaIo
+R2pd+bj+EXA/wEVyGJGCmVuZHN0cmVhbQplbmRvYmoKMiAwIG9iago8PAovVHlwZSAvRm9u
dERlc2NyaXB0b3IKL0ZvbnROYW1lIC9DTVIxMAovRmxhZ3MgNAovRm9udEJCb3ggWzAgLTE5
NCAxMDI3IDY4M10KL0l0YWxpY0FuZ2xlIDAKL0FzY2VudCA2ODMKL0Rlc2NlbnQgLTE5NAov
Q2FwSGVpZ2h0IDY5NAovU3RlbVYgOTIKL0ZvbnRGaWxlIDEgMCBSCj4+CmVuZG9iagozIDAg
b2JqCjw8Ci9UeXBlIC9Gb250Ci9TdWJ0eXBlIC9UeXBlMQovTmFtZSAvQ01SMTAKL0Jhc2VG
b250IC9DTVIxMAovRmlyc3RDaGFyIDEzCi9MYXN0Q2hhciAxMTkKL1dpZHRocwpbIDU1NS41
NTcyNTEgMCAwCjAgMCAwIDAgMCAwIDAgMAowIDAgMCAwIDAgMCAwIDAKMCAwIDAgMCAwIDAg
MCAwCjAgMCAwIDAgMCAzMzMuMzMyODI1IDAgNTAwLjAwMTUyNgo1MDAuMDAxNTI2IDUwMC4w
MDE1MjYgNTAwLjAwMTUyNiA1MDAuMDAxNTI2IDUwMC4wMDE1MjYgNTAwLjAwMTUyNiA1MDAu
MDAxNTI2IDAKMCAwIDAgMCAwIDAgMCAwCjAgMCA3MDguMzM1ODc2IDAgMCAwIDAgMAowIDAg
MCAwIDAgOTE2LjY2ODcwMSAwIDAKMCAwIDAgMCAwIDAgMCAwCjAgMCAwIDAgMCAwIDAgMAow
IDUwMC4wMDE1MjYgNTU1LjU1NzI1MSA0NDQuNDQ0Mjc1IDU1NS41NTcyNTEgNDQ0LjQ0NDI3
NSAwIDAKNTU1LjU1NzI1MSAyNzcuNzc4NjI1IDAgNTI3Ljc4MDE1MSAyNzcuNzc4NjI1IDAg
MCAwCjU1NS41NTcyNTEgMCAzOTEuNjY3MTc1IDM5NC40NDQyNzUgMzg4Ljg5MDA3NiA1NTUu
NTU3MjUxIDAgNzIyLjIyMjkwMCBdCi9Gb250RGVzY3JpcHRvciAyIDAgUgo+PgplbmRvYmoK
NCAwIG9iago8PAovTGVuZ3RoIDEzNDEyCi9GaWx0ZXIgL0ZsYXRlRGVjb2RlCj4+CnN0cmVh
bQp4nNWdy64lx3Wm53yKM7QH3MrMuOZUhmGgAQ0kcdbdA1mib30KsEU3/Pr9/5FnR3wraxdN
FQmjbcIQuSord2Rc1i2+WLE9Sq3ncb79xzf/pn/SI297aeVte2zj/94+vZC9fzP/FbLfjzfs
n/3J/Jf5R9/u2+M8c93b+sM/ftJf/vV33/zqb37zu317Ox9nPWre3r77h2/2N73kbX/79njk
c6t1w7999+ntr7a/fvvuX7752++++e3453js23H08y23x5HzdmZ9xAshvoLC368PPvMj977r
b316JcQLKPxL+kFv7eVoDS/4KR2RH2ffUyq3jti/1BN73h8t6V8TuwJSfEqQojP23h9nq6l1
9gakfAelX9UfeMPP6JDjSx1ypPo4ji23gx0CKT4mSNEh6qFHrrnUxg6BlO+g9Ks6BG/4GR2S
vtQhKW2PtvVad3YIpPiYIEWHpNYepxpbKjsEUr6D0q/qELzhZ3RI/qLyOMpjP2svW9AeS0r1
QSk6RFPmMdRKYYdAGlQQpF/VIXjDz+iQ8qUOKfv58Cemkx0CKT4mSNEhsjUPGZs9ZXYIpHwH
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
fg6nVr77h292fZ7+zhu6xwCez9N+9+ntr/7+r9+++5f50ACVZCVuD/3pn7/9jz//879///d/
+GN83Btg0hDp9vz/+faf/vSHfTz6t9/py377VV+HCfT/4/eln/19a0J+/ff960/6vv8lu/V/
f/inX2ZY1rz9L2z2rbfXP/8P8uP3dWVuZHN0cmVhbQplbmRvYmoKNSAwIG9iago8PAovVHlw
ZSAvUGFnZQovUGFyZW50IDYgMCBSCi9NZWRpYUJveCBbLTM3LjkzMzE5NCAtMzMuMjgzOTA5
IDkyNS43ODI2MTggNTcxLjg1ODgzN10KL0NvbnRlbnRzIDQgMCBSCi9SZXNvdXJjZXMgPDwK
L1Byb2NTZXQgWyAvUERGIC9UZXh0IF0KL0ZvbnQgPDwKL0NNUjEwIDMgMCBSCj4+Cj4+Cj4+
CmVuZG9iago2IDAgb2JqCjw8Ci9UeXBlIC9QYWdlcwovS2lkcyBbNSAwIFJdCi9Db3VudCAx
Cj4+CmVuZG9iago3IDAgb2JqCjw8Ci9DcmVhdG9yIChQeVggMC45KQovQ3JlYXRpb25EYXRl
IChEOjIwMDkwNjA0MTU1NC0wMScwMCcpCj4+CmVuZG9iago4IDAgb2JqCjw8Ci9UeXBlIC9D
YXRhbG9nCi9QYWdlcyA2IDAgUgo+PgplbmRvYmoKeHJlZgowIDkKMDAwMDAwMDAwMCA2NTUz
NSBmIAowMDAwMDAwMDE1IDAwMDAwIG4gCjAwMDAwMDY5OTkgMDAwMDAgbiAKMDAwMDAwNzE3
OCAwMDAwMCBuIAowMDAwMDA3Nzc2IDAwMDAwIG4gCjAwMDAwMjEyNjEgMDAwMDAgbiAKMDAw
MDAyMTQ0NiAwMDAwMCBuIAowMDAwMDIxNTAzIDAwMDAwIG4gCjAwMDAwMjE1ODEgMDAwMDAg
biAKdHJhaWxlcgo8PAovU2l6ZSA5Ci9Sb290IDggMCBSCi9JbmZvIDcgMCBSCj4+CnN0YXJ0
eHJlZgoyMTYzMAolJUVPRgo=

--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="bdi-writeback-hda1.log"

dbench version 3.04 - Copyright Andrew Tridgell 1999-2004

Running for 600 seconds with load '/usr/share/dbench/client.txt' and minimum warmup 120 secs
30 clients started
  30        48    47.25 MB/sec  warmup   1 sec   
  30        48    25.73 MB/sec  warmup   2 sec   
  30        48    17.67 MB/sec  warmup   3 sec   
  30        51    14.77 MB/sec  warmup   4 sec   
  30        55     5.01 MB/sec  warmup  14 sec   
  30        57     2.47 MB/sec  warmup  29 sec   
  30        60     2.29 MB/sec  warmup  33 sec   
  30        61     1.83 MB/sec  warmup  42 sec   
  30        66     1.90 MB/sec  warmup  45 sec   
  30        66     1.86 MB/sec  warmup  46 sec   
  30        66     1.82 MB/sec  warmup  47 sec   
  30        66     1.78 MB/sec  warmup  48 sec   
  30        94     2.43 MB/sec  warmup  52 sec   
  30        94     2.39 MB/sec  warmup  53 sec   
  30        99     2.08 MB/sec  warmup  64 sec   
  30       126     2.40 MB/sec  warmup  68 sec   
  30       126     2.37 MB/sec  warmup  69 sec   
  30       171     2.49 MB/sec  warmup  84 sec   
  30       171     2.46 MB/sec  warmup  85 sec   
  30       171     2.43 MB/sec  warmup  86 sec   
  30       171     2.40 MB/sec  warmup  87 sec   
  30       179     2.23 MB/sec  warmup  97 sec   
  30       186     2.15 MB/sec  warmup 104 sec   
  30       186     2.02 MB/sec  warmup 111 sec   
  30       189     1.93 MB/sec  warmup 117 sec   
  30       256     2.44 MB/sec  warmup 119 sec   
  30       256     2.42 MB/sec  warmup 120 sec   
  30       261     0.00 MB/sec  execute   1 sec   
  30       261     0.00 MB/sec  execute   2 sec   
  30       272     0.45 MB/sec  execute  23 sec   
  30       299     1.20 MB/sec  execute  30 sec   
  30       299     1.16 MB/sec  execute  31 sec   
  30       299     1.12 MB/sec  execute  32 sec   
  30       299     1.09 MB/sec  execute  33 sec   
  30       299     1.06 MB/sec  execute  34 sec   
  30       335     1.83 MB/sec  execute  38 sec   
  30       350     2.14 MB/sec  execute  39 sec   
  30       418     3.10 MB/sec  execute  48 sec   
  30       430     3.22 MB/sec  execute  49 sec   
  30       430     3.16 MB/sec  execute  50 sec   
  30       493     3.61 MB/sec  execute  59 sec   
  30       499     3.61 MB/sec  execute  60 sec   
  30       617     3.94 MB/sec  execute  67 sec   
  30       720     4.14 MB/sec  execute  68 sec   
  30       839     4.46 MB/sec  execute  69 sec   
  30      1171     5.26 MB/sec  execute  70 sec   
  30      1185     5.25 MB/sec  execute  71 sec   
  30      1185     5.17 MB/sec  execute  72 sec   
  30      1493     5.44 MB/sec  execute  81 sec   
  30      1493     5.37 MB/sec  execute  82 sec   
  30      1505     5.33 MB/sec  execute  83 sec   
  30      1559     5.39 MB/sec  execute  84 sec   
  30      1563     5.33 MB/sec  execute  85 sec   
  30      1646     5.43 MB/sec  execute  86 sec   
  30      1677     5.43 MB/sec  execute  87 sec   
  30      2030     6.06 MB/sec  execute  88 sec   
  30      2381     6.61 MB/sec  execute  89 sec   
  30      2738     7.17 MB/sec  execute  90 sec   
  30      3127     7.72 MB/sec  execute  91 sec   
  30      3451     8.32 MB/sec  execute  92 sec   
  30      3837     8.78 MB/sec  execute  93 sec   
  30      4188     9.35 MB/sec  execute  94 sec   
  30      4521     9.80 MB/sec  execute  95 sec   
  30      4903    10.34 MB/sec  execute  96 sec   
  30      5267    10.88 MB/sec  execute  97 sec   
  30      5376    11.02 MB/sec  execute  98 sec   
  30      5587    11.17 MB/sec  execute  99 sec   
  30      5868    11.52 MB/sec  execute 100 sec   
  30      6039    11.68 MB/sec  execute 101 sec   
  30      6047    11.57 MB/sec  execute 102 sec   
  30      6078    11.46 MB/sec  execute 103 sec   
  30      6170    11.46 MB/sec  execute 104 sec   
  30      6224    11.42 MB/sec  execute 105 sec   
  30      6374    11.56 MB/sec  execute 106 sec   
  30      6601    11.84 MB/sec  execute 107 sec   
  30      6839    12.08 MB/sec  execute 108 sec   
  30      7078    12.32 MB/sec  execute 109 sec   
  30      7320    12.56 MB/sec  execute 110 sec   
  30      7634    12.88 MB/sec  execute 111 sec   
  30      8001    13.31 MB/sec  execute 112 sec   
  30      8290    13.69 MB/sec  execute 113 sec   
  30      8638    14.13 MB/sec  execute 114 sec   
  30      9038    14.41 MB/sec  execute 115 sec   
  30      9367    14.86 MB/sec  execute 116 sec   
  30      9697    15.19 MB/sec  execute 117 sec   
  30     10052    15.52 MB/sec  execute 118 sec   
  30     10412    15.91 MB/sec  execute 119 sec   
  30     10613    16.01 MB/sec  execute 120 sec   
  30     10640    15.93 MB/sec  execute 121 sec   
  30     10838    16.08 MB/sec  execute 122 sec   
  30     11211    16.38 MB/sec  execute 123 sec   
  30     11558    16.69 MB/sec  execute 124 sec   
  30     11899    17.09 MB/sec  execute 125 sec   
  30     12267    17.39 MB/sec  execute 126 sec   
  30     12619    17.67 MB/sec  execute 127 sec   
  30     12891    17.94 MB/sec  execute 128 sec   
  30     13072    18.01 MB/sec  execute 129 sec   
  30     13263    18.05 MB/sec  execute 130 sec   
  30     13425    18.16 MB/sec  execute 131 sec   
  30     13572    18.23 MB/sec  execute 132 sec   
  30     13761    18.29 MB/sec  execute 133 sec   
  30     13901    18.29 MB/sec  execute 134 sec   
  30     14035    18.36 MB/sec  execute 135 sec   
  30     14129    18.37 MB/sec  execute 136 sec   
  30     14212    18.31 MB/sec  execute 137 sec   
  30     14279    18.26 MB/sec  execute 138 sec   
  30     14374    18.20 MB/sec  execute 139 sec   
  30     14460    18.12 MB/sec  execute 140 sec   
  30     14552    18.14 MB/sec  execute 141 sec   
  30     14565    18.02 MB/sec  execute 142 sec   
  30     14567    17.90 MB/sec  execute 143 sec   
  30     14567    17.77 MB/sec  execute 144 sec   
  30     14567    17.65 MB/sec  execute 145 sec   
  30     14567    17.53 MB/sec  execute 146 sec   
  30     14567    17.41 MB/sec  execute 147 sec   
  30     14728    17.51 MB/sec  execute 148 sec   
  30     14957    17.69 MB/sec  execute 149 sec   
  30     15027    17.61 MB/sec  execute 150 sec   
  30     15378    17.90 MB/sec  execute 151 sec   
  30     15742    18.13 MB/sec  execute 152 sec   
  30     16100    18.42 MB/sec  execute 153 sec   
  30     16466    18.68 MB/sec  execute 154 sec   
  30     16790    18.93 MB/sec  execute 155 sec   
  30     17055    19.08 MB/sec  execute 156 sec   
  30     17138    19.06 MB/sec  execute 157 sec   
  30     17230    19.03 MB/sec  execute 158 sec   
  30     17332    18.99 MB/sec  execute 159 sec   
  30     17522    19.07 MB/sec  execute 160 sec   
  30     17736    19.16 MB/sec  execute 161 sec   
  30     17840    18.18 MB/sec  execute 171 sec   
  30     17840    18.07 MB/sec  execute 172 sec   
  30     17851    17.97 MB/sec  execute 173 sec   
  30     17851    17.87 MB/sec  execute 174 sec   
  30     17851    17.77 MB/sec  execute 175 sec   
  30     17852    17.67 MB/sec  execute 176 sec   
  30     17858    17.58 MB/sec  execute 177 sec   
  30     17858    17.48 MB/sec  execute 178 sec   
  30     17899    17.43 MB/sec  execute 179 sec   
  30     18946    17.39 MB/sec  execute 189 sec   
  30     18946    17.29 MB/sec  execute 190 sec   
  30     19249    17.30 MB/sec  execute 192 sec   
  30     19415    17.35 MB/sec  execute 193 sec   
  30     19517    17.33 MB/sec  execute 194 sec   
  30     19589    17.31 MB/sec  execute 195 sec   
  30     19669    17.28 MB/sec  execute 196 sec   
  30     19709    17.24 MB/sec  execute 197 sec   
  30     19773    17.19 MB/sec  execute 198 sec   
  30     19847    17.18 MB/sec  execute 199 sec   
  30     19947    17.14 MB/sec  execute 200 sec   
  30     20045    17.14 MB/sec  execute 201 sec   
  30     20136    17.14 MB/sec  execute 202 sec   
  30     20203    17.10 MB/sec  execute 203 sec   
  30     20294    17.10 MB/sec  execute 204 sec   
  30     20316    17.05 MB/sec  execute 205 sec   
  30     20422    17.03 MB/sec  execute 206 sec   
  30     20470    16.97 MB/sec  execute 207 sec   
  30     20480    16.90 MB/sec  execute 208 sec   
  30     20480    16.82 MB/sec  execute 209 sec   
  30     20480    16.74 MB/sec  execute 210 sec   
  30     20480    16.66 MB/sec  execute 211 sec   
  30     20526    16.62 MB/sec  execute 212 sec   
  30     20555    16.56 MB/sec  execute 213 sec   
  30     20555    16.48 MB/sec  execute 214 sec   
  30     20768    16.56 MB/sec  execute 215 sec   
  30     21073    16.75 MB/sec  execute 216 sec   
  30     21427    16.92 MB/sec  execute 217 sec   
  30     21778    17.10 MB/sec  execute 218 sec   
  30     22150    17.27 MB/sec  execute 219 sec   
  30     22494    17.47 MB/sec  execute 220 sec   
  30     22837    17.63 MB/sec  execute 221 sec   
  30     23200    17.81 MB/sec  execute 222 sec   
  30     23552    18.00 MB/sec  execute 223 sec   
  30     23886    18.17 MB/sec  execute 224 sec   
  30     24037    18.21 MB/sec  execute 225 sec   
  30     24060    18.14 MB/sec  execute 226 sec   
  30     24293    17.72 MB/sec  execute 234 sec   
  30     24293    17.64 MB/sec  execute 235 sec   
  30     24293    17.57 MB/sec  execute 236 sec   
  30     24321    17.53 MB/sec  execute 237 sec   
  30     24547    17.58 MB/sec  execute 238 sec   
  30     24602    17.56 MB/sec  execute 239 sec   
  30     24950    17.71 MB/sec  execute 240 sec   
  30     25300    17.86 MB/sec  execute 241 sec   
  30     25654    18.03 MB/sec  execute 242 sec   
  30     26001    18.20 MB/sec  execute 243 sec   
  30     26340    18.34 MB/sec  execute 244 sec   
  30     27206    18.57 MB/sec  execute 248 sec   
  30     27288    18.56 MB/sec  execute 249 sec   
  30     27288    18.49 MB/sec  execute 250 sec   
  30     27290    18.41 MB/sec  execute 251 sec   
  30     27290    18.34 MB/sec  execute 252 sec   
  30     27347    18.32 MB/sec  execute 253 sec   
  30     27347    18.25 MB/sec  execute 254 sec   
  30     27347    18.18 MB/sec  execute 255 sec   
  30     27454    18.17 MB/sec  execute 256 sec   
  30     27728    18.28 MB/sec  execute 257 sec   
  30     28097    18.43 MB/sec  execute 258 sec   
  30     28464    18.59 MB/sec  execute 259 sec   
  30     28795    18.73 MB/sec  execute 260 sec   
  30     29002    18.83 MB/sec  execute 261 sec   
  30     29209    18.84 MB/sec  execute 262 sec   
  30     29428    18.88 MB/sec  execute 263 sec   
  30     29577    18.92 MB/sec  execute 264 sec   
  30     29725    18.94 MB/sec  execute 265 sec   
  30     29802    18.93 MB/sec  execute 266 sec   
  30     29835    18.88 MB/sec  execute 267 sec   
  30     29938    18.88 MB/sec  execute 268 sec   
  30     30150    18.93 MB/sec  execute 269 sec   
  30     30487    19.08 MB/sec  execute 270 sec   
  30     30853    19.22 MB/sec  execute 271 sec   
  30     31222    19.35 MB/sec  execute 272 sec   
  30     31579    19.49 MB/sec  execute 273 sec   
  30     31936    19.64 MB/sec  execute 274 sec   
  30     32085    19.67 MB/sec  execute 275 sec   
  30     32232    19.68 MB/sec  execute 276 sec   
  30     32399    19.71 MB/sec  execute 277 sec   
  30     32513    19.70 MB/sec  execute 278 sec   
  30     33554    19.35 MB/sec  execute 291 sec   
  30     33577    19.29 MB/sec  execute 292 sec   
  30     33577    19.23 MB/sec  execute 293 sec   
  30     33577    19.16 MB/sec  execute 294 sec   
  30     33577    19.10 MB/sec  execute 295 sec   
  30     33577    19.03 MB/sec  execute 296 sec   
  30     33577    18.97 MB/sec  execute 297 sec   
  30     33577    18.91 MB/sec  execute 298 sec   
  30     33577    18.84 MB/sec  execute 299 sec   
  30     33577    18.78 MB/sec  execute 300 sec   
  30     33577    18.72 MB/sec  execute 301 sec   
  30     33588    18.66 MB/sec  execute 302 sec   
  30     33667    18.64 MB/sec  execute 303 sec   
  30     33843    18.66 MB/sec  execute 304 sec   
  30     33872    18.62 MB/sec  execute 305 sec   
  30     34209    18.76 MB/sec  execute 306 sec   
  30     34558    18.88 MB/sec  execute 307 sec   
  30     34883    19.00 MB/sec  execute 308 sec   
  30     35233    19.13 MB/sec  execute 309 sec   
  30     35571    19.24 MB/sec  execute 310 sec   
  30     35939    19.36 MB/sec  execute 311 sec   
  30     36268    19.52 MB/sec  execute 312 sec   
  30     36588    19.65 MB/sec  execute 313 sec   
  30     36887    19.70 MB/sec  execute 314 sec   
  30     36887    19.64 MB/sec  execute 315 sec   
  30     36889    19.58 MB/sec  execute 316 sec   
  30     37176    19.68 MB/sec  execute 317 sec   
  30     37289    19.64 MB/sec  execute 318 sec   
  30     37321    19.59 MB/sec  execute 319 sec   
  30     37452    19.58 MB/sec  execute 320 sec   
  30     37677    19.62 MB/sec  execute 321 sec   
  30     38025    19.74 MB/sec  execute 322 sec   
  30     38379    19.86 MB/sec  execute 323 sec   
  30     38741    19.98 MB/sec  execute 324 sec   
  30     39109    20.09 MB/sec  execute 325 sec   
  30     39465    20.22 MB/sec  execute 326 sec   
  30     39831    20.33 MB/sec  execute 327 sec   
  30     40194    20.45 MB/sec  execute 328 sec   
  30     40530    20.54 MB/sec  execute 329 sec   
  30     40741    20.59 MB/sec  execute 330 sec   
  30     40882    20.59 MB/sec  execute 331 sec   
  30     40967    20.58 MB/sec  execute 332 sec   
  30     41068    20.58 MB/sec  execute 333 sec   
  30     41191    20.57 MB/sec  execute 334 sec   
  30     41249    20.53 MB/sec  execute 335 sec   
  30     41249    20.47 MB/sec  execute 336 sec   
  30     41249    20.40 MB/sec  execute 337 sec   
  30     41249    20.34 MB/sec  execute 338 sec   
  30     41249    20.28 MB/sec  execute 339 sec   
  30     41261    20.24 MB/sec  execute 340 sec   
  30     41261    20.18 MB/sec  execute 341 sec   
  30     41262    20.12 MB/sec  execute 342 sec   
  30     41279    20.06 MB/sec  execute 343 sec   
  30     41375    20.00 MB/sec  execute 345 sec   
  30     41375    19.94 MB/sec  execute 346 sec   
  30     41416    19.90 MB/sec  execute 347 sec   
  30     41704    19.98 MB/sec  execute 348 sec   
  30     42073    20.10 MB/sec  execute 349 sec   
  30     42437    20.21 MB/sec  execute 350 sec   
  30     42788    20.31 MB/sec  execute 351 sec   
  30     43159    20.42 MB/sec  execute 352 sec   
  30     43528    20.53 MB/sec  execute 353 sec   
  30     43878    20.64 MB/sec  execute 354 sec   
  30     44254    20.73 MB/sec  execute 355 sec   
  30     44585    20.85 MB/sec  execute 356 sec   
  30     44944    20.94 MB/sec  execute 357 sec   
  30     45246    21.01 MB/sec  execute 358 sec   
  30     45453    21.06 MB/sec  execute 359 sec   
  30     45662    21.12 MB/sec  execute 360 sec   
  30     45873    21.15 MB/sec  execute 361 sec   
  30     46057    21.18 MB/sec  execute 362 sec   
  30     46289    21.20 MB/sec  execute 363 sec   
  30     46469    21.22 MB/sec  execute 364 sec   
  30     46611    21.24 MB/sec  execute 365 sec   
  30     46719    21.25 MB/sec  execute 366 sec   
  30     46869    21.22 MB/sec  execute 367 sec   
  30     46898    21.17 MB/sec  execute 368 sec   
  30     46930    21.12 MB/sec  execute 369 sec   
  30     46960    21.08 MB/sec  execute 370 sec   
  30     47021    21.06 MB/sec  execute 371 sec   
  30     47043    21.01 MB/sec  execute 372 sec   
  30     47166    21.00 MB/sec  execute 373 sec   
  30     47219    20.97 MB/sec  execute 374 sec   
  30     47219    20.91 MB/sec  execute 375 sec   
  30     47219    20.86 MB/sec  execute 376 sec   
  30     47219    20.80 MB/sec  execute 377 sec   
  30     47219    20.75 MB/sec  execute 378 sec   
  30     47219    20.69 MB/sec  execute 379 sec   
  30     47219    20.64 MB/sec  execute 380 sec   
  30     47245    20.60 MB/sec  execute 381 sec   
  30     47296    20.56 MB/sec  execute 382 sec   
  30     47461    20.57 MB/sec  execute 383 sec   
  30     47678    20.61 MB/sec  execute 384 sec   
  30     48044    20.71 MB/sec  execute 385 sec   
  30     48370    20.82 MB/sec  execute 386 sec   
  30     48993    20.63 MB/sec  execute 395 sec   
  30     49009    20.58 MB/sec  execute 396 sec   
  30     49075    20.55 MB/sec  execute 397 sec   
  30     49075    20.50 MB/sec  execute 398 sec   
  30     49075    20.45 MB/sec  execute 399 sec   
  30     49075    20.40 MB/sec  execute 400 sec   
  30     49075    20.35 MB/sec  execute 401 sec   
  30     49075    20.30 MB/sec  execute 402 sec   
  30     49274    20.33 MB/sec  execute 403 sec   
  30     49623    20.43 MB/sec  execute 404 sec   
  30     49993    20.51 MB/sec  execute 405 sec   
  30     50324    20.62 MB/sec  execute 406 sec   
  30     50700    20.69 MB/sec  execute 407 sec   
  30     50845    20.70 MB/sec  execute 408 sec   
  30     52557    20.77 MB/sec  execute 420 sec   
  30     52924    20.85 MB/sec  execute 421 sec   
  30     53287    20.94 MB/sec  execute 422 sec   
  30     53631    21.02 MB/sec  execute 423 sec   
  30     53997    21.12 MB/sec  execute 424 sec   
  30     54316    21.19 MB/sec  execute 425 sec   
  30     54659    21.27 MB/sec  execute 426 sec   
  30     54845    21.31 MB/sec  execute 427 sec   
  30     55031    21.32 MB/sec  execute 428 sec   
  30     55175    21.33 MB/sec  execute 429 sec   
  30     55317    21.34 MB/sec  execute 430 sec   
  30     55437    21.33 MB/sec  execute 431 sec   
  30     55518    21.30 MB/sec  execute 432 sec   
  30     55518    21.26 MB/sec  execute 433 sec   
  30     55633    21.25 MB/sec  execute 434 sec   
  30     55734    21.24 MB/sec  execute 435 sec   
  30     55757    21.20 MB/sec  execute 436 sec   
  30     55780    21.16 MB/sec  execute 437 sec   
  30     55862    21.14 MB/sec  execute 438 sec   
  30     56199    21.22 MB/sec  execute 439 sec   
  30     56559    21.30 MB/sec  execute 440 sec   
  30     56920    21.39 MB/sec  execute 441 sec   
  30     57279    21.47 MB/sec  execute 442 sec   
  30     57642    21.55 MB/sec  execute 443 sec   
  30     58017    21.63 MB/sec  execute 444 sec   
  30     58374    21.72 MB/sec  execute 445 sec   
  30     58736    21.78 MB/sec  execute 446 sec   
  30     59070    21.86 MB/sec  execute 447 sec   
  30     59434    21.95 MB/sec  execute 448 sec   
  30     59619    21.98 MB/sec  execute 449 sec   
  30     59654    21.94 MB/sec  execute 450 sec   
  30     59983    22.05 MB/sec  execute 451 sec   
  30     60218    22.08 MB/sec  execute 452 sec   
  30     60495    22.13 MB/sec  execute 453 sec   
  30     60506    22.08 MB/sec  execute 454 sec   
  30     60584    22.06 MB/sec  execute 455 sec   
  30     60662    22.03 MB/sec  execute 456 sec   
  30     60854    22.02 MB/sec  execute 457 sec   
  30     61212    22.09 MB/sec  execute 458 sec   
  30     61523    22.16 MB/sec  execute 459 sec   
  30     61533    22.11 MB/sec  execute 460 sec   
  30     61536    22.06 MB/sec  execute 461 sec   
  30     61537    22.01 MB/sec  execute 462 sec   
  30     61538    21.97 MB/sec  execute 463 sec   
  30     61550    21.93 MB/sec  execute 464 sec   
  30     61550    21.88 MB/sec  execute 465 sec   
  30     61555    21.84 MB/sec  execute 466 sec   
  30     61555    21.79 MB/sec  execute 467 sec   
  30     61555    21.74 MB/sec  execute 468 sec   
  30     61556    21.70 MB/sec  execute 469 sec   
  30     61663    21.69 MB/sec  execute 470 sec   
  30     62013    21.76 MB/sec  execute 471 sec   
  30     62299    21.87 MB/sec  execute 472 sec   
  30     62632    21.95 MB/sec  execute 473 sec   
  30     62971    22.00 MB/sec  execute 474 sec   
  30     63260    22.05 MB/sec  execute 475 sec   
  30     63646    21.86 MB/sec  execute 480 sec   
  30     63711    21.83 MB/sec  execute 481 sec   
  30     63711    21.79 MB/sec  execute 482 sec   
  30     63825    21.78 MB/sec  execute 483 sec   
  30     64186    21.86 MB/sec  execute 484 sec   
  30     64537    21.93 MB/sec  execute 485 sec   
  30     64897    22.00 MB/sec  execute 486 sec   
  30     65243    22.09 MB/sec  execute 487 sec   
  30     65600    22.15 MB/sec  execute 488 sec   
  30     65961    22.23 MB/sec  execute 489 sec   
  30     66314    22.30 MB/sec  execute 490 sec   
  30     66410    22.29 MB/sec  execute 491 sec   
  30     66662    22.32 MB/sec  execute 492 sec   
  30     66870    22.35 MB/sec  execute 493 sec   
  30     67106    22.39 MB/sec  execute 494 sec   
  30     67305    22.40 MB/sec  execute 495 sec   
  30     67475    22.41 MB/sec  execute 496 sec   
  30     67482    22.37 MB/sec  execute 497 sec   
  30     67520    22.33 MB/sec  execute 498 sec   
  30     67530    22.29 MB/sec  execute 499 sec   
  30     67623    22.27 MB/sec  execute 500 sec   
  30     67679    22.24 MB/sec  execute 501 sec   
  30     67768    22.22 MB/sec  execute 502 sec   
  30     68060    22.28 MB/sec  execute 503 sec   
  30     68262    22.31 MB/sec  execute 504 sec   
  30     68335    22.28 MB/sec  execute 505 sec   
  30     68346    22.24 MB/sec  execute 506 sec   
  30     68395    22.21 MB/sec  execute 507 sec   
  30     68438    22.18 MB/sec  execute 508 sec   
  30     68440    22.14 MB/sec  execute 509 sec   
  30     68600    22.15 MB/sec  execute 510 sec   
  30     68952    22.22 MB/sec  execute 511 sec   
  30     69262    22.27 MB/sec  execute 512 sec   
  30     69504    22.31 MB/sec  execute 513 sec   
  30     69774    22.35 MB/sec  execute 514 sec   
  30     70182    22.41 MB/sec  execute 515 sec   
  30     70510    22.50 MB/sec  execute 516 sec   
  30     70834    22.58 MB/sec  execute 517 sec   
  30     71147    22.64 MB/sec  execute 518 sec   
  30     71177    22.61 MB/sec  execute 519 sec   
  30     71337    22.61 MB/sec  execute 520 sec   
  30     71354    22.57 MB/sec  execute 521 sec   
  30     71354    22.53 MB/sec  execute 522 sec   
  30     71372    22.49 MB/sec  execute 523 sec   
  30     71372    22.44 MB/sec  execute 524 sec   
  30     71483    22.44 MB/sec  execute 525 sec   
  30     71641    22.44 MB/sec  execute 526 sec   
  30     71823    22.46 MB/sec  execute 527 sec   
  30     72045    22.47 MB/sec  execute 528 sec   
  30     72211    22.48 MB/sec  execute 529 sec   
  30     72417    22.50 MB/sec  execute 530 sec   
  30     72778    22.57 MB/sec  execute 531 sec   
  30     73142    22.64 MB/sec  execute 532 sec   
  30     73511    22.70 MB/sec  execute 533 sec   
  30     73572    22.67 MB/sec  execute 534 sec   
  30     73671    22.66 MB/sec  execute 535 sec   
  30     73909    22.63 MB/sec  execute 538 sec   
  30     74121    22.68 MB/sec  execute 539 sec   
  30     74351    22.72 MB/sec  execute 540 sec   
  30     74443    22.69 MB/sec  execute 541 sec   
  30     74453    22.65 MB/sec  execute 542 sec   
  30     74532    22.62 MB/sec  execute 543 sec   
  30     74612    22.60 MB/sec  execute 544 sec   
  30     74721    22.50 MB/sec  execute 547 sec   
  30     74721    22.46 MB/sec  execute 548 sec   
  30     74735    22.42 MB/sec  execute 549 sec   
  30     74735    22.38 MB/sec  execute 550 sec   
  30     74750    22.34 MB/sec  execute 551 sec   
  30     74903    22.34 MB/sec  execute 552 sec   
  30     75279    22.41 MB/sec  execute 553 sec   
  30     75573    22.46 MB/sec  execute 554 sec   
  30     75873    22.50 MB/sec  execute 555 sec   
  30     76203    22.57 MB/sec  execute 556 sec   
  30     76562    22.64 MB/sec  execute 557 sec   
  30     76899    22.68 MB/sec  execute 558 sec   
  30     77253    22.74 MB/sec  execute 559 sec   
  30     77614    22.80 MB/sec  execute 560 sec   
  30     77942    22.87 MB/sec  execute 561 sec   
  30     78282    22.94 MB/sec  execute 562 sec   
  30     78566    22.99 MB/sec  execute 563 sec   
  30     78917    23.05 MB/sec  execute 564 sec   
  30     79191    23.08 MB/sec  execute 565 sec   
  30     79232    23.04 MB/sec  execute 566 sec   
  30     79232    23.00 MB/sec  execute 567 sec   
  30     79239    22.96 MB/sec  execute 568 sec   
  30     79239    22.92 MB/sec  execute 569 sec   
  30     79593    22.97 MB/sec  execute 570 sec   
  30     79954    23.03 MB/sec  execute 571 sec   
  30     80319    23.10 MB/sec  execute 572 sec   
  30     80680    23.16 MB/sec  execute 573 sec   
  30     81044    23.22 MB/sec  execute 574 sec   
  30     81404    23.28 MB/sec  execute 575 sec   
  30     81765    23.34 MB/sec  execute 576 sec   
  30     82122    23.41 MB/sec  execute 577 sec   
  30     82226    23.37 MB/sec  execute 578 sec   
  30     82226    23.33 MB/sec  execute 579 sec   
  30     82226    23.29 MB/sec  execute 580 sec   
  30     82226    23.25 MB/sec  execute 581 sec   
  30     82226    23.21 MB/sec  execute 582 sec   
  30     82226    23.17 MB/sec  execute 583 sec   
  30     82226    23.13 MB/sec  execute 584 sec   
  30     82226    23.09 MB/sec  execute 585 sec   
  30     82226    23.05 MB/sec  execute 586 sec   
  30     82226    23.01 MB/sec  execute 587 sec   
  30     82325    23.00 MB/sec  execute 588 sec   
  30     82358    22.96 MB/sec  execute 589 sec   
  30     82395    22.93 MB/sec  execute 590 sec   
  30     82485    22.91 MB/sec  execute 591 sec   
  30     82495    22.88 MB/sec  execute 592 sec   
  30     82682    22.89 MB/sec  execute 593 sec   
  30     83043    22.95 MB/sec  execute 594 sec   
  30     83407    23.00 MB/sec  execute 595 sec   
  30     83772    23.06 MB/sec  execute 596 sec   
  30     84137    23.12 MB/sec  execute 597 sec   
  30     84392    23.15 MB/sec  execute 598 sec   
  30     84523    23.16 MB/sec  execute 599 sec   
  30     84692    23.16 MB/sec  cleanup 600 sec   
  30     84692    23.12 MB/sec  cleanup 601 sec   
  30     84692    23.08 MB/sec  cleanup 602 sec   
  30     84692    23.05 MB/sec  cleanup 603 sec   
  30     84692    23.01 MB/sec  cleanup 604 sec   
  30     84692    22.97 MB/sec  cleanup 605 sec   
  30     84692    22.93 MB/sec  cleanup 606 sec   
  30     84692    22.87 MB/sec  cleanup 608 sec   
  30     84692    22.83 MB/sec  cleanup 609 sec   
  30     84692    22.79 MB/sec  cleanup 610 sec   
  30     84692    22.76 MB/sec  cleanup 611 sec   
  30     84692    22.72 MB/sec  cleanup 612 sec   
  30     84692    22.68 MB/sec  cleanup 613 sec   
  30     84692    22.64 MB/sec  cleanup 614 sec   
  30     84692    22.61 MB/sec  cleanup 615 sec   
  30     84692    22.57 MB/sec  cleanup 616 sec   
  30     84692    22.53 MB/sec  cleanup 617 sec   
  30     84692    22.50 MB/sec  cleanup 618 sec   
  30     84692    22.46 MB/sec  cleanup 619 sec   
  30     84692    22.44 MB/sec  cleanup 620 sec   

Throughput 23.1628 MB/sec 30 procs

--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="bdi-writeback-hda3.log"

dbench version 3.04 - Copyright Andrew Tridgell 1999-2004

Running for 600 seconds with load '/usr/share/dbench/client.txt' and minimum warmup 120 secs
30 clients started
  30        13     0.00 MB/sec  warmup   1 sec   
  30        14     0.00 MB/sec  warmup   2 sec   
  30        14     0.00 MB/sec  warmup   3 sec   
  30        14     0.00 MB/sec  warmup   4 sec   
  30        20     2.14 MB/sec  warmup   5 sec   
  30        26     3.29 MB/sec  warmup   6 sec   
  30        30     3.86 MB/sec  warmup   7 sec   
  30        34     4.19 MB/sec  warmup   8 sec   
  30        35     3.93 MB/sec  warmup   9 sec   
  30        44     4.58 MB/sec  warmup  10 sec   
  30        49     4.88 MB/sec  warmup  11 sec   
  30        52     4.88 MB/sec  warmup  12 sec   
  30        60     5.19 MB/sec  warmup  13 sec   
  30        68     5.65 MB/sec  warmup  14 sec   
  30        68     5.28 MB/sec  warmup  15 sec   
  30        83     5.94 MB/sec  warmup  16 sec   
  30        92     6.43 MB/sec  warmup  17 sec   
  30        96     6.35 MB/sec  warmup  18 sec   
  30       101     6.29 MB/sec  warmup  19 sec   
  30       112     6.62 MB/sec  warmup  20 sec   
  30       116     6.60 MB/sec  warmup  21 sec   
  30       123     6.69 MB/sec  warmup  22 sec   
  30       123     6.41 MB/sec  warmup  23 sec   
  30       142     6.92 MB/sec  warmup  24 sec   
  30       149     7.02 MB/sec  warmup  25 sec   
  30       158     7.13 MB/sec  warmup  26 sec   
  30       169     7.29 MB/sec  warmup  27 sec   
  30       177     7.33 MB/sec  warmup  28 sec   
  30       190     7.51 MB/sec  warmup  29 sec   
  30       225     7.94 MB/sec  warmup  32 sec   
  30       237     8.04 MB/sec  warmup  33 sec   
  30       250     8.16 MB/sec  warmup  34 sec   
  30       254     8.04 MB/sec  warmup  35 sec   
  30       269     8.25 MB/sec  warmup  36 sec   
  30       275     8.24 MB/sec  warmup  37 sec   
  30       288     8.35 MB/sec  warmup  38 sec   
  30       301     8.45 MB/sec  warmup  39 sec   
  30       315     8.55 MB/sec  warmup  40 sec   
  30       339     8.58 MB/sec  warmup  41 sec   
  30       347     8.57 MB/sec  warmup  42 sec   
  30       356     8.57 MB/sec  warmup  43 sec   
  30       374     8.62 MB/sec  warmup  44 sec   
  30       535     9.14 MB/sec  warmup  45 sec   
  30       606     9.09 MB/sec  warmup  46 sec   
  30       631     8.68 MB/sec  warmup  51 sec   
  30       631     8.52 MB/sec  warmup  52 sec   
  30       671     8.56 MB/sec  warmup  53 sec   
  30       949     9.24 MB/sec  warmup  54 sec   
  30      1102     9.86 MB/sec  warmup  55 sec   
  30      1196     9.99 MB/sec  warmup  56 sec   
  30      1339    10.34 MB/sec  warmup  57 sec   
  30      1460    10.46 MB/sec  warmup  58 sec   
  30      1544    10.67 MB/sec  warmup  59 sec   
  30      1593    10.76 MB/sec  warmup  60 sec   
  30      1621    10.73 MB/sec  warmup  61 sec   
  30      1644    10.73 MB/sec  warmup  62 sec   
  30      1661    10.79 MB/sec  warmup  63 sec   
  30      1689    10.85 MB/sec  warmup  64 sec   
  30      1740    10.46 MB/sec  warmup  68 sec   
  30      1761    10.36 MB/sec  warmup  69 sec   
  30      1817    10.44 MB/sec  warmup  70 sec   
  30      2138    10.95 MB/sec  warmup  71 sec   
  30      2446    11.50 MB/sec  warmup  72 sec   
  30      2532    11.76 MB/sec  warmup  73 sec   
  30      2538    11.69 MB/sec  warmup  74 sec   
  30      2572    11.58 MB/sec  warmup  75 sec   
  30      2731    11.87 MB/sec  warmup  76 sec   
  30      3047    12.36 MB/sec  warmup  77 sec   
  30      3104    12.33 MB/sec  warmup  78 sec   
  30      3107    12.15 MB/sec  warmup  79 sec   
  30      3124    12.01 MB/sec  warmup  80 sec   
  30      3143    11.96 MB/sec  warmup  81 sec   
  30      3231    11.82 MB/sec  warmup  84 sec   
  30      3231    11.69 MB/sec  warmup  85 sec   
  30      3231    11.55 MB/sec  warmup  86 sec   
  30      3231    11.42 MB/sec  warmup  87 sec   
  30      3231    11.29 MB/sec  warmup  88 sec   
  30      3428    11.29 MB/sec  warmup  92 sec   
  30      3663    11.70 MB/sec  warmup  93 sec   
  30      3785    11.85 MB/sec  warmup  94 sec   
  30      3923    11.94 MB/sec  warmup  95 sec   
  30      3937    11.86 MB/sec  warmup  96 sec   
  30      3980    11.78 MB/sec  warmup  97 sec   
  30      4298    12.17 MB/sec  warmup  98 sec   
  30      4616    12.59 MB/sec  warmup  99 sec   
  30      4905    12.95 MB/sec  warmup 100 sec   
  30      5228    13.32 MB/sec  warmup 101 sec   
  30      5513    13.58 MB/sec  warmup 102 sec   
  30      5826    13.97 MB/sec  warmup 103 sec   
  30      6116    14.29 MB/sec  warmup 104 sec   
  30      6409    14.58 MB/sec  warmup 105 sec   
  30      6674    14.89 MB/sec  warmup 106 sec   
  30      6913    15.14 MB/sec  warmup 107 sec   
  30      7043    15.19 MB/sec  warmup 108 sec   
  30      7052    15.05 MB/sec  warmup 109 sec   
  30      7052    14.91 MB/sec  warmup 110 sec   
  30      7052    14.78 MB/sec  warmup 111 sec   
  30      7052    14.65 MB/sec  warmup 112 sec   
  30      7155    13.85 MB/sec  warmup 120 sec   
  30      7658    49.68 MB/sec  execute   1 sec   
  30      7972    51.10 MB/sec  execute   2 sec   
  30      8295    51.55 MB/sec  execute   3 sec   
  30      8611    51.36 MB/sec  execute   4 sec   
  30      8916    51.52 MB/sec  execute   5 sec   
  30      9246    51.10 MB/sec  execute   6 sec   
  30      9544    51.43 MB/sec  execute   7 sec   
  30      9848    50.67 MB/sec  execute   8 sec   
  30     10068    49.09 MB/sec  execute   9 sec   
  30     10386    46.18 MB/sec  execute  11 sec   
  30     10695    47.04 MB/sec  execute  12 sec   
  30     10875    45.13 MB/sec  execute  13 sec   
  30     11177    45.71 MB/sec  execute  14 sec   
  30     11484    46.09 MB/sec  execute  15 sec   
  30     11807    46.10 MB/sec  execute  16 sec   
  30     12103    46.36 MB/sec  execute  17 sec   
  30     12405    46.66 MB/sec  execute  18 sec   
  30     12735    46.73 MB/sec  execute  19 sec   
  30     13569    46.71 MB/sec  execute  22 sec   
  30     13878    47.14 MB/sec  execute  23 sec   
  30     14149    47.36 MB/sec  execute  24 sec   
  30     14442    47.34 MB/sec  execute  25 sec   
  30     14759    47.20 MB/sec  execute  26 sec   
  30     14961    46.57 MB/sec  execute  27 sec   
  30     15008    43.28 MB/sec  execute  29 sec   
  30     15234    33.64 MB/sec  execute  38 sec   
  30     15234    32.77 MB/sec  execute  39 sec   
  30     15395    26.75 MB/sec  execute  49 sec   
  30     15421    26.24 MB/sec  execute  50 sec   
  30     15421    25.73 MB/sec  execute  51 sec   
  30     15559    22.94 MB/sec  execute  58 sec   
  30     15578    22.63 MB/sec  execute  59 sec   
  30     15665    22.51 MB/sec  execute  60 sec   
  30     15833    22.59 MB/sec  execute  61 sec   
  30     15833    22.22 MB/sec  execute  62 sec   
  30     15833    21.87 MB/sec  execute  63 sec   
  30     15920    19.76 MB/sec  execute  71 sec   
  30     15923    19.49 MB/sec  execute  72 sec   
  30     16229    19.88 MB/sec  execute  73 sec   
  30     16549    20.32 MB/sec  execute  74 sec   
  30     16806    20.58 MB/sec  execute  75 sec   
  30     16935    20.60 MB/sec  execute  76 sec   
  30     16942    20.34 MB/sec  execute  77 sec   
  30     17042    20.27 MB/sec  execute  78 sec   
  30     17125    20.14 MB/sec  execute  79 sec   
  30     17160    19.95 MB/sec  execute  80 sec   
  30     17201    19.81 MB/sec  execute  81 sec   
  30     17201    19.57 MB/sec  execute  82 sec   
  30     17212    19.35 MB/sec  execute  83 sec   
  30     17228    19.14 MB/sec  execute  84 sec   
  30     17376    19.22 MB/sec  execute  85 sec   
  30     17412    19.06 MB/sec  execute  86 sec   
  30     17624    17.30 MB/sec  execute  97 sec   
  30     17734    17.33 MB/sec  execute  98 sec   
  30     17817    17.32 MB/sec  execute  99 sec   
  30     17872    17.24 MB/sec  execute 100 sec   
  30     17912    17.09 MB/sec  execute 101 sec   
  30     17920    16.94 MB/sec  execute 102 sec   
  30     17922    16.76 MB/sec  execute 103 sec   
  30     18159    16.94 MB/sec  execute 104 sec   
  30     18298    16.98 MB/sec  execute 105 sec   
  30     18405    16.98 MB/sec  execute 106 sec   
  30     18512    17.00 MB/sec  execute 107 sec   
  30     18618    17.00 MB/sec  execute 108 sec   
  30     18715    16.98 MB/sec  execute 109 sec   
  30     18758    15.53 MB/sec  execute 119 sec   
  30     18758    14.94 MB/sec  execute 124 sec   
  30     18758    14.82 MB/sec  execute 125 sec   
  30     18758    14.70 MB/sec  execute 126 sec   
  30     18851    14.78 MB/sec  execute 127 sec   
  30     19019    14.87 MB/sec  execute 128 sec   
  30     19143    14.93 MB/sec  execute 129 sec   
  30     19301    15.00 MB/sec  execute 130 sec   
  30     19458    15.02 MB/sec  execute 131 sec   
  30     19636    15.10 MB/sec  execute 132 sec   
  30     19814    15.25 MB/sec  execute 133 sec   
  30     20000    15.36 MB/sec  execute 134 sec   
  30     20210    15.49 MB/sec  execute 135 sec   
  30     20419    15.64 MB/sec  execute 136 sec   
  30     20664    15.81 MB/sec  execute 137 sec   
  30     20910    15.95 MB/sec  execute 138 sec   
  30     21142    16.11 MB/sec  execute 139 sec   
  30     21377    16.29 MB/sec  execute 140 sec   
  30     21487    16.28 MB/sec  execute 141 sec   
  30     21516    16.20 MB/sec  execute 142 sec   
  30     21566    16.14 MB/sec  execute 143 sec   
  30     21752    16.24 MB/sec  execute 144 sec   
  30     22045    16.45 MB/sec  execute 145 sec   
  30     22285    15.60 MB/sec  execute 155 sec   
  30     22506    15.74 MB/sec  execute 156 sec   
  30     22740    15.79 MB/sec  execute 157 sec   
  30     22761    15.71 MB/sec  execute 158 sec   
  30     22761    15.61 MB/sec  execute 159 sec   
  30     22807    15.57 MB/sec  execute 160 sec   
  30     22854    15.56 MB/sec  execute 161 sec   
  30     24444    15.92 MB/sec  execute 174 sec   
  30     24744    16.05 MB/sec  execute 175 sec   
  30     25033    16.29 MB/sec  execute 176 sec   
  30     25233    16.37 MB/sec  execute 177 sec   
  30     25413    15.58 MB/sec  execute 188 sec   
  30     25413    15.50 MB/sec  execute 189 sec   
  30     25510    15.50 MB/sec  execute 190 sec   
  30     25575    15.46 MB/sec  execute 191 sec   
  30     25780    15.58 MB/sec  execute 192 sec   
  30     26020    15.66 MB/sec  execute 193 sec   
  30     26228    15.77 MB/sec  execute 194 sec   
  30     26496    15.89 MB/sec  execute 195 sec   
  30     26758    16.04 MB/sec  execute 196 sec   
  30     26976    16.16 MB/sec  execute 197 sec   
  30     27206    16.25 MB/sec  execute 198 sec   
  30     27417    16.35 MB/sec  execute 199 sec   
  30     27651    16.42 MB/sec  execute 200 sec   
  30     27875    16.53 MB/sec  execute 201 sec   
  30     28118    16.68 MB/sec  execute 202 sec   
  30     28283    16.71 MB/sec  execute 203 sec   
  30     28285    16.63 MB/sec  execute 204 sec   
  30     28299    16.55 MB/sec  execute 205 sec   
  30     28381    16.53 MB/sec  execute 206 sec   
  30     28429    16.49 MB/sec  execute 207 sec   
  30     28484    16.46 MB/sec  execute 208 sec   
  30     28563    16.45 MB/sec  execute 209 sec   
  30     28563    16.38 MB/sec  execute 210 sec   
  30     28563    16.30 MB/sec  execute 211 sec   
  30     28710    15.47 MB/sec  execute 224 sec   
  30     28740    15.42 MB/sec  execute 225 sec   
  30     28756    15.37 MB/sec  execute 226 sec   
  30     28808    15.33 MB/sec  execute 227 sec   
  30     28993    15.36 MB/sec  execute 228 sec   
  30     28993    15.29 MB/sec  execute 229 sec   
  30     29136    15.32 MB/sec  execute 230 sec   
  30     29136    15.26 MB/sec  execute 231 sec   
  30     29136    15.19 MB/sec  execute 232 sec   
  30     29136    15.12 MB/sec  execute 233 sec   
  30     29136    15.06 MB/sec  execute 234 sec   
  30     29136    15.00 MB/sec  execute 235 sec   
  30     29273    14.34 MB/sec  execute 248 sec   
  30     29292    14.31 MB/sec  execute 249 sec   
  30     29295    14.25 MB/sec  execute 250 sec   
  30     29327    14.21 MB/sec  execute 251 sec   
  30     29568    14.31 MB/sec  execute 252 sec   
  30     29837    14.43 MB/sec  execute 253 sec   
  30     30141    14.56 MB/sec  execute 254 sec   
  30     30309    14.62 MB/sec  execute 255 sec   
  30     30346    14.58 MB/sec  execute 256 sec   
  30     30347    14.51 MB/sec  execute 257 sec   
  30     30349    14.45 MB/sec  execute 258 sec   
  30     30423    14.46 MB/sec  execute 259 sec   
  30     30542    14.49 MB/sec  execute 260 sec   
  30     30656    14.51 MB/sec  execute 261 sec   
  30     30845    14.53 MB/sec  execute 262 sec   
  30     31008    14.60 MB/sec  execute 263 sec   
  30     31127    14.62 MB/sec  execute 264 sec   
  30     31170    14.58 MB/sec  execute 265 sec   
  30     31386    14.24 MB/sec  execute 274 sec   
  30     31521    14.27 MB/sec  execute 275 sec   
  30     31680    14.32 MB/sec  execute 276 sec   
  30     31895    14.38 MB/sec  execute 277 sec   
  30     32031    14.40 MB/sec  execute 278 sec   
  30     32168    14.40 MB/sec  execute 279 sec   
  30     32414    14.51 MB/sec  execute 280 sec   
  30     32667    14.59 MB/sec  execute 281 sec   
  30     32945    14.69 MB/sec  execute 282 sec   
  30     33242    14.81 MB/sec  execute 283 sec   
  30     33536    14.92 MB/sec  execute 284 sec   
  30     33735    15.00 MB/sec  execute 285 sec   
  30     33965    15.07 MB/sec  execute 286 sec   
  30     34200    15.13 MB/sec  execute 287 sec   
  30     34455    15.21 MB/sec  execute 288 sec   
  30     34524    15.20 MB/sec  execute 289 sec   
  30     34528    15.15 MB/sec  execute 290 sec   
  30     34544    15.11 MB/sec  execute 291 sec   
  30     34632    15.09 MB/sec  execute 292 sec   
  30     34901    15.19 MB/sec  execute 293 sec   
  30     35218    15.32 MB/sec  execute 294 sec   
  30     35515    15.43 MB/sec  execute 295 sec   
  30     35825    15.54 MB/sec  execute 296 sec   
  30     36138    15.67 MB/sec  execute 297 sec   
  30     36433    15.78 MB/sec  execute 298 sec   
  30     36724    15.90 MB/sec  execute 299 sec   
  30     37025    16.01 MB/sec  execute 300 sec   
  30     37336    16.09 MB/sec  execute 301 sec   
  30     37372    16.05 MB/sec  execute 302 sec   
  30     37625    15.57 MB/sec  execute 314 sec   
  30     37637    15.52 MB/sec  execute 315 sec   
  30     37652    15.48 MB/sec  execute 316 sec   
  30     37654    15.43 MB/sec  execute 317 sec   
  30     37654    15.38 MB/sec  execute 318 sec   
  30     37654    15.33 MB/sec  execute 319 sec   
  30     37654    15.29 MB/sec  execute 320 sec   
  30     37654    15.24 MB/sec  execute 321 sec   
  30     37654    15.19 MB/sec  execute 322 sec   
  30     37654    15.14 MB/sec  execute 323 sec   
  30     37654    15.10 MB/sec  execute 324 sec   
  30     37654    15.05 MB/sec  execute 325 sec   
  30     37654    15.00 MB/sec  execute 326 sec   
  30     37654    14.95 MB/sec  execute 327 sec   
  30     37691    14.92 MB/sec  execute 328 sec   
  30     37779    14.94 MB/sec  execute 329 sec   
  30     37963    14.99 MB/sec  execute 330 sec   
  30     38159    15.05 MB/sec  execute 331 sec   
  30     38352    15.11 MB/sec  execute 332 sec   
  30     38549    15.18 MB/sec  execute 333 sec   
  30     38733    15.20 MB/sec  execute 334 sec   
  30     38873    15.21 MB/sec  execute 335 sec   
  30     39050    15.25 MB/sec  execute 336 sec   
  30     39197    15.28 MB/sec  execute 337 sec   
  30     39289    15.27 MB/sec  execute 338 sec   
  30     39297    15.23 MB/sec  execute 339 sec   
  30     39554    15.25 MB/sec  execute 342 sec   
  30     39584    15.21 MB/sec  execute 343 sec   
  30     39587    15.16 MB/sec  execute 344 sec   
  30     39587    15.12 MB/sec  execute 345 sec   
  30     39587    15.08 MB/sec  execute 346 sec   
  30     39587    15.03 MB/sec  execute 347 sec   
  30     39587    14.99 MB/sec  execute 348 sec   
  30     39587    14.95 MB/sec  execute 349 sec   
  30     39696    14.67 MB/sec  execute 358 sec   
  30     39801    14.68 MB/sec  execute 359 sec   
  30     39927    14.71 MB/sec  execute 360 sec   
  30     40050    14.71 MB/sec  execute 361 sec   
  30     40162    14.72 MB/sec  execute 362 sec   
  30     40289    14.73 MB/sec  execute 363 sec   
  30     40451    14.78 MB/sec  execute 364 sec   
  30     40666    14.81 MB/sec  execute 365 sec   
  30     40864    14.86 MB/sec  execute 366 sec   
  30     41030    14.89 MB/sec  execute 367 sec   
  30     41073    14.86 MB/sec  execute 368 sec   
  30     41095    14.83 MB/sec  execute 369 sec   
  30     41107    14.79 MB/sec  execute 370 sec   
  30     41107    14.75 MB/sec  execute 371 sec   
  30     41107    14.71 MB/sec  execute 372 sec   
  30     41107    14.67 MB/sec  execute 373 sec   
  30     41107    14.64 MB/sec  execute 374 sec   
  30     41107    14.60 MB/sec  execute 375 sec   
  30     41107    14.56 MB/sec  execute 376 sec   
  30     41107    14.52 MB/sec  execute 377 sec   
  30     41107    14.48 MB/sec  execute 378 sec   
  30     41107    14.44 MB/sec  execute 379 sec   
  30     41107    14.40 MB/sec  execute 380 sec   
  30     41232    14.19 MB/sec  execute 388 sec   
  30     41458    14.10 MB/sec  execute 392 sec   
  30     41549    14.10 MB/sec  execute 393 sec   
  30     41549    14.06 MB/sec  execute 394 sec   
  30     41549    14.03 MB/sec  execute 395 sec   
  30     41549    13.99 MB/sec  execute 396 sec   
  30     41549    13.96 MB/sec  execute 397 sec   
  30     42290    13.74 MB/sec  execute 412 sec   
  30     42290    13.71 MB/sec  execute 413 sec   
  30     42290    13.67 MB/sec  execute 414 sec   
  30     42290    13.64 MB/sec  execute 415 sec   
  30     42290    13.61 MB/sec  execute 416 sec   
  30     42458    13.37 MB/sec  execute 426 sec   
  30     42607    13.39 MB/sec  execute 427 sec   
  30     42765    13.43 MB/sec  execute 428 sec   
  30     42961    13.45 MB/sec  execute 429 sec   
  30     43148    13.50 MB/sec  execute 430 sec   
  30     43339    13.55 MB/sec  execute 431 sec   
  30     43438    13.54 MB/sec  execute 432 sec   
  30     43451    13.51 MB/sec  execute 433 sec   
  30     43469    13.49 MB/sec  execute 434 sec   
  30     43532    13.48 MB/sec  execute 435 sec   
  30     43534    13.45 MB/sec  execute 436 sec   
  30     43534    13.42 MB/sec  execute 437 sec   
  30     43534    13.39 MB/sec  execute 438 sec   
  30     43534    13.36 MB/sec  execute 439 sec   
  30     43534    13.33 MB/sec  execute 440 sec   
  30     43653    13.03 MB/sec  execute 451 sec   
  30     43707    13.02 MB/sec  execute 452 sec   
  30     43727    13.01 MB/sec  execute 453 sec   
  30     43729    12.98 MB/sec  execute 454 sec   
  30     43756    12.96 MB/sec  execute 455 sec   
  30     43763    12.93 MB/sec  execute 456 sec   
  30     43789    12.92 MB/sec  execute 457 sec   
  30     43828    12.90 MB/sec  execute 458 sec   
  30     43875    12.89 MB/sec  execute 459 sec   
  30     43879    12.86 MB/sec  execute 460 sec   
  30     43879    12.84 MB/sec  execute 461 sec   
  30     43879    12.81 MB/sec  execute 462 sec   
  30     43879    12.78 MB/sec  execute 463 sec   
  30     43879    12.75 MB/sec  execute 464 sec   
  30     44099    12.54 MB/sec  execute 475 sec   
  30     44193    12.55 MB/sec  execute 476 sec   
  30     44252    12.55 MB/sec  execute 477 sec   
  30     44302    12.53 MB/sec  execute 478 sec   
  30     44313    12.51 MB/sec  execute 479 sec   
  30     44313    12.48 MB/sec  execute 480 sec   
  30     44313    12.45 MB/sec  execute 481 sec   
  30     44313    12.43 MB/sec  execute 482 sec   
  30     44511    12.29 MB/sec  execute 490 sec   
  30     44610    12.30 MB/sec  execute 491 sec   
  30     44691    12.30 MB/sec  execute 492 sec   
  30     44772    12.32 MB/sec  execute 493 sec   
  30     44921    12.34 MB/sec  execute 494 sec   
  30     45064    12.36 MB/sec  execute 495 sec   
  30     45169    12.36 MB/sec  execute 496 sec   
  30     45266    12.36 MB/sec  execute 497 sec   
  30     45377    12.37 MB/sec  execute 498 sec   
  30     45418    12.36 MB/sec  execute 499 sec   
  30     45419    12.33 MB/sec  execute 500 sec   
  30     45419    12.31 MB/sec  execute 501 sec   
  30     45479    12.30 MB/sec  execute 502 sec   
  30     45584    12.31 MB/sec  execute 503 sec   
  30     45584    12.28 MB/sec  execute 504 sec   
  30     45584    12.26 MB/sec  execute 505 sec   
  30     45584    12.23 MB/sec  execute 506 sec   
  30     45584    12.21 MB/sec  execute 507 sec   
  30     45584    12.19 MB/sec  execute 508 sec   
  30     45584    12.16 MB/sec  execute 509 sec   
  30     45584    12.14 MB/sec  execute 510 sec   
  30     45613    12.13 MB/sec  execute 511 sec   
  30     45756    11.96 MB/sec  execute 520 sec   
  30     45783    11.95 MB/sec  execute 521 sec   
  30     45795    11.93 MB/sec  execute 522 sec   
  30     45795    11.91 MB/sec  execute 523 sec   
  30     45814    11.89 MB/sec  execute 524 sec   
  30     45927    11.90 MB/sec  execute 525 sec   
  30     46076    11.93 MB/sec  execute 526 sec   
  30     46229    11.95 MB/sec  execute 527 sec   
  30     46367    11.97 MB/sec  execute 528 sec   
  30     46510    11.99 MB/sec  execute 529 sec   
  30     46531    11.98 MB/sec  execute 530 sec   
  30     46685    11.87 MB/sec  execute 537 sec   
  30     47084    11.79 MB/sec  execute 546 sec   
  30     47084    11.77 MB/sec  execute 547 sec   
  30     47084    11.75 MB/sec  execute 548 sec   
  30     47084    11.73 MB/sec  execute 549 sec   
  30     47084    11.71 MB/sec  execute 550 sec   
  30     47084    11.69 MB/sec  execute 551 sec   
  30     47108    11.67 MB/sec  execute 552 sec   
  30     47170    11.67 MB/sec  execute 553 sec   
  30     47258    11.47 MB/sec  execute 564 sec   
  30     47335    11.46 MB/sec  execute 565 sec   
  30     47346    11.44 MB/sec  execute 566 sec   
  30     47346    11.42 MB/sec  execute 567 sec   
  30     47346    11.40 MB/sec  execute 568 sec   
  30     47346    11.38 MB/sec  execute 569 sec   
  30     47346    11.36 MB/sec  execute 570 sec   
  30     47346    11.34 MB/sec  execute 571 sec   
  30     47527    11.27 MB/sec  execute 577 sec   
  30     47610    11.28 MB/sec  execute 578 sec   
  30     47658    11.29 MB/sec  execute 579 sec   
  30     47778    11.30 MB/sec  execute 580 sec   
  30     47912    11.32 MB/sec  execute 581 sec   
  30     48003    11.34 MB/sec  execute 582 sec   
  30     48125    11.36 MB/sec  execute 583 sec   
  30     48236    11.36 MB/sec  execute 584 sec   
  30     48445    11.38 MB/sec  execute 585 sec   
  30     48705    11.44 MB/sec  execute 586 sec   
  30     48750    11.43 MB/sec  execute 587 sec   
  30     48774    11.41 MB/sec  execute 588 sec   
  30     48817    11.40 MB/sec  execute 589 sec   
  30     48949    11.28 MB/sec  execute 597 sec   
  30     49124    11.31 MB/sec  execute 598 sec   
  30     49341    11.35 MB/sec  execute 599 sec   
  30     49649    11.41 MB/sec  cleanup 600 sec   
  30     49649    11.39 MB/sec  cleanup 601 sec   
  30     49649    11.37 MB/sec  cleanup 602 sec   
  30     49649    11.35 MB/sec  cleanup 603 sec   
  30     49649    11.33 MB/sec  cleanup 604 sec   
  30     49649    11.31 MB/sec  cleanup 605 sec   

Throughput 11.4073 MB/sec 30 procs

--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="pdflush-hda1.log"

dbench version 3.04 - Copyright Andrew Tridgell 1999-2004

Running for 600 seconds with load '/usr/share/dbench/client.txt' and minimum warmup 120 secs
30 clients started
  30        48    56.54 MB/sec  warmup   1 sec   
  30        48    28.00 MB/sec  warmup   2 sec   
  30        48    18.73 MB/sec  warmup   3 sec   
  30        48    14.07 MB/sec  warmup   4 sec   
  30        48    11.26 MB/sec  warmup   5 sec   
  30        48     9.39 MB/sec  warmup   6 sec   
  30        50     4.38 MB/sec  warmup  13 sec   
  30        50     2.57 MB/sec  warmup  23 sec   
  30        59     2.65 MB/sec  warmup  27 sec   
  30        59     2.56 MB/sec  warmup  28 sec   
  30        65     2.17 MB/sec  warmup  37 sec   
  30        68     2.06 MB/sec  warmup  42 sec   
  30        69     1.67 MB/sec  warmup  52 sec   
  30        72     1.52 MB/sec  warmup  60 sec   
  30        81     1.51 MB/sec  warmup  70 sec   
  30        86     1.48 MB/sec  warmup  76 sec   
  30       104     1.54 MB/sec  warmup  88 sec   
  30       121     1.71 MB/sec  warmup  89 sec   
  30       121     1.69 MB/sec  warmup  90 sec   
  30       125     1.72 MB/sec  warmup  91 sec   
  30       370     2.26 MB/sec  warmup  92 sec   
  30       681     2.90 MB/sec  warmup  93 sec   
  30       868     3.29 MB/sec  warmup  94 sec   
  30       879     3.38 MB/sec  warmup  95 sec   
  30       886     3.40 MB/sec  warmup  96 sec   
  30       902     3.41 MB/sec  warmup  97 sec   
  30       902     3.37 MB/sec  warmup  98 sec   
  30       902     3.34 MB/sec  warmup  99 sec   
  30       902     3.31 MB/sec  warmup 100 sec   
  30       902     3.27 MB/sec  warmup 101 sec   
  30       902     3.24 MB/sec  warmup 102 sec   
  30       961     3.67 MB/sec  warmup 103 sec   
  30       983     3.72 MB/sec  warmup 104 sec   
  30       983     3.69 MB/sec  warmup 105 sec   
  30       983     3.65 MB/sec  warmup 106 sec   
  30       983     3.62 MB/sec  warmup 107 sec   
  30       983     3.59 MB/sec  warmup 108 sec   
  30       990     3.61 MB/sec  warmup 109 sec   
  30      1073     3.95 MB/sec  warmup 110 sec   
  30      1078     3.95 MB/sec  warmup 111 sec   
  30      1078     3.91 MB/sec  warmup 112 sec   
  30      1078     3.88 MB/sec  warmup 113 sec   
  30      1078     3.84 MB/sec  warmup 114 sec   
  30      1078     3.81 MB/sec  warmup 115 sec   
  30      1078     3.78 MB/sec  warmup 116 sec   
  30      1079     3.77 MB/sec  warmup 117 sec   
  30      1079     3.74 MB/sec  warmup 118 sec   
  30      1079     3.71 MB/sec  warmup 119 sec   
  30      1079     0.00 MB/sec  execute   1 sec   
  30      1089     4.10 MB/sec  execute   2 sec   
  30      1099     5.52 MB/sec  execute   3 sec   
  30      1107     6.18 MB/sec  execute   4 sec   
  30      1148     7.56 MB/sec  execute   5 sec   
  30      1151     6.70 MB/sec  execute   6 sec   
  30      1151     5.74 MB/sec  execute   7 sec   
  30      1151     5.02 MB/sec  execute   8 sec   
  30      1151     4.46 MB/sec  execute   9 sec   
  30      1151     4.02 MB/sec  execute  10 sec   
  30      1151     3.66 MB/sec  execute  11 sec   
  30      1164     3.91 MB/sec  execute  12 sec   
  30      1172     4.23 MB/sec  execute  13 sec   
  30      1305     7.88 MB/sec  execute  15 sec   
  30      1324     7.53 MB/sec  execute  16 sec   
  30      1428     7.96 MB/sec  execute  17 sec   
  30      1793    10.90 MB/sec  execute  18 sec   
  30      2150    13.32 MB/sec  execute  19 sec   
  30      2514    15.80 MB/sec  execute  20 sec   
  30      2891    17.63 MB/sec  execute  21 sec   
  30      3109    18.79 MB/sec  execute  22 sec   
  30      3173    19.45 MB/sec  execute  23 sec   
  30      3392    20.10 MB/sec  execute  24 sec   
  30      3435    19.51 MB/sec  execute  25 sec   
  30      3435    18.76 MB/sec  execute  26 sec   
  30      3537    18.72 MB/sec  execute  27 sec   
  30      3742    19.16 MB/sec  execute  28 sec   
  30      3790    18.80 MB/sec  execute  29 sec   
  30      3801    18.19 MB/sec  execute  30 sec   
  30      3801    17.61 MB/sec  execute  31 sec   
  30      3801    17.06 MB/sec  execute  32 sec   
  30      3802    16.54 MB/sec  execute  33 sec   
  30      3838    16.27 MB/sec  execute  34 sec   
  30      3863    15.94 MB/sec  execute  35 sec   
  30      4080    16.43 MB/sec  execute  36 sec   
  30      4185    16.61 MB/sec  execute  37 sec   
  30      4254    16.47 MB/sec  execute  38 sec   
  30      4254    16.05 MB/sec  execute  39 sec   
  30      4254    15.65 MB/sec  execute  40 sec   
  30      4261    15.41 MB/sec  execute  41 sec   
  30      4266    15.16 MB/sec  execute  42 sec   
  30      6902    19.95 MB/sec  execute  56 sec   
  30      6997    20.12 MB/sec  execute  57 sec   
  30      6998    19.79 MB/sec  execute  58 sec   
  30      7060    19.63 MB/sec  execute  59 sec   
  30      7234    19.72 MB/sec  execute  60 sec   
  30      7580    20.44 MB/sec  execute  61 sec   
  30      7943    21.01 MB/sec  execute  62 sec   
  30      8298    21.60 MB/sec  execute  63 sec   
  30      8659    22.19 MB/sec  execute  64 sec   
  30      8986    22.73 MB/sec  execute  65 sec   
  30      9347    23.33 MB/sec  execute  66 sec   
  30      9713    23.84 MB/sec  execute  67 sec   
  30      9968    24.12 MB/sec  execute  68 sec   
  30      9968    23.77 MB/sec  execute  69 sec   
  30      9968    23.43 MB/sec  execute  70 sec   
  30      9968    23.10 MB/sec  execute  71 sec   
  30      9968    22.77 MB/sec  execute  72 sec   
  30     10001    22.57 MB/sec  execute  73 sec   
  30     10013    22.31 MB/sec  execute  74 sec   
  30     10078    22.19 MB/sec  execute  75 sec   
  30     10109    22.04 MB/sec  execute  76 sec   
  30     10113    21.76 MB/sec  execute  77 sec   
  30     10197    21.58 MB/sec  execute  78 sec   
  30     10198    21.31 MB/sec  execute  79 sec   
  30     10209    21.05 MB/sec  execute  80 sec   
  30     10209    20.78 MB/sec  execute  81 sec   
  30     10510    19.28 MB/sec  execute  91 sec   
  30     10698    19.43 MB/sec  execute  92 sec   
  30     10746    19.31 MB/sec  execute  93 sec   
  30     10944    19.44 MB/sec  execute  94 sec   
  30     11068    19.47 MB/sec  execute  95 sec   
  30     11077    19.27 MB/sec  execute  96 sec   
  30     11166    19.22 MB/sec  execute  97 sec   
  30     11166    19.02 MB/sec  execute  98 sec   
  30     11166    18.83 MB/sec  execute  99 sec   
  30     11166    18.64 MB/sec  execute 100 sec   
  30     11272    18.62 MB/sec  execute 101 sec   
  30     11438    18.71 MB/sec  execute 102 sec   
  30     11633    18.92 MB/sec  execute 103 sec   
  30     11783    18.96 MB/sec  execute 104 sec   
  30     12021    19.17 MB/sec  execute 105 sec   
  30     13712    19.37 MB/sec  execute 117 sec   
  30     13943    19.49 MB/sec  execute 118 sec   
  30     13993    19.37 MB/sec  execute 119 sec   
  30     14021    19.23 MB/sec  execute 120 sec   
  30     14031    19.10 MB/sec  execute 121 sec   
  30     14037    18.95 MB/sec  execute 122 sec   
  30     14070    18.85 MB/sec  execute 123 sec   
  30     14413    19.15 MB/sec  execute 124 sec   
  30     14729    19.37 MB/sec  execute 125 sec   
  30     15089    19.68 MB/sec  execute 126 sec   
  30     15451    20.00 MB/sec  execute 127 sec   
  30     15814    20.30 MB/sec  execute 128 sec   
  30     16178    20.60 MB/sec  execute 129 sec   
  30     16212    20.50 MB/sec  execute 130 sec   
  30     16270    20.42 MB/sec  execute 131 sec   
  30     16278    20.28 MB/sec  execute 132 sec   
  30     16632    20.56 MB/sec  execute 133 sec   
  30     16981    20.85 MB/sec  execute 134 sec   
  30     17315    21.11 MB/sec  execute 135 sec   
  30     17595    21.27 MB/sec  execute 136 sec   
  30     17920    21.57 MB/sec  execute 137 sec   
  30     18231    21.77 MB/sec  execute 138 sec   
  30     18605    22.02 MB/sec  execute 139 sec   
  30     18977    22.24 MB/sec  execute 140 sec   
  30     19181    22.34 MB/sec  execute 141 sec   
  30     19232    22.20 MB/sec  execute 142 sec   
  30     19481    22.34 MB/sec  execute 143 sec   
  30     19724    22.45 MB/sec  execute 144 sec   
  30     19831    22.43 MB/sec  execute 145 sec   
  30     19943    22.38 MB/sec  execute 146 sec   
  30     20025    22.31 MB/sec  execute 147 sec   
  30     20091    22.24 MB/sec  execute 148 sec   
  30     20175    22.18 MB/sec  execute 149 sec   
  30     20252    22.12 MB/sec  execute 150 sec   
  30     20348    22.08 MB/sec  execute 151 sec   
  30     20454    22.03 MB/sec  execute 152 sec   
  30     20543    21.99 MB/sec  execute 153 sec   
  30     20653    21.97 MB/sec  execute 154 sec   
  30     20706    21.88 MB/sec  execute 155 sec   
  30     20758    21.80 MB/sec  execute 156 sec   
  30     20790    21.70 MB/sec  execute 157 sec   
  30     20828    21.61 MB/sec  execute 158 sec   
  30     21111    21.76 MB/sec  execute 159 sec   
  30     21312    21.79 MB/sec  execute 160 sec   
  30     21414    20.90 MB/sec  execute 168 sec   
  30     21414    20.78 MB/sec  execute 169 sec   
  30     21414    20.66 MB/sec  execute 170 sec   
  30     21414    20.54 MB/sec  execute 171 sec   
  30     21414    20.42 MB/sec  execute 172 sec   
  30     21414    20.30 MB/sec  execute 173 sec   
  30     21414    20.18 MB/sec  execute 174 sec   
  30     21414    20.07 MB/sec  execute 175 sec   
  30     21414    19.95 MB/sec  execute 176 sec   
  30     21443    19.89 MB/sec  execute 177 sec   
  30     21539    19.89 MB/sec  execute 178 sec   
  30     21630    19.88 MB/sec  execute 179 sec   
  30     21677    19.81 MB/sec  execute 180 sec   
  30     21906    19.89 MB/sec  execute 181 sec   
  30     22088    19.95 MB/sec  execute 182 sec   
  30     22242    19.98 MB/sec  execute 183 sec   
  30     22461    20.08 MB/sec  execute 184 sec   
  30     22547    20.05 MB/sec  execute 185 sec   
  30     22566    19.95 MB/sec  execute 186 sec   
  30     22572    19.85 MB/sec  execute 187 sec   
  30     22572    19.74 MB/sec  execute 188 sec   
  30     22572    19.64 MB/sec  execute 189 sec   
  30     22573    19.53 MB/sec  execute 190 sec   
  30     22727    19.58 MB/sec  execute 191 sec   
  30     22952    19.66 MB/sec  execute 192 sec   
  30     23302    19.83 MB/sec  execute 193 sec   
  30     23326    19.75 MB/sec  execute 194 sec   
  30     23326    19.65 MB/sec  execute 195 sec   
  30     23639    19.28 MB/sec  execute 201 sec   
  30     23914    19.43 MB/sec  execute 202 sec   
  30     24221    19.58 MB/sec  execute 203 sec   
  30     24323    19.55 MB/sec  execute 204 sec   
  30     24361    19.49 MB/sec  execute 205 sec   
  30     24361    19.39 MB/sec  execute 206 sec   
  30     24361    19.30 MB/sec  execute 207 sec   
  30     24387    19.23 MB/sec  execute 208 sec   
  30     24387    19.14 MB/sec  execute 209 sec   
  30     24387    19.05 MB/sec  execute 210 sec   
  30     24387    18.96 MB/sec  execute 211 sec   
  30     24387    18.87 MB/sec  execute 212 sec   
  30     24387    18.78 MB/sec  execute 213 sec   
  30     24407    18.69 MB/sec  execute 214 sec   
  30     24517    18.69 MB/sec  execute 215 sec   
  30     24647    18.69 MB/sec  execute 216 sec   
  30     24907    18.80 MB/sec  execute 217 sec   
  30     25262    18.97 MB/sec  execute 218 sec   
  30     25610    19.15 MB/sec  execute 219 sec   
  30     25698    19.15 MB/sec  execute 220 sec   
  30     25804    19.10 MB/sec  execute 221 sec   
  30     26017    19.19 MB/sec  execute 222 sec   
  30     26179    19.27 MB/sec  execute 223 sec   
  30     26291    19.26 MB/sec  execute 224 sec   
  30     26448    19.26 MB/sec  execute 225 sec   
  30     26801    19.45 MB/sec  execute 226 sec   
  30     26998    19.51 MB/sec  execute 227 sec   
  30     27023    19.44 MB/sec  execute 228 sec   
  30     27057    19.36 MB/sec  execute 230 sec   
  30     27057    19.28 MB/sec  execute 231 sec   
  30     27057    19.20 MB/sec  execute 232 sec   
  30     27173    19.15 MB/sec  execute 233 sec   
  30     27173    19.07 MB/sec  execute 234 sec   
  30     27182    18.99 MB/sec  execute 235 sec   
  30     27182    18.91 MB/sec  execute 236 sec   
  30     27182    18.83 MB/sec  execute 237 sec   
  30     27182    18.75 MB/sec  execute 238 sec   
  30     27182    18.67 MB/sec  execute 239 sec   
  30     27182    18.60 MB/sec  execute 240 sec   
  30     27182    18.52 MB/sec  execute 241 sec   
  30     27182    18.44 MB/sec  execute 242 sec   
  30     27182    18.37 MB/sec  execute 243 sec   
  30     27182    18.29 MB/sec  execute 244 sec   
  30     27183    18.22 MB/sec  execute 245 sec   
  30     27185    18.14 MB/sec  execute 246 sec   
  30     27185    18.07 MB/sec  execute 247 sec   
  30     27185    18.00 MB/sec  execute 248 sec   
  30     27185    17.93 MB/sec  execute 249 sec   
  30     27185    17.86 MB/sec  execute 250 sec   
  30     27185    17.79 MB/sec  execute 251 sec   
  30     27187    17.72 MB/sec  execute 252 sec   
  30     27187    17.65 MB/sec  execute 253 sec   
  30     27199    17.58 MB/sec  execute 254 sec   
  30     27228    17.53 MB/sec  execute 255 sec   
  30     27261    17.48 MB/sec  execute 256 sec   
  30     27296    17.14 MB/sec  execute 261 sec   
  30     27296    17.07 MB/sec  execute 262 sec   
  30     27296    17.01 MB/sec  execute 263 sec   
  30     27296    16.94 MB/sec  execute 264 sec   
  30     27296    16.88 MB/sec  execute 265 sec   
  30     27300    16.82 MB/sec  execute 266 sec   
  30     27308    16.78 MB/sec  execute 267 sec   
  30     27308    16.71 MB/sec  execute 268 sec   
  30     27308    16.65 MB/sec  execute 269 sec   
  30     27423    16.64 MB/sec  execute 270 sec   
  30     27720    16.77 MB/sec  execute 271 sec   
  30     27951    16.85 MB/sec  execute 272 sec   
  30     28036    16.88 MB/sec  execute 273 sec   
  30     28182    16.91 MB/sec  execute 274 sec   
  30     28259    16.89 MB/sec  execute 275 sec   
  30     28308    16.86 MB/sec  execute 276 sec   
  30     28330    16.81 MB/sec  execute 277 sec   
  30     28330    16.75 MB/sec  execute 278 sec   
  30     28377    16.72 MB/sec  execute 279 sec   
  30     28539    16.74 MB/sec  execute 280 sec   
  30     28762    16.80 MB/sec  execute 281 sec   
  30     29077    16.92 MB/sec  execute 282 sec   
  30     29372    17.03 MB/sec  execute 283 sec   
  30     29642    17.14 MB/sec  execute 284 sec   
  30     29906    17.20 MB/sec  execute 285 sec   
  30     30263    17.34 MB/sec  execute 286 sec   
  30     30622    17.48 MB/sec  execute 287 sec   
  30     30981    17.63 MB/sec  execute 288 sec   
  30     31325    17.75 MB/sec  execute 289 sec   
  30     31685    17.90 MB/sec  execute 290 sec   
  30     32046    18.05 MB/sec  execute 291 sec   
  30     32185    18.06 MB/sec  execute 292 sec   
  30     32267    18.04 MB/sec  execute 293 sec   
  30     32415    18.06 MB/sec  execute 294 sec   
  30     32783    18.19 MB/sec  execute 295 sec   
  30     33145    18.32 MB/sec  execute 296 sec   
  30     33481    18.47 MB/sec  execute 297 sec   
  30     33666    18.53 MB/sec  execute 298 sec   
  30     33667    18.46 MB/sec  execute 299 sec   
  30     33785    18.46 MB/sec  execute 300 sec   
  30     33973    18.49 MB/sec  execute 301 sec   
  30     34219    18.54 MB/sec  execute 302 sec   
  30     34401    18.57 MB/sec  execute 303 sec   
  30     34428    18.53 MB/sec  execute 304 sec   
  30     34547    18.52 MB/sec  execute 305 sec   
  30     34559    18.46 MB/sec  execute 306 sec   
  30     34567    18.40 MB/sec  execute 307 sec   
  30     34579    18.34 MB/sec  execute 308 sec   
  30     34643    18.32 MB/sec  execute 309 sec   
  30     34794    18.33 MB/sec  execute 310 sec   
  30     34794    18.27 MB/sec  execute 311 sec   
  30     34794    18.22 MB/sec  execute 312 sec   
  30     34794    18.16 MB/sec  execute 313 sec   
  30     34854    18.15 MB/sec  execute 314 sec   
  30     35074    18.18 MB/sec  execute 315 sec   
  30     35264    18.22 MB/sec  execute 316 sec   
  30     35560    18.30 MB/sec  execute 317 sec   
  30     35832    18.40 MB/sec  execute 318 sec   
  30     36135    18.47 MB/sec  execute 319 sec   
  30     36442    18.58 MB/sec  execute 320 sec   
  30     36734    18.68 MB/sec  execute 321 sec   
  30     37050    18.76 MB/sec  execute 322 sec   
  30     37130    18.74 MB/sec  execute 323 sec   
  30     37131    18.68 MB/sec  execute 324 sec   
  30     37168    18.65 MB/sec  execute 325 sec   
  30     37261    18.63 MB/sec  execute 326 sec   
  30     37315    18.61 MB/sec  execute 327 sec   
  30     37608    18.53 MB/sec  execute 332 sec   
  30     37945    18.66 MB/sec  execute 333 sec   
  30     38283    18.76 MB/sec  execute 334 sec   
  30     38574    18.84 MB/sec  execute 335 sec   
  30     38649    18.83 MB/sec  execute 336 sec   
  30     38649    18.77 MB/sec  execute 337 sec   
  30     38987    18.67 MB/sec  execute 342 sec   
  30     39347    18.78 MB/sec  execute 343 sec   
  30     39666    18.89 MB/sec  execute 344 sec   
  30     39939    18.96 MB/sec  execute 345 sec   
  30     40084    18.98 MB/sec  execute 346 sec   
  30     40101    18.93 MB/sec  execute 347 sec   
  30     40101    18.88 MB/sec  execute 348 sec   
  30     40101    18.82 MB/sec  execute 349 sec   
  30     40101    18.77 MB/sec  execute 350 sec   
  30     40101    18.71 MB/sec  execute 351 sec   
  30     40103    18.67 MB/sec  execute 352 sec   
  30     40104    18.61 MB/sec  execute 353 sec   
  30     40715    18.12 MB/sec  execute 367 sec   
  30     40740    18.08 MB/sec  execute 368 sec   
  30     40758    18.04 MB/sec  execute 369 sec   
  30     40758    17.99 MB/sec  execute 370 sec   
  30     40758    17.94 MB/sec  execute 371 sec   
  30     40760    17.89 MB/sec  execute 372 sec   
  30     40837    17.88 MB/sec  execute 373 sec   
  30     41050    17.92 MB/sec  execute 374 sec   
  30     41051    17.88 MB/sec  execute 375 sec   
  30     41085    17.84 MB/sec  execute 376 sec   
  30     41428    17.94 MB/sec  execute 377 sec   
  30     41802    18.03 MB/sec  execute 378 sec   
  30     42136    18.15 MB/sec  execute 379 sec   
  30     42520    18.24 MB/sec  execute 380 sec   
  30     42832    18.34 MB/sec  execute 381 sec   
  30     43128    18.40 MB/sec  execute 382 sec   
  30     43397    18.48 MB/sec  execute 383 sec   
  30     43671    18.54 MB/sec  execute 384 sec   
  30     43902    18.59 MB/sec  execute 385 sec   
  30     43943    18.55 MB/sec  execute 386 sec   
  30     44051    18.55 MB/sec  execute 387 sec   
  30     44098    18.53 MB/sec  execute 388 sec   
  30     44099    18.48 MB/sec  execute 389 sec   
  30     44183    18.46 MB/sec  execute 390 sec   
  30     44223    18.43 MB/sec  execute 391 sec   
  30     44223    18.38 MB/sec  execute 392 sec   
  30     44226    18.33 MB/sec  execute 393 sec   
  30     44226    18.29 MB/sec  execute 394 sec   
  30     44226    18.24 MB/sec  execute 395 sec   
  30     44226    18.19 MB/sec  execute 396 sec   
  30     44226    18.15 MB/sec  execute 397 sec   
  30     44228    18.10 MB/sec  execute 398 sec   
  30     44229    18.06 MB/sec  execute 399 sec   
  30     44233    18.02 MB/sec  execute 400 sec   
  30     44461    18.09 MB/sec  execute 401 sec   
  30     44750    18.17 MB/sec  execute 402 sec   
  30     44835    18.17 MB/sec  execute 403 sec   
  30     44890    18.15 MB/sec  execute 404 sec   
  30     45089    18.18 MB/sec  execute 405 sec   
  30     45109    18.14 MB/sec  execute 406 sec   
  30     45322    18.18 MB/sec  execute 407 sec   
  30     45326    18.14 MB/sec  execute 408 sec   
  30     45353    18.12 MB/sec  execute 409 sec   
  30     45718    18.21 MB/sec  execute 410 sec   
  30     45791    18.19 MB/sec  execute 411 sec   
  30     45947    18.04 MB/sec  execute 416 sec   
  30     46023    18.02 MB/sec  execute 417 sec   
  30     46140    18.02 MB/sec  execute 418 sec   
  30     46384    18.07 MB/sec  execute 419 sec   
  30     46621    18.12 MB/sec  execute 420 sec   
  30     46858    18.18 MB/sec  execute 421 sec   
  30     47095    18.23 MB/sec  execute 422 sec   
  30     47334    18.28 MB/sec  execute 423 sec   
  30     47557    18.31 MB/sec  execute 424 sec   
  30     47799    18.36 MB/sec  execute 425 sec   
  30     47934    18.37 MB/sec  execute 426 sec   
  30     47934    18.33 MB/sec  execute 427 sec   
  30     47934    18.29 MB/sec  execute 428 sec   
  30     47934    18.24 MB/sec  execute 429 sec   
  30     47935    18.20 MB/sec  execute 430 sec   
  30     47945    18.17 MB/sec  execute 431 sec   
  30     47974    18.13 MB/sec  execute 432 sec   
  30     47982    18.10 MB/sec  execute 433 sec   
  30     48020    18.07 MB/sec  execute 434 sec   
  30     48362    18.11 MB/sec  execute 436 sec   
  30     48627    18.16 MB/sec  execute 437 sec   
  30     48794    18.19 MB/sec  execute 438 sec   
  30     49137    18.27 MB/sec  execute 439 sec   
  30     49429    18.34 MB/sec  execute 440 sec   
  30     49483    18.31 MB/sec  execute 441 sec   
  30     49564    18.30 MB/sec  execute 442 sec   
  30     49564    18.26 MB/sec  execute 443 sec   
  30     49564    18.22 MB/sec  execute 444 sec   
  30     49745    18.22 MB/sec  execute 445 sec   
  30     49869    18.24 MB/sec  execute 446 sec   
  30     49869    18.19 MB/sec  execute 447 sec   
  30     49869    18.15 MB/sec  execute 448 sec   
  30     49869    18.11 MB/sec  execute 449 sec   
  30     49869    18.07 MB/sec  execute 450 sec   
  30     49869    18.03 MB/sec  execute 451 sec   
  30     49966    18.01 MB/sec  execute 453 sec   
  30     50077    18.01 MB/sec  execute 454 sec   
  30     50436    18.10 MB/sec  execute 455 sec   
  30     50787    18.18 MB/sec  execute 456 sec   
  30     51046    18.23 MB/sec  execute 457 sec   
  30     51046    18.19 MB/sec  execute 458 sec   
  30     51046    18.15 MB/sec  execute 459 sec   
  30     51119    18.14 MB/sec  execute 460 sec   
  30     51262    18.15 MB/sec  execute 461 sec   
  30     51450    18.18 MB/sec  execute 462 sec   
  30     51692    18.21 MB/sec  execute 463 sec   
  30     51743    18.19 MB/sec  execute 464 sec   
  30     52015    18.27 MB/sec  execute 465 sec   
  30     52213    18.29 MB/sec  execute 466 sec   
  30     52388    18.33 MB/sec  execute 467 sec   
  30     52592    18.34 MB/sec  execute 468 sec   
  30     52843    18.38 MB/sec  execute 469 sec   
  30     53055    18.42 MB/sec  execute 470 sec   
  30     53346    18.45 MB/sec  execute 472 sec   
  30     53626    18.52 MB/sec  execute 473 sec   
  30     53893    18.55 MB/sec  execute 474 sec   
  30     54125    18.59 MB/sec  execute 475 sec   
  30     54148    18.55 MB/sec  execute 476 sec   
  30     54148    18.51 MB/sec  execute 477 sec   
  30     54215    18.50 MB/sec  execute 478 sec   
  30     54215    18.46 MB/sec  execute 479 sec   
  30     54215    18.42 MB/sec  execute 480 sec   
  30     54215    18.38 MB/sec  execute 481 sec   
  30     54215    18.34 MB/sec  execute 482 sec   
  30     54215    18.30 MB/sec  execute 483 sec   
  30     54215    18.27 MB/sec  execute 484 sec   
  30     54215    18.23 MB/sec  execute 485 sec   
  30     54215    18.19 MB/sec  execute 486 sec   
  30     54228    18.15 MB/sec  execute 487 sec   
  30     54408    17.36 MB/sec  execute 511 sec   
  30     54460    17.36 MB/sec  execute 512 sec   
  30     54488    17.34 MB/sec  execute 513 sec   
  30     54556    17.33 MB/sec  execute 514 sec   
  30     54608    17.30 MB/sec  execute 515 sec   
  30     54608    17.27 MB/sec  execute 516 sec   
  30     54608    17.24 MB/sec  execute 517 sec   
  30     54616    17.20 MB/sec  execute 518 sec   
  30     54616    17.17 MB/sec  execute 519 sec   
  30     54616    17.14 MB/sec  execute 520 sec   
  30     54616    17.10 MB/sec  execute 521 sec   
  30     54616    17.07 MB/sec  execute 522 sec   
  30     54616    17.04 MB/sec  execute 523 sec   
  30     54616    17.01 MB/sec  execute 524 sec   
  30     54682    17.00 MB/sec  execute 525 sec   
  30     54683    16.97 MB/sec  execute 526 sec   
  30     54683    16.93 MB/sec  execute 527 sec   
  30     54683    16.90 MB/sec  execute 528 sec   
  30     54686    16.87 MB/sec  execute 529 sec   
  30     54687    16.84 MB/sec  execute 530 sec   
  30     54789    16.82 MB/sec  execute 531 sec   
  30     54849    16.81 MB/sec  execute 532 sec   
  30     54930    16.79 MB/sec  execute 533 sec   
  30     55042    16.80 MB/sec  execute 534 sec   
  30     55161    16.80 MB/sec  execute 535 sec   
  30     55244    16.80 MB/sec  execute 536 sec   
  30     55273    16.77 MB/sec  execute 537 sec   
  30     55427    16.76 MB/sec  execute 539 sec   
  30     55443    16.73 MB/sec  execute 540 sec   
  30     55443    16.70 MB/sec  execute 541 sec   
  30     55443    16.67 MB/sec  execute 542 sec   
  30     55591    16.69 MB/sec  execute 543 sec   
  30     55748    16.69 MB/sec  execute 544 sec   
  30     55751    16.66 MB/sec  execute 545 sec   
  30     55751    16.63 MB/sec  execute 546 sec   
  30     55751    16.60 MB/sec  execute 547 sec   
  30     55751    16.57 MB/sec  execute 548 sec   
  30     55751    16.54 MB/sec  execute 549 sec   
  30     55751    16.51 MB/sec  execute 550 sec   
  30     55751    16.48 MB/sec  execute 551 sec   
  30     55751    16.45 MB/sec  execute 552 sec   
  30     55760    16.42 MB/sec  execute 553 sec   
  30     55896    16.43 MB/sec  execute 554 sec   
  30     56111    16.47 MB/sec  execute 555 sec   
  30     56459    16.53 MB/sec  execute 556 sec   
  30     56802    16.61 MB/sec  execute 557 sec   
  30     57107    16.66 MB/sec  execute 558 sec   
  30     57195    16.66 MB/sec  execute 559 sec   
  30     57302    16.66 MB/sec  execute 560 sec   
  30     57313    16.63 MB/sec  execute 561 sec   
  30     57314    16.60 MB/sec  execute 562 sec   
  30     57336    16.58 MB/sec  execute 563 sec   
  30     57346    16.55 MB/sec  execute 564 sec   
  30     57346    16.52 MB/sec  execute 565 sec   
  30     57351    16.50 MB/sec  execute 566 sec   
  30     57373    16.47 MB/sec  execute 567 sec   
  30     57390    16.45 MB/sec  execute 568 sec   
  30     57422    16.43 MB/sec  execute 569 sec   
  30     57451    16.41 MB/sec  execute 570 sec   
  30     57501    16.39 MB/sec  execute 571 sec   
  30     57520    16.38 MB/sec  execute 572 sec   
  30     57538    16.35 MB/sec  execute 573 sec   
  30     57893    16.36 MB/sec  execute 576 sec   
  30     58139    16.42 MB/sec  execute 577 sec   
  30     58157    16.39 MB/sec  execute 578 sec   
  30     58157    16.37 MB/sec  execute 579 sec   
  30     58195    16.36 MB/sec  execute 580 sec   
  30     58317    16.36 MB/sec  execute 581 sec   
  30     58644    16.41 MB/sec  execute 582 sec   
  30     58646    16.39 MB/sec  execute 583 sec   
  30     58661    16.36 MB/sec  execute 584 sec   
  30     58902    16.33 MB/sec  execute 587 sec   
  30     59116    16.36 MB/sec  execute 588 sec   
  30     59333    16.38 MB/sec  execute 589 sec   
  30     59561    16.43 MB/sec  execute 590 sec   
  30     59788    16.47 MB/sec  execute 591 sec   
  30     60014    16.50 MB/sec  execute 592 sec   
  30     60236    16.53 MB/sec  execute 593 sec   
  30     60461    16.57 MB/sec  execute 594 sec   
  30     60625    16.58 MB/sec  execute 595 sec   
  30     60681    16.57 MB/sec  execute 596 sec   
  30     60685    16.54 MB/sec  execute 597 sec   
  30     60713    16.52 MB/sec  execute 598 sec   
  30     60735    16.50 MB/sec  execute 599 sec   
  30     60751    16.48 MB/sec  cleanup 600 sec   
  30     60751    16.45 MB/sec  cleanup 601 sec   
  30     60751    16.42 MB/sec  cleanup 603 sec   
  30     60751    16.39 MB/sec  cleanup 604 sec   
  30     60751    16.37 MB/sec  cleanup 605 sec   
  30     60751    16.34 MB/sec  cleanup 606 sec   
  30     60751    16.31 MB/sec  cleanup 607 sec   
  30     60751    16.29 MB/sec  cleanup 608 sec   
  30     60751    16.26 MB/sec  cleanup 609 sec   
  30     60751    16.23 MB/sec  cleanup 610 sec   
  30     60751    16.21 MB/sec  cleanup 611 sec   
  30     60751    16.18 MB/sec  cleanup 612 sec   
  30     60751    16.15 MB/sec  cleanup 613 sec   
  30     60751    16.13 MB/sec  cleanup 614 sec   
  30     60751    16.10 MB/sec  cleanup 615 sec   
  30     60751    16.08 MB/sec  cleanup 616 sec   
  30     60751    15.99 MB/sec  cleanup 619 sec   
  30     60751    15.96 MB/sec  cleanup 620 sec   
  30     60751    15.94 MB/sec  cleanup 621 sec   
  30     60751    15.93 MB/sec  cleanup 621 sec   

Throughput 16.4806 MB/sec 30 procs

--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="pdflush-hda3.log"

dbench version 3.04 - Copyright Andrew Tridgell 1999-2004

Running for 600 seconds with load '/usr/share/dbench/client.txt' and minimum warmup 120 secs
30 clients started
  30        13     2.82 MB/sec  warmup   1 sec   
  30        20     4.27 MB/sec  warmup   3 sec   
  30        20     3.05 MB/sec  warmup   4 sec   
  30        20     2.37 MB/sec  warmup   5 sec   
  30        20     1.94 MB/sec  warmup   6 sec   
  30        51     6.86 MB/sec  warmup   7 sec   
  30        64     7.10 MB/sec  warmup   8 sec   
  30        69     7.26 MB/sec  warmup   9 sec   
  30        74     7.22 MB/sec  warmup  10 sec   
  30        78     7.09 MB/sec  warmup  11 sec   
  30        82     6.71 MB/sec  warmup  12 sec   
  30        93     7.23 MB/sec  warmup  13 sec   
  30       161     7.83 MB/sec  warmup  14 sec   
  30       169     8.17 MB/sec  warmup  15 sec   
  30       169     7.64 MB/sec  warmup  16 sec   
  30       177     7.82 MB/sec  warmup  17 sec   
  30       183     7.81 MB/sec  warmup  18 sec   
  30       188     7.73 MB/sec  warmup  19 sec   
  30       190     7.46 MB/sec  warmup  20 sec   
  30       221     7.60 MB/sec  warmup  21 sec   
  30       225     7.52 MB/sec  warmup  22 sec   
  30       228     7.43 MB/sec  warmup  23 sec   
  30       232     7.29 MB/sec  warmup  24 sec   
  30       232     6.99 MB/sec  warmup  25 sec   
  30       245     7.37 MB/sec  warmup  26 sec   
  30       252     7.34 MB/sec  warmup  27 sec   
  30       256     7.29 MB/sec  warmup  28 sec   
  30       265     7.38 MB/sec  warmup  29 sec   
  30       265     7.13 MB/sec  warmup  30 sec   
  30       282     7.43 MB/sec  warmup  31 sec   
  30       292     7.51 MB/sec  warmup  32 sec   
  30       304     7.51 MB/sec  warmup  33 sec   
  30       306     7.33 MB/sec  warmup  34 sec   
  30       306     7.12 MB/sec  warmup  35 sec   
  30       324     7.40 MB/sec  warmup  36 sec   
  30       336     7.54 MB/sec  warmup  37 sec   
  30       347     7.62 MB/sec  warmup  38 sec   
  30       347     7.43 MB/sec  warmup  39 sec   
  30       359     7.55 MB/sec  warmup  40 sec   
  30       379     7.57 MB/sec  warmup  41 sec   
  30       387     7.59 MB/sec  warmup  42 sec   
  30       400     7.70 MB/sec  warmup  43 sec   
  30       408     7.71 MB/sec  warmup  44 sec   
  30       421     7.79 MB/sec  warmup  45 sec   
  30       433     7.75 MB/sec  warmup  46 sec   
  30       444     7.83 MB/sec  warmup  47 sec   
  30       448     7.75 MB/sec  warmup  48 sec   
  30       456     7.76 MB/sec  warmup  49 sec   
  30       480     7.93 MB/sec  warmup  50 sec   
  30       483     7.84 MB/sec  warmup  51 sec   
  30       498     7.87 MB/sec  warmup  52 sec   
  30       506     7.86 MB/sec  warmup  53 sec   
  30       531     8.06 MB/sec  warmup  54 sec   
  30       544     8.14 MB/sec  warmup  55 sec   
  30       575     8.17 MB/sec  warmup  56 sec   
  30       606     8.15 MB/sec  warmup  57 sec   
  30       613     8.06 MB/sec  warmup  58 sec   
  30       802     8.63 MB/sec  warmup  59 sec   
  30       971     9.04 MB/sec  warmup  60 sec   
  30       988     9.00 MB/sec  warmup  61 sec   
  30       998     9.02 MB/sec  warmup  62 sec   
  30      1082     9.09 MB/sec  warmup  63 sec   
  30      1223     9.30 MB/sec  warmup  64 sec   
  30      1472     9.81 MB/sec  warmup  65 sec   
  30      1629     9.43 MB/sec  warmup  72 sec   
  30      1661     9.45 MB/sec  warmup  73 sec   
  30      1792     9.78 MB/sec  warmup  74 sec   
  30      1926     9.94 MB/sec  warmup  75 sec   
  30      2252    10.47 MB/sec  warmup  76 sec   
  30      2564    11.02 MB/sec  warmup  77 sec   
  30      2881    11.53 MB/sec  warmup  78 sec   
  30      3138    12.11 MB/sec  warmup  79 sec   
  30      3270    12.36 MB/sec  warmup  80 sec   
  30      3360    11.97 MB/sec  warmup  85 sec   
  30      3390    11.46 MB/sec  warmup  89 sec   
  30      3430    10.80 MB/sec  warmup  95 sec   
  30      3435    10.67 MB/sec  warmup  96 sec   
  30      3461    10.62 MB/sec  warmup  97 sec   
  30      3474    10.51 MB/sec  warmup  99 sec   
  30      3485    10.39 MB/sec  warmup 100 sec   
  30      3542    10.35 MB/sec  warmup 101 sec   
  30      3574    10.31 MB/sec  warmup 102 sec   
  30      3789    10.53 MB/sec  warmup 103 sec   
  30      4105    10.90 MB/sec  warmup 104 sec   
  30      4416    11.30 MB/sec  warmup 105 sec   
  30      4736    11.70 MB/sec  warmup 106 sec   
  30      4903    11.82 MB/sec  warmup 107 sec   
  30      4934    11.75 MB/sec  warmup 108 sec   
  30      4984    11.70 MB/sec  warmup 109 sec   
  30      4992    11.63 MB/sec  warmup 110 sec   
  30      4992    11.52 MB/sec  warmup 111 sec   
  30      4992    11.42 MB/sec  warmup 112 sec   
  30      5033    11.38 MB/sec  warmup 113 sec   
  30      5149    11.47 MB/sec  warmup 114 sec   
  30      5284    11.61 MB/sec  warmup 115 sec   
  30      5450    11.76 MB/sec  warmup 116 sec   
  30      5618    11.90 MB/sec  warmup 117 sec   
  30      5783    12.00 MB/sec  warmup 118 sec   
  30      5783    11.90 MB/sec  warmup 119 sec   
  30      5802    11.80 MB/sec  warmup 120 sec   
  30      5948    11.54 MB/sec  execute   1 sec   
  30      5956     7.62 MB/sec  execute   2 sec   
  30      6053     9.94 MB/sec  execute   3 sec   
  30      6218    14.81 MB/sec  execute   4 sec   
  30      6275     5.18 MB/sec  execute  13 sec   
  30      6275     4.81 MB/sec  execute  14 sec   
  30      6275     4.48 MB/sec  execute  15 sec   
  30      6275     4.20 MB/sec  execute  16 sec   
  30      6275     3.95 MB/sec  execute  17 sec   
  30      6275     3.73 MB/sec  execute  18 sec   
  30      6278     3.57 MB/sec  execute  19 sec   
  30      6380     4.11 MB/sec  execute  20 sec   
  30      6473     5.05 MB/sec  execute  21 sec   
  30      6474     4.82 MB/sec  execute  22 sec   
  30      6480     4.85 MB/sec  execute  23 sec   
  30      6586     5.57 MB/sec  execute  24 sec   
  30      6788     6.49 MB/sec  execute  25 sec   
  30      7070     8.13 MB/sec  execute  26 sec   
  30      7355     9.76 MB/sec  execute  27 sec   
  30      7684    10.88 MB/sec  execute  28 sec   
  30      7965    12.52 MB/sec  execute  29 sec   
  30      8027    12.57 MB/sec  execute  30 sec   
  30      8027    12.16 MB/sec  execute  31 sec   
  30      8027    11.78 MB/sec  execute  32 sec   
  30      8027    11.42 MB/sec  execute  33 sec   
  30      8081    11.46 MB/sec  execute  34 sec   
  30      8234    11.74 MB/sec  execute  35 sec   
  30      8402    12.12 MB/sec  execute  36 sec   
  30      8680    13.02 MB/sec  execute  37 sec   
  30      8911    13.77 MB/sec  execute  38 sec   
  30      9069    14.05 MB/sec  execute  39 sec   
  30      9396    15.01 MB/sec  execute  40 sec   
  30      9636    15.58 MB/sec  execute  41 sec   
  30      9775    15.73 MB/sec  execute  42 sec   
  30      9870    15.74 MB/sec  execute  43 sec   
  30      9934    12.59 MB/sec  execute  54 sec   
  30      9934    12.36 MB/sec  execute  55 sec   
  30      9934    12.14 MB/sec  execute  56 sec   
  30      9934    11.93 MB/sec  execute  57 sec   
  30      9934    11.72 MB/sec  execute  58 sec   
  30      9934    11.53 MB/sec  execute  59 sec   
  30      9934    11.34 MB/sec  execute  60 sec   
  30      9934    11.15 MB/sec  execute  61 sec   
  30      9934    10.97 MB/sec  execute  62 sec   
  30      9934    10.80 MB/sec  execute  63 sec   
  30     10006    10.83 MB/sec  execute  64 sec   
  30     10316    11.34 MB/sec  execute  65 sec   
  30     10584    11.96 MB/sec  execute  66 sec   
  30     10871    12.60 MB/sec  execute  67 sec   
  30     11147    13.17 MB/sec  execute  68 sec   
  30     11383    13.43 MB/sec  execute  69 sec   
  30     11676    13.82 MB/sec  execute  70 sec   
  30     11896    14.12 MB/sec  execute  71 sec   
  30     12149    14.53 MB/sec  execute  72 sec   
  30     12234    14.49 MB/sec  execute  73 sec   
  30     12273    14.44 MB/sec  execute  74 sec   
  30     12399    14.55 MB/sec  execute  75 sec   
  30     12410    14.37 MB/sec  execute  76 sec   
  30     12476    14.28 MB/sec  execute  77 sec   
  30     12758    14.73 MB/sec  execute  78 sec   
  30     13081    15.17 MB/sec  execute  79 sec   
  30     13393    15.60 MB/sec  execute  80 sec   
  30     13701    16.05 MB/sec  execute  81 sec   
  30     14015    16.43 MB/sec  execute  82 sec   
  30     14291    16.74 MB/sec  execute  83 sec   
  30     14327    16.61 MB/sec  execute  84 sec   
  30     14469    15.54 MB/sec  execute  92 sec   
  30     14498    15.40 MB/sec  execute  93 sec   
  30     14498    15.24 MB/sec  execute  94 sec   
  30     14498    15.08 MB/sec  execute  95 sec   
  30     14531    14.95 MB/sec  execute  96 sec   
  30     14736    15.17 MB/sec  execute  97 sec   
  30     14880    15.22 MB/sec  execute  98 sec   
  30     15007    15.30 MB/sec  execute  99 sec   
  30     15159    15.39 MB/sec  execute 100 sec   
  30     15237    15.37 MB/sec  execute 101 sec   
  30     15342    15.42 MB/sec  execute 102 sec   
  30     15567    15.56 MB/sec  execute 103 sec   
  30     15879    15.89 MB/sec  execute 104 sec   
  30     16075    16.11 MB/sec  execute 105 sec   
  30     16323    16.31 MB/sec  execute 106 sec   
  30     16556    16.49 MB/sec  execute 107 sec   
  30     16817    16.74 MB/sec  execute 108 sec   
  30     17654    17.09 MB/sec  execute 114 sec   
  30     17766    17.10 MB/sec  execute 115 sec   
  30     17856    17.03 MB/sec  execute 116 sec   
  30     17889    16.93 MB/sec  execute 117 sec   
  30     17959    16.84 MB/sec  execute 118 sec   
  30     18024    16.77 MB/sec  execute 119 sec   
  30     18036    16.66 MB/sec  execute 120 sec   
  30     18036    16.53 MB/sec  execute 121 sec   
  30     18067    16.45 MB/sec  execute 122 sec   
  30     18179    14.64 MB/sec  execute 138 sec   
  30     19236    15.07 MB/sec  execute 145 sec   
  30     19498    15.27 MB/sec  execute 146 sec   
  30     19687    15.41 MB/sec  execute 147 sec   
  30     19928    15.50 MB/sec  execute 148 sec   
  30     20154    15.70 MB/sec  execute 149 sec   
  30     20341    15.79 MB/sec  execute 150 sec   
  30     20577    15.91 MB/sec  execute 151 sec   
  30     20813    16.14 MB/sec  execute 152 sec   
  30     21060    16.32 MB/sec  execute 153 sec   
  30     21308    16.47 MB/sec  execute 154 sec   
  30     21542    16.64 MB/sec  execute 155 sec   
  30     21872    16.63 MB/sec  execute 158 sec   
  30     22137    16.76 MB/sec  execute 159 sec   
  30     22206    16.69 MB/sec  execute 160 sec   
  30     22330    16.68 MB/sec  execute 161 sec   
  30     22472    16.73 MB/sec  execute 162 sec   
  30     22529    16.68 MB/sec  execute 163 sec   
  30     22541    16.60 MB/sec  execute 164 sec   
  30     22541    16.43 MB/sec  execute 166 sec   
  30     22541    16.33 MB/sec  execute 167 sec   
  30     22541    16.23 MB/sec  execute 168 sec   
  30     22541    16.14 MB/sec  execute 169 sec   
  30     22541    16.04 MB/sec  execute 170 sec   
  30     22556    15.97 MB/sec  execute 171 sec   
  30     22689    16.01 MB/sec  execute 172 sec   
  30     23014    16.21 MB/sec  execute 173 sec   
  30     23191    16.30 MB/sec  execute 174 sec   
  30     23423    16.42 MB/sec  execute 175 sec   
  30     23680    16.55 MB/sec  execute 176 sec   
  30     23846    16.60 MB/sec  execute 177 sec   
  30     23965    16.61 MB/sec  execute 178 sec   
  30     24135    16.69 MB/sec  execute 179 sec   
  30     24259    16.71 MB/sec  execute 180 sec   
  30     24481    16.83 MB/sec  execute 181 sec   
  30     24729    16.96 MB/sec  execute 182 sec   
  30     24991    17.11 MB/sec  execute 183 sec   
  30     25281    17.31 MB/sec  execute 184 sec   
  30     25579    17.46 MB/sec  execute 185 sec   
  30     25838    17.62 MB/sec  execute 186 sec   
  30     25903    17.57 MB/sec  execute 187 sec   
  30     26263    17.35 MB/sec  execute 192 sec   
  30     26350    17.33 MB/sec  execute 193 sec   
  30     26371    17.25 MB/sec  execute 194 sec   
  30     26569    17.34 MB/sec  execute 195 sec   
  30     26892    17.50 MB/sec  execute 196 sec   
  30     27050    17.55 MB/sec  execute 197 sec   
  30     27088    17.49 MB/sec  execute 198 sec   
  30     27135    17.43 MB/sec  execute 199 sec   
  30     27151    17.37 MB/sec  execute 200 sec   
  30     27151    17.28 MB/sec  execute 201 sec   
  30     27157    17.21 MB/sec  execute 202 sec   
  30     27300    17.23 MB/sec  execute 203 sec   
  30     27628    17.41 MB/sec  execute 204 sec   
  30     27928    17.55 MB/sec  execute 205 sec   
  30     28244    17.72 MB/sec  execute 206 sec   
  30     28571    17.89 MB/sec  execute 207 sec   
  30     28897    18.05 MB/sec  execute 208 sec   
  30     29208    18.21 MB/sec  execute 209 sec   
  30     29535    18.38 MB/sec  execute 210 sec   
  30     29785    18.48 MB/sec  execute 211 sec   
  30     29998    18.56 MB/sec  execute 212 sec   
  30     30092    18.54 MB/sec  execute 213 sec   
  30     30092    18.45 MB/sec  execute 214 sec   
  30     30092    18.37 MB/sec  execute 215 sec   
  30     30092    18.28 MB/sec  execute 216 sec   
  30     30092    18.20 MB/sec  execute 217 sec   
  30     30169    18.19 MB/sec  execute 218 sec   
  30     30258    18.17 MB/sec  execute 219 sec   
  30     30411    18.20 MB/sec  execute 220 sec   
  30     30595    18.28 MB/sec  execute 221 sec   
  30     30662    18.26 MB/sec  execute 222 sec   
  30     30960    18.09 MB/sec  execute 227 sec   
  30     31247    18.20 MB/sec  execute 228 sec   
  30     31316    18.16 MB/sec  execute 229 sec   
  30     31350    18.10 MB/sec  execute 230 sec   
  30     31427    18.08 MB/sec  execute 231 sec   
  30     31497    18.06 MB/sec  execute 232 sec   
  30     31674    18.09 MB/sec  execute 233 sec   
  30     31936    18.18 MB/sec  execute 234 sec   
  30     32246    18.34 MB/sec  execute 235 sec   
  30     32560    18.46 MB/sec  execute 236 sec   
  30     32897    18.56 MB/sec  execute 237 sec   
  30     33175    18.74 MB/sec  execute 238 sec   
  30     33513    18.82 MB/sec  execute 239 sec   
  30     33784    18.99 MB/sec  execute 240 sec   
  30     34125    19.10 MB/sec  execute 241 sec   
  30     37031    20.11 MB/sec  execute 253 sec   
  30     37316    20.23 MB/sec  execute 254 sec   
  30     37603    20.29 MB/sec  execute 255 sec   
  30     37918    20.41 MB/sec  execute 256 sec   
  30     38232    20.47 MB/sec  execute 257 sec   
  30     38526    20.58 MB/sec  execute 258 sec   
  30     38718    20.64 MB/sec  execute 259 sec   
  30     38718    20.56 MB/sec  execute 260 sec   
  30     38718    20.48 MB/sec  execute 261 sec   
  30     38755    20.42 MB/sec  execute 262 sec   
  30     38824    20.39 MB/sec  execute 263 sec   
  30     38824    20.31 MB/sec  execute 264 sec   
  30     38824    20.23 MB/sec  execute 265 sec   
  30     38824    20.16 MB/sec  execute 266 sec   
  30     38824    20.08 MB/sec  execute 267 sec   
  30     38824    20.01 MB/sec  execute 268 sec   
  30     38824    19.93 MB/sec  execute 269 sec   
  30     38824    19.86 MB/sec  execute 270 sec   
  30     38824    19.78 MB/sec  execute 271 sec   
  30     38824    19.71 MB/sec  execute 272 sec   
  30     38824    19.64 MB/sec  execute 273 sec   
  30     38824    19.57 MB/sec  execute 274 sec   
  30     38824    19.50 MB/sec  execute 275 sec   
  30     38824    19.43 MB/sec  execute 276 sec   
  30     38824    19.36 MB/sec  execute 277 sec   
  30     38824    19.29 MB/sec  execute 278 sec   
  30     38824    19.22 MB/sec  execute 279 sec   
  30     38878    19.19 MB/sec  execute 280 sec   
  30     38962    19.15 MB/sec  execute 281 sec   
  30     39021    19.14 MB/sec  execute 282 sec   
  30     39180    18.29 MB/sec  execute 297 sec   
  30     39329    18.35 MB/sec  execute 298 sec   
  30     39422    18.35 MB/sec  execute 299 sec   
  30     39551    18.34 MB/sec  execute 300 sec   
  30     39623    18.32 MB/sec  execute 301 sec   
  30     39689    18.29 MB/sec  execute 302 sec   
  30     39729    18.24 MB/sec  execute 303 sec   
  30     39763    18.20 MB/sec  execute 304 sec   
  30     39766    18.14 MB/sec  execute 305 sec   
  30     39766    18.08 MB/sec  execute 306 sec   
  30     39784    18.03 MB/sec  execute 307 sec   
  30     39884    18.02 MB/sec  execute 308 sec   
  30     40163    18.11 MB/sec  execute 309 sec   
  30     40489    18.22 MB/sec  execute 310 sec   
  30     40727    18.29 MB/sec  execute 311 sec   
  30     40859    18.30 MB/sec  execute 312 sec   
  30     41000    18.31 MB/sec  execute 313 sec   
  30     41057    18.27 MB/sec  execute 314 sec   
  30     41100    18.25 MB/sec  execute 315 sec   
  30     41140    18.21 MB/sec  execute 316 sec   
  30     41186    18.17 MB/sec  execute 317 sec   
  30     41225    18.14 MB/sec  execute 318 sec   
  30     41292    18.11 MB/sec  execute 319 sec   
  30     41540    18.18 MB/sec  execute 320 sec   
  30     41849    18.28 MB/sec  execute 321 sec   
  30     42124    18.37 MB/sec  execute 322 sec   
  30     42341    18.41 MB/sec  execute 323 sec   
  30     42596    18.49 MB/sec  execute 324 sec   
  30     42915    18.59 MB/sec  execute 325 sec   
  30     43192    18.67 MB/sec  execute 326 sec   
  30     43474    18.72 MB/sec  execute 327 sec   
  30     43655    18.48 MB/sec  execute 332 sec   
  30     43679    18.41 MB/sec  execute 334 sec   
  30     43679    18.36 MB/sec  execute 335 sec   
  30     43679    18.30 MB/sec  execute 336 sec   
  30     43679    18.25 MB/sec  execute 337 sec   
  30     43679    18.19 MB/sec  execute 338 sec   
  30     43679    18.14 MB/sec  execute 339 sec   
  30     43679    18.09 MB/sec  execute 340 sec   
  30     43679    18.03 MB/sec  execute 341 sec   
  30     43679    17.98 MB/sec  execute 342 sec   
  30     43679    17.93 MB/sec  execute 343 sec   
  30     43679    17.88 MB/sec  execute 344 sec   
  30     43679    17.82 MB/sec  execute 345 sec   
  30     43679    17.77 MB/sec  execute 346 sec   
  30     43679    17.72 MB/sec  execute 347 sec   
  30     43679    17.67 MB/sec  execute 348 sec   
  30     44430    17.86 MB/sec  execute 352 sec   
  30     44741    17.93 MB/sec  execute 353 sec   
  30     45043    18.03 MB/sec  execute 354 sec   
  30     45343    18.10 MB/sec  execute 355 sec   
  30     45671    18.21 MB/sec  execute 356 sec   
  30     45932    18.28 MB/sec  execute 357 sec   
  30     46248    18.35 MB/sec  execute 358 sec   
  30     46541    18.43 MB/sec  execute 359 sec   
  30     46711    18.47 MB/sec  execute 360 sec   
  30     46909    18.50 MB/sec  execute 361 sec   
  30     47073    18.54 MB/sec  execute 362 sec   
  30     47345    18.42 MB/sec  execute 367 sec   
  30     47438    18.40 MB/sec  execute 368 sec   
  30     47526    18.38 MB/sec  execute 369 sec   
  30     47744    18.43 MB/sec  execute 370 sec   
  30     47817    18.42 MB/sec  execute 371 sec   
  30     47817    18.37 MB/sec  execute 372 sec   
  30     47817    18.32 MB/sec  execute 373 sec   
  30     47817    18.27 MB/sec  execute 374 sec   
  30     47817    18.22 MB/sec  execute 375 sec   
  30     47817    18.17 MB/sec  execute 376 sec   
  30     47817    18.12 MB/sec  execute 377 sec   
  30     47821    18.08 MB/sec  execute 378 sec   
  30     47882    18.05 MB/sec  execute 379 sec   
  30     47930    18.03 MB/sec  execute 380 sec   
  30     48008    18.01 MB/sec  execute 381 sec   
  30     48115    18.01 MB/sec  execute 382 sec   
  30     48377    18.08 MB/sec  execute 383 sec   
  30     48586    18.11 MB/sec  execute 384 sec   
  30     48801    18.16 MB/sec  execute 385 sec   
  30     49112    18.24 MB/sec  execute 386 sec   
  30     49364    18.30 MB/sec  execute 387 sec   
  30     49606    18.37 MB/sec  execute 388 sec   
  30     49817    18.40 MB/sec  execute 389 sec   
  30     50071    18.45 MB/sec  execute 390 sec   
  30     50392    18.52 MB/sec  execute 391 sec   
  30     50665    18.62 MB/sec  execute 392 sec   
  30     50969    18.69 MB/sec  execute 393 sec   
  30     51267    18.76 MB/sec  execute 394 sec   
  30     51576    18.82 MB/sec  execute 395 sec   
  30     51863    18.90 MB/sec  execute 396 sec   
  30     52156    18.96 MB/sec  execute 397 sec   
  30     52441    18.57 MB/sec  execute 408 sec   
  30     52710    18.63 MB/sec  execute 409 sec   
  30     52913    18.67 MB/sec  execute 410 sec   
  30     52963    18.64 MB/sec  execute 411 sec   
  30     52969    18.59 MB/sec  execute 412 sec   
  30     52969    18.55 MB/sec  execute 413 sec   
  30     52969    18.50 MB/sec  execute 414 sec   
  30     53011    18.48 MB/sec  execute 415 sec   
  30     53101    18.47 MB/sec  execute 416 sec   
  30     53166    18.45 MB/sec  execute 417 sec   
  30     53257    18.44 MB/sec  execute 418 sec   
  30     53360    18.44 MB/sec  execute 419 sec   
  30     53471    18.44 MB/sec  execute 420 sec   
  30     53570    18.43 MB/sec  execute 421 sec   
  30     53719    18.44 MB/sec  execute 422 sec   
  30     54034    18.52 MB/sec  execute 423 sec   
  30     54325    18.58 MB/sec  execute 424 sec   
  30     54634    18.65 MB/sec  execute 425 sec   
  30     54910    18.73 MB/sec  execute 426 sec   
  30     55216    18.79 MB/sec  execute 427 sec   
  30     55486    18.86 MB/sec  execute 428 sec   
  30     55768    18.91 MB/sec  execute 429 sec   
  30     56018    18.88 MB/sec  execute 431 sec   
  30     56327    18.45 MB/sec  execute 444 sec   
  30     56419    18.44 MB/sec  execute 445 sec   
  30     56471    18.41 MB/sec  execute 446 sec   
  30     56520    18.39 MB/sec  execute 447 sec   
  30     56520    18.35 MB/sec  execute 448 sec   
  30     56520    18.31 MB/sec  execute 449 sec   
  30     56520    18.27 MB/sec  execute 450 sec   
  30     56520    18.23 MB/sec  execute 451 sec   
  30     56520    18.19 MB/sec  execute 452 sec   
  30     56520    18.15 MB/sec  execute 453 sec   
  30     56520    18.11 MB/sec  execute 454 sec   
  30     56520    18.07 MB/sec  execute 455 sec   
  30     56520    18.03 MB/sec  execute 456 sec   
  30     56520    17.99 MB/sec  execute 457 sec   
  30     56640    17.99 MB/sec  execute 458 sec   
  30     56751    17.99 MB/sec  execute 459 sec   
  30     57011    18.04 MB/sec  execute 460 sec   
  30     57116    18.03 MB/sec  execute 461 sec   
  30     57206    18.03 MB/sec  execute 462 sec   
  30     57325    18.04 MB/sec  execute 463 sec   
  30     57473    18.04 MB/sec  execute 464 sec   
  30     57552    18.04 MB/sec  execute 465 sec   
  30     57623    18.03 MB/sec  execute 466 sec   
  30     57883    18.07 MB/sec  execute 467 sec   
  30     57914    18.05 MB/sec  execute 468 sec   
  30     57967    18.03 MB/sec  execute 469 sec   
  30     58052    18.03 MB/sec  execute 470 sec   
  30     58147    18.00 MB/sec  execute 471 sec   
  30     58195    17.98 MB/sec  execute 472 sec   
  30     58221    17.95 MB/sec  execute 473 sec   
  30     58225    17.91 MB/sec  execute 474 sec   
  30     58352    17.56 MB/sec  execute 485 sec   
  30     58474    17.58 MB/sec  execute 486 sec   
  30     58630    17.60 MB/sec  execute 487 sec   
  30     58712    17.59 MB/sec  execute 488 sec   
  30     58982    17.64 MB/sec  execute 489 sec   
  30     59303    17.69 MB/sec  execute 490 sec   
  30     59613    17.76 MB/sec  execute 491 sec   
  30     59885    17.82 MB/sec  execute 492 sec   
  30     60158    17.90 MB/sec  execute 493 sec   
  30     60464    17.94 MB/sec  execute 494 sec   
  30     60770    18.00 MB/sec  execute 495 sec   
  30     61069    18.06 MB/sec  execute 496 sec   
  30     61384    18.12 MB/sec  execute 497 sec   
  30     61687    18.19 MB/sec  execute 498 sec   
  30     61905    18.24 MB/sec  execute 499 sec   
  30     62204    18.25 MB/sec  execute 501 sec   
  30     62480    18.32 MB/sec  execute 502 sec   
  30     62776    18.40 MB/sec  execute 503 sec   
  30     63086    18.43 MB/sec  execute 504 sec   
  30     63402    18.48 MB/sec  execute 505 sec   
  30     63412    18.45 MB/sec  execute 506 sec   
  30     63726    18.27 MB/sec  execute 513 sec   
  30     63727    18.24 MB/sec  execute 514 sec   
  30     63900    18.25 MB/sec  execute 515 sec   
  30     64195    18.32 MB/sec  execute 516 sec   
  30     64520    18.38 MB/sec  execute 517 sec   
  30     64827    18.44 MB/sec  execute 518 sec   
  30     65161    18.50 MB/sec  execute 519 sec   
  30     65456    18.57 MB/sec  execute 520 sec   
  30     65696    18.61 MB/sec  execute 521 sec   
  30     65995    18.66 MB/sec  execute 522 sec   
  30     66315    18.72 MB/sec  execute 523 sec   
  30     66594    18.79 MB/sec  execute 524 sec   
  30     66867    18.86 MB/sec  execute 525 sec   
  30     67175    18.90 MB/sec  execute 526 sec   
  30     67401    18.92 MB/sec  execute 527 sec   
  30     67613    18.96 MB/sec  execute 528 sec   
  30     67872    19.00 MB/sec  execute 529 sec   
  30     68048    19.04 MB/sec  execute 530 sec   
  30     68234    19.05 MB/sec  execute 531 sec   
  30     68431    19.08 MB/sec  execute 532 sec   
  30     68685    19.11 MB/sec  execute 533 sec   
  30     68994    19.15 MB/sec  execute 534 sec   
  30     69074    19.14 MB/sec  execute 535 sec   
  30     69134    19.12 MB/sec  execute 536 sec   
  30     69434    19.17 MB/sec  execute 537 sec   
  30     69551    19.16 MB/sec  execute 538 sec   
  30     69551    19.13 MB/sec  execute 539 sec   
  30     69551    19.09 MB/sec  execute 540 sec   
  30     69551    19.06 MB/sec  execute 541 sec   
  30     69551    19.02 MB/sec  execute 542 sec   
  30     69551    18.99 MB/sec  execute 543 sec   
  30     69782    18.61 MB/sec  execute 557 sec   
  30     70043    18.66 MB/sec  execute 558 sec   
  30     70329    18.71 MB/sec  execute 559 sec   
  30     70594    18.74 MB/sec  execute 560 sec   
  30     70873    18.78 MB/sec  execute 561 sec   
  30     71176    18.83 MB/sec  execute 562 sec   
  30     71444    18.87 MB/sec  execute 563 sec   
  30     71722    18.93 MB/sec  execute 564 sec   
  30     72012    18.96 MB/sec  execute 565 sec   
  30     72257    19.01 MB/sec  execute 566 sec   
  30     72509    19.05 MB/sec  execute 567 sec   
  30     72745    19.09 MB/sec  execute 568 sec   
  30     72949    19.12 MB/sec  execute 569 sec   
  30     73154    18.85 MB/sec  execute 580 sec   
  30     73184    18.82 MB/sec  execute 581 sec   
  30     73195    18.79 MB/sec  execute 582 sec   
  30     73506    18.84 MB/sec  execute 583 sec   
  30     73681    18.86 MB/sec  execute 584 sec   
  30     73774    18.86 MB/sec  execute 585 sec   
  30     73905    18.85 MB/sec  execute 586 sec   
  30     74020    18.86 MB/sec  execute 587 sec   
  30     74103    18.85 MB/sec  execute 588 sec   
  30     74206    18.85 MB/sec  execute 589 sec   
  30     74337    18.85 MB/sec  execute 590 sec   
  30     74442    18.85 MB/sec  execute 591 sec   
  30     74581    18.85 MB/sec  execute 592 sec   
  30     74801    18.89 MB/sec  execute 593 sec   
  30     75102    18.93 MB/sec  execute 594 sec   
  30     75360    18.97 MB/sec  execute 595 sec   
  30     75676    19.01 MB/sec  execute 596 sec   
  30     75916    19.06 MB/sec  execute 597 sec   
  30     76208    19.09 MB/sec  execute 598 sec   
  30     76497    19.15 MB/sec  execute 599 sec   
  30     76721    19.18 MB/sec  execute 600 sec   
  30     77016    19.22 MB/sec  cleanup 601 sec   
  30     77016    19.19 MB/sec  cleanup 602 sec   
  30     77016    18.84 MB/sec  cleanup 612 sec   
  30     77016    18.69 MB/sec  cleanup 617 sec   
  30     77016    18.64 MB/sec  cleanup 619 sec   

Throughput 19.219 MB/sec 30 procs

--pf9I7BMVVzbSWLtt--

