Return-Path: <linux-kernel-owner+w=401wt.eu-S1759041AbYLLOfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759041AbYLLOfX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 09:35:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbYLLOfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 09:35:09 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:33600 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930AbYLLOfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 09:35:08 -0500
Date: Fri, 12 Dec 2008 08:34:58 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, lkml <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, lizf@cn.fujitsu.com
Subject: Re: [PATCH 1/1] devices cgroup: allow mkfifo
Message-ID: <20081212143458.GC9571@us.ibm.com>
References: <20081211155027.GB12750@us.ibm.com> <20081211191208.d4d251ad.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081211191208.d4d251ad.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
> On Thu, 11 Dec 2008 09:50:27 -0600 "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> 
> > The devcgroup_inode_permission() hook in the devices whitelist
> > cgroup has always bypassed access checks on fifos.  But the
> > mknod hook did not.  The devices whitelist is only about block
> > and char devices, and fifos can't even be added to the whitelist,
> > so fifos can't be created at all except by tasks which have 'a'
> > in their whitelist (meaning they have access to all devices).
> > 
> > Fix the behavior by bypassing access checks to mkfifo (and mksock).
> > 
> > (Thanks, Daniel, for finding this)
> > 
> > Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> > Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
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
> 
> hm.  I'd looked at your description and decided this was 2.6.29 material.
> 
> But you think it's for 2.6.28 and even for 2.6.27.  How come?
> 
> (iow, your changelog sucked :)

Sorry, I should have put the exchange between Li and I in there.
(Ouch, and I didn't cc: Li this time!  Sorry, Li.)

Li thought it was 2.6.27/2.6.27 material.  I thought not, but wanted
to see what the -stable folks thought.

This is not a security hole, and since noone has complained before
it doesn't appear to be too inconvenient.  Until the fix goes
up, container users can always create the fifos and socks on the
root image while creating the container, before entering the
device whitelist.

thanks,
-serge
