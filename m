Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196AbYKARfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbYKARfs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 13:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbYKARfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 13:35:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63945 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbYKARfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 13:35:39 -0400
Date: Sat, 1 Nov 2008 13:35:36 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jonathan Corbet <corbet@lwn.net>, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Robert Hancock <hancockr@shaw.ca>,
       e1000-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc2 hates my e1000e
In-Reply-To: <alpine.LFD.2.00.0811010958230.6226@nehalem.linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0811011326390.9409@gandalf.stny.rr.com>
References: <fa.P5jmIAOhSJ192sfWD+qlec07fe8@ifi.uio.no> <490A5532.2000704@shaw.ca> <20081030205851.3208f52f@bike.lwn.net> <86802c440810302108h48046c08x3bbdcd0e35fd31b7@mail.gmail.com> <alpine.LFD.2.00.0810310800120.21084@nehalem.linux-foundation.org>
 <alpine.LFD.2.00.0810310839380.21084@nehalem.linux-foundation.org> <20081031100040.1f0cf34f@bike.lwn.net> <alpine.LFD.2.00.0810310916050.21084@nehalem.linux-foundation.org> <20081031105105.092ebad3@bike.lwn.net> <alpine.LFD.2.00.0810310953550.21084@nehalem.linux-foundation.org>
 <20081101090154.3d014f57@bike.lwn.net> <alpine.LFD.2.00.0811010958230.6226@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Note, lots of family activities this weekend, so my response may be 
  slow ]

On Sat, 1 Nov 2008, Linus Torvalds wrote:
> On Sat, 1 Nov 2008, Jonathan Corbet wrote:
> 
> > Networking is fine in the absence of NFS.  I retried things and
> > stress-tested it in a few ways with no trouble.  I think your last patch
> > fixes the network card just fine.
> > 
> > Then I tried NFS again, watching more closely this time around.
> > Everything locks up.  In fact, the soft lockup watchdog starts to
> > scream:
> 
> Interesting. I wonder why it happens for NFS, but not apparently for all 
> your other modules.
> 
> It does look very much like a ftrace issue, though, not NFS or 
> network-related. Steven? Is this something that you are aware of already, 
> with what looks like a lockup in ftrace_record_ip()?
> 

No, I have not seen this before. The code is now pretty straight forward.

Jon, could you do a gdb vmlinux and a li *ftrace_record_ip+0xcb to find 
the exact line that is?

Showing the call path of this we have:

in module.c:

  	/* sechdrs[0].sh_size is always zero */
	mseg = section_objs(hdr, sechdrs, secstrings, "__mcount_loc",
			    sizeof(*mseg), &num_mcount);
	ftrace_init_module(mseg, mseg + num_mcount);

Where we pass a table of mcount callers to the ftrace_init_module.

void ftrace_init_module(unsigned long *start, unsigned long *end)
{
	if (ftrace_disabled || start == end)
		return;
	ftrace_convert_nops(start, end);
}

I wonder if I should test to make sure start is < end :-/

ftrace_convert_nops does the following under a mutex.

	while (p < end) {
		addr = ftrace_call_adjust(*p++);
		ftrace_record_ip(addr);
	}


And ftrace_record_ip does:

ftrace_record_ip(unsigned long ip)
{
	struct dyn_ftrace *rec;
	if (!ftrace_enabled || ftrace_disabled)
		return NULL;
	rec = ftrace_alloc_dyn_node(ip);
	if (!rec)
		return NULL;
	rec->ip = ip;
	list_add(&rec->list, &ftrace_new_addrs);
	return rec;
}


The ftrace_alloc_dyn_node does allocate a page if we are running low, but 
there's no other loops or locks that I can see us deadlocking on.

-- Steve

