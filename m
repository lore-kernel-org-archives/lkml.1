Return-Path: <linux-kernel-owner+w=401wt.eu-S1751308AbXAXS6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308AbXAXS6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 13:58:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbXAXS6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 13:58:50 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45730 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbXAXS6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 13:58:49 -0500
Date: Wed, 24 Jan 2007 12:58:45 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       containers@lists.osdl.org
Subject: Re: [PATCH 7/8] user ns: handle file sigio
Message-ID: <20070124185845.GA597@sergelap.austin.ibm.com>
References: <20061219225902.GA25904@sergelap.austin.ibm.com> <20061219230127.GH25904@sergelap.austin.ibm.com> <m1zm881gq4.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1zm881gq4.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serue@us.ibm.com> writes:
> 
> > From: Serge E. Hallyn <serue@us.ibm.com>
> > Subject: [PATCH 7/8] user ns: handle file sigio
> >
> > A process in one user namespace could set a fowner and sigio on a file in a
> > shared vfsmount, ending up killing a task in another user namespace.
> >
> > Prevent this by adding a user namespace pointer to the fown_struct, and
> > enforcing that a process causing a signal to be sent be in the same
> > user namespace as the file owner.
> >
> 
> 
> > @@ -455,6 +460,9 @@ static const long band_table[NSIGPOLL] =
> >  static inline int sigio_perm(struct task_struct *p,
> >                               struct fown_struct *fown, int sig)
> >  {
> > +	if (fown->user_ns != init_task.nsproxy->user_ns &&
> > +				fown->user_ns != p->nsproxy->user_ns)
> > +		return 0;
> 
> Why is the initial user namespace being treated specially here?

Because we haven't yet agreed upon any other security model.  For now,
although I know you really dislike it, the fact is that "the initial
namespace has special privileges" is our basic security model.

If you want to have a discussion about an appropriate security model,
or an infrastructure to support multiple models, I think this would be a
good time, given that several namespaces are out there.  And networkns,
making its way up, also has concerns.

Three basic approaches I could see being simple to both implement and
understand/use are

1. add a set of capabilities concerning cross-ns operations, not
reassignable once they are removed.  Simple to understand, very
limited.

2. maintain that any cross-ns operation is allowed if and only if
the target ns is a child of the subject ns.

3. cross-ns operations are not permitted.  The only way to achieve
them is using a (as-yet unimplemented, but i'm working on it) namespace
enter feature to execute code in a child namespace.

> Especially when you start considering nested containers special treatment
> like this is semantically a real problem, to maintain.

Yup.

> If we need to I can see doing something special if the process setting
> fown has CAP_KILL

Obviously CAP_KILL is insufficient :)  I assume you mean a new
CAP_XNS_CAP_KILL?

> and bypassing the security checks that way, but
> hard coding rules like that when it doesn't appear we have any
> experience to indicate we need the extra functionality looks
> premature.

Ok, in this case actually I suspect you're right and we can just ditch
the exception.  But in general the security discussion is one we should
still have.

> >  	return (((fown->euid == 0) ||
> >  		 (fown->euid == p->suid) || (fown->euid == p->uid) ||
> >  		 (fown->uid == p->suid) || (fown->uid == p->uid)) &&
> 
> Eric
