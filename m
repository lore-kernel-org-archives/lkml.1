Return-Path: <linux-kernel-owner+w=401wt.eu-S1759621AbZDNSgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621AbZDNSgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759399AbZDNSeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:34:25 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:53343 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759420AbZDNSeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:34:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ewv4J6TGw/LQKR3p/8xFLfVj9D5mdTd+L3rP4b6/OarnI79/txwh9F02J8U7iI7bYg
         kTdsi1MjLzfJ/xz+lbulDMQE/xT0jNelTtMzH0u80HY9Ceu4TXyNF2AfHke3Ra7qDgFm
         f6aQsAfRDcJxOdckEtJWznoJeuyTuFMUawt2s=
Date: Tue, 14 Apr 2009 22:34:35 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, xemul@parallels.com,
       serue@us.ibm.com, mingo@elte.hu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/30] C/R OpenVZ/Virtuozzo style
Message-ID: <20090414183435.GA28233@x200.localdomain>
References: <20090410023207.GA27788@x200.localdomain> <1239340031.24083.21.camel@nimitz> <20090413091423.GA19236@x200.localdomain> <49E4108A.8050201@cs.columbia.edu> <20090414145830.GA27461@x200.localdomain> <49E4D115.5080601@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E4D115.5080601@cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 02:08:21PM -0400, Oren Laadan wrote:
> 
> 
> Alexey Dobriyan wrote:
> > On Tue, Apr 14, 2009 at 12:26:50AM -0400, Oren Laadan wrote:
> >> Alexey Dobriyan wrote:
> >>> On Thu, Apr 09, 2009 at 10:07:11PM -0700, Dave Hansen wrote:
> >>>> I'm curious how you see these fitting in with the work that we've been
> >>>> doing with Oren.  Do you mean to just start a discussion or are you
> >>>> really proposing these as an alternative to what Oren has been posting?
> >>> Yes, this is posted as alternative.
> >>>
> >>> Some design decisions are seen as incorrect from here like:
> >> A definition of "design" would help; I find most of your comments
> >> below either vague, cryptic, or technical nits...
> >>
> >>> * not rejecting checkpoint with possible "leaks" from container
> >> ...like this, for example.
> > 
> > Like checkpointing one process out of many living together.
> 
> See the thread on creating tasks in userspace vs. kernel space:
> the argument here is that is an interesting enough use case for
> a checkpoint of not-an-entire-container.
> 
> Of course it will require more logic to it, so the user can choose
> what she cares or does not care about, and the kernel could alert
> the user about it.
> 
> The point is, that it is, IMHO, a desirable capability.
> 
> > 
> > If you allow this you consequently drop checks (e.g. refcount checks)
> > for "somebody else is using structure to be checkpointed".
> > 
> 
> From this point below, I totally agree with you that for the purpose
> of a whole-container-checkpoint this is certainly desirable. My point
> was that it can be easily added the existing patchset (not yours).
> Why not add it there ?
> 
> > If you drop these checks, you can't decipher legal sutiations like
> > "process genuinely doesn't care about routing table of netns it lives in"
> > from "illegal" situations like "process created shm segment but currently
> > doesn't use it so not checkpointing ipcns will result in breakagenlater".
> > 
> > You'll have to move responsibility to user, so user exactly knows what
> > app relies on and on what. And probably add flags like CKPT_SHM,
> > CKPT_NETNS_ROUTE ad infinitum.
> > 
> > And user will screw it badly and complain: "after restart my app
> > segfaulted". And user himself is screwed now: old running process is
> > already killed (it was checkpointed on purpose) and new process in image
> > segfaults every time it's restarted.
> > 
> > All of this in out opinion results in doing C/R unreliably and badly.
> > 
> > We are going to do it well and dig from the other side.
> > 
> > If "leak" (any "leak") is detected, C/R is aborted because kernel
> > doesn't know what app relies on and what app doesn't care about.
> > 
> > This protected from situations and failure modes described above.
> > 
> > This also protects to some extent from in-kernel changes where C/R code
> > should have been updated but wasn't. Person doing incomplete change won't
> > notice e.g refcount checks and won't try to "fix" them. But we'll notice it,
> > e.g. when running testsuite (amen) and update C/R code accordingly.
> > 
> > I'm talking about these checks so that everyone understands:
> > 
> > 	for_each_cr_object(ctx, obj, CR_CTX_MM_STRUCT) {
> >                 struct mm_struct *mm = obj->o_obj;
> >                 unsigned int cnt = atomic_read(&mm->mm_users);
> > 
> >                 if (obj->o_count != cnt) {
> >                         printk("%s: mm_struct %p has external references %lu:%u\n", __func__, mm, obj->o_count, cnt);
> >                         return -EINVAL;
> >                 }
> >         }
> > 
> > They are like moving detectors, small, invisible, something moved, you don't
> > know what, but you don't care because you have to investigate anyway.
> > 
> > In this scheme, if user wants to checkpoint just one process, he should
> > start it alone in separate container. Right now, in posted patchset
> > as cloned process with
> > CLONE_NEWNS|CLONE_NEWUTS|CLONE_NEWIPC|CLONE_NEWUSER|CLONE_NEWPID|CLONE_NEWNET
> 
> So you suggest that to checkpoint a single process, say a cpu job that
> would run a week, which runs in the topmost pid_ns, I will need to
> checkpoint the entire topmost pid_ns (as a container, if at all possible
> - surely there will non-checkpointable tasks there) and then in
> user-space filter out the data and leave only one task, and then to
> restart I'll use a container again ?

No, you do little preparations and start CPU job in container from the very
beginning.

> Pffff ... why not just allow subtree checkpoint, not in a container,
> with its well known limitations -- would work the same, for very little
> additional implementation cost.
