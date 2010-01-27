Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572Ab0A0TXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab0A0TXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 14:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498Ab0A0TXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 14:23:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56124 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492Ab0A0TXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 14:23:33 -0500
Message-ID: <4B60919E.1020900@zytor.com>
Date: Wed, 27 Jan 2010 11:18:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Zijlstra <peterz@infradead.org>, Tom Tromey <tromey@redhat.com>,
       Kyle Moffett <kyle@moffetthome.net>,
       "Frank Ch. Eigler" <fche@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       utrace-devel@redhat.com, Thomas Gleixner <tglx@linutronix.de>,
       JimKeniston <jkenisto@us.ibm.com>
Subject: Re: linux-next: add utrace tree
References: <20100121013822.28781960.sfr@canb.auug.org.au>  <20100122005147.GD22003@redhat.com>  <20100121170541.7425ff10.akpm@linux-foundation.org>  <alpine.LFD.2.00.1001211724500.13231@localhost.localdomain>  <20100122182827.GA13185@redhat.com> <20100122200129.GG22003@redhat.com>  <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain>  <20100122221348.GA4263@redhat.com>  <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain>  <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>  <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com>  <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain>  <m33a1tnbd9.fsf@fleche.redhat.com>  <alpine.LFD.2.00.1001251332370.3574@localhost.localdomain>  <m3636oh2rt.fsf@fleche.redhat.com>  <alpine.LFD.2.00.1001261535510.17519@localhost.localdomain> <1264575134.4283.1983.camel@laptop> <alpine.LFD.2.00.1001270231520.24253@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1001270231520.24253@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2010 02:43 AM, Linus Torvalds wrote:
> 
> 
> On Wed, 27 Jan 2010, Peter Zijlstra wrote:
>>
>> Right, so you're going to love uprobes, which does exactly that. The
>> current proposal is overwriting the target instruction with an INT3 and
>> injecting an extra vma into the target process's address space
>> containing the original instruction(s) and possible jumps back to the
>> old code stream.
> 
> Just out of interest, how does it handle the threading issue?
> 
> Last I saw, at least some CPU people were _very_ nervous about overwriting 
> instructions if another CPU might be just about to execute them.
> 
> Even the "overwrite only the first byte with 'int3'" made them go "umm, I 
> need to talk to some core CPU people to see if that's ok". They mumble 
> about possible CPU errata, I$ coherency, instruction retry etc.
> 

We actually went through a review of that here at Intel.  We do not yet
have an *official* answer (in order for us to have that we have to have
it approved by the architecture committee and published in the SDM), but
to the best of our current knowledge (and I'm allowed to say this) the
int3 method followed by global IPIs should be safe for modifying *one
(atomic) instruction*.  This is a specific case of a more general rule,
but I don't want to disclose the whole rule until it has been officially
approved.

> I realize kprobes does this very thing, but kprobes is esoteric stuff and 
> doesn't have much choice. In user space, you _could_ do the modification 
> on a different physical page and then just switch the page table entry 
> instead, and not get into the whole D$/I$ coherency thing at all.

On the more general rule of interpretation: I'm really concerned about
having a bunch of partially-capable x86 interpreters all over the
kernel.  x86 is *hard* to emulate, and it will only get harder as the
architecture evolves.

	-hpa
