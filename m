Return-Path: <linux-kernel-owner+w=401wt.eu-S1757564AbXELGSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbXELGSo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 02:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbXELGSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 02:18:37 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750833AbXELGSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 02:18:36 -0400
Date: Fri, 11 May 2007 23:17:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
Message-Id: <20070511231711.21b8a334.akpm@linux-foundation.org>
In-Reply-To: <20070512055935.GD979@enneenne.com>
References: <20070321074121.GA13843@enneenne.com>
	<20070502193314.GA23367@enneenne.com>
	<20070510002740.c4350813.akpm@linux-foundation.org>
	<20070512055935.GD979@enneenne.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007 23:55:37 +0200
Rodolfo Giometti <giometti@enneenne.com> wrote:

> Hello,
> 
> here my new patch with a lot of fixes.
> 
> The only issue not still fixed is the one related with:
> 
> 	#define NETLINK_PPSAPI          20
> 
> I need time to resolve it.
> 
> Follows my comments and then the patch, hope now I can came back into
> -mm tree again! :)

Well I suppose I could toss it in there for a bit of review-and-test.  But
I'll need to drop it again because we do need to split this patch into the series
of patches, please.

You should do this earlier rather than later because it improves reviewability.

> > - This:
> > 
> > 	static void pps_class_release(struct class_device *cdev)
> > 	{
> > 		/* Nop??? */
> > 	}
> > 
> >   is a bug and it earns you a nastygram from Greg.  These objects must be
> >   dynamically allocated - this is not optional.
> 
> It could be acceptable defining this function as void?

No, it needs to be a proper release function, like all the other ones
around the place.

This comes up again and again and again and I recently asked Greg to direct
me to (or to write) suitable documentation, and I think he did, but I lost
it.  Greg, can you remind us please?

> >   We have a bunch of code in random other drivers which is dependent upon
> >   CONFIG_PPS_CLIENT_foo.  The problem is that if a kernel was compiled with
> >   CONFIG_PPS_CLIENT_foo=n and then the pps driver is later built for that
> >   kernel, it won't actually work because lp, serial etc weren't correctly
> >   configured when _they_ were built.
> > 
> >   This sort of cross-module coupling is considered to be a bad thing, but
> >   I'm not really sure it's all that important.
> >
> > - Please split the patch up into a series of patches: one for pps core and
> >   one for each of the clients (servers?): one for lp, one for serial, etc.
> > 
> >   Try to arrange for that series of patches to build and run at each stage
> >   of application.
> > 
> >   Please don't lose my changes when you do so ;)
> > 
> >   Please review the changes I made and a) stick to the same style and b) fix
> >   up any sites which I missed.
> > 
> > - Please remove all the typedefs:
> > 
> > +typedef struct ntp_fp {
> > +typedef union pps_timeu {
> > +typedef struct pps_info {
> > +typedef struct pps_params {
> > 
> >   and just use `struct ntp_fp' everywhere.
> 
> Those typedefs are defined in PPS specifications (please, see RFC 2783).

We don't use typedefs in-kernel.  Please convert the code to use `struct
ntp_fp' everywhere.

For RFC compatibility to userspace you can do

#ifndef __KERNEL__
typedef struct ntp_fp ntp_fp_t;
...
#endif

> > - The above four structures are communicated with userspace, yes?
> > 
> >   I believe that they will not work correctly when 32-bit userspace is
> >   communicating with a 64-bit kernel.  Alignments change and sizeof(long)
> >   changes.
> > 
> >   You don't want to have to write compat code.  I suggest that you redo
> >   those structures in terms of __u32, __u64, etc.  You probably need to use
> >   attribute((packed)) too, not sure.
> > 
> >   Then let's get that part carefully reviewed (Arnd Bergmann <arnd@arndb.de>
> >   is my go-to guru on this) and please test it carefully.
> > 
> >   Yeah, you just haven't got a chance that something as huge and as complex
> >   as struct pps_netlink_msg will survive the 32->64 transition.
> 
> The same as above. These structure are fixed by RFC 2783.

Your answer has no relationship to my question.

The problem here is that under a 64-bit kernel we require that applications
which use this structure definition work correctly when they are compiled
to generate 32-bit code and when they are compiled to generate 64-bit code.

Furthermore we should aim to to have to code work correctly across
different version of the compiler, and when different compiler options are
used, and when altogether different compilers are used.

It is not clear to me that your definition is sufficiently defensive
against _any_ of these things.

> > - Please ensure that `make headers_check' passes OK (you'll hear from me if
> >   it doesn't ;))
> 
> Done.
> 
> > - Can we get rid of the private dbg, err and info macros?  Surely there are
> >   generic ones somewhere.
> 
> They are very useful to LinuxPPS users who can enable/disable them by
> configuration menu.

You misunderstand.  I'm not saying "remove the callsites".  I'm saying
"remove the definitions".

Because we already have things like pr_debug() and pr_info(), so new code
should use those rather than reinventing them.

Plus, we already have at least 52 different implementations of "dbg" in the
tree and your 53rd one didn't compile because it clashed with someone
else's.  This is the compiler sending us a message: "use the exiting
infrastructure".   If that infrastructure is insufficient then let's
improve it.

