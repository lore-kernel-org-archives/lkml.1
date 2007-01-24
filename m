Return-Path: <linux-kernel-owner+w=401wt.eu-S1752042AbXAXRYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbXAXRYD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 12:24:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbXAXRYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 12:24:01 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33854 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbXAXRYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 12:24:00 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, containers@lists.osdl.org
Subject: Re: [PATCH 7/8] user ns: handle file sigio
References: <20061219225902.GA25904@sergelap.austin.ibm.com>
	<20061219230127.GH25904@sergelap.austin.ibm.com>
Date: Wed, 24 Jan 2007 10:23:31 -0700
In-Reply-To: <20061219230127.GH25904@sergelap.austin.ibm.com> (Serge
	E. Hallyn's message of "Tue, 19 Dec 2006 17:01:27 -0600")
Message-ID: <m1zm881gq4.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> From: Serge E. Hallyn <serue@us.ibm.com>
> Subject: [PATCH 7/8] user ns: handle file sigio
>
> A process in one user namespace could set a fowner and sigio on a file in a
> shared vfsmount, ending up killing a task in another user namespace.
>
> Prevent this by adding a user namespace pointer to the fown_struct, and
> enforcing that a process causing a signal to be sent be in the same
> user namespace as the file owner.
>


> @@ -455,6 +460,9 @@ static const long band_table[NSIGPOLL] =
>  static inline int sigio_perm(struct task_struct *p,
>                               struct fown_struct *fown, int sig)
>  {
> +	if (fown->user_ns != init_task.nsproxy->user_ns &&
> +				fown->user_ns != p->nsproxy->user_ns)
> +		return 0;

Why is the initial user namespace being treated specially here?
Especially when you start considering nested containers special treatment
like this is semantically a real problem, to maintain.

If we need to I can see doing something special if the process setting
fown has CAP_KILL and bypassing the security checks that way, but
hard coding rules like that when it doesn't appear we have any
experience to indicate we need the extra functionality looks
premature.

>  	return (((fown->euid == 0) ||
>  		 (fown->euid == p->suid) || (fown->euid == p->uid) ||
>  		 (fown->uid == p->suid) || (fown->uid == p->uid)) &&

Eric
