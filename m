Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbZGKTj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbZGKTj1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 15:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbZGKTjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 15:39:18 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47677 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390AbZGKTjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 15:39:18 -0400
Date: Sat, 11 Jul 2009 12:39:44 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Oren Laadan <orenl@cs.columbia.edu>, serue@us.ibm.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Containers <containers@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Deny CLONE_PARENT|CLONE_NEWPID|CLONE_SIGHAND
	combination
Message-ID: <20090711193944.GA32330@us.ibm.com>
References: <20090701074045.GA14595@us.ibm.com> <20090702115740.GB3552@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090702115740.GB3552@redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov [oleg@redhat.com] wrote:
| On 07/01, Sukadev Bhattiprolu wrote:
| >
| > Deny CLONE_PARENT|CLONE_NEWPID|CLONE_SIGHAND combination.
| >
| > CLONE_PARENT was used to implement an older threading model.  For consistency
| > with the CLONE_THREAD check in copy_pid_ns(), disable CLONE_PARENT and
| > CLONE_SIGHAND with CLONE_NEWPID, at least until the required semantics of
| > the pid namespaces are clear.
| >
| > Changelog[v2]:
| > 	[Eric Biederman] Disable CLONE_SIGHAND also ???
| >
| > Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
| > Acked-by: Roland McGrath <roland@redhat.com>
| > ---
| >  kernel/pid_namespace.c |    2 +-
| >  1 file changed, 1 insertion(+), 1 deletion(-)
| >
| > Index: linux-mmotm/kernel/pid_namespace.c
| > ===================================================================
| > --- linux-mmotm.orig/kernel/pid_namespace.c	2009-06-30 23:01:09.000000000 -0700
| > +++ linux-mmotm/kernel/pid_namespace.c	2009-06-30 23:49:06.000000000 -0700
| > @@ -118,7 +118,7 @@ struct pid_namespace *copy_pid_ns(unsign
| >  {
| >  	if (!(flags & CLONE_NEWPID))
| >  		return get_pid_ns(old_ns);
| > -	if (flags & CLONE_THREAD)
| > +	if (flags & (CLONE_THREAD|CLONE_PARENT|CLONE_SIGHAND))
| >  		return ERR_PTR(-EINVAL);
| 
| Still can't understand why CLONE_SIGHAND is forbidden...
| 
| CLONE_SIGHAND doesn't mean we share the signal queue, so what is
| the reason?

I don't have a convincing reason. We could disable just the
CLONE_NEWPID|CLONE_PARENT combination till we have a need for it. We
talked about removing CLONE_PARENT but backed-off since some application
may be using it. Disabling specific combinations like this (CLONE_NEWPID is
relatively a new flag) could make it a little easier to remove CLONE_PARENT
in the future.

Sukadev
