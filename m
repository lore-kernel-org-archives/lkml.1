Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbZJ1UP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbZJ1UP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 16:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755040AbZJ1UP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 16:15:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056AbZJ1UPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 16:15:55 -0400
Subject: Re: [PATCH] [GIT PULL] tracing: allow to change permissions for
 text with dynamic ftrace enabled
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1256759778.2683.185.camel@sbs-t61.sc.intel.com>
References: <1256666023.26028.411.camel@gandalf.stny.rr.com>
	 <1256671227.2691.15.camel@sbs-t61.sc.intel.com>
	 <1256668438.26028.414.camel@gandalf.stny.rr.com>
	 <1256682364.2691.33.camel@sbs-t61.sc.intel.com>
	 <1256679318.26028.468.camel@gandalf.stny.rr.com>
	 <1256685826.15873.41.camel@sbs-t61.sc.intel.com>
	 <1256686285.26028.487.camel@gandalf.stny.rr.com>
	 <1256759778.2683.185.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 28 Oct 2009 16:15:53 -0400
Message-Id: <1256760953.26028.1770.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-28 at 11:56 -0800, Suresh Siddha wrote:
> On Tue, 2009-10-27 at 16:31 -0700, Steven Rostedt wrote: 
> > On Tue, 2009-10-27 at 15:23 -0800, Suresh Siddha wrote:
> > 
> > > > 
> > > > I'll test it out, and if it does work, you can write up a formal patch
> > > > and remove the !define that I added.
> > > 
> > > I just saw one more place calling do_ftrace_mod_code(). So moved this
> > > check inside the do_ftrace_mod_code(). Does this cover all the cases?
> > > Thanks.
> > 
> > For ftrace, probably. But I just realized this may have other
> > consequences. The CPA_DEBUG tests setting a bit in the page table at
> > random locations.
> 
> CPA_DEBUG is setting/clearing unused bit 9. It has no interaction with
> RW bits. Though the random page and random length selections may end up

Actually it does. When you call the clear_page_attribute, and go to set
or clear bit 9, the static_protections() function is called against the
new_prot. This will clear the RW bit if it is set, even if the original
caller did not touch that bit.

> splitting the large page mappings for kernel text. This is a different
> issue that needs to be addressed (perhaps I can ignore this bit 9 as
> well for the kernel text mapping. In general it sounds like a bad idea
> to break any large page mappings to small page mappings for cpa debug
> tests, especially when we don't restore the large page mapping when we
> clear those unused bits once the test is done. Will look into this).
> 
> > The code you added makes any change to kernel text
> > page attributes remove the RW bit.
> 
> Only for CONFIG_DEBUG_RODATA.
> 
> > On boot up, it is considered that
> > kernel text is writable.
> 
> For CONFIG_DEBUG_RODATA, during the boot we change it to RO.

We do that at the end of boot up. I'm sure there's a reason for this :-/

> 
> > Perhaps you need to add a check in your if statement to only prevent
> > that bit when kernel_set_to_readonly is not true.
> 
> Are you worried that kernel_set_to_readonly might not be true but we
> might have the kernel text mapping read-only?

Yes, because the code clears the RW bit whenever something changes any
attribute of that page table. Including bit 9.

> 
> As ftrace is now using kernel identity mapping on 64-bit, we can change
> the semantics of kernel_set_to_readonly to reflect the status of kernel
> identity mapping for 64-bit. I can update the comments.

Well, the identity mapping should still be set to readonly after boot
up, right?

-- Steve


