Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbYJQSa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbYJQSa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 14:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754748AbYJQSav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 14:30:51 -0400
Received: from relay1.sgi.com ([192.48.171.29]:58672 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754232AbYJQSau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 14:30:50 -0400
Date: Fri, 17 Oct 2008 13:30:48 -0500
From: Dean Nelson <dcn@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] NULL struct irq_desc's member 'name' in dynamic_irq_cleanup()
Message-ID: <20081017183048.GA17891@sgi.com>
References: <20081016125808.GA24347@sgi.com> <20081016161145.58bbe635.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081016161145.58bbe635.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 04:11:45PM -0700, Andrew Morton wrote:
> On Thu, 16 Oct 2008 07:58:08 -0500
> Dean Nelson <dcn@sgi.com> wrote:
> 
> > If the member 'name' of the irq_desc structure happens to point to a character
> > string that is resident within a kernel module, problems insue if that module
> > is rmmod'd (at which time dynamic_irq_cleanup() is called) and then later
> > show_interrupts() is called by someone.
> 
> It would be nice to spell out what the "problems" are.

I'm working on a drivers/misc/sgi-xp patchset for SGI's UV system that will
call uv_setup_irq() and uv_teardown_irq(), both of which were submitted as a
patch (Subject: [PATCH] x86, UV: add uv_setup_irq() and uv_teardown_irq()
functions v.3) which has been applied to Ingo's tip/x86/uv.

The first argument to uv_setup_irq() is a pointer to the irq_name to be
stored in irq_desc.name. For XPC, it points to a string resident in the
kernel module.

When I rmmod xpc, uv_teardown_irq() calls destroy_irq() which in turn
calls dynamic_irq_cleanup().

In arch/x86/kernel/irq_64.c, show_interrupts() references the 'name' member
in the following manner:

	seq_printf(p, "-%-8s", irq_desc[i].name);

In my case, show_interrupts was called by the irq balancer and the end result
was an Oops. Note that this can occur later than the rmmod such that the
two events do not appear related.

> 
> Because we should work out whether this should be backported into
> -stable.  And if so, how far back it should go.

I don't have an answer for this.

