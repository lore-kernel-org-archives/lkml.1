Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376AbXCOVQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbXCOVQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 17:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbXCOVQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 17:16:58 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:21110 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbXCOVQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 17:16:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DC01FJ9nCDpoB7swS+EMkCcZ+lc0H6DdYKIir7zgWdWSqXYR321HdydWiLM9YjdKYrypemWow1El9JOXZk+2NYRgJT3xyIalJ00MeOpKjz+tV/E/E27qSfpNBldmx/sO9PZoDdcR3oHv4mEq/v6QKKYpIsKuyIA85xe9YtZdfd0=
Message-ID: <9e0cf0bf0703151416r644e5302t9e053eae24d9d398@mail.gmail.com>
Date: Thu, 15 Mar 2007 23:16:54 +0200
From: "Alon Bar-Lev" <alon.barlev@gmail.com>
To: alon.barlev@gmail.com, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [REPOST] x86_64, i386: Add command line length to boot protocol
In-Reply-To: <20070315210516.GA28998@strauss.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070315210516.GA28998@strauss.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I really don' t understand why you insist that the boot protocol
>=2.02 had 255 limit!
Please remove this from the description.
You want to add size, that's OK, but please don't mess with previous
definitions.
Boot protocol 2.02 introduced the null terminated string truncated by
kernel, which can be at any size.

Best Regards,
Alon Bar-Lev.

On 3/15/07, Bernhard Walle <bwalle@suse.de> wrote:
> Because the command line is increased to 2048 characters after 2.6.21,
> it's not possible for boot loaders and userspace tools to determine the length
> of the command line the kernel can understand. The benefit of knowing the
> length is that users can be warned if the command line size is too long which
> prevents surprise if things don't work after bootup.
>
> This patch updates the boot protocol to contain a field called
> "cmdline_size" that contain the length of the command line (excluding
> the terminating zero).
>
> The patch also adds missing fields (of protocol version 2.05) to the x86_64
> setup code.
>
>
> Signed-off-by: Bernhard Walle <bwalle@suse.de>
> Cc: Alon Bar-Lev <alon.barlev@gmail.com>
>
> ---
>  Documentation/i386/boot.txt |   23 +++++++++++++++++------
>  arch/i386/boot/setup.S      |    7 ++++++-
>  arch/x86_64/boot/setup.S    |   15 ++++++++++++++-
>  3 files changed, 37 insertions(+), 8 deletions(-)
>
> Index: longer-cmdline-boot-proto-mm/Documentation/i386/boot.txt
> ===================================================================
> --- longer-cmdline-boot-proto-mm.orig/Documentation/i386/boot.txt
> +++ longer-cmdline-boot-proto-mm/Documentation/i386/boot.txt
> @@ -2,7 +2,7 @@
>                      ----------------------------
>
>                     H. Peter Anvin <hpa@zytor.com>
> -                       Last update 2007-01-26
> +                       Last update 2007-03-06
>
>  On the i386 platform, the Linux kernel uses a rather complicated boot
>  convention.  This has evolved partially due to historical aspects, as
> @@ -35,9 +35,13 @@ Protocol 2.03:       (Kernel 2.4.18-pre1) Expl
>                 initrd address available to the bootloader.
>
>  Protocol 2.04: (Kernel 2.6.14) Extend the syssize field to four bytes.
> +
>  Protocol 2.05: (Kernel 2.6.20) Make protected mode kernel relocatable.
>                 Introduce relocatable_kernel and kernel_alignment fields.
>
> +Protocol 2.06: (Kernel 2.6.22) Added a field that contains the size of
> +               the boot command line
> +
>
>  **** MEMORY LAYOUT
>
> @@ -133,6 +137,8 @@ Offset      Proto   Name            Meaning
>  022C/4 2.03+   initrd_addr_max Highest legal initrd address
>  0230/4 2.05+   kernel_alignment Physical addr alignment required for kernel
>  0234/1 2.05+   relocatable_kernel Whether kernel is relocatable or not
> +0235/3 N/A     pad2            Unused
> +0238/4 2.06+   cmdline_size    Maximum size of the kernel command line
>
>  (1) For backwards compatibility, if the setup_sects field contains 0, the
>      real value is 4.
> @@ -233,6 +239,12 @@ filled out, however:
>         if your ramdisk is exactly 131072 bytes long and this field is
>         0x37FFFFFF, you can start your ramdisk at 0x37FE0000.)
>
> +  cmdline_size:
> +       The maximum size of the command line without the terminating
> +       zero. This means that the command line can contain at most
> +       cmdline_size characters. With protocol version 2.05 and
> +       earlier, the maximum size was 255.
> +
>
>  **** THE KERNEL COMMAND LINE
>
> @@ -241,11 +253,10 @@ loader to communicate with the kernel.
>  relevant to the boot loader itself, see "special command line options"
>  below.
>
> -The kernel command line is a null-terminated string currently up to
> -255 characters long, plus the final null.  A string that is too long
> -will be automatically truncated by the kernel, a boot loader may allow
> -a longer command line to be passed to permit future kernels to extend
> -this limit.
> +The kernel command line is a null-terminated string. The maximum
> +length can be retrieved from the field cmdline_size.  Before protocol
> +version 2.06, the maximum was 255 characters.  A string that is too
> +long will be automatically truncated by the kernel.
>
>  If the boot protocol version is 2.02 or later, the address of the
>  kernel command line is given by the header field cmd_line_ptr (see
> Index: longer-cmdline-boot-proto-mm/arch/i386/boot/setup.S
> ===================================================================
> --- longer-cmdline-boot-proto-mm.orig/arch/i386/boot/setup.S
> +++ longer-cmdline-boot-proto-mm/arch/i386/boot/setup.S
> @@ -52,6 +52,7 @@
>  #include <asm/boot.h>
>  #include <asm/e820.h>
>  #include <asm/page.h>
> +#include <asm/setup.h>
>
>  /* Signature words to ensure LILO loaded us right */
>  #define SIG1   0xAA55
> @@ -81,7 +82,7 @@ start:
>  # This is the setup header, and it must start at %cs:2 (old 0x9020:2)
>
>                 .ascii  "HdrS"          # header signature
> -               .word   0x0205          # header version number (>= 0x0105)
> +               .word   0x0206          # header version number (>= 0x0105)
>                                         # or else old loadlin-1.5 will fail)
>  realmode_swtch:        .word   0, 0            # default_switch, SETUPSEG
>  start_sys_seg: .word   SYSSEG
> @@ -171,6 +172,10 @@ relocatable_kernel:    .byte 0
>  pad2:                  .byte 0
>  pad3:                  .word 0
>
> +cmdline_size:   .long   COMMAND_LINE_SIZE-1     #length of the command line,
> +                                                #added with boot protocol
> +                                                #version 2.06
> +
>  trampoline:    call    start_of_setup
>                 .align 16
>                                         # The offset at this point is 0x240
> Index: longer-cmdline-boot-proto-mm/arch/x86_64/boot/setup.S
> ===================================================================
> --- longer-cmdline-boot-proto-mm.orig/arch/x86_64/boot/setup.S
> +++ longer-cmdline-boot-proto-mm/arch/x86_64/boot/setup.S
> @@ -51,6 +51,7 @@
>  #include <asm/boot.h>
>  #include <asm/e820.h>
>  #include <asm/page.h>
> +#include <asm/setup.h>
>
>  /* Signature words to ensure LILO loaded us right */
>  #define SIG1   0xAA55
> @@ -80,7 +81,7 @@ start:
>  # This is the setup header, and it must start at %cs:2 (old 0x9020:2)
>
>                 .ascii  "HdrS"          # header signature
> -               .word   0x0204          # header version number (>= 0x0105)
> +               .word   0x0206          # header version number (>= 0x0105)
>                                         # or else old loadlin-1.5 will fail)
>  realmode_swtch:        .word   0, 0            # default_switch, SETUPSEG
>  start_sys_seg: .word   SYSSEG
> @@ -155,6 +156,18 @@ cmd_line_ptr:      .long 0                 # (Header versio
>                                         # low memory 0x10000 or higher.
>
>  ramdisk_max:   .long 0xffffffff
> +
> +kernel_alignment:  .long CONFIG_PHYSICAL_START         #physical addr alignment
> +                                               #(not relocatable =>
> +                                               #fixed start == alignment)
> +
> +relocatable_kernel:     .byte 0                 #x86_64 is currently not
> +pad2:                  .byte 0                 #relocatable
> +pad3:                  .word 0
> +
> +cmdline_size:   .long   COMMAND_LINE_SIZE-1     #length of the command line,
> +                                                #added with boot protocol
> +                                                #version 2.06
>
>  trampoline:    call    start_of_setup
>                 .align 16
>
