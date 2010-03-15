Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab0COEYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 00:24:36 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37199 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab0COEYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 00:24:33 -0400
Date: Sun, 14 Mar 2010 23:24:31 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Matthew Helsley <matt.helsley@gmail.com>
Cc: mtk.manpages@gmail.com, James Morris <jmorris@namei.org>,
       lkml <linux-kernel@vger.kernel.org>, SELinux <selinux@tycho.nsa.gov>,
       linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@epoch.ncsc.mil>,
       Kees Cook <kees.cook@canonical.com>, Andrew Morgan <morgan@kernel.org>,
       "Christopher J. PeBenito" <cpebenito@tresys.com>,
       Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCH] Define CAP_SYSLOG
Message-ID: <20100315042431.GA7550@us.ibm.com>
References: <20100312205537.GA1091@us.ibm.com>
 <cfd18e0f1003132118y21bd71band2d07ae85c8d4c9@mail.gmail.com>
 <20100314053521.GA12410@us.ibm.com>
 <6a12d2f31003141816k5c637891s7e85231fc891e4e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6a12d2f31003141816k5c637891s7e85231fc891e4e@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Matthew Helsley (matt.helsley@gmail.com):
> On Sat, Mar 13, 2010 at 10:35 PM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> > Quoting Michael Kerrisk (mtk.manpages@googlemail.com):
> >> > There is one downside to this patch:  If some site or distro currently
> >> > has syslogd/whatever running as a non-root user with cap_sys_admin+pe,
> >> > then it will need to be changed to run with cap_syslog+pe.  I don't
> >> > know if there are such sites, or if that concern means we should take
> >> > a different approach to introducing this change, or simply refuse this
> >> > change.
> >>
> >> *If* this is a problem, would the way to address it not be to permit
> >> syslog if the caller has *either* CAP_SYS_ADMIN or CAP_SYSLOG? (The
> >> only weakness I see in this idea is that it fails to lighten the
> >> hugely overlaoded CAP_SYS_ADMIN.)
> >
> > Which becomes a very big weakness because it won't allow a
> > container to be started with cap_sys_admin but not cap_syslog
> > in its capability bounding set.
> >
> > So, if it is deemed a problem, then the alternative will be to
> > introduce a syslog namespace.  Container setup can then create
> > a new syslog namespace, and can no longer read or clear the
> > host's syslog.
> >
> > thanks,
> > -serge
> 
> Would it make sense to warn once when CAP_SYS_ADMIN permits what
> CAP_SYSLOG will be used for in the future? Something like:
> 
> -            type != SYSLOG_ACTION_SIZE_BUFFER) && !capable(CAP_SYS_ADMIN))
> +            type != SYSLOG_ACTION_SIZE_BUFFER) &&
> !(capable(CAP_SYSLOG)||capable(CAP_SYS_ADMIN))) {
> +             WARN_ONCE(capable(CAP_SYS_ADMIN) &&
> !capable(CAP_SYSLOG), "CAP_SYS_ADMIN will not permit syslog
> configuration in the near future. Please switch your code to
> CAP_SYSLOG\n");
>                return -EPERM;
> +        }
>        return 0;

Good idea - though I'd prefer to WARN_ONCE and then deny :)  If we log
and allow, the log msg will be ignored.

> After a period of time allowing userspace apps to transition to
> CAP_SYSLOG remove the CAP_SYS_ADMIN portions. Of course this won't fix
> containers for that transition period but it would avoid a sudden
> change of what CAP_SYS_ADMIN allows.
> 
> > So, if it is deemed a problem, then the alternative will be to
> > introduce a syslog namespace.  Container setup can then create
> > a new syslog namespace, and can no longer read or clear the
> > host's syslog.
> 
> Yup, this is also an option. Possibly better as it doesn't involved
> changing the meaning of a overly-[ab]used capability bit and wouldn't
> require a transition period.

Still I can definately see a case where you want the container to
be in the host's syslog for simplicity, but not be able to clear it.

-serge
