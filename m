Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312Ab0BSLtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 06:49:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753Ab0BSLtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 06:49:07 -0500
Subject: Re: [PATCH 2/2] dlm: Remove obsolete lockspace lookup
From: Steven Whitehouse <swhiteho@redhat.com>
To: David Teigland <teigland@redhat.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20100218210407.GB13276@redhat.com>
References: <1266399695-29885-1-git-send-email-swhiteho@redhat.com>
	 <1266399695-29885-2-git-send-email-swhiteho@redhat.com>
	 <1266399695-29885-3-git-send-email-swhiteho@redhat.com>
	 <20100217201243.GA29576@redhat.com> <1266484563.2297.6.camel@localhost>
	 <20100218210407.GB13276@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Fri, 19 Feb 2010 11:52:24 +0000
Message-ID: <1266580344.2758.47.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2010-02-18 at 16:04 -0500, David Teigland wrote:
> On Thu, Feb 18, 2010 at 09:16:03AM +0000, Steven Whitehouse wrote:
> > I'm not sure what more I can say here.... this is a sysfs file store
> > function and one of the reasons for using it is that sysfs looks after
> > the ref counting for you.
> > 
> > Even aside from that, if you don't have a reference to the lockspace,
> > then the dereference that is done to discover the lockspace name would
> > be invalid, since the structure might have already been freed before the
> > reference is obtained.
> > 
> > You could also compare with with the other store and show functions in
> > that same file and notice that none of them try to grab a reference to
> > the lockspace in that way. So if this is required, then it must be
> > required for those functions too.
> > 
> > Either way there is something not quite right here and having studied
> > the code in some detail, I'm pretty sure this is the correct fix,
> 
> I guess you didn't see this oops in your tests.  Can you show that the
> situation in this commit is no longer possible?
> 
No, I didn't hit it. I'm not sure how to reproduce whatever situation
led to this in the first place.

There was a clue though in the patch prior to the one you pointed out in
the git tree, the comment in this patch doesn't make a lot of sense
until without the context from that patch. I noticed that where the
sysfs function does this:

> +	ls = dlm_find_lockspace_local(ls->ls_local_handle);
> +	if (!ls)
> +		return -EINVAL;
> +

it isn't primarily a ref count operation. Yes, it does get a ref count
on the object if it is successful, but the main purpose is testing to
see if the shutdown process has started (i.e. is the lockspace still on
the ls_list). If the list removal used a list_del_init rather than a
list del, the dlm_find_lockspace_local() call could be replaced with:

	spin_lock(&lslist_lock);
	ret = list_empty(&ls->ls_list);
	if (!ret)
		ls->ls_count++;
	spin_unlock(&lslist_lock);
	if (ret)
		return -EINVAL;

which might be a bit less confusing, and also saves traversing the list
of lockspaces. This is basically a "hold" operation, rather than a
find/get type operation.

My confusion has arisen from the fact that there are three ref counters
for the lockspace object. One is ls_count, one is ls_create_count and
the other the is kobject ref count.

ls_create_count seems to deal with user references, ls_count seems to be
used for internal references and the kobject ref count only seems to be
incremented/decremented on initial object creation/removal.

Probably the correct long term solution is to at least merge the
ls_count into kobject ref count system, and maybe the ls_create_count
too. I'll have to do some more investigation before I can see whether
there are any reasons why that isn't possible.

Either way, we are getting away from what was originally a small and
simple patch, so I'll suggest to ignore this one for now, and just apply
the first one of the two which I sent. I'll have another look at this in
the mean time,

Steve.



