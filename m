Return-Path: <linux-kernel-owner+w=401wt.eu-S1757827AbZEZTfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827AbZEZTfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 15:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756964AbZEZTfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 15:35:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:51896 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757054AbZEZTfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 15:35:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bXMYf62csCUrfp0hRkPyegEnm454Zy4TVW0SNU1IJFfZRHlW0THXeBgZs0h01tlIIn
         zHbNNxYz2TFj1dIP64vepTayuYaXA1l8JYxnw67wntX6ryWtqYoDZBTr1sMjZQwhGF8x
         6Ui5H0HZcBBZamG1XcCA+w9iiLy86Lqna/+Q4=
Date: Tue, 26 May 2009 23:35:03 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: akpm@linux-foundation.org, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/38] C/R: core stuff
Message-ID: <20090526193503.GB11909@x200.localdomain>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com> <1242968132-1044-18-git-send-email-adobriyan@gmail.com> <20090526131644.GA20920@hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526131644.GA20920@hallyn.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 08:16:44AM -0500, Serge E. Hallyn wrote:
> Quoting Alexey Dobriyan (adobriyan@gmail.com):
> > Introduction
> > ------------
> > Checkpoint/restart (C/R from now) allows to dump group of processes to disk
> > for various reasons like saving process state in case of box failure or
> > restoration of group of processes on another or same machine later.
> > 
> > Unlike, let's say, hypervisor C/R style which only needs to freeze guest kernel
> > and dump more or less raw pages, proposed C/R doesn't require hypervisor.
> > For that C/R code needs to know about all little and big intimate kernel details.
> > 
> > The good thing is that not all details needs to be serialized and saved
> > like, say, readahead state. The bad things is still quite a few things
> > need to be.
> 
> Hi Alexey,
> 
> the last time you posted this, I went through and tried to discern the
> meaningful differences between yours and Oren's patchsets.  Then I sent some
> patches to Oren to make his set configurable to act more like yours.  And Oren
> took them!  But now you resend this patchset with no real changelog, no
> acknowledgment that Oren's set even exists

Is this a requirement? Everybody following topic already knows about
Oren's patchset.

> - or is much farther along and pretty widely reviewed and tested (which is
> only because he started earlier and, when we asked for your counterpatches
> at an earlier stage, you would never reply) - or, most importantly, what
> it is that you think your patchset does that his does not and cannot.

There are differences. And they're not small like you're trying to describe
but pretty big compared the scale of the problem.

> *Why* are you spending your time on this instead of helping with Oren's set?

Because we disagree with some core directions Oren chose.
ANK literally said: "I don't know how to dump live netns".

So, partly patchset was created so that absolutely nobody will tell us
to shut up and show the code.

The other part, is that I looked at Oren patchset, found quite a lot of
suspicious, broken and unclean places and decided that it'd be faster
to start from scratch because sending patches will overhaul like 85% of
the code.

One example, is why CKPT_HDR_CPU and CKPT_RESTART_BLOCK exist at all?
Should objects in image be only what sharable objects are in kernel
(expect VMAs, pages and possibly file descriptors)? pt_regs don't exist
by themselves after all.

And since you guys showed that just idea of in-kernel checkpointing is not
rejected outright, it doesn't mean that you can drag every single idea too.
Because history shows, that once something (especially user-visible,
like restart syscall semantics) is in kernel it's nearly impossible
to cut it out, so it's very-very important to get it right from the very
beginning.

Now here goes second version, with prefixes fixed (kstate_") like Ingo
suggested and so Linus could look at the code and with C/R code moved
close to usual code and with more checks added (which you should have
already!) to not restore null selector in %cs for example.

> The code really isn't all that different...

> Maybe you just think that two independently written patchsets will expose
> more gotchas that we'll need to catch, so you're continuing on this effort
> under the expectation that eventualy we'll merge the two sets?

Well, it already exposes. Just print both, and watch for differences.

> Honestly, I have great respect for your coding abilities.  And if 'voices
> from on high' tell us to base upon your code, I'd be fine with that, I
> have no real problems with what I see on yet another cursory look.  But
> given the amount of collective time that's been spent developing, reviewing,
> and testing Oren's set, it wouldn't make any sense to just jump.  So
> I'd still just like to know how you see this proceeding.

Yes, please, someone decide on "checkpoint semi-live container" issue.
