Return-Path: <linux-kernel-owner+w=401wt.eu-S1757472AbYDYGCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbYDYGCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 02:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754969AbYDYGB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 02:01:56 -0400
Received: from smtp-out.google.com ([216.239.33.17]:6894 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbYDYGBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 02:01:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=yUPSTi5oH1iy8+UKdoRKa3s4kuUqxTJLFgS/3z2BzgzLVF+Pl3lVaOkCyUSqjEGnE
	aBecMMAut6MgbG7ueZ+5g==
Message-ID: <6599ad830804242301s6a00dd75ye212a28f97072b68@mail.gmail.com>
Date: Thu, 24 Apr 2008 23:01:46 -0700
From: "Paul Menage" <menage@google.com>
To: "Matt Helsley" <matthltc@us.ibm.com>
Subject: Re: [RFC][PATCH 5/5] Add a Signal Control Group Subsystem
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       "Cedric Le Goater" <clg@fr.ibm.com>,
       "Oren Laadan" <orenl@cs.columbia.edu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Pavel Machek" <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       "Linux Containers" <containers@lists.linux-foundation.org>
In-Reply-To: <20080424064758.113999091@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080424064756.643890130@us.ibm.com>
	 <20080424064758.113999091@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think you need cgroup_signal.h. It's only included in
cgroup_signal.c, and doesn't really contain any useful definitions
anyway. You should just use a cgroup_subsys_state object as your state
object, since you'll never need to do anything with it anyway.

>+static struct cgroup_subsys_state *signal_create(
>+	struct cgroup_subsys *ss, struct cgroup *cgroup)
>+{
>+	struct stateless *dummy;
>+
>+	if (!capable(CAP_SYS_ADMIN))
>+		return ERR_PTR(-EPERM);

This is unnecessary.

>+
+	dummy = kzalloc(sizeof(struct stateless), GFP_KERNEL);
+	if (!dummy)
+		return ERR_PTR(-ENOMEM);
+	return  &dummy->css;
+}

This function could be simplified to:

struct cgroup_subsys_state *css;
css = kzalloc(sizeof(*css), GFP_KERNEL);
return css ?: ERR_PTR(-ENOMEM);

>+static int signal_can_attach(struct cgroup_subsys *ss,
>+			     struct cgroup *new_cgroup,
>+			     struct task_struct *task)
>+{
>+	return 0;
>+}

No need for a can_attach() method if it just returns 0 - that's the default.

>+static int signal_kill(struct cgroup *cgroup, int signum)
>+{
>+	struct cgroup_iter it;
>+	struct task_struct *task;
>+	int retval = 0;
>+
>+	cgroup_iter_start(cgroup, &it);
>+	while ((task = cgroup_iter_next(cgroup, &it))) {
>+		retval = send_sig(signum, task, 1);
>+		if (retval)
>+			break;
>+	}
>+	cgroup_iter_end(cgroup, &it);
>+
>+	return retval;
>+}

cgroup_iter_start() takes a read lock - is send_sig() guaranteed not to sleep?

>+static ssize_t signal_write(struct cgroup *cgroup,
>+			     struct cftype *cft,
>+			     struct file *file,
>+			     const char __user *userbuf,
>+			     size_t nbytes, loff_t *unused_ppos)

This should just be a write_u64() method - cgroups will handle the
copying/parsing for you. See e.g.
kernel/sched.c:cpu_shares_write_u64()

>+static struct cftype kill_file = {
>+	.name = "kill",
>+	.write = signal_write,
>+	.private = 0,
>+};

I agree with PaulJ that "signal.send" would be a nicer name for this
than "signal.kill"
