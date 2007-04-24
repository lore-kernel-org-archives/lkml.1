Return-Path: <linux-kernel-owner+w=401wt.eu-S1161663AbXDXGdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161663AbXDXGdG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 02:33:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161664AbXDXGdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 02:33:06 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:38604 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161663AbXDXGdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 02:33:03 -0400
Date: Tue, 24 Apr 2007 12:01:40 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Jurriaan <thunder7@xs4all.nl>, Helge Hafting <helgehaf@aitel.hist.no>,
       linux-kernel@vger.kernel.org, Horms <horms@verge.net.au>,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH 1/2] x86_64: Reflect the relocatability of the kernel in the ELF header.
Message-ID: <20070424063139.GA22742@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <m1ircghb6w.fsf@ebiederm.dsl.xmission.com> <20070331232957.e1c93f19.akpm@linux-foundation.org> <20070402074159.GA13704@in.ibm.com> <m1abxrf9o3.fsf@ebiederm.dsl.xmission.com> <20070402094520.GC13704@in.ibm.com> <m1648eg01d.fsf@ebiederm.dsl.xmission.com> <20070403040152.GA5108@in.ibm.com> <m1zm5qc9q2.fsf@ebiederm.dsl.xmission.com> <20070403100349.GA21759@in.ibm.com> <m18xcjznbm.fsf_-_@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m18xcjznbm.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2007 at 11:12:13PM -0600, Eric W. Biederman wrote:
> 
> Currently because vmlinux does not reflect that the kernel is relocatable
> we still have to support CONFIG_PHYSICAL_START.  So this patch adds a small
> c program to do what we cannot do with a linker script, set the elf header
> type to ET_DYN.
> 
> This should remove the last obstacle to removing CONFIG_PHYSICAL_START
> on x86_64.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

[Dropping fastboot mailing list from CC as kexec mailing list is new list
 for this discussion]

[..]
> +void file_open(const char *name)
> +{
> +	if ((fd = open(name, O_RDWR, 0)) < 0)
> +		die("Unable to open `%s': %m", name);
> +}
> +
> +static void mketrel(void)
> +{
> +	unsigned char e_type[2];
> +	if (read(fd, &e_ident, sizeof(e_ident)) != sizeof(e_ident))
> +		die("Cannot read ELF header: %s\n", strerror(errno));
> +
> +	if (memcmp(e_ident, ELFMAG, 4) != 0)
> +		die("No ELF magic\n");
> +
> +	if ((e_ident[EI_CLASS] != ELFCLASS64) &&
> +	    (e_ident[EI_CLASS] != ELFCLASS32))
> +		die("Unrecognized ELF class: %x\n", e_ident[EI_CLASS]);
> +	
> +	if ((e_ident[EI_DATA] != ELFDATA2LSB) &&
> +	    (e_ident[EI_DATA] != ELFDATA2MSB))
> +		die("Unrecognized ELF data encoding: %x\n", e_ident[EI_DATA]);
> +
> +	if (e_ident[EI_VERSION] != EV_CURRENT)
> +		die("Unknown ELF version: %d\n", e_ident[EI_VERSION]);
> +
> +	if (e_ident[EI_DATA] == ELFDATA2LSB) {
> +		e_type[0] = ET_REL & 0xff;
> +		e_type[1] = ET_REL >> 8;
> +	} else {
> +		e_type[1] = ET_REL & 0xff;
> +		e_type[0] = ET_REL >> 8;
> +	}

Hi Eric,

Should this be ET_REL or ET_DYN? kexec refuses to load this vmlinux
as it does not find it to be executable type.

I am not well versed with various conventions but if I go through "Executable
and Linking Format" document, this is what it says about various file types.

• A relocatable file holds code and data suitable for linking with other
  object files to create an executable or a shared object file.

• An executable file holds a program suitable for execution.

• A shared object file holds code and data suitable for linking in two
  contexts. First, the link editor may process it with other relocatable and
  shared object files to create another object file. Second, the dynamic
  linker combines it with an executable file and other shared objects
  to create a process image.

So above does not seem to fit in the ET_REL type. We can't relink this
vmlinux? And it does not seem to fit in ET_DYN definition too. We are
not relinking this vmlinux with another executable or other relocatable
files.

I remember once you mentioned the term dynamic executable which can be
loaded at a non-compiled address and let run without requiring any
relocation processing. This vmlinux will fall in that category but can't 
relate it to standard elf file definitions.

Thanks
Vivek
