Return-Path: <linux-kernel-owner+w=401wt.eu-S1756558AbZBWSdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbZBWSdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 13:33:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbZBWScw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 13:32:52 -0500
Received: from thunk.org ([69.25.196.29]:43297 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbZBWScu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 13:32:50 -0500
Date: Mon, 23 Feb 2009 13:32:21 -0500
From: Theodore Tso <tytso@mit.edu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] tracing/markers: make markers select tracepoints
Message-ID: <20090223183220.GE19739@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Steven Rostedt <rostedt@goodmis.org>,
	"Frank Ch. Eigler" <fche@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	linux-kernel@vger.kernel.org, zippel@linux-m68k.org,
	linux-kbuild@vger.kernel.org
References: <20090220172241.GF24538@elte.hu> <1235302980.4632.8.camel@laptop> <y0mocwuptbc.fsf@ton.toronto.redhat.com> <1235304876.4632.10.camel@laptop> <20090222122424.GA9951@redhat.com> <1235387487.4645.28.camel@laptop> <20090223154404.GA30147@redhat.com> <1235406159.4645.366.camel@laptop> <20090223171032.GA2566@redhat.com> <alpine.DEB.2.00.0902231228420.18221@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0902231228420.18221@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 12:31:31PM -0500, Steven Rostedt wrote:
> > The impression that this is somehow different with tracepoints is
> > mistaken.  Tracepoints are *exactly* as "ABI-like" as markers.
> 
> I disagree with this point. markers are text strings that will eventually 
> appear to userspace. trace points need translation. A trace point can be 
> modified at any time and should never mess up user apps.
> 
> You may have a hook to a trace point that provides user apps a text based 
> output. If the trace point changes, this hook may break. But the tracer 
> maintainer of that hook will be responsible for that change, not the 
> maintainer of the code the tracepoint existed in.

So stupid question time --- exactly who is supposed to write and
maintain trnaslation code; the "hook"?  What trace points have done is
added an extra layer of indirection, but in order for someone to
actually make *use* of the have the trace point, someone has to
maintain the "hook".

I'm sorry I've offended Peter with the ext4 trace_mark() hooks, but
it's what I could forsee needing if someone wants reports a wierd sh*t
bug in ext4 and I wanted to be able to be able to extract debugging
information without forcing them to patch and recompile the kernel,
and in the ideal world, without even needing to reboot the kernel.
(If we had usable and reliable debuginfo information, in most cases
I'd be able simply use access to function parameters as replacements
for trace_mark().)

I've had to debug problems in the field on customer machines where
installing a new kernel was a big deal (as in, you get a window to
reboot the machine every 24 hours, and the problem is so complex you
can't replicate it anywhere *but* the production environment).  It's
also been the case that more than once I've seen wierd behaviour on my
laptop, and being able to peer inside it to see what is going on
easily and conveniently is a major win.

My big complaint with tracepoints is specifically *that* I need to
write a lot of hook code each time I want to investigate something.
So to say it's more maintabile because it doesn't present an ABI is a
bit of sophistry, I think.  Yes, there's no ABI because each time you
want to do something different, you have to roll your own kernel
module code to write the hook from scratch --- taking something that
was a "gee, I wonder...." 30 second experiment to something which
takes 5-10 times longer, at minimum.


Finally, whether or not the text string is an ABI really depends on
the tools.  Given that the string is self describing, it's only an ABI
if the tools are stupid.  It doesn't take that much extra parsing
smarts to be able to under stand a format string of:

	dev %s dir %lu mode %d

and DTRT if the kernel instead hands back something which was
constructed with the format string:

	dev %s dir %lu mode %d grp %u

or even:

	dev %s dir %lu

if the mode parameter is unavailable for whatever reason in future
kernel versions.  This really isn't rocket science....

					- Ted
