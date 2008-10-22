Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbYJVREX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbYJVREX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbYJVREM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:04:12 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:37405 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbYJVREL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:04:11 -0400
Date: Wed, 22 Oct 2008 12:03:25 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org, tglx@linutronix.de,
       dave@linux.vnet.ibm.com, mingo@elte.hu, hpa@zytor.com,
       viro@zeniv.linux.org.uk
Subject: Re: [RFC v7][PATCH 2/9] General infrastructure for checkpoint
	restart
Message-ID: <20081022170325.GA4908@us.ibm.com>
References: <1224481237-4892-1-git-send-email-orenl@cs.columbia.edu> <1224481237-4892-3-git-send-email-orenl@cs.columbia.edu> <20081021124130.a002e838.akpm@linux-foundation.org> <20081021202410.GA10423@us.ibm.com> <48FE82DF.6030005@cs.columbia.edu> <20081022152804.GA23821@us.ibm.com> <48FF4EB2.5060206@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FF4EB2.5060206@cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oren Laadan (orenl@cs.columbia.edu):
> 
> 
> Serge E. Hallyn wrote:
> > Quoting Oren Laadan (orenl@cs.columbia.edu):
> > Just thinking aloud...
> > 
> > Is read mode appropriate?  The user can edit the statefile and restart
> > it.  Admittedly the restart code should then do all the appropriate
> > checks for recreating resources, but I'm having a hard time thinking
> > through this straight.
> > 
> > Let's say hallyn is running passwd.  ruid=500,euid=0.  He quickly
> > checkpoints.  Then he restarts.  Will restart say "ok, the /bin/passwd
> > binary is setuid 0 so let hallyn take euid=0 for this?"  I guess not.
> > But are there other resources for which this is harder to get right?
> 
> I'd say that checkpoint and restart are separate.
> 
> In checkpoint, you read the state and save it somewhere; you don't
> modify anything in the target task (container). This equivalent to
> ptrace read-mode. If you could do ptrace, you could save all that
> state. In fact, you could save it in a format that is suitable for
> a future restart ... (or just forge one !)

Yeah, that's convincing.

> In restart, we either don't trust the user and keep everything to
> be done with her credentials, of we trust the root user and allow
> all operations (like loading a kernel module).
> 
> We can actually have both modes of operations. How to decide that
> we trust the user is a separate question:  one option is to have
> both checkpoint and restart executables setuid - checkpoint will
> sign (in user space) the output image, and restart (in user space)
> will validate the signature, before passing it to the kenrel. Surely
> there are other ways...

Makes sense.

...

> > Hmm, so do you think we just always use the caller's credentials?
> 
> Nope, since we will fail to restart in many cases. We will need a way
> to move from caller's credentials to saved credentials, and even from
> caller's credentials to privileged credentials (e.g. to reopen a file
> that was created by a setuid program prior to dropping privileges).

Can we agree to worry about that much much later? :)  Would you agree
that for the majority of use-cases, restarting with caller's credentials
will work?  Or am I wrong about that?

> To do that, we will need to agree on a way to escalate/change the
> credentials. This however belongs to user-space (and then the binaries
> for checkpoint/restart will be setuid themselves).

Ok those are less scary, and I have no problem with those.

> There will also be the issue of mapping credentials: a user A may have
> one UID/GID on once system and another UID/GID on another system, and
> we may want to do the conversion. This, too, can be done in user space
> prior to restart by using an appropriate filter through the checkpoint
> stream.

User namespaces may help here too.  So user A can create a new user
namespace and restart as user B in that namespace.  But right now that
sounds like overkill.

-serge
