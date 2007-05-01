Return-Path: <linux-kernel-owner+w=401wt.eu-S1755109AbXEARqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbXEARqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 13:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755111AbXEARqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 13:46:45 -0400
Received: from smtp-out.google.com ([216.239.45.13]:11147 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbXEARqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 13:46:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=SbvpWgwS6LhvNEwNR5/+mPAEK48SDGQL5h31gdhxzdl8pV88trvTevML7FqIRI32G
	DLiXQcDaXhsDjwiUBmvRg==
Message-ID: <6599ad830705011046l6d0a0db7jd28d29f8c1b8cdb9@mail.gmail.com>
Date: Tue, 1 May 2007 10:46:10 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [PATCH 1/9] Containers (V9): Basic container framework
Cc: akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       vatsa@in.ibm.com, ebiederm@xmission.com, haveblue@us.ibm.com,
       svaidy@linux.vnet.ibm.com, balbir@in.ibm.com, pj@sgi.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, containers@lists.osdl.org,
       devel@openvz.org
In-Reply-To: <46377BA4.6030701@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070427104607.252541000@menage.corp.google.com>
	 <20070427111300.015604000@menage.corp.google.com>
	 <46377BA4.6030701@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> menage@google.com wrote:
> > This patch adds the main containers framework - the container
> > filesystem, and the basic structures for tracking membership and
> > associating subsystem state objects to tasks.
>
> [snip]
>
> > +*** notify_on_release is disabled in the current patch set. It may be
> > +*** reactivated in a future patch in a less-intrusive manner
> > +
>
> Won't this break user space tools for cpusets?

Yes, so it's a must-fix before this gets anywhere near a real distribution.

>
> [snip]
>
> > +See kernel/container.c for more details.
> > +
> > +Subsystems can take/release the container_mutex via the functions
> > +container_lock()/container_unlock(), and can
> > +take/release the callback_mutex via the functions
> > +container_lock()/container_unlock().
> > +
>
> Hmm.. looks like a documentation error. Both mutex's are obtained through
> container_lock/container_unlock ?

The second half of that sentence is obsolete and should have been deleted.

>
> > +Accessing a task's container pointer may be done in the following ways:
> > +- while holding container_mutex
> > +- while holding the task's alloc_lock (via task_lock())
> > +- inside an rcu_read_lock() section via rcu_dereference()
> > +
>
> container_mutex() and task_lock() can be used for changing the pointer?

No, these are all for read operations. (Actually, this is a bit of
documentation that's bit-rotted - there's no longer a per-task
"container" pointer). I'll update this.

For write operations, only the container system should be modifying
those pointers (under the protection of both container_mutex and
alloc_lock).

>
> We needed the equivalent of container_remove_file() to be called
> if container_add_file() failed.
>

Yes, this is some incomplete behaviour that I inherited from cpusets.
Needs tidying up.

>
> Can't we derive the top_container from containerfs_root?

Yes, we could for the cost of an extra dereference. Not sure it's a
big deal either way.

> > +     ssize_t (*read) (struct container *cont, struct cftype *cft,
> > +                      struct file *file,
> > +                      char __user *buf, size_t nbytes, loff_t *ppos);
> > +     u64 (*read_uint) (struct container *cont, struct cftype *cft);
>
> Is this a new callback, a specialization of the read() callback?

Yes. It's to simplify the common case of reporting a number in a
control file. (Not yet well documented :-( )

Paul
