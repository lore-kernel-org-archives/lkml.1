Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440AbYHINNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbYHINNb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 09:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbYHINNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 09:13:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57467 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbYHINNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 09:13:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Mackerras <paulus@samba.org>
Subject: please pull cell merge branch
Date: Sat, 9 Aug 2008 15:13:04 +0200
User-Agent: KMail/1.9.9
Cc: Carl Love <cel@us.ibm.com>, linuxppc-dev@ozlabs.org,
       cel <cel@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, cbe-oss-dev@ozlabs.org,
       benh@kernel.crashing.org
References: <1217620879.15667.145.camel@carll-linux-desktop> <200808081526.21405.arnd@arndb.de> <1218235184.6637.111.camel@carll-linux-desktop>
In-Reply-To: <1218235184.6637.111.camel@carll-linux-desktop>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808091513.05251.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+DLX7P7U7LbKs3v3ZkGu8cTHpCFRtuUbmZnaL
 OXMk2nWpmuHQpem6zuFPtGjevrK34U797TigCwSMjW7Rfa7MSl
 jXnMf/gJSBKS8xUav9aFg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

I've fixed one last bug in Carl's update for cell-oprofile (int flags
instead of unsigned long flags) and made sure the comments fit the
usual style. This fixes a long-standing bug that prevented us from
using oprofile on SPUs in many real-world scenarios. Please
pull from

 master.kernel.org:/pub/scm/linux/kernel/git/arnd/cell-2.6.git merge

so we can get it fixed in 2.6.27-rc3. Sorry for the size of the patch
so late after the merge window, unfortunately it wasn't possible to
fix the problem in a simpler way.

	Arnd <><

---

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

commit f90a87b5f5fa46dc6c556e9267a6f25a95fbef14
Author: Carl Love <cel@us.ibm.com>
Date:   Fri Aug 8 15:39:44 2008 -0700

    powerpc/cell/oprofile: avoid double free of profile buffer

    If an error occurs on opcontrol start, the event and per cpu buffers
    are released.  If later opcontrol shutdown is called then the free
    function will be called again to free buffers that no longer
    exist.  This results in a kernel oops.  The following changes
    prevent the call to delete buffers that don't exist.

    Signed-off-by: Carl Love <carll@us.ibm.com>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

commit 70f546a7262c6f67b87e875a542f315f8b9a7c17
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

