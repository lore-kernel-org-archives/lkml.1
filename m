Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbZJTAMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbZJTAMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 20:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758017AbZJTAMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 20:12:52 -0400
Received: from claw.goop.org ([74.207.240.146]:49304 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756060AbZJTAMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 20:12:51 -0400
Message-ID: <4ADD0086.9060304@goop.org>
Date: Tue, 20 Oct 2009 09:12:54 +0900
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: "Ryan C. Gordon" <icculus@icculus.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/2] binfmt_elf: FatELF support for kernel modules.
References: <alpine.DEB.2.00.0910190422090.13303@andre.icculuslan>
In-Reply-To: <alpine.DEB.2.00.0910190422090.13303@andre.icculuslan>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/09 23:41, Ryan C. Gordon wrote:
> Allows kernel modules to be FatELF binaries.
>
> Details, rationale, tools, and patches for handling FatELF binaries can be
> found at http://icculus.org/fatelf/
>
> Please note that this requires an updated depmod and modprobe to be truly
> effective, but an unmodified insmod can work with FatELF binaries.
>   

This seems much more dubious.  It would only encourage more binary
modules, which we're not very keen on doing.

    J

> Signed-off-by: Ryan C. Gordon <icculus@icculus.org>
> ---
>  kernel/module.c |   72 +++++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 files changed, 67 insertions(+), 5 deletions(-)
>
> diff --git a/kernel/module.c b/kernel/module.c
> index 8b7d880..cda8f79 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2066,13 +2066,69 @@ static inline void kmemleak_load_module(struct module *mod, Elf_Ehdr *hdr,
>  }
>  #endif
>  
> +/*
> + * See if we're a valid FatELF binary, find the right record, and
> + *  return the offset of that record within the binary. Returns NULL if there's
> + *  a problem, or a pointer to the real ELF header if we're okay.
> + *  If we don't see the FatELF magic number, we assume this is a regular ELF
> + *  binary and let the regular ELF checks handle it.
> + *
> + * This is a simplified version of examine_fatelf in fs/binfmt_elf.c
> + */
> +static Elf_Ehdr *examine_fatelf_module(const unsigned char *hdr,
> +				       const unsigned long len)
> +{
> +	Elf_Ehdr elf;
> +	int records, i;
> +	const fatelf_hdr *fatelf = (const fatelf_hdr *) hdr;
> +
> +	if (likely(le32_to_cpu(fatelf->magic) != FATELF_MAGIC)) {
> +		return (Elf_Ehdr *) hdr;  /* not FatELF; not an error. */
> +	} else if (unlikely(le16_to_cpu(fatelf->version) != 1)) {
> +		return NULL; /* Unrecognized format version. */
> +	}
> +
> +	memset(&elf, 0, sizeof (elf));
> +
> +	records = (int) fatelf->num_records;  /* uint8, no byteswap needed */
> +	for (i = 0; i < records; i++) {
> +		const fatelf_record *record = &fatelf->records[i];
> +
> +		/* Fill in the data elf_check_arch() might care about. */
> +		elf.e_ident[EI_OSABI] = record->osabi;
> +		elf.e_ident[EI_CLASS] = record->word_size;
> +		elf.e_ident[EI_DATA] = record->byte_order;
> +		elf.e_machine = le16_to_cpu(record->machine);
> +
> +		if (likely(!elf_check_arch(&elf))) {
> +			continue;  /* Unsupported CPU architecture. */
> +		} else {
> +			const __u64 rec_offset = le64_to_cpu(record->offset);
> +			const __u64 rec_size = le64_to_cpu(record->size);
> +			const __u64 end_offset = rec_offset + rec_size;
> +			const unsigned long uloff = (unsigned long) rec_offset;
> +
> +			if (unlikely(end_offset < rec_offset)) {
> +				continue;  /* overflow (corrupt file?)... */
> +			} else if (unlikely(end_offset > len)) {
> +				continue;  /* past EOF. */
> +			}
> +
> +			return (Elf_Ehdr *) (hdr + uloff);
> +		}
> +	}
> +
> +	return NULL;  /* no binaries we could use. */
> +}
> +
>  /* Allocate and load the module: note that size of section 0 is always
>     zero, and we rely on this for optional sections. */
>  static noinline struct module *load_module(void __user *umod,
>  				  unsigned long len,
>  				  const char __user *uargs)
>  {
> -	Elf_Ehdr *hdr;
> +	Elf_Ehdr *hdr_alloc;  /* returned from vmalloc */
> +	Elf_Ehdr *hdr;  /* adjusted hdr_alloc for FatELF */
>  	Elf_Shdr *sechdrs;
>  	char *secstrings, *args, *modmagic, *strtab = NULL;
>  	char *staging;
> @@ -2094,14 +2150,20 @@ static noinline struct module *load_module(void __user *umod,
>  
>  	/* Suck in entire file: we'll want most of it. */
>  	/* vmalloc barfs on "unusual" numbers.  Check here */
> -	if (len > 64 * 1024 * 1024 || (hdr = vmalloc(len)) == NULL)
> +	if (len > 64 * 1024 * 1024 || (hdr_alloc = vmalloc(len)) == NULL)
>  		return ERR_PTR(-ENOMEM);
>  
> -	if (copy_from_user(hdr, umod, len) != 0) {
> +	if (copy_from_user(hdr_alloc, umod, len) != 0) {
>  		err = -EFAULT;
>  		goto free_hdr;
>  	}
>  
> +	hdr = examine_fatelf_module((unsigned char *) hdr_alloc, len);
> +	if (hdr == NULL) {
> +		err = -ENOEXEC;
> +		goto free_hdr;
> +	}
> +
>  	/* Sanity checks against insmoding binaries or wrong arch,
>             weird elf version */
>  	if (memcmp(hdr->e_ident, ELFMAG, SELFMAG) != 0
> @@ -2505,7 +2567,7 @@ static noinline struct module *load_module(void __user *umod,
>  	add_notes_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
>  
>  	/* Get rid of temporary copy */
> -	vfree(hdr);
> +	vfree(hdr_alloc);
>  
>  	trace_module_load(mod);
>  
> @@ -2538,7 +2600,7 @@ static noinline struct module *load_module(void __user *umod,
>  	kfree(args);
>  	kfree(strmap);
>   free_hdr:
> -	vfree(hdr);
> +	vfree(hdr_alloc);
>  	return ERR_PTR(err);
>  
>   truncated:
>   

