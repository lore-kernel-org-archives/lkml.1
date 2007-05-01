Return-Path: <linux-kernel-owner+w=401wt.eu-S1945928AbXEAUiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945928AbXEAUiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945918AbXEAUhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:37:54 -0400
Received: from smtp-out.google.com ([216.239.33.17]:8122 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945928AbXEAUhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:37:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=MvDYNAemfoiBaxxSAkn+tPl97/ku+SliD0GH65djPWoUmm4P0oEiQKDyYYW+sXY2G
	DGo7r5m33uf6EuzSn6H4w==
Message-ID: <6599ad830705011337r6f200baen841919ac17c6f38b@mail.gmail.com>
Date: Tue, 1 May 2007 13:37:24 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [ckrm-tech] [PATCH 3/9] Containers (V9): Add tasks file interface
Cc: vatsa@in.ibm.com, ckrm-tech@lists.sourceforge.net, balbir@in.ibm.com,
       haveblue@us.ibm.com, xemul@sw.ru, dev@sw.ru, containers@lists.osdl.org,
       pj@sgi.com, devel@openvz.org, ebiederm@xmission.com, mbligh@google.com,
       rohitseth@google.com, serue@us.ibm.com, akpm@linux-foundation.org,
       svaidy@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
In-Reply-To: <46378311.6000703@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070427104607.252541000@menage.corp.google.com>
	 <20070427111300.406327000@menage.corp.google.com>
	 <46378311.6000703@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > +     if (container_is_removed(cont)) {
> > +             retval = -ENODEV;
> > +             goto out2;
> > +     }
>
> Can't we make this check prior to kmalloc() and copy_from_user()?

We could but I'm not sure what it would buy us - we'd be optimizing
for the case that essentially never occurs.

>
>
>
> > +int container_task_count(const struct container *cont) {
> > +     int count = 0;
> > +     struct task_struct *g, *p;
> > +     struct container_subsys_state *css;
> > +     int subsys_id;
> > +     get_first_subsys(cont, &css, &subsys_id);
> > +
> > +     read_lock(&tasklist_lock);
>
> Can be replaced with rcu_read_lock() and rcu_read_unlock()

Are you sure about that? I see many users of
do_each_thread()/while_each_thread() taking a lock on tasklist_lock,
and only one (fs/binfmt_elf.c) that's clearly relying on an RCU
critical sections. Documentation?

>
> Any chance we could get a per-container task list? It will
> help subsystem writers as well.

It would be possible, yes - but we probably wouldn't want the overhead
(additional ref counts and list manipulations on every fork/exit) of
it on by default. We could make it a config option that particular
subsystems could select.

I guess the question is how useful is this really, compared to just
doing a do_each_thread() and seeing which tasks are in the container?
Certainly that's a non-trivial operation, but in what circumstances is
it really necessary to do it?

Paul
