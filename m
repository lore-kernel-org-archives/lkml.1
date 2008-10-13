Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbYJMOx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbYJMOx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 10:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756843AbYJMOxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 10:53:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63087 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858AbYJMOxo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 10:53:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [Cbe-oss-dev] powerpc/cell/oprofile: fix mutex locking for spu-oprofile
Date: Mon, 13 Oct 2008 16:53:28 +0200
User-Agent: KMail/1.9.9
Cc: Paul Mackerras <paulus@samba.org>, Robert Richter <robert.richter@amd.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       oprofile-list@lists.sourceforge.net, cel <cel@linux.vnet.ibm.com>,
       cbe-oss-dev@ozlabs.org, benh@kernel.crashing.org
References: <1217620879.15667.145.camel@carll-linux-desktop> <18610.20951.764057.574721@cargo.ozlabs.ibm.com> <200808250955.57638.arnd@arndb.de>
In-Reply-To: <200808250955.57638.arnd@arndb.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810131653.29631.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18OGgfeH8VF4BU67AprYrQFiRV4kLyO0eTpyJZ
 yn+tx1Dbzyb4zadOPKAZ6P+1n1ORnwYCTxNEg5/aI6V+8yiiPm
 FJGitjqi/VREZxyWcnWEw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 August 2008, Arnd Bergmann wrote:
> On Monday 25 August 2008, Paul Mackerras wrote:
> > 
> > > Since rc4 is out now, I understand if you feel more comfortable with
> > > putting the patch into -next instead of -merge.
> > 
> > Linus has been getting stricter about only putting in fixes for
> > regressions and serious bugs (see his recent email to Dave Airlie on
> > LKML for instance).  I assume that the corruption is just in the data
> > that is supplied to userspace and doesn't extend to any kernel data
> > structures.
> 
> That's right, please queue it for -next then.

I just realized that this patch never made it into powerpc-next after
all, neither benh nor paulus version. Whoever is handling it today,
could you please pull

 master.kernel.org:/pub/scm/linux/kernel/git/arnd/cell-2.6.git merge

to get this commit below. I have rebased it on top of the current
benh/powerpc/next branch.

Thanks,

	Arnd <><

---

commit aa5810fa545515c9f383e3e649bd120bef9c7f29
Author: Carl Love <cel@us.ibm.com>
Date:   Fri Aug 8 15:38:36 2008 -0700

    powerpc/cell/oprofile: fix mutex locking for spu-oprofile

    The issue is the SPU code is not holding the kernel mutex lock while
    adding samples to the kernel buffer.

    This patch creates per SPU buffers to hold the data.  Data
    is added to the buffers from in interrupt context.  The data
    is periodically pushed to the kernel buffer via a new Oprofile
    function oprofile_put_buff(). The oprofile_put_buff() function
    is called via a work queue enabling the funtion to acquire the
    mutex lock.

    The existing user controls for adjusting the per CPU buffer
    size is used to control the size of the per SPU buffers.
    Similarly, overflows of the SPU buffers are reported by
    incrementing the per CPU buffer stats.  This eliminates the
    need to have architecture specific controls for the per SPU
    buffers which is not acceptable to the OProfile user tool
    maintainer.

    The export of the oprofile add_event_entry() is removed as it
    is no longer needed given this patch.

    Note, this patch has not addressed the issue of indexing arrays
    by the spu number.  This still needs to be fixed as the spu
    numbering is not guarenteed to be 0 to max_num_spus-1.

    Signed-off-by: Carl Love <carll@us.ibm.com>
    Signed-off-by: Maynard Johnson <maynardj@us.ibm.com>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: Acked-by: Robert Richter <robert.richter@amd.com>

 arch/powerpc/oprofile/cell/pr_util.h       |   13 +
 arch/powerpc/oprofile/cell/spu_profiler.c  |    4
 arch/powerpc/oprofile/cell/spu_task_sync.c |  236 ++++++++++++++++++++++++---
 drivers/oprofile/buffer_sync.c             |   24 ++
 drivers/oprofile/cpu_buffer.c              |   15 +
 drivers/oprofile/event_buffer.c            |    2
 drivers/oprofile/event_buffer.h            |    7
 include/linux/oprofile.h                   |   16 +
 drivers/oprofile/cpu_buffer.c              |    4
 9 files changed, 284 insertions(+), 37 deletions(-)
