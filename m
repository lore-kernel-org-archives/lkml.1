Return-Path: <linux-kernel-owner+w=401wt.eu-S1758565AbZD1EZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565AbZD1EZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 00:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbZD1EZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 00:25:27 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41819 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbZD1EZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 00:25:26 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: meminfo Committed_AS underflows
Cc: kosaki.motohiro@jp.fujitsu.com, balbir@linux.vnet.ibm.com,
       dave@linux.vnet.ibm.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, ebmunson@us.ibm.com,
       mel@linux.vnet.ibm.com, cl@linux-foundation.org, stable@kernel.org
In-Reply-To: <20090427202707.9d36ce8a.akpm@linux-foundation.org>
References: <20090428092400.EBB6.A69D9226@jp.fujitsu.com> <20090427202707.9d36ce8a.akpm@linux-foundation.org>
Message-Id: <20090428130035.EBB9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 28 Apr 2009 13:25:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > > > >  	committed = atomic_long_read(&vm_committed_space);
> > > > > > > +	if (committed < 0)
> > > > > > > +		committed = 0;
> > > > > > 
> > > 
> > > Is there a reason why we can't use a boring old percpu_counter for
> > > vm_committed_space?  That way the meminfo code can just use
> > > percpu_counter_read_positive().
> > > 
> > > Or perhaps just percpu_counter_read().  The percpu_counter code does a
> > > better job of handling large cpu counts than the
> > > mysteriously-duplicative open-coded stuff we have there.
> > 
> > At that time, I thought smallest patch is better because it can send -stable
> > tree easily.
> > but maybe I was wrong. it made bikeshed discussion :(
> 
> Yes, I know what you mean.  But otoh it's a good idea to keep -stable
> in sync with mainline - it means that -stable can merge things which
> have had a suitable amount of testing.

Agreed.


> > Reported-by: Dave Hansen <dave@linux.vnet.ibm.com>
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Cc: Eric B Munson <ebmunson@us.ibm.com>
> > ---
> >  fs/proc/meminfo.c    |    2 +-
> >  include/linux/mman.h |    9 +++------
> >  mm/mmap.c            |   12 ++++++------
> >  mm/nommu.c           |   13 +++++++------
> >  mm/swap.c            |   46 ----------------------------------------------
> >  5 files changed, 17 insertions(+), 65 deletions(-)
> 
> Well that was nice.
> 
> There's potential here for weird performance regressions, so I think
> that if we do this in mainline, we should wait a while (a few weeks?)
> before backporting it.
> 
> Do we know how long this bug has existed for?  Quite a while, I expect?

ACCT_THRESHOLD was introduced bit-keeper age.
powerpc default NR_CPUS is still less 128.

% grep NR_CPUS *
cell_defconfig:CONFIG_NR_CPUS=4
celleb_defconfig:CONFIG_NR_CPUS=4
chrp32_defconfig:CONFIG_NR_CPUS=4
g5_defconfig:CONFIG_NR_CPUS=4
iseries_defconfig:CONFIG_NR_CPUS=32
maple_defconfig:CONFIG_NR_CPUS=4
mpc86xx_defconfig:CONFIG_NR_CPUS=2
pasemi_defconfig:CONFIG_NR_CPUS=2
ppc64_defconfig:CONFIG_NR_CPUS=32
ps3_defconfig:CONFIG_NR_CPUS=2
pseries_defconfig:CONFIG_NR_CPUS=128

powerpc maximum NR_CPUS was increased following commit.
I'm not sure about one year is short or long.

==========================================================
commit 90035fe378c7459ba19c43c63d5f878284224ce4
Author: Tony Breeds <tony@bakeyournoodle.com>
Date:   Thu Apr 24 13:43:49 2008 +1000

    [POWERPC] Raise the upper limit of NR_CPUS and move the pacas into the BSS

    This adds the required functionality to fill in all pacas at runtime.

    With NR_CPUS=1024
    text    data     bss     dec     hex filename
     137 1704032       0 1704169  1a00e9 arch/powerpc/kernel/paca.o :Before
     121 1179744  524288 1704153  1a00d9 arch/powerpc/kernel/paca.o :After

    Also remove unneeded #includes from arch/powerpc/kernel/paca.c

    Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
    Signed-off-by: Paul Mackerras <paulus@samba.org>

diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 5fc7fac..f7efaa9 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -220,8 +220,8 @@ config SMP
          If you don't know what to do here, say N.

 config NR_CPUS
-       int "Maximum number of CPUs (2-128)"
-       range 2 128
+       int "Maximum number of CPUs (2-1024)"
+       range 2 1024
        depends on SMP
        default "32" if PPC64
        default "4"



