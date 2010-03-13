Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934192Ab0CMRhU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 12:37:20 -0500
Received: from cpe-74-67-89-75.stny.res.rr.com ([74.67.89.75]:41247 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932937Ab0CMRhT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 12:37:19 -0500
Subject: Re: [PATCH 03/10] ftrace: allow building without frame pointers
From: Steven Rostedt <rostedt@goodmis.org>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
In-Reply-To: <1268462987-8271-4-git-send-email-rabin@rab.in>
References: <1268462987-8271-1-git-send-email-rabin@rab.in>
	 <1268462987-8271-4-git-send-email-rabin@rab.in>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 13 Mar 2010 12:36:32 -0500
Message-ID: <1268501792.3366.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-03-13 at 12:19 +0530, Rabin Vincent wrote:
> With current gcc, compiling with both -pg and -fomit-frame-pointer is
> not allowed.  However, -pg can be used to build without actually
> specying -fno-omit-frame-pointer, upon which the defaut behaviour for
> the target will be used.
> 
> On ARM, it is not possible to build a Thumb-2 kernel with
> -fno-omit-frame-pointer (FRAME_POINTERS depends on !THUMB2_KERNEL). In
> order to support ftrace for Thumb-2, we need to be able to allow a
> combination of FUNCTION_TRACER and !FRAME_POINTER.  We do this by
> omitting -fomit-frame-pointer if ftrace is enabled.
> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
> v2: Better comment.
> 
>  Makefile |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 08ff02d..61404e0 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -546,8 +546,15 @@ endif
>  ifdef CONFIG_FRAME_POINTER
>  KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
>  else
> +# Some targets (ARM with Thumb2, for example), can't be built with frame
> +# pointers.  For those, we don't have FUNCTION_TRACER automatically
> +# select FRAME_POINTER.  However, FUNCTION_TRACER adds -pg, and this is
> +# incompatible with -fomit-frame-pointer with current GCC, so we don't use
> +# -fomit-frame-pointer with FUNCTION_TRACER.
> +ifndef CONFIG_FUNCTION_TRACER
>  KBUILD_CFLAGS	+= -fomit-frame-pointer

I believe this is correct, but have you tested this on other archs other
than ARM? I can do it for x86 and PPC, but it will need to wait as those
machines are currently performing stress tests.

-- Steve

>  endif
> +endif
>  
>  ifdef CONFIG_DEBUG_INFO
>  KBUILD_CFLAGS	+= -g

