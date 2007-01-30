Return-Path: <linux-kernel-owner+w=401wt.eu-S1752523AbXA3DAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbXA3DAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 22:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbXA3DAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 22:00:46 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38409 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbXA3DAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 22:00:45 -0500
Date: Mon, 29 Jan 2007 21:00:39 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morton <akpm@osdl.org>, "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Cedric Le Goater <clg@fr.ibm.com>,
       Daniel Hokka Zakrisson <daniel@hozac.com>, trond.myklebust@fys.uio.no,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH] namespaces: fix exit race by splitting exit
Message-ID: <20070130030039.GB21829@sergelap.austin.ibm.com>
References: <20070126052659.GA23250@sergelap.austin.ibm.com> <20070125223056.c77b0e97.akpm@osdl.org> <20070130024228.GE5062@MAIL.13thfloor.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070130024228.GE5062@MAIL.13thfloor.at>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Herbert Poetzl (herbert@13thfloor.at):
> On Thu, Jan 25, 2007 at 10:30:56PM -0800, Andrew Morton wrote:
> > On Thu, 25 Jan 2007 23:26:59 -0600
> > "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> > 
> > > Fix exit race by splitting the nsproxy putting into two pieces.
> > > First piece reduces the nsproxy refcount.  If we dropped the last
> > > reference, then it puts the mnt_ns, and returns the nsproxy as a
> > > hint to the caller.  Else it returns NULL.  The second piece of
> > > exiting task namespaces sets tsk->nsproxy to NULL, and drops the
> > > references to other namespaces and frees the nsproxy only if an
> > > nsproxy was passed in.
> > > 
> > > A little awkward and should probably be reworked, but hopefully
> > > it fixes the NFS oops.
> > 
> > I'm a bit worried about jamming something like this into 2.6.20.
> > Could the usual culprits please review this carefully with 
> > some urgency?
> 
> okay, after integrating this into two Linux-VServer
> branches and some testing, I can confirm that it 
> _seems_ to fix the nfs and related issues, but still, 
> I do not like it :)

I don't either  :)

> here my issues with this approach:
> 
>  - the code is quite hard to read and can easily
>    lead to unexpected issues when spaces are
>    manipulated

Yes, but I do think fixing the naming will help that.

>  - it breaks the basic get/put refcounting for
>    nsproxy references outside the task struct
>    i.e. we had to add a vs_put_nsproxy() which
>    does what the put_nsproxy() did before, to
>    keep and handle a reference to the nsproxy 
>    from the context structure

Was the put_and_finalize_nsproxy() not sufficient?

>  - the following scenario might become a problem
>    for future spaces (especially the pid space?)
> 
>             A                       B
> 
>  exit_task_namespaces_early()
> 			exit_task_namespaces_early()
> 			exit_notify()
> 			exit_task_namespaces()
>  ---------------------------------------------------
>  exit_notify()
>  exit_task_namespaces()

Confounded, you're right, the exit_task_namespaces() in B
would see that B had reduced the nsproxy->count to 0, and
free the nsproxy, so that exit_notify() in A would oops.
And that should be triggerable right now.

I'm afraid adding an extra refcount for the mounts is
unavoidable.

> note: I still consider it the best available fix
> for this issues, especially as 2.6.20 is in a 
> late rc stage ... but IMHO the nfs threads should
> be modified to handle the nsproxy disposal properly

That *would* lead to much more readable code.

> > And Daniel, if you can find time to runtime test it please?
> 
> he did, looks like it works fine with vanilla too
> (even when stressing the described cornercase)
> 
> best,
> Herbert
