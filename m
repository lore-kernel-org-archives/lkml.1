Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbZCPIeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbZCPIeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 04:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbZCPIeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 04:34:14 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:33937 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbZCPIeO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 04:34:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=qyYXbM3/WS3qnNAg2EZMSfqMui8qenrutQG+fBdysSKmIGPOWQp/FWX9591F87KN+G
         b78eYnoqW/X2TA+K3NsYZ+XvUSrIDZcBgBZmBPSQfFN8cDoErCUYrNQm5sM4mMcl/NBL
         aEALGbFqBhLd14fnU+u1alLpQ3PBEXDKHWmeM=
From: =?iso-8859-1?q?G=E1bor_Melis?= <mega@retes.hu>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: Signal delivery order
Date: Mon, 16 Mar 2009 09:34:03 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200903141750.37238.mega@retes.hu> <200903152306.53031.mega@retes.hu> <20090316002833.GA17615@redhat.com>
In-Reply-To: <20090316002833.GA17615@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903160934.03700.mega@retes.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Lunes 16 Marzo 2009, Oleg Nesterov wrote:
> On 03/15, Gábor Melis wrote:
> > On Domingo 15 Marzo 2009, Oleg Nesterov wrote:
> > > Now, since there are no more pending signals, we return to the
> > > user space, and start sig_2().
> >
> > I see. I guess in addition to changing the ip, the stack frobbing
> > magic arranges that sig_2 returns to sig_1 or some code that calls
> > sig_1.
>
> yes. "some code" == rt_sigreturn,
>
> > The revised signal-delivery-order.c (also attached) outputs:
> >
> > test_handler=8048727
> > sigsegv_handler=804872c
> > eip: 8048727
> > esp: b7d94cb8
> >
> > which shows that sigsegv_handler also has incorrect eip in the
> > context.
>
> Why do you think it is not correct?
>
> I didn't try your test-case, but I can't see where "esp: b7d94cb8"
> comes from. But "eip: 8048727" looks exactly right, this is the
> address of test_handler.

Sorry, I removed the printing of esp from the code as it was not 
relevant to my point but pasted the output of a previous run.

Anyway, I think eip is incorrect in sigsegv because it's not pointing to 
the instruction that caused the sigsegv. In general the ucontext is 
wrong, because it's as if sigsegv_handler were invoked within 
test_handler.

This is problematic if the sigsegv handler wants to do something with 
the context. The real life sigsegv handler that's been failing does 
this:
- skip the offending instruction by incrementing eip
- taking esp from the context, frob the control stack so that some 
function is called on return from the handler (the handler itself is on 
altstack). This is not unlike what the kernel does, it seems.

Now, "some function" cannot be called with SIGUSR1 blocked because that 
would potentially lead to deadlocks. (SIGUSR1 is sent to a thread when 
the garbage collector wants to stop it, and some function does 
allocations.)

So the context in the sigsegv handler pointing to the handler of SIGUSR1 
loses because it finds an unexpected sigmask: SIGUSR1 is blocked. It 
loses because the eip is not pointing to the right instruction, it 
loses because the SIGUSR1 handler won't finish until "some function" 
returns ...

It seems to me that the same problem could be triggerred by 
pthread_kill()ing a thread that's sigtrapping if the signum of the 
signal sent is lower than that of sigtrap, say it's SIGINT.

In a nutshell, the context argument is wrong.

> Oleg.
