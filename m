Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbXISWcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbXISWcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 18:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbXISWcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 18:32:33 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39620 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751849AbXISWcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 18:32:32 -0400
Date: Wed, 19 Sep 2007 15:32:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bernhard Walle <bwalle@suse.de>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [patch 1/7] Extended crashkernel command line
Message-Id: <20070919153222.37dddfb1.akpm@linux-foundation.org>
In-Reply-To: <20070913161428.754733639@strauss.suse.de>
References: <20070913161428.343951643@strauss.suse.de>
	<20070913161428.754733639@strauss.suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007 18:14:29 +0200
Bernhard Walle <bwalle@suse.de> wrote:

> This is the generic part of the patch. It adds a parse_crashkernel() function
> in kernel/kexec.c that is called by the architecture specific code that
> actually reserves the memory. That function takes the whole command line and
> looks itself for "crashkernel=" in it.
> 
> If there are multiple occurrences, then the last one is taken.  The advantage
> is that if you have a bootloader like lilo or elilo which allows you to append
> a command line parameter but not to remove one (like in GRUB), then you can add
> another crashkernel value for testing at the boot command line and this one
> overwrites the command line in the configuration then.
> 
> 
> Signed-off-by: Bernhard Walle <bwalle@suse.de>
> 
> ---
>  include/linux/kexec.h |    2 
>  kernel/kexec.c        |  139 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 141 insertions(+)
> 
> --- a/include/linux/kexec.h
> +++ b/include/linux/kexec.h
> @@ -179,6 +179,8 @@ extern note_buf_t *crash_notes;
>  extern u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
>  extern unsigned int vmcoreinfo_size;
>  extern unsigned int vmcoreinfo_max_size;
> +int parse_crashkernel(char *cmdline, unsigned long long system_ram,
> +		unsigned long long *crash_size, unsigned long long *crash_base);
>  
>  
>  #else /* !CONFIG_KEXEC */
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1146,6 +1146,145 @@ static int __init crash_notes_memory_ini
>  }
>  module_init(crash_notes_memory_init)
>  
> +
> +/*
> + * parsing the "crashkernel" commandline
> + *
> + * this code is intended to be called from architecture specific code
> + */
> +
> +
> +/*
> + * This function parses command lines in the format
> + *
> + *   crashkernel=<ramsize-range>:<size>[,...][@<base>]
> + *
> + * The function returns 0 on success and -EINVAL on failure.
> + */
> +static int parse_crashkernel_mem(char 			*cmdline,
> +				 unsigned long long 	*crash_size,
> +				 unsigned long long 	*crash_base,
> +				 unsigned long 		system_ram)
> +{

The patchset seems to be putting a large amount of stuff into .text
which could have gone into .text.init?
