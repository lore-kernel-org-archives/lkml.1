Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898Ab0AQOho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab0AQOho (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 09:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853Ab0AQOhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 09:37:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab0AQOhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 09:37:42 -0500
Message-ID: <4B532093.5080600@redhat.com>
Date: Sun, 17 Jan 2010 16:37:07 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Jim Keniston <jkenisto@us.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>	 <20100111122529.22050.32596.sendpatchset@srikar.in.ibm.com>	 <1263467289.4244.288.camel@laptop>	 <1263498366.4875.25.camel@localhost.localdomain>	 <1263546175.4244.342.camel@laptop>	 <1263589634.5007.34.camel@localhost.localdomain>	 <1263592192.4244.488.camel@laptop> <1263603503.5007.134.camel@localhost.localdomain>
In-Reply-To: <1263603503.5007.134.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2010 02:58 AM, Jim Keniston wrote:
>
> I hear (er, read) you.  Emulation may turn out to be the answer for some
> architectures.  But here are some things to keep in mind about the
> various approaches:
>
> 1. Single-stepping inline is easiest: you need to know very little about
> the instruction set you're probing.  But it's inadequate for
> multithreaded apps.
> 2. Single-stepping out of line solves the multithreading issue (as do #3
> and #4), but requires more knowledge of the instruction set.  (In
> particular, calls, jumps, and returns need special care; as do
> rip-relative instructions in x86_64.)  I count 9 architectures that
> support kprobes.  I think most of these do SSOL.
> 3. "Boosted" probes (where an appended jump instruction removes the need
> for the single-step trap on many instructions) require even more
> knowledge of the instruction set, and like SSOL, require XOL slots.
> Right now, as far as I know, x86 is the only architecture with boosted
> kprobes.
> 4. Emulation removes the need for the XOL area, but requires pretty much
> total knowledge of the instruction set.  It's also a performance win for
> architectures that can't do #3.  I see kvm implemented on 4
> architectures (ia64, powerpc, s390, x86).  Coincidentally, those are the
> architectures to which uprobes (old uprobes, with ubp and xol bundled
> in) has already been ported (though Intel hasn't been maintaining their
> ia64 port).  So it sort of comes down to how objectionable the XOL vma
> (or page) really is.
>    

The kvm emulator emulates only a subset of the x86 instruction set 
(basically mmio instructions and commonly-used page-table manipulation 
instructions, as well as some privileged instructions).  It would take a 
lot of work to expand it to be completely generic; and even then it will 
fail if userspace uses an instruction set extension the kernel is not 
aware of.

To me, boosted probes with a fallback to single-stepping seems to be the 
better option by far.

-- 
error compiling committee.c: too many arguments to function

