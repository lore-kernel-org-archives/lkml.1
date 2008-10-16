Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315AbYJPDqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbYJPDqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 23:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbYJPDpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 23:45:53 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:57793 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbYJPDpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 23:45:53 -0400
Date: Thu, 16 Oct 2008 09:15:30 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Roland McGrath <roland@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, akpm@linux-foundation.org,
       mingo@elte.hu, jason.wessel@windriver.com, avi@qumranet.com,
       richardj_moore@uk.ibm.com
Subject: Re: [RFC Patch 1/9] Introducing generic hardware breakpoint
	handler interfaces
Message-ID: <20081016034530.GA6175@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20081008192044.GA4510@in.ibm.com> <20081008192300.GA4989@in.ibm.com> <20081016024956.602C61544CB@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081016024956.602C61544CB@magilla.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,
	Thanks for the review of the patches and your detailed comments.

My responses to your comments are placed inline....

On Wed, Oct 15, 2008 at 07:49:56PM -0700, Roland McGrath wrote:
> The "sstep_reason" hair in the x86 patch is the perfect example of exactly
> what I wanted to avoid by keeping the hw_breakpoint layer simpler.  (Also I
> strongly doubt that the x86 patch's single-step magic is correct in all the
> corner cases.  But that discussion is the very rat hole that I want to
> defer, is my point in this here discussion.)
> 
> I think the role of the hw_breakpoint layer ought to be an arch-neutral API
> for accessing and multiplexing the breakpoint functionality of the hardware.
> I don't think its role ought to include enhancing the facilities beyond
> what the actual hardware has (just the multiplexing).

I agree with you that single-stepping and enablement of a post_handler
for instruction breakpoints in x86 provides a 'feature' over what the
underlying processor provides. There may be corner-case issues to it
(and I'd be glad to hear if somebody has discovered any).

However, I'm afraid if the addition of such a feature in a layer above
the hw_breakpoint can be done entirely without modifying code that is
much closer to the hardware - say do_debug().

Without sufficient support in the proposed hw_breakpoint layer, I'm
afraid that future support for a post_handler() through use of
single-stepping for instructions in x86 may involve plenty of changes in
both the code underlying hw_breakpoint layer and itself. This is more
pronounced due to the fact that we now have multiple users of processor
single-stepping functionality - kprobes, KGDB and IABR (for PowerPC
which does not have an equivalent of RF bit).

"sstep_reason" - in its future avatars may be made to point to several
other reasons like SSTEP_KGDB (as pointed out by me earlier, integration
with KGDB is still pending and will require some re-work on the
patches).

Yet, given that there's sufficient interest to see hw_breakpoint layer
as one that provides pure wrappers around processor functionality i.e.
devoid of the overloading of single-stepping function, I will submit my
next iteration of patches with a single pointer called triggered() as a
callback function.

I would submit a new set of patches with a pre_ and post_handlers made
available (for instructions, that is) after the discussions on
hw_breakpoint itself have settled down.

I will respond to your suggestions to my individual patches as separate
emails.

> 
> AFAIK no hardware's facility delivers two separate exceptions for a single
> hit of a single breakpoint slot.  There is just one hit, and it's either
> before the instruction or after it.  So you only need one handler function,
> and one pointer slot for it.

Yes, a triggered() callback would suffice if we are not going to
overload the single-stepping functionality. I've discussed this above.

> 
> Each given type of breakpoint on a given arch is either a fire-before or a
> fire-after type.  The *_supported() functions are enough to make it clear.
> Those really should be inlines in an arch header, since they will be
> constants or type==CONST tests that are probably entirely optimized away
> (and let a big dead fork of the caller's code get optimized away).
> 
> For fire-before types, there are two flavors.  On powerpc, data breakpoints
> are fire-before, and to actually complete the triggering load/store you

It's my understanding that Data Breakpoints, set by DABR fire the Data
Storage Interrupt in PPC only after the data access operation is done
(except for store operations on atomic writes). Exceptions resulting due
to a match with IABR (for instructions) is trigger-before.

> have to clear the dabr (disable the breakpoint) before resuming (and then
> potentially deal with step-then-reenable, etc).  On x86, instruction
> breakpoints are fire-before, but there is the option of using the magic RF
> bit to suppress the hit without disabling the breakpoint.  So you need
> another inline a la *_supported() to indicate what's possible.  (Possibly
> the handler should be able to control this with its return value,
> i.e. allow returning with RF clear for some reason.)

Are you suggesting that the post_handler_supported() in i386/x86_64 be
modified to return, say UNSUPPORTED_DUE_TO_RF instead of just
UNSUPPORTED to indicate that post_handler() may be supported if
single-stepping is used to step-over the instructions rather than use
RF bit?

> 
> The sequence of suppress-and-single-step (x86 insn) or
> disable-and-single-step-and-reenable (powerpc data) will of course be
> desireable for high-level uses.  But that doesn't mean they need to be
> built into hw_breakpoint.  Make the hw_breakpoint layer clearly expose what
> the options are on the hardware, and the rest can be built up from
> hw_breakpoint along with other components managing the stepping part.
> (For user-mode stepping, the building blocks are already there.  For the
> kernel side, we can attack that windmill another day.)
> 
> 
> Thanks,
> Roland

Thanks,
K.Prasad

