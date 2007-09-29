Return-Path: <linux-kernel-owner+w=401wt.eu-S1757117AbXI2Omu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117AbXI2Omu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 10:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbXI2Omm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 10:42:42 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:44550 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbXI2Oml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 10:42:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=B1my+ZLHD0nYJSyjIWDEebFb91e0C557HgJkqlFZefWd0V3pLsVjmwWLQvtth6A7STQI0VNkCi+NcKAYPFMkT9vVJX64axETQYEagNzGvOHc5bCcHI4/jp/GU5v7vtJAYELgGooxnCYhKowhi1jMiijwCiAFmM+J7kt9ApHPEZY=
Date: Sat, 29 Sep 2007 09:43:16 -0500
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Jan Engelhardt <jengelh@computergmbh.de>, Adrian Bunk <bunk@kernel.org>,
       roel <12o3l@tiscali.nl>
Subject: Re: [PATCH 1/3] CodingStyle updates
Message-ID: <20070929144316.GA5642@mediacenter.austin.rr.com>
References: <11910151223214-git-send-email-ezk@cs.sunysb.edu> <11910151223447-git-send-email-ezk@cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11910151223447-git-send-email-ezk@cs.sunysb.edu>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 05:32:00PM -0400, Erez Zadok wrote:
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
> ---
>  Documentation/CodingStyle |   88 +++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 86 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
> index 7f1730f..00b29e4 100644
> --- a/Documentation/CodingStyle
> +++ b/Documentation/CodingStyle
> @@ -643,8 +643,26 @@ Printing numbers in parentheses (%d) adds no value and should be avoided.
>  There are a number of driver model diagnostic macros in <linux/device.h>
>  which you should use to make sure messages are matched to the right device
>  and driver, and are tagged with the right level:  dev_err(), dev_warn(),
> -dev_info(), and so forth.  For messages that aren't associated with a
> -particular device, <linux/kernel.h> defines pr_debug() and pr_info().
> +dev_info(), and so forth.
> +
> +A number of people often like to define their own debugging printf's,
> +wrapping printk's in #ifdef's that get turned on only when subsystem
> +debugging is compiled in (e.g., dprintk, Dprintk, DPRINTK, etc.).  Please
> +don't reinvent the wheel but use existing mechanisms.  For messages that
> +aren't associated with a particular device, <linux/kernel.h> defines
> +pr_debug() and pr_info(); the latter two translate to printk(KERN_DEBUG) and

The latter two?  Since there are only two presented I think there is no
reason to say "latter".

> +printk(KERN_INFO), respectively.  However, to get pr_debug() to actually
> +emit the message, you'll need to turn on DEBUG in your code, which can be
> +done as follows in your subsystem Makefile:
> +
> +ifeq ($(CONFIG_WHATEVER_DEBUG),y)
> +EXTRA_CFLAGS += -DDEBUG
> +endif
> +
> +In this way, you can create a Kconfig parameter to turn on debugging at
> +compile time, which will also turn on DEBUG, to enable pr_debug() to emit
> +actual messages; conversely, when CONFIG_WHATEVER_DEBUG is off, DEBUG is
> +off, and pr_debug() will display nothing.
>  
>  Coming up with good debugging messages can be quite a challenge; and once
>  you have them, they can be a huge help for remote troubleshooting.  Such
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

                          ^^^^^^

> +
> +	ptr = kmalloc(size, GFP_KERNEL);
> +	if (unlikely(!ptr))
> +		...
> +
> +or
> +	err = some_function(...);
> +	if (likely(!err))
> +		...

--
Shawn
