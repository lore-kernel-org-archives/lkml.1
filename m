Return-Path: <linux-kernel-owner+w=401wt.eu-S1756336AbZGMPxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbZGMPxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 11:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756262AbZGMPxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 11:53:17 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34676 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756213AbZGMPxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 11:53:16 -0400
Date: Mon, 13 Jul 2009 21:23:10 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] taskstats: Fix CGROUPSTATS_TYPE_CGROUP_STATS
	having same value as TASKSTATS_TYPE_PID
Message-ID: <20090713155310.GE5051@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <200907131831.12994.knikanth@suse.de> <20090713134158.GD5051@balbir.in.ibm.com> <200907132107.37850.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <200907132107.37850.knikanth@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nikanth Karthikesan <knikanth@suse.de> [2009-07-13 21:07:37]:

> On Monday 13 July 2009 19:11:58 Balbir Singh wrote:
> > * Nikanth Karthikesan <knikanth@suse.de> [2009-07-13 18:31:12]:
> > > Hi
> > >
> > > Currently we never get message from kernel to userspace of type
> > > TASKSTATS_TYPE_PID. Otherwise this could have been spotted earlier.
> > >
> > > I was trying to add a new taskstat command that would return response of
> > > type TASKSTATS_TYPE_PID.
> > >
> > > Having the same values would restrict one not to use the same netlink
> > > socket for a command that would return response of type
> > > TASKSTATS_TYPE_PID and the CGROUPSTATS_CMD_GET command.
> > >
> > > Should we fix it by using values after __TASKSTATS_TYPE_MAX.
> > >
> > > Changing this now might break pre-built binaries. Or is this intended,
> > > and the application is not supposed to use CGROUPSTATS and TASKSTATS on
> > > the same socket?
> >
> > Ideally they are supposed to be on different sockets, but nothing
> > really is hard and fast in terms of rules.
> >
> 
> IMHO, If we are adding CGROUPSTATS_CMD_GET to the same netlink family of 
> TASKSTATS, we should allow both the commands in the same socket.
> 
> > > Thanks
> > > Nikanth
> > >
> > > Currently we never get message from kernel to userspace of type
> > > TASKSTATS_TYPE_PID. Otherwise this could have been spotted earlier.
> > > Having the values in the same range would restrict one not to use the
> > > same netlink socket for a command that would return response of type
> > > TASKSTATS_TYPE_PID and the CGROUPSTATS_CMD_GET command. Fix it by using
> > > values after
> > > __TASKSTATS_TYPE_MAX.
> > >
> > > Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> > >
> > > ---
> > >
> > >
> > > diff --git a/include/linux/cgroupstats.h b/include/linux/cgroupstats.h
> > > index 3753c33..87b31f0 100644
> > > --- a/include/linux/cgroupstats.h
> > > +++ b/include/linux/cgroupstats.h
> > > @@ -53,7 +53,7 @@ enum {
> > >  #define CGROUPSTATS_CMD_MAX (__CGROUPSTATS_CMD_MAX - 1)
> > >
> > >  enum {
> > > -	CGROUPSTATS_TYPE_UNSPEC = 0,	/* Reserved */
> > > +	CGROUPSTATS_TYPE_UNSPEC = __TASKSTATS_TYPE_MAX,	/* Reserved */
> > >  	CGROUPSTATS_TYPE_CGROUP_STATS,	/* contains name + stats */
> > >  	__CGROUPSTATS_TYPE_MAX,
> > >  };
> >
> > This seems like the correct fix
> >
> > Reviewed-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> But this would break applications every time a new item is added to the enums 
> in taskstat.h
>


Yes, correct and the expectation, we will bump the version number (see
version field) or ignore the fix and send a strong recommendation that
we should use different sockets for cgroupstats and taskstats.
 
> The correct fix would be to add all the CGROUPSTATS_* enums, as part of the 
> same enum in taskstat.h. So that when new members are added to enum's in 
> taskstat.h, the cgroup stat enum's values won't change and applications need 
> not be re-built. If you agree, I would send a patch to do that.
>

I wanted to keep the separate to avoid #ifdef's around the code. One
other generic fix would be to use different starting bases. We could
for example use a bit (say bit 63) to indicate the type - taskstats or
cgroupstats, but we might be too late for that.

Please remember to bump the version field, lets try your suggested
approach of integration and if that can be done cleanly, I have no
objection.

-- 
	Balbir
