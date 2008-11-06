Return-Path: <linux-kernel-owner+w=401wt.eu-S1753626AbYKFIPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbYKFIPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 03:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbYKFIPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 03:15:10 -0500
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:65195 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbYKFIPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 03:15:09 -0500
Message-ID: <4912A73C.4080308@fr.ibm.com>
Date: Thu, 06 Nov 2008 09:13:48 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       Matt Helsley <matthltc@us.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH -last version] freezer_cg: disable writing freezer.state
 of root  cgroup
References: <491245F1.5070707@cn.fujitsu.com> <6599ad830811051724p1f97026fl96be5efe38b33152@mail.gmail.com> <49124DFF.1090702@cn.fujitsu.com> <49125006.4050206@cn.fujitsu.com>
In-Reply-To: <49125006.4050206@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Li ! 

Li Zefan wrote:
> Li Zefan wrote:
>>> Acked-by: Paul Menage <menage@google.com>
>>>
>>> I might use the term "non-freezable" rather than "unfreezable".
>>>
>> My bad English :(
>>
>> patch updated. (some annoying leading tabs are also removed in the doc)
>>
> 
> And I forgot to s/EIO/EINVAL in the document..
> 
> This patch should be the last version.. Sorry for the bothering.
> 
> 
> ======================
> 
> From: Li Zefan <lizf@cn.fujitsu.com>
> Date: Tue, 4 Nov 2008 15:26:29 +0800
> Subject: [PATCH] freezer_cg: disable writing freezer.state of root cgroup
> 
> With this change, control file 'freezer.state' doesn't exist in root
> cgroup, making root cgroup unfreezable.
> 
> I think it's reasonable to disallow freeze tasks in the root cgroup.
> And then we can avoid fork overhead when freezer subsystem is
> compiled but not used.
> 
> Also make writing invalid value to freezer.state returns EINVAL
> rather than EIO. This is more consistent with other cgroup subsystem.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> Acked-by: Paul Menage <menage@google.com>

It looks fine 

Acked-by: Cedric Le Goater <clg@fr.ibm.com>

I've also tested it.

here's a minor comment,

I would make a small macro is_root_freezer() to show explicitly
what we are testing and use the CSS_ROOT bit to test. That's what
the CSS_ROOT bit is for Paul ?

if yes, here's a possible result is below. 

C.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
---
 kernel/cgroup_freezer.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

Index: 2.6.27-lxc/kernel/cgroup_freezer.c
===================================================================
--- 2.6.27-lxc.orig/kernel/cgroup_freezer.c
+++ 2.6.27-lxc/kernel/cgroup_freezer.c
@@ -47,6 +47,11 @@ static inline struct freezer *task_freez
 			    struct freezer, css);
 }
 
+static inline int is_root_freezer(struct freezer *freezer)
+{
+	return test_bit(CSS_ROOT, &freezer->css.flags);
+}
+
 int cgroup_frozen(struct task_struct *task)
 {
 	struct freezer *freezer;
@@ -190,6 +195,13 @@ static void freezer_fork(struct cgroup_s
 	freezer = task_freezer(task);
 	task_unlock(task);
 
+	/*
+	 * The root cgroup is non-freezable, so we can skip the
+	 * following check.
+	 */
+	if (is_root_freezer(freezer))
+		return;
+
 	BUG_ON(freezer->state == CGROUP_FROZEN);
 	spin_lock_irq(&freezer->lock);
 	/* Locking avoids race with FREEZING -> THAWED transitions. */
@@ -363,6 +375,9 @@ static struct cftype files[] = {
 
 static int freezer_populate(struct cgroup_subsys *ss, struct cgroup *cgroup)
 {
+	if (is_root_freezer(cgroup_freezer(cgroup)))
+		return 0;
+
 	return cgroup_add_files(cgroup, ss, files, ARRAY_SIZE(files));
 }
