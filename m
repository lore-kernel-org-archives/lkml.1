Return-Path: <linux-kernel-owner+w=401wt.eu-S1756671AbYDLSBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbYDLSBs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 14:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbYDLSBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 14:01:40 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:26190 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801AbYDLSBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 14:01:40 -0400
Subject: Re: [PATCH] Replace completions with semaphores
From: Daniel Walker <dwalker@mvista.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Oeser <ioe-lkml@rameria.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@osdl.org>
In-Reply-To: <20080412172606.GL11962@parisc-linux.org>
References: <20080411210022.GJ11962@parisc-linux.org>
	 <1208003081.7427.7.camel@twins>  <20080412172606.GL11962@parisc-linux.org>
Content-Type: text/plain
Date: Sat, 12 Apr 2008 11:01:35 -0700
Message-Id: <1208023296.21308.354.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-04-12 at 11:26 -0600, Matthew Wilcox wrote:

> It would look bloody odd to write (code taken from megasas_mgmt_ioctl_fw() in
> drivers/scsi/megaraid/megaraid_sas.c):
> 
>         if (wait_for_completion_interruptible(&instance->ioctl_completion)) {
>                 error = -ERESTARTSYS;
>                 goto out_kfree_ioc;
>         }
>         error = megasas_mgmt_fw_ioctl(instance, user_ioc, ioc);
>         complete(&instance->ioctl_sem);
> 
> What I'm trying to get a feeling for is whether people find it similarly
> odd to use semaphores where we currently use completions.  We *used*
> to, but I don't find that a compelling reason.

The above doesn't look all that odd to me. It may be that you've seen
semaphores in that position in the past and just expect to see them. 

> Arnd contacted me off-list and made the very sensible suggestion of:
> 
> struct completion {
> 	struct semaphore sem;
> }
> 
> That lets us eliminate the duplicate code since all the completion
> functions become very thin wrappers around semaphore operations.
> 
> I'll note that the semaphore code I hae queued for 2.6.26 is slightly
> more efficient than the current implementation of completions because
> completions use the generic waitqueue code and thus do an indirect
> function call per wakeup.  Of course, there's no reason completions
> couldn't use the same technique as my semaphore code ... but then they
> would be identical to semaphores ;-)

I would just re-write completions keeping the name and API in tact, make
them better and just leave semaphores alone..

Daniel

