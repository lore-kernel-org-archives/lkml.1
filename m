Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab0CABni (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 20:43:38 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:39603 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab0CABng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 20:43:36 -0500
Date: Mon, 1 Mar 2010 10:43:01 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: monstr@monstr.eu, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] microblaze: Support FRAME_POINTER for better backtrace
Message-ID: <20100301014300.GA23086@linux-sh.org>
References: <1267128809-22749-1-git-send-email-steve@digidescorp.com> <4B878106.1090007@monstr.eu> <1267202998.3124.75.camel@iscandar.digidescorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267202998.3124.75.camel@iscandar.digidescorp.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 10:49:58AM -0600, Steven J. Magnani wrote:
> On Fri, 2010-02-26 at 09:06 +0100, Michal Simek wrote:
> > 2. it is just one optimization which could help but IMHO not. Your patch 
> > expects that every stack frame size has 7/8 (doesn't matter right now) 
> > items but that's not correct expectation. (Do objdump from vmlinux and 
> > look at cpu_idle, prom_add_property and others) - that's why I think 
> > that your patch won't work.
> 
> The patch expects only that frames involved in a backtrace are _at
> least_ 8 words deep and that the frame pointer is always the 8th word of
> the frame (index 7).
> 
> In my build, cpu_idle() begins like this:
> 
>  4b8:   3021ffd8        addik   r1, r1, -40
>  4bc:   fa61001c        swi     r19, r1, 28
>  4c0:   f9e10000        swi     r15, r1, 0
> 
> ...which is a frame of 40 bytes, and a frame pointer stored 7 words into
> the frame. prom_add_property() has a frame of 48 bytes and a frame
> pointer stored 7 words in. 
> 
> Now, disable_hlt() has a runt frame of only 8 bytes when compiled with
> -fno-omit-frame-pointer. But it is a leaf function and should never show
> up in a backtrace, at least in a noMMU kernel. For MMU I suppose it's
> possible for a leaf function to oops. I don't know the implications of
> that.
> 
> Although the examples you cite don't prove your point, in looking more
> closely, I see that there _are_ non-leaf functions where the frame
> pointer is being placed elsewhere, for example do_one_initcall():
> 
> 20000064:       3021ffc0        addik   r1, r1, -64
> 20000068:       fa61002c        swi     r19, r1, 44
> 
> This of course is a killer. I wonder if this is something that could be
> changed in the Microblaze gcc someday.
> 
This doesn't look that bad compared to what some of the other
architectures have to deal with. If the frame pointer is always setup
using these addik/swi pairs then you can trivially scan an arbitrary
number of instructions attempting to match before giving up. We do
similar things for sh64 where we also have to figure out how stack frames
were created in order to roll them back.

In any event, take a look at arch/sh/kernel/cpu/sh5/unwind.c, you should
be able to use a similar scheme without the need for undue complexity.
