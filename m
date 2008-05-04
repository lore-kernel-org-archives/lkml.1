Return-Path: <linux-kernel-owner+w=401wt.eu-S1757051AbYEDWUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051AbYEDWUJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 18:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756675AbYEDWTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 18:19:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:33049 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270AbYEDWTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 18:19:38 -0400
In-Reply-To: <481DF3D8.3010108@shaw.ca>
References: <fa.QTbvQYXhEm5VNP5dvkl5JG7NHYQ@ifi.uio.no> <481DF3D8.3010108@shaw.ca>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <a6dd201e0149f8dbdf10a7a194673833@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: undefined reference to __udivdi3 (gcc-4.3)
Date: Mon, 5 May 2008 00:19:08 +0200
To: Robert Hancock <hancockr@shaw.ca>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I assume it's one or both of these loops in arch/x86/xen/time.c 
> do_stolen_accounting() that are being optimized into a divide which 
> generates a libgcc call:
>
> 	while (stolen >= NS_PER_TICK) {
> 		ticks++;
> 		stolen -= NS_PER_TICK;
> 	}
>
> or
>
> 	while (blocked >= NS_PER_TICK) {
> 		ticks++;
> 		blocked -= NS_PER_TICK;
> 	}

That looks plausible.

> I seem to recall in one previous case we added some dummy assembly 
> code to stop gcc from doing this.

I think you refer to 38332cb9, "time: prevent the loop in
timespec_add_ns() from being optimised away".


         while(unlikely(ns >= NSEC_PER_SEC)) {
+               /* The following asm() prevents the compiler from
+                * optimising this loop into a modulo operation.  */
+               asm("" : "+r"(ns));
+
                 ns -= NSEC_PER_SEC;
                 a->tv_sec++;
         }


> Not sure if that is a sustainable fix, though..

It should be.  The asm() arg tells GCC that the asm() could modify
"ns" in some way, so GCC cannot optimise away the loop, since it
doesn't have the required info about the induction variable to do
that.


Segher

