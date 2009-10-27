Return-Path: <linux-kernel-owner+w=401wt.eu-S932115AbZJ0UZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbZJ0UZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 16:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756794AbZJ0UZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 16:25:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46251 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756793AbZJ0UZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 16:25:22 -0400
Subject: Re: [PATCH 1/9] tracing: recordmcount.pl Amend the documentation
 according to the implementation
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Hong <lihong.hi@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20091027065421.GA22032@uhli>
References: <20091027065421.GA22032@uhli>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 27 Oct 2009 16:04:22 -0400
Message-Id: <1256673862.26028.430.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 14:54 +0800, Li Hong wrote:
> In documentation, we says we will use the first function in a section as a
> reference. Actually, the algorithm is: choose the first global function we
> meet as a reference. If there is none, choose the first local one. So let the
> documentation consistent to the code.
> 
> Also add several clarifications.
> 
> Signed-off-by: Li Hong <lihong.hi@gmail.com>
> 
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index 090d300..ac908b3 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -6,73 +6,88 @@
>  #                   all the offsets to the calls to mcount.
>  #
>  #
> -# What we want to end up with is a section in vmlinux called
> -# __mcount_loc that contains a list of pointers to all the
> -# call sites in the kernel that call mcount. Later on boot up, the kernel
> -# will read this list, save the locations and turn them into nops.
> -# When tracing or profiling is later enabled, these locations will then
> -# be converted back to pointers to some function.
> +# What we want to end up with this is a data area in .init.data in vmlinux 
> +# that contains a list of pointers to all the call sites in the kernel that
> +# call mcount. Later on boot up, the kernel will read this list, save the 
> +# locations and turn them into nops. When tracing or profiling is later 
> +# enabled, these locations will then be converted back to pointers to 
> +# some function.

Yes it is in .init.data, but the point is that we called it __mcount_loc
in the object files. I don't want to blindly throw that name away.

Something to the lines of this.

Each object file will have a section called __mcount_loc that will hold
the list of pointers to mcount callers. After final linking, the vmlinux
will have within .init.data the list of all callers to mcount between
_start_mcount_loc and __stop_mcount_loc.


>  #
>  # This is no easy feat. This script is called just after the original
>  # object is compiled and before it is linked.
>  #
> -# The references to the call sites are offsets from the section of text
> -# that the call site is in. Hence, all functions in a section that
> -# has a call site to mcount, will have the offset from the beginning of
> -# the section and not the beginning of the function.
> +# When parse this object file using 'objdump', the references to the call 
> +# sites are offsets from the section that the call site is in. Hence, all 
> +# functions in a section that  has a call site to mcount, will have the 
                                ^^
                            double space

> +# offset from the beginning of the section and not the beginning of the 
> +# function.
>  #
> -# The trick is to find a way to record the beginning of the section.
> -# The way we do this is to look at the first function in the section
> -# which will also be the location of that section after final link.
> +# But where this section will reside finally in vmlinx is undetermined at 
> +# this point. So we can't use this kind of offsets to record the final
> +# address of this call site.
> +#
> +# The trick is to change the call offset refering the start of a section to
                                         referring

> +# refering a function symbol in this section. During the link step, 'ld' will
     referring


The rest looks good.

-- Steve

> +# compute the final address according to the information we record.
> +# 
>  # e.g.
>  #
>  #  .section ".sched.text", "ax"
> -#

