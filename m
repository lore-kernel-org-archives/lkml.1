Return-Path: <linux-kernel-owner+w=401wt.eu-S1753273AbZE1Wdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbZE1Wdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 18:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbZE1Wdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 18:33:36 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:57800 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbZE1Wdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 18:33:35 -0400
Date: Thu, 28 May 2009 15:33:34 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       xemul@parallels.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/38] C/R: core stuff
Message-ID: <20090528223334.GB17402@us.ibm.com>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com> <1242968132-1044-18-git-send-email-adobriyan@gmail.com> <20090526131644.GA20920@hallyn.com> <20090526193503.GB11909@x200.localdomain> <4A1DA8FB.3000306@cs.columbia.edu> <20090527221753.GB8321@x200.localdomain> <4A1DC270.8080807@cs.columbia.edu> <20090528153322.GB18256@x200.localdomain> <4A1F0E29.2040506@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1F0E29.2040506@cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 06:20:25PM -0400, Oren Laadan wrote:
> 
> 
> Alexey Dobriyan wrote:
> > On Wed, May 27, 2009 at 06:45:04PM -0400, Oren Laadan wrote:
> >> Alexey Dobriyan wrote:
> >>> On Wed, May 27, 2009 at 04:56:27PM -0400, Oren Laadan wrote:
> >>>> Alexey Dobriyan wrote:
> >>>>> On Tue, May 26, 2009 at 08:16:44AM -0500, Serge E. Hallyn wrote:
> >>>>>> Quoting Alexey Dobriyan (adobriyan@gmail.com):
> >>>>>>> Introduction
> >>>>>>> ------------
> >>>>>>> Checkpoint/restart (C/R from now) allows to dump group of processes to disk
> >>>>>>> for various reasons like saving process state in case of box failure or
> >>>>>>> restoration of group of processes on another or same machine later.
> >>>>>>>
> >>>>>>> Unlike, let's say, hypervisor C/R style which only needs to freeze guest kernel
> >>>>>>> and dump more or less raw pages, proposed C/R doesn't require hypervisor.
> >>>>>>> For that C/R code needs to know about all little and big intimate kernel details.
> >>>>>>>
> >>>>>>> The good thing is that not all details needs to be serialized and saved
> >>>>>>> like, say, readahead state. The bad things is still quite a few things
> >>>>>>> need to be.
> >>>>>> Hi Alexey,
> >>>>>>
> >>>>>> the last time you posted this, I went through and tried to discern the
> >>>>>> meaningful differences between yours and Oren's patchsets.  Then I sent some
> >>>>>> patches to Oren to make his set configurable to act more like yours.  And Oren
> >>>>>> took them!  But now you resend this patchset with no real changelog, no
> >>>>>> acknowledgment that Oren's set even exists
> >>>>> Is this a requirement? Everybody following topic already knows about
> >>>>> Oren's patchset.
> >>>> Some people do ack other people's work. See for example patches #1
> >>>> and #24 in my recent post. You're welcome.
> >>>>
> >>>>>> - or is much farther along and pretty widely reviewed and tested (which is
> >>>>>> only because he started earlier and, when we asked for your counterpatches
> >>>>>> at an earlier stage, you would never reply) - or, most importantly, what
> >>>>>> it is that you think your patchset does that his does not and cannot.
> >>>>> There are differences. And they're not small like you're trying to describe
> >>>>> but pretty big compared the scale of the problem.
> >>>> I've asked before, and I repeat now: can you enumerate these "big"
> >>>> scary differences that make it such a "big" problem ?
> >>>>
> >>>> So far, we identified two main "design" issues -
> >>> Why in "? Yes, they are high-level design issues.
> >>>
> >> In quotes, because I argued further on that, although my patchset
> >> takes a stand on both issues, it can be easily reverted _within_
> >> that patchset. Moreover, I argue that they can co-exist.
> >>
> >>>> 1) Whether or not allow c/r of sub-container (partial hierarchy)
> >>>>
> >>>> 2) Creation of restarting process hierarchy in kernel or in userspace
> >>>>
> >>>> As for #1, you are the _only_ one who advocates restricting c/r to
> >>>> a full container only. I guess you have your reasons, but I'm unsure
> >>>> what they may be.
> >>> The reason is that checkpointing half-frozen, half-live container is
> >>> essentially equivalent to live container which adds much complexity
> >>> to code fundamentally preventing kernel from taking coherent snapshot.
> >>>
> >>> In such situations kernel will do its job badly.
> >> In such situation the kernel will do a bad job if the user is asking
> >> for a bad job.
> > 
> > User doesn't even understand why we're discussing this issue so hard.
> > 
> >> Just like checkpointing without snapshotting the file system and expecting
> >> it to always work.
> > 
> > This is different.
> > 
> > Kernel can't do anything about not-synced fs. Because nodoby is
> > advocating that kernel should sync fs. Consequently, screwup in fs sync is
> > clearly user failure. Any (yours, mine) in-kernel C/R has this failure mode,
> > so we skip it and discuss what's left.
> > 
> > Now, kernel CAN do something about tasks and other data structures
> > because it easily controls them.
> > 
> > Your procedure for checkpointing starts with "kill -STOP".
> 
> Wrong. It requires the processes to be frozen.
> 
> > To make anything reliable, you have to ban "kill -CONT" for the duration of
> > checkpointing. Is this done BTW? I don't remember new flags added
> > in task_struct. Or this is going to be skipped on grounds that it's
> > user screwup (potentially oopsable).
> > 
> > That's why, OpenVZ relies on suspend-to-ram freezer solely, because userspace
> > can't arbitrarily send suspend and freeze notifications. We only need to
> > protect against untimely STR unfreeze which only adds code in C/R code
> > not in task_struct.
> 
> Same principle for both patchsets:  tasks may *not* be permitted to
> execute while being checkpointed.
> 
> For this I suggested a CHECKPOINTING freezer state: transition to/from
> this state is done _only_ by sys_checkpoint(), so that checkpointed
> processes cannot be unfrozen. Matt Helseley already posted a patch to
> implement this.

In case it helps, here's the patch and some feedback Oren gave me:

https://lists.linux-foundation.org/pipermail/containers/2009-May/017586.html

Cheers,
	-Matt Helsley
