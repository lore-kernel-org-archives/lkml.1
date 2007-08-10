Return-Path: <linux-kernel-owner+w=401wt.eu-S940608AbXHJQrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940608AbXHJQrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 12:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932531AbXHJQqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 12:46:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35586 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935524AbXHJQqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 12:46:53 -0400
Date: Fri, 10 Aug 2007 09:46:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: "Miles Lane" <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       "shannon.nelson@intel.com" <shannon.nelson@intel.com>,
       "Luck, Tony" <tony.luck@intel.com>
Subject: Re: 2.6.23-rc2-mm1 -- drivers/dma/ioat_dca.c:177: error: implicit
 declaration of function ___cpu_physical_id___
Message-Id: <20070810094601.fa436707.akpm@linux-foundation.org>
In-Reply-To: <200708101527.42628.ak@suse.de>
References: <a44ae5cd0708090718v5dc19572k69087f170f9ba857@mail.gmail.com>
	<20070809115258.5372f76e.akpm@linux-foundation.org>
	<200708101527.42628.ak@suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 15:27:42 +0200 Andi Kleen <ak@suse.de> wrote:

> On Thursday 09 August 2007 20:52:58 Andrew Morton wrote:
> > On Thu, 9 Aug 2007 10:18:15 -0400
> > "Miles Lane" <miles.lane@gmail.com> wrote:
> > 
> > >   CC      drivers/dma/ioat_dca.o
> > > drivers/dma/ioat_dca.c: In function 'ioat_dca_get_tag':
> > > drivers/dma/ioat_dca.c:177: error: implicit declaration of function
> > > 'cpu_physical_id'
> > 
> > Looks like cpu_physical_id() doesn't get implemented if CONFIG_SMP=n.
> > 
> > Either ioat needs to stop using cpu_physical_id() if SMP=n, or the
> > supported architectures (i386, x86_64, ia64) should provide a non-SMP
> > version of cpu_physical_id().  Preferably the latter, I'd say.
> 
> 
> It doesn't make much sense in smp.h because there is not really
> a concept of physical id on most architectures i expect. Better 
> to put it into the individual asm files.
> 

I gave up and did this:

From: Andrew Morton <akpm@linux-foundation.org>

drivers/dma/ioat_dca.c: In function 'ioat_dca_get_tag':
drivers/dma/ioat_dca.c:177: error: implicit declaration of function 'cpu_physical_id'

This is soooo screwed up.  Root cause: linux/smp.h only includes asm/smp.h if
CONFIG_SMP=y.

To get at cpu_physical_id() on UP, the user must include asm/smp.h, not
linux/smp.h.

Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Shannon Nelson <shannon.nelson@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/ioat_dca.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/dma/ioat_dca.c~git-dma-up-fix drivers/dma/ioat_dca.c
--- a/drivers/dma/ioat_dca.c~git-dma-up-fix
+++ a/drivers/dma/ioat_dca.c
@@ -25,6 +25,9 @@
 #include <linux/smp.h>
 #include <linux/interrupt.h>
 #include <linux/dca.h>
+
+#include <asm/smp.h>
+
 #include "ioatdma.h"
 #include "ioatdma_registers.h"
 
_

