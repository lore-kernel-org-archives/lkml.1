Return-Path: <linux-kernel-owner+w=401wt.eu-S933223AbYEAWLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223AbYEAWLB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 18:11:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbYEAWKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 18:10:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755891AbYEAWKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 18:10:52 -0400
Date: Thu, 1 May 2008 15:07:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org, lucho@ionkov.net,
       ericvh@gmail.com
Subject: Re: [PATCH] fix flags length in net 9p
Message-Id: <20080501150737.3400dffb.akpm@linux-foundation.org>
In-Reply-To: <1209677160.12461.267.camel@localhost.localdomain>
References: <Pine.LNX.4.58.0805011706070.12785@gandalf.stny.rr.com>
	<20080501141919.78b7dc4f.akpm@linux-foundation.org>
	<1209677160.12461.267.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 May 2008 14:26:00 -0700
Daniel Walker <dwalker@mvista.com> wrote:

> 
> On Thu, 2008-05-01 at 14:19 -0700, Andrew Morton wrote:
> > On Thu, 1 May 2008 17:08:05 -0400 (EDT)
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > Some files in the net/9p directory uses "int" for flags. This can
> > > cause hard to find bugs on some architectures. This patch converts the
> > > flags to use "long" instead.
> > 
> > gargh.
> > 
> > > This bug was discovered by doing an allyesconfig make on the -rt kernel
> > > where checks are done to ensure all flags are of size sizeof(long).
> > 
> > I was about to suggest that we do something like that...
> > 
> > I wonder how messy it is.  I long ago lost the ability to follow the
> > convolutions in include/linux/spinlock*.h :(  gotta patch?
> 
> The check that's in -rt for this uses BUILD_BUG_ON(), and it's extremely
> cryptic when there is a failure .. Most people will be baffled why the
> build stopped. If a check went into mainline it should at least give you
> some sort of idea what's happening ..
> 

I think a warning is good enough here.  There are all sorts of warnings if,
which ignored, will crash your box.

And there is only one type which we use to hold processor flags and that is
unsigned long.


So a plain old

#define must_be_ulong(p)
	do {
		if (&p == (unsigned long *)0)
			;
	} while (0)

(or whatever)

should suffice.
