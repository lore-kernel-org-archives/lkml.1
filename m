Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbZFPCVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbZFPCVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 22:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbZFPCVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 22:21:36 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:26649 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbZFPCVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 22:21:35 -0400
Subject: RE: [RFC PATCH 0/4]: affinity-on-next-touch
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Stefan Lankes <lankes@lfbs.rwth-aachen.de>
Cc: "'Andi Kleen'" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-numa@vger.kernel.org, Boris Bierbaum <boris@lfbs.rwth-aachen.de>,
       "'Brice Goglin'" <Brice.Goglin@inria.fr>
In-Reply-To: <000001c9eac4$cb8b6690$62a233b0$@rwth-aachen.de>
References: <000c01c9d212$4c244720$e46cd560$@rwth-aachen.de>
	 <87zldjn597.fsf@basil.nowhere.org>
	 <000001c9eac4$cb8b6690$62a233b0$@rwth-aachen.de>
Content-Type: text/plain
Organization: HP/LKTT
Date: Mon, 15 Jun 2009 22:21:33 -0400
Message-Id: <1245118893.6724.27.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-11 at 20:45 +0200, Stefan Lankes wrote:
> > Your patches seem to have a lot of overlap with
> > Lee Schermerhorn's old migrate memory on cpu migration patches.
> > I don't know the status of those.
> 
> I analyze Lee Schermerhorn's migrate memory on cpu migration patches
> (http://free.linux.hp.com/~lts/Patches/PageMigration/). I think that Lee
> Schermerhorn add similar functionalities to the kernel. He called the
> "affinity-on-next-touch" functionality "migrate_on_fault" and uses in his
> patches the normal NUMA memory policies. Therefore, his solution fits better
> to the Linux kernel. I tested his patches with our test applications and got
> nearly the same performance results. 
> 
> I found only patches for the kernel 2.6.25-rc2-mm1. Does someone develop
> these patches further?

Sorry for the delay.  I was offline for a long weekend. 

Regarding the patches:  I was rebasing them every few mmotm releases
until I ran into trouble with the memory controller handling of page
migration conflicting with migrating in the fault path and haven't had
time to investigate a solution.

Here's the problem I have:

when migrating a page with memory controller configured, the migration
code [mem_cgroup_prepare_migration()] tentatively charges the page
against the control group.  Then, when migration completes, it calls
mem_cgroup_end_migration() to commit [or cancel?] the charge.  Migration
on fault operates on an anon page in the page cache that has zero pte
references [page_mapcount(page) == 0] in do_swap_page().  do_swap_page()
does a mem_cgroup_try_charge_swapin() that also tentatively charges the
page.  I don't try to migrate the page unless this succeeds.  No sense
in doing all that work if the cgroup can't afford the page.

But, this ends up with nested "tentative charges" against the page when
I call down into the migration code via migrate_misplaced_page() and I
was having problems getting the ref counting correct.   It would bug out
under load.

What I want to do is see if the page migration code can "atomically
transfer" the page charge [including any tentative charge from
do_swap_page()] down in migrate_page_copy(), the way all other page
state is copied.  Haven't had time to see whether this is feasible.

Regards,
Lee
 

