Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbZDPPST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbZDPPST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 11:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbZDPPSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 11:18:08 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.67.1]:65362 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbZDPPSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 11:18:07 -0400
X-Greylist: delayed 2021 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Apr 2009 11:18:07 EDT
Subject: Re: [PATCH] rework/fix is_single_threaded()
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090416133658.GA6532@redhat.com>
References: <20090413214513.GA1119@redhat.com> <14878.1239876272@redhat.com>
	 <20090416133658.GA6532@redhat.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 16 Apr 2009 10:36:12 -0400
Message-Id: <1239892572.7591.43.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-16 at 15:36 +0200, Oleg Nesterov wrote:
> On 04/16, David Howells wrote:
> >
> > Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > > - Fix the comment, is_single_threaded(p) actually means that nobody shares
> > >   ->mm with p.
> > >
> > >   I think this helper should be renamed,
> >
> > What we want to know when we ask this function is whether or not a process is
> > single-threaded, hence the name.  The fact that because:
> >
> > 	CLONE_THREAD => CLONE_SIGHAND => CLONE_VM
> >
> > we can work this out purely by checking that there aren't any processes that
> > share VM space with us is immaterial.
> 
> Confused... I already asked this in http://marc.info/?t=123853355800001
> "what is_single_threaded() does?" and perhaps I misunderstood you.
> 
> So, once again, what it should do? If we only care about CLONE_THREAD (implies
> CLONE_VM), then we can just do
> 
> 	bool is_single_threaded(struct task_struct *p)
> 	{
> 		return atomic_read(&p->signal->live) == 1;
> 	}
> 
> But, if it should check p doesn't share VM space (this is what it does
> with or without the patch), then we have to scan all processes.

In the SELinux case, we care about shared VM space.   The purpose of the
check for SELinux is to prevent the security contexts of tasks that
share a VM from diverging from one another, as we cannot enforce any
separation among them.

> > > and it should not have arguments.  With or without this patch it must not be
> > > used unless p == current, otherwise we can't safely use p->signal or p->mm.
> >
> > Well, I can live with that, but you need to check with the SELinux people too.
> > Whilst they do currently limit the selinux_setprocattr() to current only, they
> > still hand the task pointer that function is given around.
> 
> Yes, I see. But (apart from "not safe" above), from the security pov it doesn't
> make sense to call is_single_threaded(p) unless p == current ? The task can
> fork right after the check.

Right.  In the SELinux case, we will only ever call it with p ==
current, and if you want to make that explicit by dropping the task
argument and directly acting on current, feel free.

-- 
Stephen Smalley
National Security Agency

