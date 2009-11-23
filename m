Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbZKWUZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbZKWUZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 15:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756327AbZKWUZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 15:25:26 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:54761 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256AbZKWUZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 15:25:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BAgAfbb4rtujosmVmhGZuT7aUdPsBTHT6XKv80gS4Pe0NuWG35uhW7o1UmAHzk9n0d
         lxuZVHI4TojxAsUM2A+1l8RU7Q7EhbOmJIczL1IwWH82gUVmGmazRk/K1StEkljpcYru
         i8ntVoYi27GgPT3MG5iYuaArlWYEqC9rlo4GI=
Date: Mon, 23 Nov 2009 21:25:28 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 4/4] perf tools: Add support for breakpoint events in
	perf tools
Message-ID: <20091123202525.GA4979@nowhere>
References: <1258987355-8751-1-git-send-email-fweisbec@gmail.com> <1258987355-8751-4-git-send-email-fweisbec@gmail.com> <20091123173601.GA7273@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123173601.GA7273@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 11:06:01PM +0530, K.Prasad wrote:
> On Mon, Nov 23, 2009 at 03:42:35PM +0100, Frederic Weisbecker wrote:
> > Add the breakpoint events support with this new sysnopsis:
> > 
> > mem:addr[:access]
> > 
> > Where addr is a raw addr value in the kernel and access can be
> > either [r][w][x]
> > 
> > Example to profile tasklist_lock:
> > 
> > 	$ grep tasklist_lock /proc/kallsyms
> > 	ffffffff8189c000 D tasklist_lock
> > 
> > 	$ perf record -e mem:0xffffffff8189c000:rw -a -f -c 1
> > 	$ perf report
> 
> The problem in obtaining just the breakpoint address is that there can
> be a variety of breakpoint lengths that can be associated with them -
> assigning the smallest possible length (1-Byte) may cause loss of
> exceptions and a higher length would lead to stray exceptions (such
> dilemmas led to the support of symbol-only breakpoint in ksym_tracer and
> perf-tools in my patchset...the default 1-Byte breakpoint length being a
> temporary fix).


Right.

 
> With kernel symbols as input it would be possible to derive the bkpt
> length based on the symbol-size, say using
> kallsyms_lookup_size_offset() (although the corresponding length may not
> be available on the host processor such requests can be failed or
> over-ridden by the user using a smaller length), but for addresses I think
> it is vital to know what breakpoint length is desired by the user.



Yeah. I guess we first need a way to manually add this length, may
be:

	mem:addr/len:access

And as you said, finding it automatically for symbols. But still, passing
symbols to perf attr leads to confusion and complexity if we want to profile
in userspace.

I think we should find this symbol length from userspace.
I'm not sure how yet, probably using Dwarf. Arnaldo, do you have an
idea about that?

> This comes at the cost of exposing the user to variations in
> breakpoint implementation across architectures and demand processor-specific
> knowledge, but specifying a kernel-space address would anyway require the
> user to penetrate beyond the normal abstraction provided by the
> interface/tool...so I presume it must be acceptable.



Yeah. We'll probably need to write a quick sum-up about
such variations to facilitate perf uses.


> On a related note, the supported breakpoint length for PPC64 is a fixed
> 8-Byte length (which means all extraneous exceptions must be filtered by
> the breakpoint architecture) and Book-E Power processors matching
> addresses against a bitmask; for S390 it can be practically anything
> (bound by a set of start and end addresses)...and you see what a
> quandary it leads to!
> 
> Thanks,
> K.Prasad


Yep :)

Thanks.

