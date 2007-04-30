Return-Path: <linux-kernel-owner+w=401wt.eu-S1946541AbXD3R67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946541AbXD3R67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 13:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946547AbXD3R67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 13:58:59 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:51934 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946541AbXD3R65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 13:58:57 -0400
Date: Mon, 30 Apr 2007 23:36:53 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: "Paul Jackson" <pj@sgi.com>, akpm@linux-foundation.org, dev@sw.ru,
       xemul@sw.ru, serue@us.ibm.com, ebiederm@xmission.com,
       haveblue@us.ibm.com, svaidy@linux.vnet.ibm.com, balbir@in.ibm.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, containers@lists.osdl.org,
       devel@openvz.org
Subject: Re: [PATCH 0/9] Containers (V9): Generic Process Containers
Message-ID: <20070430180653.GA31001@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070427104607.252541000@menage.corp.google.com> <20070429023721.53f249b9.pj@sgi.com> <20070430171225.GH24350@in.ibm.com> <6599ad830704301009k11100a78we98e20deba9b1fdc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830704301009k11100a78we98e20deba9b1fdc@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 10:09:38AM -0700, Paul Menage wrote:
> Paul, is there any reason why we need to do a write_lock() on
> tasklist_lock if we're just trying to block fork, or is it just
> historical accident? Wouldn't it be fine to do a read_lock()?

Good point ..read_lock() will probably suffice in update_nodemask which
means we don't need the patch I sent earlier.

Paul (Jackson),
	This made me see another race in update_nodemask vs fork:

Lets say cpuset CS1 has only one task T1 to begin with.

update_nodemask(CS1)			T1 in do_fork()
	CPU0				     CPU1
=============================================================


					cpuset_fork();
					mpol_copy();


ntasks = atomic_read(&cs->count);
[ntasks = 2, accounting new born child T2]
cs->mems_allowed = something;
set_cpuset_being_rebound()


write/read_lock(tasklist_lock);


do_each_thread {

	/* Finds only T1 */

	mmarray[] = ..

} while_each_thread();

write/read_unlock(tasklist_lock);

					write_lock(tasklist_lock);

					/* Add T2, child of T1 to tasklist */

					write_unlock(tasklist_lock);


for (i = 0; i < n; i++) {

	mpol_rebind_mm(..);

}


In this for loop, we migrate only T1's ->mm. T2's->mm isn't migrated
AFAICS.

Is that fine?

-- 
Regards,
vatsa
