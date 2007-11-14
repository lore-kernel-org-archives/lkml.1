Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710AbXKNJP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbXKNJP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 04:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbXKNJPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 04:15:12 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:18269 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbXKNJPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 04:15:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mH7izw/AUVxEjzKAxltnF1/4PkWLaDn/ZQ1RPWvIpjOFxjTckjtnUdoSE1lVpDwuwOE/xa3n2/dM7HsSHeUsiIQFVVeQKDndtDJrr2PVRQGQaarkOBA+4IyyQiE54V5wA5sKzxQjBpGM7VjHLBgfDysuEmAEr+7GWUNdvog9O0Q=
Message-ID: <863e9df20711140049q3ad486ben7ace2edab0a2ca41@mail.gmail.com>
Date: Wed, 14 Nov 2007 14:19:04 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Srinivasa Ds" <srinivasa@in.ibm.com>
Subject: Re: [PATCH][RFC] kprobes: Add user entry-handler in kretprobes
Cc: linux-kernel@vger.kernel.org, prasanna@in.ibm.com, davem@davemloft.net,
       anil.s.keshavamurthy@intel.com, "Jim Keniston" <jkenisto@us.ibm.com>,
       "Ananth N Mavinakayanahalli" <ananth@in.ibm.com>
In-Reply-To: <473AAA75.2050900@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47389BEB.1000901@gmail.com>
	 <863e9df20711121039t5352a993xc9eeb6bfea123805@mail.gmail.com>
	 <863e9df20711130247g45d3d541j10c76434e9c65b00@mail.gmail.com>
	 <473AAA75.2050900@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 14, 2007 1:27 PM, Srinivasa Ds <srinivasa@in.ibm.com> wrote:
> 1) How do you map the entry_handler(which gets executed when a process enters the function) with each instance of return probe handler.
> I accept that entry_handler() will execute each time process enters the function, but to  calculate time, one needs to know corresponding instance of return probe handler(there should be a map for each return handler).

Yes, a one-to-one correspondence between the entry and return handlers
is important. I've tried to address this by passing the same
kretprobe_instance to both the entry and return handlers.

>   Let me explain briefly.
> Suppose in a SMP system, 4 processes  enter the same function at almost sametime(by executing entry_hanlder()) and returns from 4 different locations by executing the return handler.  Now how do I match entry_handler() with corresponding instance of return handler for calculating time.

Right, and this scenario would also occur on UPs where the kretprobe'd
function has nested calls. This has been taken care of (see below).

> Now What I think is, there could be 2 solutions to these problem.
>
> a) Collect the entry time and exit time and put it in that kretprobe_instance structure and fetch it before freeing that instance.

In case someone wants to calculate the entry and exit timestamps of a
function using kretprobes, the appropriate place for it is not the
entry and return handlers. Thats because the path from when a function
is called or from when it returns, to the point of invocation of the
entry or return handler is not O(1).

Looking at trampoline_handler(), it actually traverses a list of all
pending return instances to reach the correct return instance. So any
kind of exit timestamp must be placed just before that and passed to
the return handler via kretprobe_instance (as you just suggested).

> b) Or pass ri(kretprobe_instance address to entry_handler) and match it with return probe handler.

This is what I'm trying to do with this patch. I hope I've not misread
what you meant here, but as you'll notice from the patch:


+               if (rp->entry_handler) {
+                       copy = *regs;
+                       arch_prepare_kretprobe(ri, &copy);
+                       if (rp->entry_handler(ri, &copy))
<------------ (entry-handler with ri)
+                               goto out; /* skip current kretprobe instance */
+                       *regs = copy;
+               } else {
+                       arch_prepare_kretprobe(ri, regs);
+               }

the entry handler is called with the appropriate return instance. I
haven't put any explicit "match" test here for ri. The reason is that
the correct ri would be passed to both the entry and return handlers
as trampoline_handler() explicitly matches them to the correct task.
Note that all pending return instances of a function are chained in
LIFO order. S the entry-handler which gets called last, should have
its return handler called first (in case of multiple pending return
instances).

Another cool thing here is that if the entry handler returns a
non-zero value, the current return instance is aborted altogether. So
if the entry-handler fails, no return handler gets called.

Does this address your concerns?

--
Regards
Abhishek Sagar

-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
