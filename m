Return-Path: <linux-kernel-owner+w=401wt.eu-S932991AbXBFFZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991AbXBFFZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 00:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbXBFFZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 00:25:48 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60807 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765AbXBFFZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 00:25:47 -0500
Date: Tue, 6 Feb 2007 10:55:14 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Etienne Lorrain <etienne_lorrain@yahoo.fr>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
Message-ID: <20070206052514.GA15613@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <522909.27613.qm@web26909.mail.ukl.yahoo.com> <45C7CDD7.20806@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C7CDD7.20806@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 04:37:43PM -0800, H. Peter Anvin wrote:
> First of all, if sending attached patches, *MAKE SURE* they're text/plain.
> 
> >diff -uprN -X linux-2.6.20/Documentation/dontdiff 
> >linux-2.6.20/arch/i386/kernel/setup.c 
> >linux-2.6.20-gujin/arch/i386/kernel/setup.c
> >--- linux-2.6.20/arch/i386/kernel/setup.c       2007-02-04 
> >18:44:54.000000000 +0000
> >+++ linux-2.6.20-gujin/arch/i386/kernel/setup.c 2007-02-05 
> >21:27:01.000000000 +0000
> >@@ -579,6 +579,19 @@ void __init setup_arch(char **cmdline_p)
> >        strlcpy(command_line, saved_command_line, COMMAND_LINE_SIZE);
> >        *cmdline_p = command_line;
> >
> >+       /*
> >+        * If the command line begin with '/', it is the filename of the
> >+        * kernel file - like a shell command line. That can be used to
> >+        * deduce where root was located when the kernel was compiled,
> >+        * inside a directory of root named /boot, inside a small partition
> >+        * mounted on a directory of root named /boot or in the root
> >+        * directory itself.
> >+        */
> >+       if (**cmdline_p == '/')
> >+               while (**cmdline_p != ' ' && **cmdline_p != '\t'
> >+                       && **cmdline_p != '\n' && **cmdline_p != '\0')
> >+                       ++*cmdline_p;
> >+
> >        max_low_pfn = setup_memory();
> >
> >        /*
> 
> The standard way to do this is to have a command line argument named 
> BOOT_IMAGE (as in BOOT_IMAGE=/foo/bar/baz).  There is no reason to do 
> this differently from every other bootloader.
> 
> Why build the real-mode code as part of the kernel binary?  If you have 
> to reference kernel symbols, you can do that with the -R option to ld. 
> Bundling it into the kernel binary just to then extract it later is 
> silly at best.
> 

Building real mode code with kernel binary (vmlinux) has got another
disadvantage that it breaks using vmlinux for kdump purposes. One compiles
the kernel binary to execute from a different address but real mode code/data
will continue to be at virtual/physical addr 0 and kexec can not load it
as that physical memory is not available at all. Kdump skips the real mode
code execution.

I don't know much about Gujin, but advantage here seems to be that it has
capability to load elf files and that's why the attempt to turn kernel binary
into a compressed elf image. Why don't we then simply add an ELF header to
bzImage and Gujin and any ELF loader including Gujin, should be able to load
it? (As Eric had done in one of the implementations in the past?) Why to 
create the new infrastructure?

Thanks
Vivek
