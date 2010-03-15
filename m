Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935228Ab0COBQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 21:16:57 -0400
Received: from mail-gx0-f227.google.com ([209.85.217.227]:48432 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935186Ab0COBQx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 21:16:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BVp3Pquf7gEXtJmtstRdazE4VVczku5LVqbUUbt2r5MPjwl2Xm3A9CnE+qeCFtdaFf
         CRPKyFSECmkWPQNHgCMwHqGfPi3twwSP838D+0W9BZ5wtiyeRDQqQkzHKNXxNrByrQZ2
         HrzGt+DcbEJrykujqLMTcZ3BHqrtFgJqaH8h4=
MIME-Version: 1.0
In-Reply-To: <20100314053521.GA12410@us.ibm.com>
References: <20100312205537.GA1091@us.ibm.com>
	 <cfd18e0f1003132118y21bd71band2d07ae85c8d4c9@mail.gmail.com>
	 <20100314053521.GA12410@us.ibm.com>
Date: Sun, 14 Mar 2010 18:16:51 -0700
Message-ID: <6a12d2f31003141816k5c637891s7e85231fc891e4e@mail.gmail.com>
Subject: Re: [PATCH] Define CAP_SYSLOG
From: Matthew Helsley <matt.helsley@gmail.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: mtk.manpages@gmail.com, James Morris <jmorris@namei.org>,
       lkml <linux-kernel@vger.kernel.org>, SELinux <selinux@tycho.nsa.gov>,
       linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@epoch.ncsc.mil>,
       Kees Cook <kees.cook@canonical.com>, Andrew Morgan <morgan@kernel.org>,
       "Christopher J. PeBenito" <cpebenito@tresys.com>,
       Eric Paris <eparis@parisplace.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 13, 2010 at 10:35 PM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> Quoting Michael Kerrisk (mtk.manpages@googlemail.com):
>> > There is one downside to this patch:  If some site or distro currently
>> > has syslogd/whatever running as a non-root user with cap_sys_admin+pe,
>> > then it will need to be changed to run with cap_syslog+pe.  I don't
>> > know if there are such sites, or if that concern means we should take
>> > a different approach to introducing this change, or simply refuse this
>> > change.
>>
>> *If* this is a problem, would the way to address it not be to permit
>> syslog if the caller has *either* CAP_SYS_ADMIN or CAP_SYSLOG? (The
>> only weakness I see in this idea is that it fails to lighten the
>> hugely overlaoded CAP_SYS_ADMIN.)
>
> Which becomes a very big weakness because it won't allow a
> container to be started with cap_sys_admin but not cap_syslog
> in its capability bounding set.
>
> So, if it is deemed a problem, then the alternative will be to
> introduce a syslog namespace.  Container setup can then create
> a new syslog namespace, and can no longer read or clear the
> host's syslog.
>
> thanks,
> -serge

Would it make sense to warn once when CAP_SYS_ADMIN permits what
CAP_SYSLOG will be used for in the future? Something like:

-            type != SYSLOG_ACTION_SIZE_BUFFER) && !capable(CAP_SYS_ADMIN))
+            type != SYSLOG_ACTION_SIZE_BUFFER) &&
!(capable(CAP_SYSLOG)||capable(CAP_SYS_ADMIN))) {
+             WARN_ONCE(capable(CAP_SYS_ADMIN) &&
!capable(CAP_SYSLOG), "CAP_SYS_ADMIN will not permit syslog
configuration in the near future. Please switch your code to
CAP_SYSLOG\n");
               return -EPERM;
+        }
       return 0;

After a period of time allowing userspace apps to transition to
CAP_SYSLOG remove the CAP_SYS_ADMIN portions. Of course this won't fix
containers for that transition period but it would avoid a sudden
change of what CAP_SYS_ADMIN allows.

> So, if it is deemed a problem, then the alternative will be to
> introduce a syslog namespace.  Container setup can then create
> a new syslog namespace, and can no longer read or clear the
> host's syslog.

Yup, this is also an option. Possibly better as it doesn't involved
changing the meaning of a overly-[ab]used capability bit and wouldn't
require a transition period.

Cheers.
    -Matt Helsley
