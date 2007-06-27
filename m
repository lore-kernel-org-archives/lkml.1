Return-Path: <linux-kernel-owner+w=401wt.eu-S1762563AbXF0QLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762563AbXF0QLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 12:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760559AbXF0QLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 12:11:09 -0400
Received: from canuck.infradead.org ([209.217.80.40]:52711 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666AbXF0QLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 12:11:08 -0400
Subject: Re: [PATCH] LinuxPPS (with new syscalls API)
From: David Woodhouse <dwmw2@infradead.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070627125802.GI13886@enneenne.com>
References: <20070626100628.GO24183@enneenne.com>
	 <1182855427.12109.203.camel@pmac.infradead.org>
	 <20070626170622.GA13886@enneenne.com>
	 <1182879520.3263.19.camel@shinybook.infradead.org>
	 <20070627101449.GH13886@enneenne.com>
	 <1182939510.6409.17.camel@pmac.infradead.org>
	 <20070627125802.GI13886@enneenne.com>
Content-Type: text/plain
Date: Wed, 27 Jun 2007 17:11:00 +0100
Message-Id: <1182960660.1170.12.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-27 at 14:58 +0200, Rodolfo Giometti wrote: 
> On Wed, Jun 27, 2007 at 11:18:30AM +0100, David Woodhouse wrote:
> > On Wed, 2007-06-27 at 12:14 +0200, Rodolfo Giometti wrote:
> > > On Tue, Jun 26, 2007 at 06:38:40PM +0100, David Woodhouse wrote:
> > > > 
> > > > 64-bit kernels can run 32-bit userspace programs. But some structures
> > > > come out _differently_ between 32-bit and 64-bit compilation, so the
> > > > system call needs a special 'compat' handler instead of just running the
> > > > normal 64-bit system call.
> > > > 
> > > > The 'struct timespec' is one structure which is sometimes different for
> > > > 32-bit vs. 64-bit, so any system call taking a 'struct timespec' must
> > > > have a separate compat_sys_xxxx() to handle that. See something like
> > > > compat_sys_clock_settime() in kernel/compat.c for an example (but don't
> > > > use set_fs() like it does; just see how it handles the compat_timespec).
> > > 
> > > Did you mean something like this?
> > 
> > How will 64-bit system calls work if you do it like that? You need to
> > provide _both_ sys_time_pps_fetch() and compat_sys_time_pps_fetch().
> 
> Sorry, I'm new to this 32/64 bits issues...
> 
> Now is it correct?

No, because you're passing a _kernel_ pointer to sys_time_pps_fetch()
where it expects a userspace pointer. Use compat_alloc_user_space() to
find somewhere to put it in user space, instead. Or change your internal
__sys_time_pps_fetch() function to take a number of ticks instead of a
pointer to a timespec, then call that directly with appropriate
arguments, from both the normal and compat syscall routines.
> 
> Since I have no way to test this code maybe is better add no function
> at all and simply using a warning message if someone try compiling
> this code with CONFIG_COMPAT enabled...

No. The fact that you cannot test it is no excuse for submitting
something which is _known_ to be broken. Once you have it to the point
where a casual observer can't point out errors, then people can test it
for you.

-- 
dwmw2

