Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936Ab0CKAGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 19:06:32 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:32833 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932918Ab0CKAGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 19:06:31 -0500
Date: Thu, 11 Mar 2010 09:05:40 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: James Bottomley <James.Bottomley@suse.de>,
       microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: [RFC] microblaze: Support FRAME_POINTER for better backtrace
Message-ID: <20100311000539.GD22729@linux-sh.org>
References: <1267128809-22749-1-git-send-email-steve@digidescorp.com> <4B878106.1090007@monstr.eu> <1267202998.3124.75.camel@iscandar.digidescorp.com> <20100301014300.GA23086@linux-sh.org> <1267478765.17327.3.camel@iscandar.digidescorp.com> <1268261476.3076.100.camel@iscandar.digidescorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268261476.3076.100.camel@iscandar.digidescorp.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 04:51:16PM -0600, Steven J. Magnani wrote:
> I've had some time to bake a Microblaze implementation of this and have
> come up with a question...
> 
> On Mon, 2010-03-01 at 15:26 -0600, Steven J. Magnani wrote:
> > On Mon, 2010-03-01 at 10:43 +0900, Paul Mundt wrote: 
> > > This doesn't look that bad compared to what some of the other
> > > architectures have to deal with. If the frame pointer is always setup
> > > using these addik/swi pairs then you can trivially scan an arbitrary
> > > number of instructions attempting to match before giving up. We do
> > > similar things for sh64 where we also have to figure out how stack frames
> > > were created in order to roll them back.
> > > 
> > > In any event, take a look at arch/sh/kernel/cpu/sh5/unwind.c, you should
> > > be able to use a similar scheme without the need for undue complexity.
> > > 
> > 
> > Thanks for the tip. This looks manageable. I had thought to search for
> > instructions that create frames but didn't think working backwards from
> > return addresses was a good idea. Using kallsyms to get the "top" of
> > each function is a nice way around that.
> 
> The kallsyms approach to unwinding depends on as many functions as
> possible being in the table, for two reasons:
> 
> * The unwind can't get past an address that kallsyms can't identify
> * A mis-lookup, such as reporting a nearby global function when the
>   actual address lies in a static function, can send the unwind off the
>   rails
> 
> To get static (local) functions into kallsyms, I've found that I need to
> specify -fno-unit-at-a-time to Microblaze gcc 4.1.2. I suspect that
> particular option has other side-effects, but despite much searching I
> couldn't find any mention of a gcc option that would do what I need. My
> x86_64 gcc (4.4.1) seems to emit local symbols by default even with
> -funit-at-a-time. 
> 
> Any suggestions?
> 
Local functions under kallsyms are a bit of a bother, particularly since
there are bound to be namespace collisions that the linker will never
see. You would also want to set KALLSYMS_ALL if you are valuing debugging
over space savings, which seems to be the case if you are considering
disabling unit-at-a-time.

On the kprobes side there was an attempt by jejb to prefix local symbols
with their file and line numbers to differentiate the symbols, but while
this might work in the case of manual probe insertion, it's certainly not
suitable for the unwinder. Nothing seems to have happened with that
though, so the point is rather moot regardless.

The lookup not being exact is certainly a problem, but I haven't found a
good workaround for that either. Potentially inaccurate call stacks are
still wildly preferential to not being able to unwind past the first
frame.
