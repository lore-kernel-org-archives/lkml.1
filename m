Return-Path: <linux-kernel-owner+w=401wt.eu-S1759055AbZA2Ow7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759055AbZA2Ow7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 09:52:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353AbZA2Owu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 09:52:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40914 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbZA2Owt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 09:52:49 -0500
Subject: Re: PFs on pages pinned with get_user_pages()
From: Peter Zijlstra <peterz@infradead.org>
To: Frank Mehnert <Frank.Mehnert@Sun.COM>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200901291541.32618.frank.mehnert@sun.com>
References: <200901290905.10966.frank.mehnert@sun.com>
	 <200901291502.48312.frank.mehnert@sun.com>
	 <1233238854.4495.93.camel@laptop>
	 <200901291541.32618.frank.mehnert@sun.com>
Content-Type: text/plain
Date: Thu, 29 Jan 2009 15:52:37 +0100
Message-Id: <1233240757.4495.94.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-29 at 15:41 +0100, Frank Mehnert wrote:
> On Thursday 29 January 2009, Peter Zijlstra wrote:
> > On Thu, 2009-01-29 at 15:02 +0100, Frank Mehnert wrote:
> > > I'm one of the VirtualBox developers. We are trying to fix the annoying
> > > kerneloops warning 'BUG: sleeping function called from invalid context'
> > > reported by the Fedora folks. This warning occurs when do_swap_page()
> > > calls lock_page() and in_atomic() returns true.
> > >
> > > This warning appears when we touch into memory which is pinned with
> > > get_user_pages(). In VT-x/AMD-V mode we are executing some code in the
> > > context of the Linux kernel. To prevent scheduling of the current CPU
> > > core we disable the interripts. preempt_disable() would be probably the
> > > better choice but this would oops as well if CONFIG_PREEMPT is enabled.
> >
> > but to get there, you'd have to have called handle_mm_fault() which
> > requires the mmap_sem, which should also give that might_sleep()
> > warning.
> 
> The stacktrace is
> 
>   __might_sleep()
>   lock_page()
>   handle_mm_fault()
>   do_page_fault()
>   error_code
> 
> So yes, handle_mm_fault() is called. But I assume that down_read_trylock()
> succeeded before we were forced to call down_read().
> 
> > That aside, is there any reason you have to avoid scheduling? Otherwise
> > I would just allow so and be done with it.
> 
> The reason is that our code expects that to ensure syncing of the CPU
> state with the saved state. I fear it is quite difficult to change that...

Ah, is that what KVM uses the preempt notifiers for? Could you too?

