Return-Path: <linux-kernel-owner+w=401wt.eu-S1751821AbYLXV0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbYLXV0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 16:26:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbYLXV0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 16:26:00 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:58119 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbYLXV0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 16:26:00 -0500
Date: Wed, 24 Dec 2008 13:24:26 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: ebiederm@xmission.com, roland@redhat.com, bastian@waldi.eu.org,
       daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 3/7][v4] Define siginfo_from_ancestor_ns()
Message-ID: <20081224212426.GD13502@us.ibm.com>
References: <20081224114414.GA7879@us.ibm.com> <20081224115124.GC8020@us.ibm.com> <20081224162823.GE11593@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081224162823.GE11593@redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov [oleg@redhat.com] wrote:
| Small nit... siginfo_from_user() is only called by siginfo_from_ancestor_ns().
| The first helper depends on CONFIG_PID_NS, the second is not. A bit strange.

| 
| Isn't it cleaner to do
| 
| 	#ifdef CONFIG_PID_NS
| 	static inline int siginfo_from_user(siginfo_t *info)
| 	{
| 		...
| 	}
| 	static inline int siginfo_from_ancestor_ns(...)
| 	{
| 		...
| 	}
| 	#else
| 	static inline int siginfo_from_ancestor_ns(...)
| 	{
| 		return 0;
| 	}
| 	#endif
| 
| ?

Yes, it was that way in the earlier version, but I thought we introduced
CONFIG_PID_NS only to hide the ugliness resulting from pid-ns. Ok. I
will revert.

| 
| > +#ifdef CONFIG_PID_NS
| > +/*
| > + * siginfo_from_user() assumes that si_code SI_ASYNCIO comes only from
| > + * within the kernel. If an application is passing in SI_ASYNCIO we 
| > + * want to know about it.
| > + */
| > +static void warn_on_asyncio(siginfo_t *info)
| > +{
| > +	WARN_ON_ONCE(info->si_code == SI_ASYNCIO);
| > +}
| > +#else
| > +#define warn_on_asyncio(info)	{}
| > +#endif
| > +
| >  asmlinkage long
| >  sys_rt_sigqueueinfo(pid_t pid, int sig, siginfo_t __user *uinfo)
| >  {
| > @@ -2324,6 +2388,9 @@ sys_rt_sigqueueinfo(pid_t pid, int sig, siginfo_t __user *uinfo)
| >  	   Nor can they impersonate a kill(), which adds source info.  */
| >  	if (info.si_code >= 0)
| >  		return -EPERM;
| > +
| > +	warn_on_asyncio(&info);
| 
| Hmm... why do you want this? The user-space can use any si_code >= 0,
| why should we uglify the code?

I thought losing a SIGKILL, however twisted the path, was serious enough
to justify the ugliness. Again, I am not particular.

| 
| And, SI_ASYNCIO only matters when we send the signal to the subnamespace,
| and in that case we will probably mangle .si_pid. So why don't we warn
| when .si_code == SI_USER?

I was wondering if I should there too :-) But what do you think ? 
