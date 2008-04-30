Return-Path: <linux-kernel-owner+w=401wt.eu-S1764923AbYD3TqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764923AbYD3TqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 15:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762300AbYD3Tpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 15:45:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762609AbYD3Tpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 15:45:53 -0400
Date: Wed, 30 Apr 2008 12:45:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [patch 0/3] dynamic_printk: new feature
Message-Id: <20080430124506.0dd2a473.akpm@linux-foundation.org>
In-Reply-To: <20080429183935.GA8717@redhat.com>
References: <20080429183935.GA8717@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 14:39:35 -0400
Jason Baron <jbaron@redhat.com> wrote:

> hi,
> 
> Add the ability to dynamically enable/disable pr_debug()/dev_dbg() in the
> kernel. Yes, these calls could be converted to printk(KERN_DEBUG), but there
> are enough to cause overhead. Additionally, the logs become difficult to read.
> This work is dependent on the CONFIG_DYNAMIC_PRINTK, which when enabled adds
> about 1% to the text size of the kernel. Mssages can be dynamically controlled
> by module:
> 
> echo "add module_name" > /sys/kernel/debug/dynamic_printk/modules
> echo "remove module_name" > /sys/kernel/debug/dynamic_printk/modules
> 
> There is also a special 'all' value that turns on all the debugging messages.
> This 'all' value can also be enabled during boot by passing 'dynamic_printk' on
> the kernel command line.
> 
> I hope that these patches are useful for people writing new kernel code, for
> system debugging and testing. In enabling the 'all' feature on the kernel I was
> running i got a bunch of messages...they are pretty interesting in and of
> themselves...they could point to error conditions, or further optimizations.
> 
> 

Without having looked at the implementation yet...

We should have done this ten years ago :(

We're now in the situation where numerous different subsystems have
implemented private mechnisms for tuning their printk verbosity levels.

Have you taken a look across the tree with a view to converting some of
them?  If so, how sizeable/messy/feasible would that task be?



The situation is far, far worse with compile-time debugging selection.  We
have over two hundred different implementations of dprintk!

Have you considered the feasibility of ploddingly converting each of those
drivers, one at a time over to the new infrastructure?  Because that's what
we should do, I'm afraid.

An implication of this is that once a dprintk-using driver has been
converted over to use your new infrastructure, it should still be possible
to fully disable the debugging at compile time.  Do you handle that?

> If this patch is accepted, i'd like to convert the myriad 'debug' printks -
> DEBUGP(), dprintk(), to a standard format, either pr_debug() or dev_dbg(), to
> hook into this mechanism.

ah, so you have looked.  How nasty will it be?


A couple of things:

- Your design handles a boolean on/off control.  But some code implements
  a verbosity-level control.  Thoughts on this?

- I expect that other code implements a field-selector control, for the
  lack of a better term: an greater-than-one number of separate boolean
  controls.  How to handle this?


Thanks for working on this.  If we can get this underway and get a decent
amount of conversion done, it will be a huuuuuuuuuuuuge cleanup to the
kernel.  But we will need to design it carefully first.

I guess one good testcase would be ALSA.  It has pretty fancy debugging
control (which I apparently have never been smart enough to understand). 
Did you take a look at what they're doing, with a view to
can-we-switch-ALSA-to-use-this?


