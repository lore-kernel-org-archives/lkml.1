Return-Path: <linux-kernel-owner+w=401wt.eu-S932526AbXECGXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526AbXECGXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 02:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932753AbXECGXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 02:23:45 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:49448 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932526AbXECGXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 02:23:44 -0400
Date: Thu, 3 May 2007 08:24:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Reg Clemens <reg@dwf.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: I don' t understand this warning.
Message-ID: <20070503062422.GB13399@uranus.ravnborg.org>
References: <200705030400.l4340bcD031447@deneb.dwf.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705030400.l4340bcD031447@deneb.dwf.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 10:00:37PM -0600, Reg Clemens wrote:
> The last several kernels I have built all have the following warning in them:
> 
> WARNING: vmlinux - Section mismatch: reference to .init.text:start_kernel from 
> .text between 'is386'
>  (at offset 0xc0401171) and 'check_x87'
> WARNING: vmlinux - Section mismatch: reference to .init.text: from .text 
> between 'rest_init' (at off
> set 0xc0401406) and 'try_name'
> WARNING: vmlinux - Section mismatch: reference to .init.data: from .text 
> between 'probe_bigsmp' (at
> offset 0xc0402032) and 'init_apic_ldr'
> WARNING: vmlinux - Section mismatch: reference to .init.text:find_unisys_acpi_o
> em_table from .text b
> etween 'acpi_madt_oem_check' (at offset 0xc0402244) and 'enable_apic_mode'
> 
> and this goes on with different variables for 18 lines.
> 
> Is this something I should be worried about?
> I frankly dont understand what the message is trying to say.

The kernel place code in three different sections.

.init.text is used for all the code that is used during early
initalisation of the kernel and is code that are discarded when the
kernel has finished the init part.

.text is used for regular code and here we hae most of the code.

.exit.text is used for code that is used for module unloading. This section is dropped
in case that the module is build in.


Now consider the scenario where code from .text refer to code in .init.text.
This is OK as long as the .init.text code is still present but when we have
discarded the .init.text section then we go oops.

So to take the first warning then we can see that there is a reference to the
symbol start_kernel in section .iit.text from the .text section somewhere between
the symbols is386 and check_x87.
The symbols in this case is most likely functions.
Due to the heavy use of inlining in the kernel this can be a bit complicated
to dechiper and sometimes I just drop the inlines and try again.


Fro data we have a .init.data section that include data used only during early
init and is discarded too. So the rule is that .text may not refer to .init.data
because it has potential been discarded => oops.
This is the reason for the warning about probe_bigsmp.

For now please do not worry they will all be fixed up pretty soon - the above are
most likely false positives or just lack of proper annotations of relevant functions.

	Sam
