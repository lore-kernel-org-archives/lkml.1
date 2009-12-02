Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbZLBP3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbZLBP3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 10:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbZLBP3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 10:29:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830AbZLBP3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 10:29:32 -0500
Date: Wed, 2 Dec 2009 10:27:22 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Divyesh Shah <dpshah@google.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       lizf@cn.fujitsu.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: Re: [PATCH 06/21] blkio: Introduce blkio controller cgroup
	interface
Message-ID: <20091202152722.GD31715@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com> <1259549968-10369-7-git-send-email-vgoyal@redhat.com> <af41c7c40911301604k1580bcafg9ef7aa7445ba5d17@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <af41c7c40911301604k1580bcafg9ef7aa7445ba5d17@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 01, 2009 at 05:34:37AM +0530, Divyesh Shah wrote:
> On Mon, Nov 30, 2009 at 8:29 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > o This is basic implementation of blkio controller cgroup interface. This is
> >  the common interface visible to user space and should be used by different
> >  IO control policies as we implement those.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  block/Kconfig                 |   13 +++
> >  block/Kconfig.iosched         |    1 +
> >  block/Makefile                |    1 +
> >  block/blk-cgroup.c            |  177 +++++++++++++++++++++++++++++++++++++++++
> >  block/blk-cgroup.h            |   58 +++++++++++++
> >  include/linux/cgroup_subsys.h |    6 ++
> >  include/linux/iocontext.h     |    4 +
> >  7 files changed, 260 insertions(+), 0 deletions(-)
> >  create mode 100644 block/blk-cgroup.c
> >  create mode 100644 block/blk-cgroup.h
> >
> > diff --git a/block/Kconfig b/block/Kconfig
> > index 9be0b56..6ba1a8e 100644
> > --- a/block/Kconfig
> > +++ b/block/Kconfig
> > @@ -77,6 +77,19 @@ config BLK_DEV_INTEGRITY
> >        T10/SCSI Data Integrity Field or the T13/ATA External Path
> >        Protection.  If in doubt, say N.
> >
> > +config BLK_CGROUP
> > +       bool
> > +       depends on CGROUPS
> > +       default n
> > +       ---help---
> > +       Generic block IO controller cgroup interface. This is the common
> > +       cgroup interface which should be used by various IO controlling
> > +       policies.
> > +
> > +       Currently, CFQ IO scheduler uses it to recognize task groups and
> > +       control disk bandwidth allocation (proportional time slice allocation)
> > +       to such task groups.
> > +
> >  endif # BLOCK
> >
> >  config BLOCK_COMPAT
> > diff --git a/block/Kconfig.iosched b/block/Kconfig.iosched
> > index 8bd1051..be0280d 100644
> > --- a/block/Kconfig.iosched
> > +++ b/block/Kconfig.iosched
> > @@ -23,6 +23,7 @@ config IOSCHED_DEADLINE
> >
> >  config IOSCHED_CFQ
> >        tristate "CFQ I/O scheduler"
> > +       select BLK_CGROUP
> >        default y
> >        ---help---
> >          The CFQ I/O scheduler tries to distribute bandwidth equally
> > diff --git a/block/Makefile b/block/Makefile
> > index 7914108..cb2d515 100644
> > --- a/block/Makefile
> > +++ b/block/Makefile
> > @@ -8,6 +8,7 @@ obj-$(CONFIG_BLOCK) := elevator.o blk-core.o blk-tag.o blk-sysfs.o \
> >                        blk-iopoll.o ioctl.o genhd.o scsi_ioctl.o
> >
> >  obj-$(CONFIG_BLK_DEV_BSG)      += bsg.o
> > +obj-$(CONFIG_BLK_CGROUP)       += blk-cgroup.o
> >  obj-$(CONFIG_IOSCHED_NOOP)     += noop-iosched.o
> >  obj-$(CONFIG_IOSCHED_DEADLINE) += deadline-iosched.o
> >  obj-$(CONFIG_IOSCHED_CFQ)      += cfq-iosched.o
> > diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> > new file mode 100644
> > index 0000000..4f6afd7
> > --- /dev/null
> > +++ b/block/blk-cgroup.c
> > @@ -0,0 +1,177 @@
> > +/*
> > + * Common Block IO controller cgroup interface
> > + *
> > + * Based on ideas and code from CFQ, CFS and BFQ:
> > + * Copyright (C) 2003 Jens Axboe <axboe@kernel.dk>
> > + *
> > + * Copyright (C) 2008 Fabio Checconi <fabio@gandalf.sssup.it>
> > + *                   Paolo Valente <paolo.valente@unimore.it>
> > + *
> > + * Copyright (C) 2009 Vivek Goyal <vgoyal@redhat.com>
> > + *                   Nauman Rafique <nauman@google.com>
> > + */
> > +#include <linux/ioprio.h>
> > +#include "blk-cgroup.h"
> > +
> > +struct blkio_cgroup blkio_root_cgroup = { .weight = 2*BLKIO_WEIGHT_DEFAULT };
> 
> This should use BLKIO_WEIGHT_MAX as 2*BLKIO_WEIGHT_DEFAULT is same as
> BLKIO_WEIGHT_MAX unless there is a reason why you would want the value
> to remain as a multiple of default_weight instead of max in case the
> constants change later.
> 

Hi Divyesh,

Every new group gets the weight as BLKIO_WEIGHT_DEFAULT. For root group by 
default I wanted to give it double the weight to begin with as it will
have all the async queues, will also have all the sync-noidle queues 
(in case of group_isolation=0) and will be doing all the system IO.

That's a different thing that 2*BLKIO_WEIGHT_DEFAULT happens to be same
as BLKIO_WEIGHT_MAX.

So functionality wise it does not change anything. It is just a matter of
what is more intutive as a root group default.

To me 2*BLKIO_WEIGHT_DEFAULT looks just fine. So I will keep it as it is,
unless you really think that it is not intutive and BLKIO_WEIGHT_MAX is
more intutive.

Thanks
Vivek
