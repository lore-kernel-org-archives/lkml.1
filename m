Return-Path: <linux-kernel-owner+w=401wt.eu-S932329AbXJPGHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbXJPGHp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 02:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760993AbXJPGHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 02:07:37 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:38733 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758523AbXJPGHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 02:07:36 -0400
Date: Mon, 15 Oct 2007 23:07:29 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: menage@google.com, nickpiggin@yahoo.com.au, a.p.zijlstra@chello.nl,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, clg@fr.ibm.com,
       ebiederm@xmission.com, containers@lists.osdl.org, serue@us.ibm.com,
       svaidy@linux.vnet.ibm.com, akpm@linux-foundation.org, xemul@openvz.org
Subject: Re: [RFC] cpuset update_cgroup_cpus_allowed
Message-Id: <20071015230729.53fcbaf7.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.9999.0710151135150.24837@chino.kir.corp.google.com>
References: <20071015071115.16057.72116.sendpatchset@jackhammer.engr.sgi.com>
	<alpine.DEB.0.9999.0710151135150.24837@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > +			if (cpus_equal(*cpus, t->cpus_allowed))
> > +				continue;
> > ...
> > +		for (q = tasks; q < p; q++) {
> > +			set_cpus_allowed(*q, *cpus);
> > +			put_task_struct(*q);
> > +		}
> > +	}
> > +}
> 
> Yet by not doing any locking here to prevent a cpu from being 
> hot-unplugged, you can race and allow the hot-unplug event to happen 
> before calling set_cpus_allowed().  That makes this entire function a 
> no-op with set_cpus_allowed() returning -EINVAL for every call, which 
> isn't caught, and no error is reported to userspace.
> 
> Now all the tasks in the cpuset have an inconsistent state with respect to 
> their p->cpuset->cpus_allowed, because that was already updated in 
> update_cpumask().

My solution may be worse than that.  Because set_cpus_allowed() will
fail if asked to set a non-overlapping cpumask, my solution could never
terminate.  If asked to set a cpusets cpus to something that went off
line right then, this I'd guess this code could keep looping forever,
looking for cpumasks that didn't match, and then not noticing that it
was failing to set them so as they would match.

... it needs work ... or the alternative solution from Paul M.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
