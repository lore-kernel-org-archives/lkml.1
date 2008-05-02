Return-Path: <linux-kernel-owner+w=401wt.eu-S1764086AbYEBQk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764086AbYEBQk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 12:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757395AbYEBQkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 12:40:47 -0400
Received: from relay1.sgi.com ([192.48.171.29]:40965 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755824AbYEBQkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 12:40:46 -0400
Date: Fri, 2 May 2008 11:40:44 -0500
From: Russ Anderson <rja@sgi.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 3/3] ia64: Call migration code on correctable errors v2
Message-ID: <20080502164044.GB7246@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20080502004425.GD12006@sgi.com> <84144f020805020258x56d4f915u5d826d8f19294d62@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020805020258x56d4f915u5d826d8f19294d62@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 12:58:12PM +0300, Pekka Enberg wrote:
> Hi Russ,
> 
> On Fri, May 2, 2008 at 3:44 AM, Russ Anderson <rja@sgi.com> wrote:
> > Migrate data off pages with correctable memory errors.  This patch is the
> >  ia64 specific piece.  It connects the CPE handler to the page migration
> >  code.  It is implemented as a kernel loadable module, similar to the mca
> >  recovery code (mca_recovery.ko).  This allows the feature to be turned off
> >  by uninstalling the module.  Creates /proc/badram to display bad page
> >  information and free bad pages.
> >
> >  Signed-off-by: Russ Anderson <rja@sgi.com>
> 
> I think sparse and checkpatch would have caught most of these but here goes:

I did run checkpatch.pl.  The two warnings were a false positive and
the other I let slide.  I'll make the rest of your suggested changes.

---
linux> scripts/checkpatch.pl ../patches/cpe.migrate.v2
WARNING: Use #include <linux/mca.h> instead of <asm/mca.h>
#80: FILE: arch/ia64/kernel/cpe_migrate.c:41:
+#include <asm/mca.h>

WARNING: consider using strict_strtoul in preference to simple_strtoul
#340: FILE: arch/ia64/kernel/cpe_migrate.c:301:
+       opt = simple_strtoul(optstr, NULL, 0);

total: 0 errors, 2 warnings, 548 lines checked
---
 
> >  +       if (cpe_paddr[cpe_head] == 0) {
> >  +               cpe_paddr[cpe_head] = paddr;
> >  +               cpe_node[cpe_head] = node;
> >  +
> >  +               if (++cpe_head >= CE_HISTORY_LENGTH)
> >  +                       cpe_head = 0;
> >  +       }
> >  +
> >  +       if (!work_scheduled) {
> >  +               work_scheduled = 1;
> >  +               schedule_work(&cpe_enable_work);
> 
> So you must not schedule cpe_enable_work if it's already in progress. Why?

If there is already a worker thread scheduled, it will process all
the addresses on the queue, including new entries.  So all ce_setup_migrate()
needs to do is add the new entry to the queue.  The CPE interrupt can come in faster
than the worker thread can migrate the pages.  Scheduling another worker 
thread on each CPE interrupt when there is already one scheduled/running
would be overkill.


> >  +       proc_badpage = create_proc_entry(BADRAM_BASENAME, 0644, NULL);
> 
> Why is this file not in sysfs?

/proc seemed like a appropriate place.  Where would you suggest in sysfs?

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
