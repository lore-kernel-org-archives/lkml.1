Return-Path: <linux-kernel-owner+w=401wt.eu-S1758478AbZDIAvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758478AbZDIAvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 20:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756011AbZDIAvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 20:51:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753976AbZDIAvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 20:51:20 -0400
Date: Wed, 8 Apr 2009 17:48:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH] x86,edac: fix for compiler error in traps.c
Message-Id: <20090408174833.b9bb56ec.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0904082004070.16430@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0904081954530.16430@gandalf.stny.rr.com>
	<alpine.DEB.2.00.0904082004070.16430@gandalf.stny.rr.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Apr 2009 20:06:53 -0400 (EDT) Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Impact: compile fix
> 
>  I got this compile failure on both tip/tracing/core as well as on 
>  v2.6.30-rc1.
>  
>    LD      .tmp_vmlinux1
>  arch/x86/kernel/built-in.o: In function `do_nmi':
>  (.text+0x3c18): undefined reference to `edac_handler_set'
>  arch/x86/kernel/built-in.o: In function `do_nmi':
>  (.text+0x3c48): undefined reference to `edac_atomic_assert_error'
>  make: *** [.tmp_vmlinux1] Error 1
>  [root@bxrhel51 linux-trace.git]# grep edac_handler_set 
>  [root@bxrhel51 linux-trace.git]# Grep edac_handler_set '*.[ch]'
>  find .  -name "*.[ch]" ! -type d  | xargs grep  "edac_handler_set"
>  ./arch/x86/kernel/traps.c:	if (edac_handler_set()) {
>  ./include/linux/edac.h:extern int edac_handler_set(void);
>  ./drivers/edac/edac_stub.c:int edac_handler_set(void)
>  ./drivers/edac/edac_stub.c:EXPORT_SYMBOL_GPL(edac_handler_set);
>  
> This patch seems to fix it.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
> index a5fdcf0..cc2bcb4 100644
> --- a/drivers/edac/Makefile
> +++ b/drivers/edac/Makefile
> @@ -7,7 +7,7 @@
>  #
>  
>  
> -obj-$(CONFIG_EDAC)			:= edac_stub.o
> +obj-$(CONFIG_EDAC)			+= edac_stub.o
>  obj-$(CONFIG_EDAC_MM_EDAC)		+= edac_core.o
>  
>  edac_core-objs	:= edac_mc.o edac_device.o edac_mc_sysfs.o edac_pci_sysfs.o

OK, thanks, I'll send that Linuswards asap.

I guess it could/should be

	obj-y += edac_stub.o

because CONFIG_EDAC is known to be true in drivers/edac/.  But that's
just a consistency/style thing for Doug to scratch his head over ;)
