Return-Path: <linux-kernel-owner+w=401wt.eu-S1756293AbXI1VsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293AbXI1VsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 17:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbXI1VsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 17:48:13 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:37612 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbXI1VsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 17:48:13 -0400
Date: Fri, 28 Sep 2007 14:46:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Jan Engelhardt <jengelh@computergmbh.de>, Adrian Bunk <bunk@kernel.org>,
       roel <12o3l@tiscali.nl>
Subject: Re: [PATCH 1/3] CodingStyle updates
Message-Id: <20070928144636.cb18f535.randy.dunlap@oracle.com>
In-Reply-To: <11910151223447-git-send-email-ezk@cs.sunysb.edu>
References: <11910151223214-git-send-email-ezk@cs.sunysb.edu>
	<11910151223447-git-send-email-ezk@cs.sunysb.edu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 17:32:00 -0400 Erez Zadok wrote:

> 1. Updates chapter 13 (printing kernel messages) to expand on the use of
>    pr_debug()/pr_info(), what to avoid, and how to hook your debug code with
>    kernel.h.
> 
> 2. New chapter 19, branch prediction optimizations, discusses the whole
>    un/likely issue.
> 
> Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>
> Cc: Kyle Moffett <mrmacman_g4@mac.com>
> Cc: Jan Engelhardt <jengelh@computergmbh.de>
> Cc: Adrian Bunk <bunk@kernel.org>
> Cc: roel <12o3l@tiscali.nl>
> 
> Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>

A few comments below...

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

> ---
>  Documentation/CodingStyle |   88 +++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 86 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
> index 7f1730f..00b29e4 100644
> --- a/Documentation/CodingStyle
> +++ b/Documentation/CodingStyle
...
> @@ -779,6 +797,69 @@ includes markers for indentation and mode configuration.  People may use their
>  own custom mode, or may have some other magic method for making indentation
>  work correctly.
>  
> +		Chapter 19: branch prediction optimizations
> +
> +The kernel includes macros called likely() and unlikely(), which can be used
> +as hints to the compiler to optimize branch prediction.  They operate by
> +asking gcc to shuffle the code around so that the more favorable outcome
> +executes linearly, avoiding a JMP instruction; this can improve cache
> +pipeline efficiency.  For technical details how these macros work, see the
> +References section at the end of this document.
> +
> +An example use of this as as follows:
> +
> +	ptr = kmalloc(size, GFP_KERNEL);
> +	if (unlikely(!ptr))
> +		...
> +
> +or
> +	err = some_function(...);
> +	if (likely(!err))
> +		...
> +
> +The main two problems with using un/likely() are that (a) programmers can
> +easily be wrong about their code's likelihood to take one branch
> +vs. another, and (b) on average, gcc will do a much better job optimizing
> +branches that the programmer can.  The benefit on some systems for
> +predicting correctly can be in saving a few instructions.  But the penalty
> +for wrong use of un/likely() can be very significant (possibly dozens of
> +instructions), as you may be doing a JMP instruction, hurting your pipeline
> +cache, EACH time you get to the branch in question!
> +
> +Therefore, use un/likely() sparingly, consider it primarily for hot paths,
> +use it only when you are certain that the condition in question rarely
> +happens, be sure that it happens with roughly the same probability under
> +most/all user conditions.  One rule of thumb suggested is that the
> +probability of the branch un/taken should exceed 99% (although some would
> +consider 95% as well).  Of course, beware of silly mistakes such as
> +intending to use likely() and using unlikely() instead.
> +
> +A good example of this is the above kmalloc(GFP_KERNEL) call.  The chances
> +of kmalloc() returning NULL are rather small, because even if it doesn't
> +have memory to return to you at the moment, with GFP_KERNEL/__GFP_WAIT
> +passed, kmalloc() will wait and suspend your thread, while it goes off to
> +find some free memory (purging caches, flushing buffers, etc.).  In other
> +words, kmalloc() tries very hard to give you the memory you asked for by the
> +time it return.

           returns.

> +
> +Consider the next, bad example.  Suppose you're developing a file system

                    ^comma seems odd here

> +which performs logically different actions on different types of entities:
> +files, directories, symlinks, devices, etc. and you use this code:
> +
> +	if (unlikely(S_ISBLK(mode))
> +		...
> +
> +On first glance, the above use of unlikely() seems right.  After all, most
> +file system objects are files and directories, and very few of them tend to
> +be block devices.  So this optimization should work well, no?  Although it's
> +true that it'll work well for most users, what about some user who happens
> +to have a file system with lots of block devices?  Or what if the user has
> +only one block device object on the file system, but the user has an
> +application which causes the above conditional to be traversed very
> +frequently (e.g., a shell script that deals with devices)?  Such users will
> +be penalized heavily for going [sic] down the wrong path...  Therefore, you
> +should consider also whether a seemingly-rare condition is indeed rare ALL
> +the time.
>  
>  
>  		Appendix I: References
> @@ -804,6 +885,9 @@ language C, URL: http://www.open-std.org/JTC1/SC22/WG14/
>  Kernel CodingStyle, by greg@kroah.com at OLS 2002:
>  http://www.kroah.com/linux/talks/ols_2002_kernel_codingstyle_talk/html/
>  
> +FAQ/LikelyUnlikely:
> +http://kernelnewbies.org/FAQ/LikelyUnlikely
> +
>  --


---
~Randy
Phaedrus says that Quality is about caring.
