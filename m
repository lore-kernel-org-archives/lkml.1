Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab0BWNdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 08:33:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55276 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab0BWNdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 08:33:08 -0500
X-Authority-Analysis: v=1.0 c=1 a=o9jgRAe6v1AA:10 a=t1oct19Vx2-iHcBslBIA:9 a=AGC8MpwH280AFzl0VLQugEt8TQcA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 07/10] ftrace: pass KBUILD_CFLAGS to record_mcount.pl
From: Steven Rostedt <rostedt@goodmis.org>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
In-Reply-To: <1266090518-31120-8-git-send-email-rabin@rab.in>
References: <1266090518-31120-1-git-send-email-rabin@rab.in>
	 <1266090518-31120-8-git-send-email-rabin@rab.in>
Content-Type: text/plain
Date: Tue, 23 Feb 2010 08:30:46 -0500
Message-Id: <1266931846.19540.9.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-02-14 at 01:18 +0530, Rabin Vincent wrote:
> On ARM, we have two ABIs, and the ABI used is controlled via a config
> option.  Object files built with one ABI can't be merged with object
> files built with the other ABI.  So, record_mcount.pl needs to use the
> same compiler flags as the kernel when generating the object file with
> the mcount locations.  Ensure this by passing CFLAGS to the script.

I'm fine with this for now, but I'm wondering if we should pass the
autoconf.h to the script and parse that instead. This would give us all
set config options that we can look at.

But I need to go back and start looking at converting recordmcount.pl to
recordmcount.c again.

> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
>  scripts/Makefile.build |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index 0b94d2f..2535c11 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -209,7 +209,8 @@ ifdef CONFIG_FTRACE_MCOUNT_RECORD
>  cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
>  	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
>  	"$(if $(CONFIG_64BIT),64,32)" \
> -	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" "$(MV)" \
> +	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC) $(KBUILD_CFLAGS)" \
> +	"$(LD)" "$(NM)" "$(RM)" "$(MV)" \

Doesn't this need to be with the change of recordmcount.pl too?
Otherwise applying this patch alone will break it. We need every step of
the patches to work otherwise we risk breaking a kernel bisect.

-- Steve

>  	"$(if $(part-of-module),1,0)" "$(@)";
>  endif
>  

