Return-Path: <linux-kernel-owner+w=401wt.eu-S1761786AbXEPER7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761786AbXEPER7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 00:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbXEPERw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 00:17:52 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:22965 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbXEPERv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 00:17:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=m6imSZI1mVOW2aSW++Sumk9AFnGD9tHD3OaiZDu254KhDuyNBQusoBinWwBo0wif/qpQiRBcyjWsfv1jKch5QMIms7c+qf55KTyHlcn6oFcO1olFoDmnTRWxJeE4hFfW/zA9dP6Uo6QApi12mKhFeXRipc++yvPym0sTbx5nqwc=
Message-ID: <86802c440705152117o34325f1dw4a0cdf95241b3b42@mail.gmail.com>
Date: Tue, 15 May 2007 21:17:50 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Gerd Hoffmann" <kraxel@suse.de>, "Andi Kleen" <ak@suse.de>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>, akpm@linux-foundation.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch] early printk and boot console fixups.
Cc: "linux kernel mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <45D5C473.4010608@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45D5C473.4010608@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/16/07, Gerd Hoffmann <kraxel@suse.de> wrote:

> The console subsystem already has an idea of a boot console, using the
> CON_BOOT flag.  The implementation has some flaws though.  The major
> problem is that presence of a boot console makes register_console()
> ignore any other console devices (unless explicitly specified on the
> kernel command line).
>
> This patch fixes the console selection code to *not* consider a boot
> console a full-featured one, so the first "normal" console registering
> will become the default boot console instead.  This way the unregister
> call for the boot console in register_console() actually triggers and
> the handover from the boot console to the real console device works
> smoothly.
>
> The patch also changes the x86 early_printk code to use this.  The early
> console is simply tagged as boot console, the disable_early_printk()
> call is gone as it isn't needed any more.

just notice console handover patch got into mainline 5/8.

for early_uart_console, I have some ideas:
1. merged that into early_serial_console in
arch/x86_64/kernel/early_printk.c, and
move early_printk.c to kernel/, --- make it understand
     earlyprintk=uart,io,0x3f8,9600n8
     earlyprintk=uart,mmio,0xff5e0000,115200n8
in addition to vga, ttyS, serial

2. or make early_uart_console to be another CON_BOOT, and get rid of
late_initcall(early_uart_console_switch).
actually with late_initcall early_uart_console_switch instead of
console handover, we will lose char output from serial drv init to
late_initcall stage.
in this case, we need to EARLY_SERIAL_CONSOLE to select
early_serial_console or early_uart_console for x86_64 platform.

YH
