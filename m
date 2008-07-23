Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbYGWCnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbYGWCnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 22:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYGWCmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 22:42:52 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:35253 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752108AbYGWCmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 22:42:52 -0400
Date: Tue, 22 Jul 2008 21:48:04 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Subject: Re: [RFC] fix kallsyms to allow discrimination of local symbols
Message-ID: <20080723014804.GA8826@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Frank Ch. Eigler" <fche@redhat.com>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	systemtap@sourceware.org
References: <1216676595.3433.80.camel@localhost.localdomain> <y0mprp68zg9.fsf@ton.toronto.redhat.com> <1216698788.3433.116.camel@localhost.localdomain> <20080722115101.GB9508@redhat.com> <1216739683.3364.43.camel@localhost.localdomain> <y0mk5fd9a64.fsf@ton.toronto.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0mk5fd9a64.fsf@ton.toronto.redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 12:05:23PM -0400, Frank Ch. Eigler wrote:
> > You're confusing issues.  I said embedding half a megabyte of symbol
> > table that the kernel already has is a bad idea full stop.  
> 
> Be that as it may, but it is not appropriate to knowingly bring up a
> topic that is irrelevant to the patch series you're actually proposing.
> 
> > The ultimate think I'm looking to do is to evolve kernel APIs that
> > makes this practice unnecessary.
> 
> If by "this practice" you mean "stap-symbols.h tables", then you're
> worrying on the wrong area of code (anything in/near kprobes).  I am
> happy to suggest more appropriate areas to help with that.

I think there is a certain amount of talking past each other which is
going on here.

Let me see if I can summarize what is going on.  My understanding of
the situation is as follows:

1) Right now, when trying to resolve the address to install a kprobe,
Systemtap is using the DWARF information from the vmlinux file and/or
the module's debuginfo files.

2) Kprobe can support setting probes based on raw addresses (which is
what Systemtap is doing now) as well as a text symbol looked up from
kallsyms plus an offset.  The latter was introduced two years ago, but
Systemtap does not take advantage of it.

3) James is offended by the fact that Systemtap is not utilizing this
interface, and has offerred up patches which adds the capability of
using the symbol+offset feature of the kprobes interface.  There seems
to be some question as to whether his patch has all of the
functionality of the existing code which determines addresses via
pawing through DWARF headers (especially where a function may have
been inlined one or more times) but presumably James' patches could be
enhanced to deal with this issues, if he hasn't done so already.

Am I missing anything?

So the main arguments against this seems to be that it by itself this
doesn't actually reduce any complexity or code in Systemtap because
there are other places (kernel data segment, user space tracing if it
ever manages to get merged into mainline, etc.) which needs to be able
to paw through DWARF headers.

James' argument that this Systemtap is cramming over half a megabyte
is regarded by is somewhat of a red herring with respect to this
specific patch, since systemtap does not calculate probe addresses at
runtime.  This 600k or so of symbol tables is being used for something
else.  (What, exactly?!?)  James clearly in the long term wants to
make this go away, which seems reasonable.  He views changing how
kprobes are placed is the first in a series of changes that he would
like to make.  So perhaps the resistance in accepting his first patch
troubles him since it appears that Systemtap folks aren't willing to
take his suggestions about how things should be improved.

May I make a suggestion and not try to come to a conclusion about the
big picture question for a moment and focus on the very short-term of
whether it is better that when I implement a probe such as:

probe module("ext4dev").function("ext4_fill_super")
{     
      printk("here am I!\n");
}

This should be done via passing a hard-coded address, or via using the
kprobes function+offset facility?  It would seem that there are
advantages to James' patch all by itself, in that it will will work
even if the debuginfo information for the ext4dev module can't be
found, since the kallsyms information would be used instead.  It also
means that the resulting systemtap probe modules will be easier to
make more kernel independent, since it won't be using a hard-coded
address, but rather a symbolic name.

So what is the good reason *not* to do things the way James has
suggested?  The kprobes kallsyms facility has been around for a while
now.  Is it that we need to make changes?

Maybe if things are focused on somewhat more concrete questions, we
can make progress.

Regards,

						- Ted
