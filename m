Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbYLKPAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbYLKPAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 10:00:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756038AbYLKPAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 10:00:10 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:59161 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834AbYLKPAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 10:00:09 -0500
Date: Thu, 11 Dec 2008 08:59:57 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Pavel Emelyanov <xemul@openvz.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] devices cgroup: allow mkfifo
Message-ID: <20081211145956.GB10107@us.ibm.com>
References: <20081210155721.GA15166@us.ibm.com> <49406553.6000408@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49406553.6000408@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Li Zefan (lizf@cn.fujitsu.com):
> CC: Andrew
> 
> Serge E. Hallyn wrote:
> > The devcgroup_inode_permission() hook in the devices whitelist
> > cgroup has always bypassed access checks on fifos.  But the
> > mknod hook did not.  The devices whitelist is only about block
> > and char devices, and fifos can't even be added to the whitelist,
> > so fifos can't be created at all except by tasks which have 'a'
> > in their whitelist (meaning they have access to all devices).
> > 
> > Fix the behavior by bypassing access checks to mkfifo.
> > 
> 
> It also bypasses checks to mksock. Should backport this patch?

Do you mean push it into -stable?

Couldn't hurt, but it's a DOS to root in a container, not a security
vulnerability, and since noone has complainted until now so at least
it's not panick-worthy.

> Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

Thanks.  I'll go ahead and send to Linus and -stable.

-serge

> > Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> > ---
> >  security/device_cgroup.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> > index 5ba7870..df9d491 100644
> > --- a/security/device_cgroup.c
> > +++ b/security/device_cgroup.c
> > @@ -513,6 +513,9 @@ int devcgroup_inode_mknod(int mode, dev_t dev)
> >  	struct dev_cgroup *dev_cgroup;
> >  	struct dev_whitelist_item *wh;
> >  
> > +	if (!S_ISBLK(mode) && !S_ISCHR(mode))
> > +		return 0;
> > +
> >  	rcu_read_lock();
> >  
> >  	dev_cgroup = task_devcgroup(current);
