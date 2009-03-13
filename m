Return-Path: <linux-kernel-owner+w=401wt.eu-S1758819AbZCMT50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819AbZCMT50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 15:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbZCMT5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 15:57:16 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:51412 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbZCMT5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 15:57:16 -0400
Date: Fri, 13 Mar 2009 14:57:13 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] devcgroup: avoid using cgroup_lock
Message-ID: <20090313195712.GA18439@us.ibm.com>
References: <49B869BB.7030907@cn.fujitsu.com> <20090312181912.GA20144@us.ibm.com> <49B9BCC7.7090908@cn.fujitsu.com> <20090313134139.GB32304@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090313134139.GB32304@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge E. Hallyn (serue@us.ibm.com):
> Quoting Li Zefan (lizf@cn.fujitsu.com):
> > >> @@ -426,11 +431,11 @@ static int devcgroup_access_write(struct cgroup *cgrp, struct cftype *cft,
> > >>  				  const char *buffer)
> > >>  {
> > >>  	int retval;
> > >> -	if (!cgroup_lock_live_group(cgrp))
> > > 
> > > Does it matter that we no longer check for cgroup_is_removed()?
> > > 
> > 
> > No, this means in a rare case that the write handler is called when the cgroup
> > is dead, we still do the update work instead of returning ENODEV.
> > 
> > This is ok, since at that time, accessing cgroup and devcgroup is still valid,
> > but will have no effect since there is no task in this cgroup and the cgroup
> > will be destroyed soon.
> 
> Ok, just wanted to make sure the devcgroup couldn't be partially torn
> down and risking NULL or freed-memory derefs...

Ok, so the cgroup's files will be deleted first, then on the directory
removal the cgroup's data (each whitelist entry) is deleted.  So we can
let that ordering (by cgroup_clear_directory) ensure that nothing inside
a file write can happen while the destroy handler is called, right?

(That's why I was worried about not using the cgroup_lock: we need some
way of synchronizing those.  But I guess we're fine)

> BTW is that against linux-next?  (didn't seem to apply cleanly against
> my 2.6.29-rc9)  I guess I'd like to do a little test before acking,
> though it looks ok based on your answer.

Acked-by: Serge Hallyn <serue@us.ibm.com>

-serge
