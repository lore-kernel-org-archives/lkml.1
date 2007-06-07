Return-Path: <linux-kernel-owner+w=401wt.eu-S965544AbXFGAGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965544AbXFGAGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 20:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755821AbXFGAGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 20:06:03 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:38618 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755463AbXFGAGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 20:06:01 -0400
Date: Wed, 6 Jun 2007 19:05:59 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Paul Jackson <pj@sgi.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, menage@google.com,
       akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru, vatsa@in.ibm.com,
       ebiederm@xmission.com, haveblue@us.ibm.com, svaidy@linux.vnet.ibm.com,
       balbir@in.ibm.com, cpw@sgi.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       mbligh@google.com, rohitseth@google.com, devel@openvz.org
Subject: Re: [PATCH 00/10] Containers(V10): Generic Process Containers
Message-ID: <20070607000559.GA19529@sergelap.austin.ibm.com>
References: <20070529130104.461765000@menage.corp.google.com> <20070604191412.GA901@sergelap.austin.ibm.com> <20070604123151.4db007a6.pj@sgi.com> <6599ad830706041330q1802ebf2n2bac63f706a73a50@mail.gmail.com> <20070604204131.GB19409@sergelap.austin.ibm.com> <20070604140533.65e25286.pj@sgi.com> <20070606223952.GB5626@sergelap.austin.ibm.com> <20070606154347.a155630b.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606154347.a155630b.pj@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Jackson (pj@sgi.com):
> > > I wasn't paying close enough attention to understand why you couldn't
> > > do it in two steps - make the container, and then populate it with
> > > resources.
> > 
> > Sorry, please clarify - are you saying that now you do understand, or
> > that I should explain?
> 
> Could you explain -- I still don't understand why you need this option.
> I still don't understand why you can't do it in two steps - make the
> container, then add cpu/mem separately.

Sure - the key is that the ns subsystem uses container_clone() to
automatically create a new container (on sys_unshare() or clone(2)
with certain flags) and move the current task into it.  Let's say
we have done

	mount -t container -o ns,cpuset nsproxy /containers

and we, as task 875, happen to be in the topmost container:

	/containers/

Now we fork task 999 which does an unshare(CLONE_NEWNS), or we just
clone(CLONE_NEWNS).  This will create

	/containers/node_999

and move task 999 into that container.  Except that when it tries
attach_task() it is refused by cpuset.  So the container_clone() fails,
and in turn the sys_unshare() or clone() fails.  A login making use
of the pam_namespace.so library would fail this way with the
ns and cpuset subsystems composed.

We could special case this by having
kernel/container.c:container_clone() check whether one of the subsystems
is cpusets and, if so, setting the defaults for mems and cpus, but
that is kind of ugly.  I suppose as a cleaner alternative we could 
add a container_subsys->inherit_defaults() handler, to be called at
container_clone(), and for cpusets this would set cpus and mems to
the parent values - sibling exclusive values.  If that comes to nothing,
then the attach_task() is still refused, and the unshare() or clone()
fails, but this time with good reason.

thanks,
-serge
