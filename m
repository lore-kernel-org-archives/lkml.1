Return-Path: <linux-kernel-owner+w=401wt.eu-S1760994AbXK1XsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760994AbXK1XsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 18:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755211AbXK1XsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 18:48:01 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:60436 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbXK1XsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 18:48:01 -0500
Date: Wed, 28 Nov 2007 17:47:43 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Andrew G. Morgan" <morgan@kernel.org>
Subject: Re: named + capset = EPERM [Was: 2.6.24-rc3-mm2]
Message-ID: <20071128234743.GA26217@sergelap.austin.ibm.com>
References: <474DF493.3010903@gmail.com> <830198.27330.qm@web36612.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <830198.27330.qm@web36612.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Casey Schaufler (casey@schaufler-ca.com):
> 
> --- Jiri Slaby <jirislaby@gmail.com> wrote:
> 
> > On 11/28/2007 12:41 PM, Andrew Morton wrote:
> > >
> >
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc3/2.6.24-rc3-mm2/
> > [...]
> > > +capabilities-introduce-per-process-capability-bounding-set.patch
> > 
> > A regression against -mm1. This patch breaks bind (9.5.0-18.a7.fc8):
> > capset(0x19980330, 0,
> >
> {CAP_DAC_READ_SEARCH|CAP_SETGID|CAP_SETUID|CAP_NET_BIND_SERVICE|CAP_SYS_CHROOT|CAP_SYS_RESOURCE,
> >
> CAP_DAC_READ_SEARCH|CAP_SETGID|CAP_SETUID|CAP_NET_BIND_SERVICE|CAP_SYS_CHROOT|CAP_SYS_RESOURCE,
> > 0}) = -1 EPERM (Operation not permitted)
> > 
> > $ grep SEC .config
> > CONFIG_SECCOMP=y
> > # CONFIG_NETWORK_SECMARK is not set
> > CONFIG_RPCSEC_GSS_KRB5=m
> > # CONFIG_RPCSEC_GSS_SPKM3 is not set
> > # CONFIG_SECURITY is not set
> > # CONFIG_SECURITY_FILE_CAPABILITIES is not set
> > 
> > probably this hunk?:
> > @@ -133,6 +119,12 @@ int cap_capset_check (struct task_struct
> >                 /* incapable of using this inheritable set */
> >                 return -EPERM;
> >         }
> > +       if (!!cap_issubset(*inheritable,
> > +                          cap_combine(target->cap_inheritable,
> > +                                      current->cap_bset))) {
> > +               /* no new pI capabilities outside bounding set */
> > +               return -EPERM;
> > +       }

That shouldn't be it, since you can't lower cap_bset since
CONFIG_SECURITY_FILE_CAPABILITIES=n.

> > 
> >         /* verify restrictions on target's new Permitted set */
> >         if (!cap_issubset (*permitted,
> 
> I can see that the value for CAP_LAST_CAP is not right in
> include/linux/capability.h, but I don't know if that is the

Alas, that doesn't seem likely to be it either, since cap_valid() and
therefore CAP_LAST_CAP are only used when tweaking the cap_bset.

> only problem. I should have a patch (unless someone beats me to it)
> later today.

Oh, sorry, after I sent the patch to fix that inline, I never sent it
as a separate patch.

I'll resend it to lkml right now.

thanks,
-serge
