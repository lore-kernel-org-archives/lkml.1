Return-Path: <linux-kernel-owner+w=401wt.eu-S1755612AbZCRJ6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbZCRJ6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 05:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbZCRJ63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 05:58:29 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:53124 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbZCRJ62 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 05:58:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=yC7iGVwM6L90kqARMPxNQ1lEqgIJSVUBPnbpnXuKAkaF2PbVni347RT1KKSwYkyFZe
         s/3q6h6h+7gOmvfKMoI2tRKGQYE+Im9wjPXUC4WL9yS4eF/AnZtMvx+nZFpZ+9eRGQNb
         sLj5cV1sTtG4nEJUVOw2HbgE1IGjDmcsgNhfE=
From: =?iso-8859-15?q?G=E1bor_Melis?= <mega@retes.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Q: SEGSEGV && uc_mcontext->ip (Was: Signal delivery order)
Date: Wed, 18 Mar 2009 10:58:22 +0100
User-Agent: KMail/1.9.9
Cc: Oleg Nesterov <oleg@redhat.com>, Davide Libenzi <davidel@xmailserver.org>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Friesen <cfriesen@nortel.com>, linux-kernel@vger.kernel.org
References: <200903141750.37238.mega@retes.hu> <200903170923.56430.mega@retes.hu> <alpine.LFD.2.00.0903170848490.3082@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903170848490.3082@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903181058.23247.mega@retes.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Martes 17 Marzo 2009, Linus Torvalds wrote:
> On Tue, 17 Mar 2009, Gábor Melis wrote:
> > As an application developer what I'd like to have is this:
> > synchronously generated signals are delivered before asynchronously
> > generated ones.
>
> I agree that it would be nice, but quite frankly, it's simply not how
> signals work. It would be a reasonably invasive change, and you
> wouldn't really be able to rely on it anyway since most kernels don't
> work that way.

True. I won't be able to rely on this and I'll stick to the SIGUSR2 
workaround that's confirmed by Oleg.

> What you might be able to do instead is to walk signal frames
> backwards by hand. IOW, accept the fact that sometimes signals end up
> being nested, but then you could try to find the right frame by just
> looking at them.

Walking the frames is not enough, because even if the right one is 
found, I can't put a new frame on it if it's not at the top ...

> And your trick of comparing 'info->si_ip' with
> 'context->uc_mcontext->ip' is pretty good, and lets the code itself
> walk the signal frames by just depending on the fault happening
> again.

Another example. Suppose there is a stack with a mprotected guard page 
at the end. The app's stack grows into the guard page, sigsegv is 
generated, its handler would be invoked, but a pthread_kill'ed SIGUSR1 
gets delivered first. Now the SIGUSR1 handler accesses the stack and 
triggers another fault, the sigsegv handler sees that si_ip == 
uc_mcontext->ip, so it unprotects the page and puts a frame on the 
stack, arranging for a function to be called. Then the function 
deadlocks because it waits for a signal that's blocked in the SIGUSR1 
handler.

I think it would be a definite improvement to prevent all these 
headaches from occurring and deliver asynchronously generated, thread 
private signals after the synchronous ones.

> 			Linus
