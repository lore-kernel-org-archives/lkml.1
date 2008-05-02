Return-Path: <linux-kernel-owner+w=401wt.eu-S935056AbYEBQ6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935056AbYEBQ6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 12:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758971AbYEBQ5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 12:57:49 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41668 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372AbYEBQ5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 12:57:48 -0400
Date: Fri, 2 May 2008 19:57:44 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Russ Anderson <rja@sgi.com>
cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, Christoph Lameter <clameter@sgi.com>,
       gregkh@suse.de
Subject: Re: [PATCH 3/3] ia64: Call migration code on correctable errors v2
In-Reply-To: <20080502164044.GB7246@sgi.com>
Message-ID: <Pine.LNX.4.64.0805021945001.3341@sbz-30.cs.Helsinki.FI>
References: <20080502004425.GD12006@sgi.com>
 <84144f020805020258x56d4f915u5d826d8f19294d62@mail.gmail.com>
 <20080502164044.GB7246@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russ,

On Fri, 2 May 2008, Russ Anderson wrote:
> > I think sparse and checkpatch would have caught most of these but here goes:
> 
> I did run checkpatch.pl.  The two warnings were a false positive and
> the other I let slide.  I'll make the rest of your suggested changes.
> 
> WARNING: consider using strict_strtoul in preference to simple_strtoul
> #340: FILE: arch/ia64/kernel/cpe_migrate.c:301:
> +       opt = simple_strtoul(optstr, NULL, 0);

Why do you think this is a false positive? We just converted SLUB over to 
use strict_stroul() as suggested by Andrew.

> > >  +       if (cpe_paddr[cpe_head] == 0) {
> > >  +               cpe_paddr[cpe_head] = paddr;
> > >  +               cpe_node[cpe_head] = node;
> > >  +
> > >  +               if (++cpe_head >= CE_HISTORY_LENGTH)
> > >  +                       cpe_head = 0;
> > >  +       }
> > >  +
> > >  +       if (!work_scheduled) {
> > >  +               work_scheduled = 1;
> > >  +               schedule_work(&cpe_enable_work);
> > 
> > So you must not schedule cpe_enable_work if it's already in progress. Why?
> 
> If there is already a worker thread scheduled, it will process all
> the addresses on the queue, including new entries.  So all ce_setup_migrate()
> needs to do is add the new entry to the queue.  The CPE interrupt can come in faster
> than the worker thread can migrate the pages.  Scheduling another worker 
> thread on each CPE interrupt when there is already one scheduled/running
> would be overkill.

Okay. Maybe a kthread would be cleaner here then (which sleeps when the 
buffer is empty)? I didn't notice any locking for cpe_paddr and cpe_node. 
Why is that?

> > >  +       proc_badpage = create_proc_entry(BADRAM_BASENAME, 0644, NULL);
> > 
> > Why is this file not in sysfs?
> 
> /proc seemed like a appropriate place.  Where would you suggest in sysfs?

Oh, /proc is for _process specific_ files although historically it has 
been (ab)used for other files as well. I think something like 
/sys/kernel/badram would be appropriate. Christoph, Greg?

			Pekka
