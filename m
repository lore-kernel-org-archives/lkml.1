Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbYDLR0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbYDLR0c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 13:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754464AbYDLR0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 13:26:25 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:57984 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330AbYDLR0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 13:26:24 -0400
Date: Sat, 12 Apr 2008 11:26:07 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Oeser <ioe-lkml@rameria.de>,
       Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Replace completions with semaphores
Message-ID: <20080412172606.GL11962@parisc-linux.org>
References: <20080411210022.GJ11962@parisc-linux.org> <1208003081.7427.7.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208003081.7427.7.camel@twins>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 02:24:41PM +0200, Peter Zijlstra wrote:
> On Fri, 2008-04-11 at 15:00 -0600, Matthew Wilcox wrote:
> > So does it make sense to retain the completion as a primitive
> > in Linux? 
> 
> My take on it is the opposite: kill off semaphores and leave the
> completions around.

OK, so all three of you have got the wrong end of the stick.

My point is that the struct semaphore and the struct completion are
essentially the same data structure, operated on in essentially the same
way and having essentially the same purpose.

It would look bloody odd to write (code taken from megasas_mgmt_ioctl_fw() in
drivers/scsi/megaraid/megaraid_sas.c):

        if (wait_for_completion_interruptible(&instance->ioctl_completion)) {
                error = -ERESTARTSYS;
                goto out_kfree_ioc;
        }
        error = megasas_mgmt_fw_ioctl(instance, user_ioc, ioc);
        complete(&instance->ioctl_sem);

What I'm trying to get a feeling for is whether people find it similarly
odd to use semaphores where we currently use completions.  We *used*
to, but I don't find that a compelling reason.


Arnd contacted me off-list and made the very sensible suggestion of:

struct completion {
	struct semaphore sem;
}

That lets us eliminate the duplicate code since all the completion
functions become very thin wrappers around semaphore operations.

I'll note that the semaphore code I hae queued for 2.6.26 is slightly
more efficient than the current implementation of completions because
completions use the generic waitqueue code and thus do an indirect
function call per wakeup.  Of course, there's no reason completions
couldn't use the same technique as my semaphore code ... but then they
would be identical to semaphores ;-)

So I'm going to redo my patch using Arnd's idea because it allows us
to eliminate code without changing the API at all.  We can continue the
discussion about eliminating one or the other API, but my opinion is that
eliminating either is a mistake.  The choice of API indicates how the
author thinks about the code, which is crucial for those reading the code.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
