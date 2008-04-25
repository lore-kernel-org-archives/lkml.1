Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbYDYFwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbYDYFwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 01:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754468AbYDYFwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 01:52:08 -0400
Received: from smtp-out.google.com ([216.239.33.17]:5797 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbYDYFwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 01:52:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=tLQ4teqHiKtcftB0iJVCkBzyAP6LgwqI4bJ1XXFY1S91fyw0sHPSOVuvTsSLsohHC
	I+LR8+fhYPaLwJ+J8EVLQ==
Message-ID: <6599ad830804242251w439dd712tc1919b489535c74c@mail.gmail.com>
Date: Thu, 24 Apr 2008 22:51:57 -0700
From: "Paul Menage" <menage@google.com>
To: "Matt Helsley" <matthltc@us.ibm.com>
Subject: Re: [RFC][PATCH 3/5] Container Freezer: Implement freezer cgroup subsystem
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       "Cedric Le Goater" <clg@fr.ibm.com>,
       "Oren Laadan" <orenl@cs.columbia.edu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Pavel Machek" <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       "Linux Containers" <containers@lists.linux-foundation.org>
In-Reply-To: <20080424064757.526468716@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080424064756.643890130@us.ibm.com>
	 <20080424064757.526468716@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>+static const char *freezer_state_strs[] = {
>+	"RUNNING\n",
>+	"FREEZING\n" ,
>+	"FROZEN\n"
>+};

I think it might be cleaner to not include the \n characters in this array.

>+static inline int cgroup_frozen(struct task_struct *task)
>+{
>+	struct cgroup *cgroup = task_cgroup(task, freezer_subsys_id);
>+	struct freezer *freezer = cgroup_freezer(cgroup);
>+	enum freezer_state state;
>+
>+	spin_lock(&freezer->lock);
>+	state = freezer->state;
>+	spin_unlock(&freezer->lock);
>+
>+	return (state == STATE_FROZEN);
>+}

You need to be in an RCU critical section or else hold task_lock() in
order to dereference the cgroup returned from task_cgroup()

I'm not sure that you need to take freezer->lock here - you're just
reading a single word.

>+
>+	if (!capable(CAP_SYS_ADMIN))
>+		return ERR_PTR(-EPERM);
>+

Why does everyone keep throwing calls to check CAP_SYS_ADMIN into
their cgroup create callbacks? You have to be root in order to mount a
cgroups hierarchy in the first place, and filesystem permissions will
control who can create new cgroups.

>+static int freezer_can_attach(struct cgroup_subsys *ss,
>+			      struct cgroup *new_cgroup,
>+			      struct task_struct *task)
>+{
>+	struct freezer *freezer = cgroup_freezer(new_cgroup);
>+	int retval = 0;
>+
>+	if (freezer->state == STATE_FROZEN)
>+		retval = -EBUSY;
>+
>+	return retval;
>+}

You should comment here that the call to cgroup_lock() in the
freezer.state write method prevents a write to that file racing
against an attach, and hence the can_attach() result will remain valid
until the attach completes.

>+static ssize_t freezer_write(struct cgroup *cgroup,
>+			     struct cftype *cft,
>+			     struct file *file,
>+			     const char __user *userbuf,
>+			     size_t nbytes, loff_t *unused_ppos)
>+{
>+	char *buffer;
>+	int retval = 0;
>+	enum freezer_state goal_state;
>+
>+	if (nbytes >= PATH_MAX)
>+		return -E2BIG;
>+
>+	/* +1 for nul-terminator */
>+	buffer = kmalloc(nbytes + 1, GFP_KERNEL);
>+	if (buffer == NULL)
>+		return -ENOMEM;

Given that you're copying a string whose maximum valid length is
"FREEZING" you don't really need to use a dynamically-allocated
buffer.

But I really ought to provide a write_string() method that handles
this kind of copying on behalf of cgroup subsystems, the way it
already does for 64-bit ints.

>+	if (strcmp(buffer, "RUNNING") == 0)
>+		goal_state = STATE_RUNNING;
>+	else if (strcmp(buffer, "FROZEN") == 0)
>+		goal_state = STATE_FROZEN;

Would it make sense to compare against the strings you already have in
the array earlier in the file?

Paul
