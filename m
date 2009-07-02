Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbZGBAYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbZGBAYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 20:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbZGBAYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 20:24:07 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37334 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbZGBAYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 20:24:06 -0400
Date: Wed, 1 Jul 2009 20:24:07 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] kmod: Fix race in usermodehelper code
Message-ID: <20090702002407.GA20298@localhost.localdomain>
References: <20090701024803.GA19659@localhost.localdomain> <20090701135631.41e590f9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701135631.41e590f9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 01:56:31PM -0700, Andrew Morton wrote:
> On Tue, 30 Jun 2009 22:48:03 -0400
> Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > User Mode Helper: Fix race in UMH_WAIT_EXEC case
> > 
> > The user mode helper code has a race in it.  call_usermodehelper_exec takes an
> > allocated subprocess_info structure, which it passes to a workqueue, and then
> > passes it to a kernel thread which it creates, after which it calls complete to
> > signal to the caller of call_usremodehelper_exec that it can free the
> > subprocess_info struct.  But since we use that structure in the created thread,
> > we can't call complete from __call_usermodehelper, which is where we create the
> > kernel_thread.  We need to call complete from within the kernel thread and then
> > not use subprocess_info afterward in the case of UMH_WAIT_EXEC.  Tested
> > successfully by me.
> > 
> 
> <stares at the code for ten minutes>
> 
> Geeze that's getting complex, isn't it?  The patch looks OK.  I think.
> 
It really is.  I had initially considered solving the problem by eliminating the
completion queue, and substituting a refcounting mechanism, but as I wrote it, I
found that the memory allocation and freeing for subprocess_info was going to
need a bunch of augmentation too.  Talk about convoluted.... I decided a simple
fixing of the bug was probably for the best.

> I wonder why people aren't reporting this.  Perhaps CLONE_VFORK plus
> child-runs-first?  (_does_ the chld run first?  We seem to have changed
> it a couple of times)
> 
I think the child currently does run first, but as you note, its not always been
that way, and it might not be that way in the future, especially if the child
queues to a different cpu for whatever reason.  

Neil

