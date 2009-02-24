Return-Path: <linux-kernel-owner+w=401wt.eu-S1758489AbZBXPwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489AbZBXPwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 10:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758259AbZBXPwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 10:52:39 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:41810 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758229AbZBXPwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 10:52:38 -0500
Date: Tue, 24 Feb 2009 09:43:51 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, hpa@zytor.com,
       linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, tglx@linutronix.de, viro@zeniv.linux.org.uk,
       mpm@selenic.com, Ingo Molnar <mingo@elte.hu>,
       torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>, xemul@openvz.org
Subject: Re: Banning checkpoint (was: Re: What can OpenVZ do?)
Message-ID: <20090224154351.GD17294@us.ibm.com>
References: <20090218003217.GB25856@elte.hu> <1234917639.4816.12.camel@nimitz> <20090218051123.GA9367@x200.localdomain> <20090218181644.GD19995@elte.hu> <1234992447.26788.12.camel@nimitz> <20090218231545.GA17524@elte.hu> <20090219190637.GA4846@x200.localdomain> <1235070714.26788.56.camel@nimitz> <20090224044752.GB3202@x200.localdomain> <1235452285.26788.226.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235452285.26788.226.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dave Hansen (dave@linux.vnet.ibm.com):
> On Tue, 2009-02-24 at 07:47 +0300, Alexey Dobriyan wrote:
> > > I think what I posted is a decent compromise.  It gets you those
> > > warnings at runtime and is a one-way trip for any given process.  But,
> > > it does detect in certain cases (fork() and unshare(FILES)) when it is
> > > safe to make the trip back to the "I'm checkpointable" state again.
> > 
> > "Checkpointable" is not even per-process property.
> > 
> > Imagine, set of SAs (struct xfrm_state) and SPDs (struct xfrm_policy).
> > They are a) per-netns, b) persistent.
> > 
> > You can hook into socketcalls to mark process as uncheckpointable,
> > but since SAs and SPDs are persistent, original process already exited.
> > You're going to walk every process with same netns as SA adder and mark
> > it as uncheckpointable. Definitely doable, but ugly, isn't it?
> > 
> > Same for iptable rules.
> > 
> > "Checkpointable" is container property, OK?
> 
> Ideally, I completely agree.
> 
> But, we don't currently have a concept of a true container in the
> kernel.  Do you have any suggestions for any current objects that we
> could use in its place for a while?

I think the main point is that it makes the concept of marking a task as
uncheckpointable unworkable.  So at sys_checkpoint() time or when we cat
/proc/$$/checkpointable, we can check for all of the uncheckpointable
state of both $$ and its container (including whether $$ is a container
init).  But we can't expect that (to use Alexey's example) when one task
in a netns does a certain sys_socketcall, all tasks in the container
will be marked uncheckpointable.  Or at least we don't want to.

Which means task->uncheckpointable can't be the big stick which I think
you were hoping it would be.

-serge
