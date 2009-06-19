Return-Path: <linux-kernel-owner+w=401wt.eu-S1758604AbZFSAcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604AbZFSAcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 20:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbZFSAce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 20:32:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54758 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbZFSAcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 20:32:33 -0400
Date: Thu, 18 Jun 2009 20:32:34 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Jake Edge <jake@lwn.net>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: problem with function_graph self-test?
In-Reply-To: <4A3ADBFA.1060702@goop.org>
Message-ID: <alpine.DEB.2.00.0906182031100.6890@gandalf.stny.rr.com>
References: <20090616122603.6a628097@chukar> <alpine.DEB.2.00.0906172312450.6890@gandalf.stny.rr.com> <4A3ADBFA.1060702@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 18 Jun 2009, Jeremy Fitzhardinge wrote:
> >
> > This is something that gcc is screwing with us. After spending all day 
> > today trying to figure out what is happening, I finally found it in the 
> > assembly.
> >
> > In the timer_stats_update_stats function, I get this at the beginning:
> >
> > 00000327 <timer_stats_update_stats>:
> >  327:   57                      push   %edi
> >  328:   8d 7c 24 08             lea    0x8(%esp),%edi
> >  32c:   83 e4 e0                and    $0xffffffe0,%esp
> >  32f:   ff 77 fc                pushl  0xfffffffc(%edi)
> >  332:   55                      push   %ebp
> >  333:   89 e5                   mov    %esp,%ebp
> >  335:   57                      push   %edi
> >  336:   56                      push   %esi
> >  337:   53                      push   %ebx
> >  338:   81 ec 8c 00 00 00       sub    $0x8c,%esp
> >  33e:   e8 fc ff ff ff          call   33f <timer_stats_update_stats+0x18>
> >                         33f: R_386_PC32 mcount
> >
> >
> > And this at the end of the function:
> >
> >  4f6:   8d 67 f8                lea    0xfffffff8(%edi),%esp
> >  4f9:   5f                      pop    %edi
> >  4fa:   c3                      ret    
> >   
> 
> Something to do with using _RET_IP_ in spin_unlock_irqrestore() perhaps?

No, it was the fact that there was a local variable of type struct entry, 
where entry was defined to be ____cacheline_aligned_in_smp. But that was 
not the end of it. It happens throughout the code. The next hit was in 
tcp_ack(). But it has something to do with -Os on i386.

-- Steve

