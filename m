Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591AbYKDL6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbYKDL6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 06:58:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbYKDL6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 06:58:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45267 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbYKDL6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 06:58:31 -0500
Date: Tue, 4 Nov 2008 09:57:41 -0200
From: Eduardo Habkost <ehabkost@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       Andrew Morton <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use BIOS reboot on Toshiba Portege 4000
Message-ID: <20081104115741.GE23893@blackpad>
References: <200810312118.45368.arvidjaar@mail.ru> <20081103090843.GI11730@elte.hu> <490ECC4D.9090704@redhat.com> <20081103133306.GZ23893@blackpad> <490F0DA3.4090108@redhat.com> <m1myggdbzg.fsf@frodo.ebiederm.org> <4910283B.4070501@redhat.com> <m163n3burt.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m163n3burt.fsf@frodo.ebiederm.org>
X-Fnord: you can see the fnord
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2008 at 03:22:30AM -0800, Eric W. Biederman wrote:
> Avi Kivity <avi@redhat.com> writes:
> 
> > Eric W. Biederman wrote:
> >> I think we are confusing two issues here.
> >>
> >> - Ordinary machine_restart which happens to call emergency_restart.
> >>   And is proceeded by machine_shutdown.
> >>
> >> - And emergency_restart itself.
> >>
> >> To some extent I would be a lot happier if Alt-sysrq-r did what
> >> was necessary to get into a context where it can call machine_restart
> >> or even better kernel_restart().
> >> emergency_restart() is a nice idea but is broken by design.
> >>
> >>
> >
> > Isn't emergency_restart() equivalent to kexec()?  Both start from indeterminite
> > conditions.
> 
> Good point.  That is a reasonable direction to evolve it on x86.
> Similar to and sharing some of the same code as the kexec on panic path.
> 
> We may need to separate out emergency_restart from the normal clean
> restart to make that happen.  It would be pointless and silly to be
> sending NMI at other cpus for example if we have cleanly shut them
> down already.

When pulling the NMI stuff to the reboot code, I've just hit this issue:
currently, machine_ops.emergency_restart has two possible semantics:

- The function that should be called to immediately reboot the machine,
  after the cleanup done by machine_restart()
- The function that should be called to reboot the machine when we are
  on a possibly inconsistent state (and will do the vmx-disabling
  stuff)

Currently we don't do anything special on emergency_restart() case,
so both cases are equivalent. But now we will need to differentiate
both cases.


...all this work because VMX breaks the good old reset lines.  :\

-- 
Eduardo
