Return-Path: <linux-kernel-owner+w=401wt.eu-S964988AbXCGKGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964988AbXCGKGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 05:06:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965026AbXCGKGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 05:06:00 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:53246 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964988AbXCGKF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 05:05:57 -0500
Date: Wed, 7 Mar 2007 15:35:45 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, alon.barlev@gmail.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64, i386: Add command line length to boot protocol
Message-ID: <20070307100545.GA9807@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070306181430.GB3151@strauss.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306181430.GB3151@strauss.suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 07:14:30PM +0100, Bernhard Walle wrote:
> Because the command line is increased to 2048 characters after 2.6.21,
> it's not possible for boot loaders and userspace tools to determine the length
> of the command line the kernel can understand. The benefit of knowing the
> length is that users can be warned if the command line size is too long which
> prevents surprise if things don't work after bootup.

This makes sense to me. It can be used in kexec bootloader to warn user
if command line size exceeds than supported by kernel.

> 
> This patch updates the boot protocol to contain a field called
> "cmdline_size" that contain the length of the command line (excluding
> the terminating zero).
> 
> The patch also adds missing fields (of protocol version 2.05) to the x86_64
> setup code.

Today I have posted the x86_64 relocatable kernel patches which also fill
in missing 2.05 fields for x86_64.

[..]
>  #define SIG1	0xAA55
> @@ -81,7 +82,7 @@ start:
>  # This is the setup header, and it must start at %cs:2 (old 0x9020:2)
> 
>  		.ascii	"HdrS"		# header signature
> -		.word	0x0205		# header version number (>= 0x0105)
> +		.word	0x0206		# header version number (>= 0x0105)
>  					# or else old loadlin-1.5 will fail)
>  realmode_swtch:	.word	0, 0		# default_switch, SETUPSEG
>  start_sys_seg:	.word	SYSSEG
> @@ -171,6 +172,10 @@ relocatable_kernel:    .byte 0
>  pad2:			.byte 0
>  pad3:			.word 0
> 
> +cmdline_size:   .long   COMMAND_LINE_SIZE-1     #length of the command line,
> +                                                #added with boot protocol
> +                                                #version 2.06
> +

I think you will not require more than two bytes to represent supported
command line size so you can use replace pad3 and use these two bytes. These
were anyway padding bytes to be used for other requirements.

[..]
>  					# or else old loadlin-1.5 will fail)
>  realmode_swtch:	.word	0, 0		# default_switch, SETUPSEG
>  start_sys_seg:	.word	SYSSEG
> @@ -155,6 +156,18 @@ cmd_line_ptr:	.long 0			# (Header versio
>  					# low memory 0x10000 or higher.
> 
>  ramdisk_max:	.long 0xffffffff
> +
> +kernel_alignment:  .long CONFIG_PHYSICAL_START 	#physical addr alignment
> +						#(not relocatable =>
> +						#fixed start == alignment)
> +

This is wrong. CONFIG_PHYSICAL_START is not alignment. On x86_64 alignment
required is 2MB. (0x200000).

Thanks
Vivek
