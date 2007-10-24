Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbXJXFaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbXJXFaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 01:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754502AbXJXF36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 01:29:58 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55790 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422AbXJXF35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 01:29:57 -0400
Date: Wed, 24 Oct 2007 10:59:31 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russel <rusty@rustcorp.com.au>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Paul E McKenney <paulmck@us.ibm.com>,
       Richard Gooch <rgooch@atnf.csiro.au>,
       Tigran Aivazian <tigran@aivazian.fs.co.uk>,
       Shoahua Li <shaohua.li@linux.com>, Ralf Baechle <ralf@linux-mips.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Nathan Lynch <ntl@pobox.com>, David Miller <davem@davemloft.net>,
       Paul Jackson <pj@sgi.com>, Josh Triplett <josh@freedesktop.org>,
       Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Akinobu Mita <akinobu.mita@gmail.com>
Subject: [RFC PATCH 0/5] Refcount based Cpu Hotplug. V2
Message-ID: <20071024052931.GA22722@in.ibm.com>
Reply-To: ego@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

This is the version 2 of the refcount based cpu-hotplug "locking" 
implementation. 

It incorporates the review comments from the first posting which
can be found here --> http://lkml.org/lkml/2007/10/16/118.

Changes since v1:
- !CONFIG_HOTPLUG_CPU part is now handled correctly, thanks
  to the patch from Paul Jackson.

- The cpu_hotplug_begin() uses a waitqueue instead of a completion struct
  where a writer can wait while there are active readers in the system.

- Provided a new API's cpu_maps_update_begin(), cpu_maps_update_done()
  for serializing the updates to cpu_present_map and cpu_online_map.
  Thus threads which update the cpu_present_map should now call
  cpu_maps_update_begin instead of lock_cpu_hotplug(), since they play the
  role of writers.

- pseries_processor_add() , pseries_processor_remove() now use
  cpu_maps_update_begin()/cpu_maps_update_done() in place of
  lock_cpu_hotplug()/unlock_cpu_hotplug().

- Replaced the workqueue_mutex with workqueue_lock, which is a spinlock
  and guards the workqueues list.

- Updated Documentation/cpu-hotplug.txt to reflect get_online_cpus(), 
  put_online_cpus() in place of the old lock_cpu_hotplug(), 
  unlock_cpu_hotplug().

I'm Cc'ing the different subsystem maintainers who might be affected
by the changes in the patchstack. Especially if they rely on
lock_cpu_hotplug() to provide them protection for their local data 
structures as well.

The patchstack which is based against 2.6.23-mm1 has behaved well
when it was stress tested with kernbench running while continuously
performing cpu-hotplug operations on i386, x86_64 and ppc64.

Awaiting your feedback.

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
