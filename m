Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbZCXV54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbZCXV54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbZCXV5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:57:46 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:35388 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbZCXV5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:57:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OtNTQYQhaaLeIQxGASl7Bea9kbESN6xCOfDRVGm/SoDZwtlse4HbBp+zYSwfI+yxUR
         4cmGjc+pW0mto2iL9OyoZ43jp1TtA/GYsFU94MNPclksB0NgV/ck081iDsaqQZJzJ7iB
         A9rhQzO9CqT+TArHFwO8taO9u3HdMt9B5s1FI=
Date: Tue, 24 Mar 2009 22:57:39 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tim Bird <tim.bird@am.sony.com>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: Anyone working on ftrace function graph support on ARM?
Message-ID: <20090324215738.GD5975@nowhere>
References: <49C936CA.8070800@am.sony.com> <20090324213618.GC5975@nowhere> <20090324214846.GB29509@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324214846.GB29509@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 10:48:46PM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Well it's a very naive listing, there are sometimes some problems. 
> > For example on x86-64, I had to save even some non-scratch 
> > registers before calling the return hook, I still don't know why.
> 
> btw., which are those registers?
> 
> 	Ingo


I would expect to only save rax,rdi,rsi,rdx,rcx,r8,r9 which
are used for parameters.
And I had some crashes until I append r10 and r11 which actually are
scratch if I'm not wrong, but since they are scratch and are not used for
arguments, I thought they didn't need to be saved.

Well, I think there were some code flow cases I was missing.


The complete code is:

	movq %rax, (%rsp)
	movq %rcx, 8(%rsp)
	movq %rdx, 16(%rsp)
	movq %rsi, 24(%rsp)
	movq %rdi, 32(%rsp)
	movq %r8, 40(%rsp)
	movq %r9, 48(%rsp)
	movq %r10, 56(%rsp)
	movq %r11, 64(%rsp)

	call ftrace_return_to_handler

	movq %rax, 72(%rsp) <-- get original return value
	movq 64(%rsp), %r11
	movq 56(%rsp), %r10
	movq 48(%rsp), %r9
	movq 40(%rsp), %r8
	movq 32(%rsp), %rdi
	movq 24(%rsp), %rsi
	movq 16(%rsp), %rdx
	movq 8(%rsp), %rcx
	movq (%rsp), %rax
	addq $72, %rsp

