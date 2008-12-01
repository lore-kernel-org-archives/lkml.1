Return-Path: <linux-kernel-owner+w=401wt.eu-S1751446AbYLAHil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbYLAHil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 02:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbYLAHib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 02:38:31 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:39272 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbYLAHia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 02:38:30 -0500
Subject: Re: signal handling description for Michaels CLONE_NEWPID man page
From: Nadia Derbey <Nadia.Derbey@bull.net>
To: mtk.manpages@gmail.com
Cc: serue@us.ibm.com, sukadev@us.ibm.com, xemul@openvz.org, kir@openvz.org,
       linux-man@vger.kernel.org, linux-kernel@vger.kernel.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
In-Reply-To: <cfd18e0f0811281358s2e831b04qc56277db403c2039@mail.gmail.com>
References: <20081127070720.954560982@bull.net>
	 <20081127070806.626288939@bull.net>
	 <cfd18e0f0811281358s2e831b04qc56277db403c2039@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 01 Dec 2008 08:36:44 +0100
Message-Id: <1228117005.2615.186.camel@frecb000730.frec.bull.fr>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-28 at 16:58 -0500, Michael Kerrisk wrote:
> Hi Nadia,
> 
> Thanks for putting this together.  A few questions below.
> 
> On Thu, Nov 27, 2008 at 2:07 AM,  <Nadia.Derbey@bull.net> wrote:
> > Michael,
> >
> > Here is the proposal for a description of signals handling in pid
> > namespaces.
> >
> > This applies on top of your CLONE_NEWPID patch.
> >
> > Regards,
> > Nadia
> >
> > ---
> >  man2/clone.2 |   23 +++++++++++++++++++++++
> >  1 file changed, 23 insertions(+)
> >
> > Index: man-pages-3.13/man2/clone.2
> > ===================================================================
> > --- man-pages-3.13.orig/man2/clone.2    2008-11-24 09:34:30.000000000 +0100
> > +++ man-pages-3.13/man2/clone.2 2008-11-27 09:17:53.000000000 +0100
> > @@ -226,6 +226,29 @@ configuration option and requires that t
> >  .RB (CAP_SYS_ADMIN ).
> >  This flag can't be specified in conjunction with
> >  .BR CLONE_THREAD .
> > +
> > +.BR "Signals handling:"
> > +just like all the system calls that address a PID, signals can only be sent
> > +to a process whose PID belongs to the same namespace as the caller.
> > +
> > +There are ways signals can be sent across namespaces boundaries such that
> 
> Just so I'm clear.  We're talking about the case here where, for
> example, a process in a parent namespace sends a signal to a process
> in the child namespace.  In such a case, the PID of the sender is not
> meaningful.  Right?

Yes, a process doesn't have a valid pid number in a descendant pid
namespace. So a process receiving a signal from an upper level PID
namespace will see the signal originator as "not meaningful".

> 
> > +the sender does not have a valid pid in the receiver's pid namespace.
> > +In such cases, the sender pid will be seen by the receiver as a 0 value
> > +(this has an impact, for example, on the
> > +.BR siginfo_t
> > +structure contents - NOTE, this is still under development).
> 
> Can you fill me in on the possibilities of "this is still under development"?

This is because the semantics are still under discussion (see thread
http://lkml.org/lkml/2008/11/25/458).
There are also places that are not addressed by this patchset, but where
the signal originator pid might have to be cleared, like the following:
1. POSIX message queues: if the process that registers for notification
through mq_notify() is in a descendant namespace of the one that sends a
message to the mqueue.
2. a process is set as the SIGIO receiver through fcntl(F_SETOWN) and
the write() to the file is done by a process that belongs to an ancestor
namespace.

Also, if the implementation proposed by this patchset is adopted, we
should add a note on what could appear as a change in the ABI for the
rt_sigqueueinfo() call: this call explicitely sends a siginfo_t
structure. So the si_pid might have been filled by the caller. But if
the signal receiver of this rt_sigqueueinfo() is in a descendant
namespace, the si_pid field will be cleared by the kernel.

Regards,
Nadia

> 
> Cheers,
> 
> Michael
> 
> > +The "init" process of a PID namespace has a particular status, since it
> > +is known both by its children as PID 1 and by its father's PID namespace
> > +as any other PID. Thus, the "init" process of a PID namespace can be sent
> > +any signal by a process that belongs to its ancestor's PID namespace (given
> > +that the sender has the appropriate permission). But the only signals that
> > +can be sent to the "init" process of a PID namespace from its own namespace
> > +are those for which it has explicitly installed signal handlers.
> > +More precisely, signals are sent successfully (i.e
> > +.BR kill (2)
> > +will not fail), but the "init" process will silently ignore unhandled signals.
> > +
> >  .TP
> >  .BR CLONE_PARENT " (since Linux 2.3.12)"
> >  If
> >
> > --
> >
> 
> 
> 
-- 
Nadia Derbey <Nadia.Derbey@bull.net>

