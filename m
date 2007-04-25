Return-Path: <linux-kernel-owner+w=401wt.eu-S1161609AbXDYFFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161609AbXDYFFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 01:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161611AbXDYFFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 01:05:30 -0400
Received: from smtp-out.google.com ([216.239.45.13]:6988 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161609AbXDYFF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 01:05:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=S0Yd1lWcedxYkuGVYBVs6H2WFC096a5KxjEAYGlxsWBlFN6Du6VQxBz2KP6U1OZrG
	iiYQUpWJKjbwyB9simI8g==
Message-ID: <6599ad830704242204n75e6340cn280999122c54530f@mail.gmail.com>
Date: Tue, 24 Apr 2007 22:04:53 -0700
From: "Paul Menage" <menage@google.com>
To: "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
Subject: Re: [ckrm-tech] [PATCH 0/7] Containers (V8): Generic Process Containers
Cc: vatsa@in.ibm.com, sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, dev@sw.ru,
       rohitseth@google.com, ebiederm@xmission.com, mbligh@google.com,
       containers@lists.osdl.org, serue@us.ibm.com, akpm@linux-foundation.org,
       devel@openvz.org
In-Reply-To: <462C9375.5030901@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070406233221.989528000@menage.corp.google.com>
	 <462C9375.5030901@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/23/07, Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> Hi Paul,
>
> In [patch 3/7] Containers (V8): Add generic multi-subsystem API to
> containers, you have forcefully enabled interrupt in
> container_init_subsys() with spin_unlock_irq() which breaks on PPC64.
>
>
> > +static void container_init_subsys(struct container_subsys *ss) {
> > +     int retval;
> > +     struct list_head *l;
> > +     printk(KERN_ERR "Initializing container subsys %s\n",
> > ss->name);
> > +
> > +     /* Create the top container state for this subsystem */
> > +     ss->root = &rootnode;
> > +     retval = ss->create(ss, dummytop);
> > +     BUG_ON(retval);
> > +     init_container_css(ss, dummytop);
> > +
> > +     /* Update all container groups to contain a subsys
> > +      * pointer to this state - since the subsystem is
> > +      * newly registered, all tasks and hence all container
> > +      * groups are in the subsystem's top container. */
> > +     spin_lock_irq(&container_group_lock);
> > +     l = &init_container_group.list;
> > +     do {
> > +             struct container_group *cg =
> > +                     list_entry(l, struct container_group, list);
> > +             cg->subsys[ss->subsys_id] =
> > dummytop->subsys[ss->subsys_id];
> > +             l = l->next;
> > +     } while (l != &init_container_group.list);
> > +     spin_unlock_irq(&container_group_lock);
>
> Interrupt gets enabled here and on PPC64, the kernel takes a pending
> decrementer and crashes because it is too early to handle them.
>
> Use of irqsave and restore routines would fix the problem.

OK, thanks. I'll add that change.

Paul
