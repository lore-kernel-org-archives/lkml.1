Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbYHSOg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbYHSOg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 10:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbYHSOfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 10:35:39 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:21677 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215AbYHSOfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 10:35:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:sender:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references:x-google-sender-auth;
        b=C6+gVRJqM9zb7Jm025oQIfSDgGTdVb7E//jOmxYivZc3asv1yrWouCF7GgEcphEFEB
         8bccmrASXhPxRXx10kkIb83R0oGkNqDCk0egGTWh3I16yr09y+wCRm5P+HOZ0ie1y//R
         utTI4vgEQLKZL0/TuxP82FJAZsboriFgesrus=
Message-ID: <a2776ec50808190735y4a122e41tca61e1bce3727760@mail.gmail.com>
Date: Tue, 19 Aug 2008 16:35:36 +0200
From: righi.andrea@gmail.com
Reply-To: righiandr@users.sourceforge.net
To: "Vivek Goyal" <vgoyal@redhat.com>
Subject: Re: [RFC] [PATCH -mm] cgroup: uid-based rules to add processes efficiently in the right cgroup
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Paul Menage" <menage@google.com>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Kazunaga Ikeno" <k-ikeno@ak.jp.nec.com>,
       "Morton Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Graf" <tgraf@redhat.com>, "Ulrich Drepper" <drepper@redhat.com>,
       "Steve Olivieri" <solivier@redhat.com>,
       "Rik Van Riel" <riel@redhat.com>
In-Reply-To: <20080818123526.GA30953@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080703101957.b3856904.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830807100223m2453963cwcfbe6eb1ad54d517@mail.gmail.com>
	 <20080710104852.797fe79c@cuia.bos.redhat.com>
	 <20080710154035.GA12043@redhat.com>
	 <20080711095501.cefff6df.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080714135719.GE16673@redhat.com> <487B665B.9080205@sun.com>
	 <20080714152142.GJ16673@redhat.com> <48A7FE7B.3060309@gmail.com>
	 <20080818123526.GA30953@redhat.com>
X-Google-Sender-Auth: bf71d2e4bc503abd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 08:35:26AM -0400, Vivek Goyal wrote:
> On Sun, Aug 17, 2008 at 12:33:31PM +0200, Andrea Righi wrote:
> > The problem of placing tasks in respective cgroups seems to be correctly
> > addressed by userspace lib wrappers or classifier daemons [1].
> >
> > However, this is an attempt to implement an in-kernel classifier.
> >
> > [ I wrote this patch for a "special purpose" environment, where a lot of
> > short-lived processes belonging to different users are spawned by
> > different daemons, so the main goal here would be to remove the dealy
> > needed by userspace classification and place the tasks in the right
> > cgroup at the time they're created. This is just an ugly hack for now
> > and it works only for uid-based rules, gid-based rules could be
> > implemented in a similar way. ]
> >
>
> Hi  Andrea,

yep! I'm having some troubles with my internet connection, and it seems
my previous reply is lost.. :( resending it, sorry for the noise if
you'll receive more than 1 mail.

>
> Recently I introduced the infrastructure in libcgroup to handle
> the task placement issue based on uid and gid rules. This is what I did.
>
> - Introduced two new APIs in libcgroup to place the task in right cgroup.
> 	- cgroup_change_cgroup_uid_gid
> 		Pleces the task in destination cgroup based on uid/gid
> 		rules specified in /etc/cgrules.conf
> 	- cgroup_change_cgroup_path
> 		Puts the task into the cgroup specified by caller
>
> - Provided two command line tools (cgexec and cgclassify) to perform
>   various process placement related tasks.
> 	- cgexec
> 		A tool to launch a task in user specfied cgroup
> 	- cgclassify
> 		A tool to re-classify already running tasks.
>
> - Wrote a pam plugin so that tasks are placed in right user groups upon
>   login or reception of other services which take pam's help.

That's interesting. All the daemons that provide access to a system
should pam-aware, so with the pam plugin I should be able to handle all
the cases. Unfortunately I don't have too much details about those
daemons and in fact I was looking for the most generic solution..

>
> - Currently work is in progress for a user space daemon which will
>   automatically place the tasks based on notifications.
>
> For your environment, where delay is unbearable, I think you can modify
> the daemon to use libcgroup to place the forked task in right cgroup
> before actually executing it. Once the task has been placed in right
> cgroup, exec() will be called.
>

The deamons should all use the exec() + setuid() way. If pam doesn't
help I'll try to wrap setuid(), using a wrapper lib or something
similar.

> We have been doing all the user space development on following mailing
> list.
>
> https://lists.sourceforge.net/lists/listinfo/libcg-devel
>
> Latest patches which got merged in libcgroup, are here.
>
> http://sourceforge.net/mailarchive/forum.php?thread_name=20080813171720.108005557%40redhat.com&forum_name=libcg-devel
>
> It is accompanied with a decent README file for design details and for
> how to use it.

Thanks, I'll look at the latest libcgroup features ASAP.

>
> I think modifying the daemon to make use of libcgroup is the right way
> to handle this issue than duplicating the infrastructure in user space
> as well as kernel space.

Totally agree in perspective (obviously when it's possible/reasonable in
terms of efforts to change the userspace daemon).

Thanks,
-Andrea
