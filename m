Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab0BNRP4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 12:15:56 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:6966 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab0BNRPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 12:15:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tTOES3RqOAjkxGKKr1gcs37CAfjNBoufzEWmjniqEnj6VhPDWegojHQlQtPt0T9+UU
         3Aw/VYLg8SAxmTHhm9cPfx9FdncFI4yk4Kt+VOnvVocvSwpHiJkL/oDx4kwzlmZI7W5F
         2aDWF68J2R7snQm+aCxk6nIY44yNYVax9LRZQ=
Date: Sun, 14 Feb 2010 18:15:49 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Michael Stefaniuc <mstefani@redhat.com>
Cc: prasad@linux.vnet.ibm.com, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org, Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Alexandre Julliard <julliard@winehq.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: Regression in ptrace (Wine) starting with 2.6.33-rc1
Message-ID: <20100214171535.GA5065@nowhere>
References: <4B743149.4000707@redhat.com> <20100211182224.GC4915@nowhere> <4B745F5C.5050001@redhat.com> <20100213173323.GB3778@in.ibm.com> <4B7719AC.6040901@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7719AC.6040901@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 13, 2010 at 10:29:16PM +0100, Michael Stefaniuc wrote:
> Results 2.6.33-rcX:
> -------------------
> ptrace(PTRACE_ATTACH, 18036, 0, 0)      = 0
> ptrace(PTRACE_POKEUSER, 18036, offsetof(struct user, u_debugreg),  
> 0x42424242) = 0
> ptrace(PTRACE_POKEUSER, 18036, offsetof(struct user, u_debugreg) + 4, 0) = 0
> ptrace(PTRACE_POKEUSER, 18036, offsetof(struct user, u_debugreg) + 8, 0) = 0
> ptrace(PTRACE_POKEUSER, 18036, offsetof(struct user, u_debugreg) + 12,  
> 0) = 0
> ptrace(PTRACE_POKEUSER, 18036, offsetof(struct user, u_debugreg) + 24,  
> 0) = 0
> ptrace(PTRACE_POKEUSER, 18036, offsetof(struct user, u_debugreg) + 28,  
> 0x155) = -1 EINVAL (Invalid argument)
>
> Results 2.6.32:
> ---------------
> trace(PTRACE_ATTACH, 3077, 0, 0)       = 0
> ptrace(PTRACE_POKEUSER, 3077, offsetof(struct user, u_debugreg),  
> 0x42424242) = 0
> ptrace(PTRACE_POKEUSER, 3077, offsetof(struct user, u_debugreg) + 4, 0) = 0
> ptrace(PTRACE_POKEUSER, 3077, offsetof(struct user, u_debugreg) + 8, 0) = 0
> ptrace(PTRACE_POKEUSER, 3077, offsetof(struct user, u_debugreg) + 12, 0) = 0
> ptrace(PTRACE_POKEUSER, 3077, offsetof(struct user, u_debugreg) + 24, 0) = 0
> ptrace(PTRACE_POKEUSER, 3077, offsetof(struct user, u_debugreg) + 28,  
> 0x155) = 0


I see... So this is setting breakpoints on the address 0. The new code
rejects such breakpoints, but the previous one was accepting it.

The point of allowing breakpoints in NULL is discutable. It's not a bug,
neither is it a security hole I think (because if the ptrace breakpoint
triggers from the kernel, it's ignored), it's just pointless, unless
userland map things in 0.

But it's too late to debate this. If the previous code accepted it,
it's an ABI, and we have broken it.

I'm preparing a fix.



> So it looks like something in the setting of DR7 is broken or at least
> changed behavior. The function in Wine that does those calls is
> set_thread_context() from server/ptrace.c .
>
> I'll try to see if I can reproduce the other regression; as it is hidden  
> at the moment by this regression.


Ok.

Thanks.

