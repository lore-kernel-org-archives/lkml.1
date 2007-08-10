Return-Path: <linux-kernel-owner+w=401wt.eu-S1760954AbXHJROL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760954AbXHJROL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 13:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbXHJRN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 13:13:57 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37073 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbXHJRN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 13:13:56 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Alexey Dobriyan <adobriyan@sw.ru>
Subject: Re: 2.6.23-rc2-mm2
References: <20070809224254.11f42716.akpm@linux-foundation.org>
	<46BC7BDA.3000305@googlemail.com>
	<6bffcb0e0708100805i417834e5t87a1ebf122c1e264@mail.gmail.com>
	<m11webz8dx.fsf@ebiederm.dsl.xmission.com>
	<20070810160519.GA27500@elte.hu>
Date: Fri, 10 Aug 2007 11:12:55 -0600
In-Reply-To: <20070810160519.GA27500@elte.hu> (Ingo Molnar's message of "Fri,
	10 Aug 2007 18:05:19 +0200")
Message-ID: <m1odhfxqi0.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> Yes.  For the sched debug case I sent Ingo and friends but apparently 
>> other changes in Ingos tree kept it from applying and Andrew dropped 
>> it.  So instead the code now screams at you and refuses to register 
>> Ingo sysctl table.
>
> the commit below is now upstream - is your patch still needed?

Ok.  I missed that.  Duh.  I just saw Andrews drop message.

This looks like Alexey respun my patch, or else we were thinking on
parallel paths.  Probably parallel given Alexey's dislike of 
using the CTL_UNNUMBERED define.

There are two remaining gotchas:
- The directories have impossible permissions (writeable).

- The ctl_name for the kernel directory is inconsistent with
  everything else.  It should be CTL_KERN.

I think the patch below fixes that up but I haven't had a chance to
test it yet.

I kind of feel bad about being so picky but the this code is the
only place in the kernel where I have seen us violate either
of those rules, and it is a lot easier to deal with things
when they are consistent.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

diff --git a/kernel/sched.c b/kernel/sched.c
index b0afd8d..47afd80 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5223,15 +5223,16 @@ static void migrate_dead_tasks(unsigned int dead_cpu)
 static struct ctl_table sd_ctl_dir[] = {
 	{
 		.procname	= "sched_domain",
-		.mode		= 0755,
+		.mode		= 0555,
 	},
 	{0,},
 };
 
 static struct ctl_table sd_ctl_root[] = {
 	{
+		.ctl_name	= CTL_KERN,
 		.procname	= "kernel",
-		.mode		= 0755,
+		.mode		= 0555,
 		.child		= sd_ctl_dir,
 	},
 	{0,},
@@ -5307,7 +5308,7 @@ static ctl_table *sd_alloc_ctl_cpu_table(int cpu)
 	for_each_domain(cpu, sd) {
 		snprintf(buf, 32, "domain%d", i);
 		entry->procname = kstrdup(buf, GFP_KERNEL);
-		entry->mode = 0755;
+		entry->mode = 0555;
 		entry->child = sd_alloc_ctl_domain_table(sd);
 		entry++;
 		i++;
@@ -5327,7 +5328,7 @@ static void init_sched_domain_sysctl(void)
 	for (i = 0; i < cpu_num; i++, entry++) {
 		snprintf(buf, 32, "cpu%d", i);
 		entry->procname = kstrdup(buf, GFP_KERNEL);
-		entry->mode = 0755;
+		entry->mode = 0555;
 		entry->child = sd_alloc_ctl_cpu_table(i);
 	}
 	sd_sysctl_header = register_sysctl_table(sd_ctl_root);
