Return-Path: <linux-kernel-owner+w=401wt.eu-S1753181AbZA1AMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbZA1AMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 19:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbZA1AMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 19:12:08 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:59406 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbZA1AMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 19:12:06 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=SA4ax6_J2kcfA1OOUTYA:9 a=HXAlKjU_n9YQ3k6ZWRj9qQgwWHMA:4 a=XMu6tZMd_poA:10 a=HgkmyU9reBMA:10
Message-ID: <497FA2D0.1090605@shaw.ca>
Date: Tue, 27 Jan 2009 18:12:00 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Roger Larsson <roger.larsson@e-gatan.se>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Robert Love <rml@tech9.net>, Pavel Machek <pavel@ucw.cz>
Subject: Re: PROBLEM: in_atomic() misuse all over the place
References: <200901280010.37633.roger.larsson@e-gatan.se>
In-Reply-To: <200901280010.37633.roger.larsson@e-gatan.se>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roger Larsson wrote:
> (resent, non html)
> 
> [1.] One line summary of the problem:    
> in_atomic() is used to select path of execution, most likely to suppress 
> warning logs when running a preemptive kernel.
> 
> [2.] Full description of the problem/report:
> 
> The problem is that in_atomic() only works on preemptive kernels...
> 
> Result: preemptive kernel warns about a potential deadlock in all kernels,
> developer silence with the help of in_atomic()
> bug remains in SMP/UP kernels...
> 
> [3.] Keywords (i.e., modules, networking, kernel):
> in_atomic(), preemptive, sleeping
> 
> [4.] Kernel version (from /proc/version):
> 	2.6.28.2 (review)
> 
> [5.] Output of Oops..
> 
> "sleeping function called from invalid context"
> 
> [6.] A small shell script or example program which triggers the
>      problem (if possible)
> 
> Small example of the strange code I found is this
> 
> file:  include/net/sock.h
> 
>    static inline gfp_t gfp_any(void)
>    {
>      return in_atomic() ? GFP_ATOMIC : GFP_KERNEL;
>    }
> 
> 	//  I can find no comment on why this strange code would be OK.
> 	//  An it is in its turn used in several drivers...
> 
> If the processor can get to this function while atomic in a preemptive kernel 
> it will likely be able to get there in other kernels as well, especially SMP.
> 
> It returns GFP_ATOMIC when being atomic in a preemptive kernel, allocating 
> with that flag will not sleep. But calling this with another kernel will 
> ALWAYS return GFP_KERNEL, and it may cause a sleeping allocate...
> 
> Other places that I think misuse of in_atomic is Arch code, USB code, ...
> 
> There are 77 uses of in_atomic directly (grep | wc)
> 36 in ./arch
> 23 in ./drivers
> 2 in ./sound/core/seq/seq_virmidi.c
> 1 in ./include/net/sock.h
> The remaining 15 are probably OK (kernel, mm/filemap)
> 
> But the sock.h gfp_any() spreads further...
> 1 in ./Documentation
> 2 in ./drivers
> 9 in ./net
> 
> 
> Suggestion: should in_atomic() that by default return the safer 1 instead of 
> the unsafe 0. And add an in_atomic_warn() with default of 0 to use where it is
> OK - like when deciding to log a warning.

I would think that the code that's using it for this purpose should be 
changed to do things differently, such as by changing the functions 
using it to make their caller pass in the proper GFP mask. I don't think 
it was ever intended to be used to select allocation behavior like this, 
only for debug warning checks and such.. Getting rid of in_atomic() and 
creating a in_atomic_warn() that just raises a warning if called 
atomically, might be the best long-term solution.
