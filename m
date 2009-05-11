Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbZEKLzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbZEKLzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 07:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758727AbZEKLyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 07:54:41 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57458 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758732AbZEKLyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 07:54:40 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "vgoyal\@redhat.com" <vgoyal@redhat.com>,
       "hbabu\@us.ibm.com" <hbabu@us.ibm.com>,
       "kexec\@lists.infradead.org" <kexec@lists.infradead.org>,
       "Huang\, Ying" <ying.huang@intel.com>, "mingo\@elte.hu" <mingo@elte.hu>,
       "tglx\@linutronix.de" <tglx@linutronix.de>,
       "sam\@ravnborg.org" <sam@ravnborg.org>
Subject: Re: RFC: x86: relocatable kernel changes (revised spec)
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>
	<m14ovwz8ua.fsf@fess.ebiederm.org> <4A03C3BB.3070401@intel.com>
	<m1tz3wgk3n.fsf@fess.ebiederm.org> <4A047E53.8040003@intel.com>
	<4A07B534.8080606@zytor.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 11 May 2009 04:54:29 -0700
In-Reply-To: <4A07B534.8080606@zytor.com> (H. Peter Anvin's message of "Sun\, 10 May 2009 22\:18\:44 -0700")
Message-ID: <m1vdo7hn2i.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: hpa@zytor.com, sam@ravnborg.org, tglx@linutronix.de, mingo@elte.hu, ying.huang@intel.com, kexec@lists.infradead.org, hbabu@us.ibm.com, vgoyal@redhat.com, linux-kernel@vger.kernel.org, hpa@linux.intel.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Revised proposal to address Eric's comments.  This is intended to
> provide full backwards compatibility while at the same time giving us
> the future flexibility.
>
> The intent will be to set by default:
>
> 	kernel_alignment	= 16 MB
> 	min_alignment		= log2(4K) or log2(2M)
> 	pref_address		= 16 MB
>
> The reason to represent min_alignment as a logarithm is that I'm getting
> very concerned about the diminishing space that is left without a
> fundamental change to the initialized part of the header; specifically,
> right now we rely on the signed byte at offset 0x201 to contain the
> (additional) size of the header, which means end at 0x281 without a
> major format change of some sort.

Thanks for concentrating on this.

Here is my first round of comments.


> Comments appreciated.
>
> 	-hpa
>
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
>
> diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
> index e020366..ccc1bd4 100644
> --- a/Documentation/x86/boot.txt
> +++ b/Documentation/x86/boot.txt
> @@ -50,6 +50,11 @@ Protocol 2.08:	(Kernel 2.6.26) Added crc32 checksum and ELF format
>  Protocol 2.09:	(Kernel 2.6.26) Added a field of 64-bit physical
>  		pointer to single linked list of struct	setup_data.
>  
> +Protocol 2.10:	(Kernel 2.6.31?) A protocol for relaxed alignment
> +	 	beyond the kernel_alignment added, new init_size and
> +	 	pref_address fields.
> +	 	
> +
>  **** MEMORY LAYOUT
>  
>  The traditional memory map for the kernel loader, used for Image or
> @@ -173,7 +178,7 @@ Offset	Proto	Name		Meaning
>  022C/4	2.03+	ramdisk_max	Highest legal initrd address
>  0230/4	2.05+	kernel_alignment Physical addr alignment required for kernel
>  0234/1	2.05+	relocatable_kernel Whether kernel is relocatable or not
> -0235/1	N/A	pad2		Unused
> +0235/1	2.10+	min_alignment	Minimum alignment, as a power of 2
>  0236/2	N/A	pad3		Unused
>  0238/4	2.06+	cmdline_size	Maximum size of the kernel command line
>  023C/4	2.07+	hardware_subarch Hardware subarchitecture
> @@ -182,6 +187,8 @@ Offset	Proto	Name		Meaning
>  024C/4	2.08+	payload_length	Length of kernel payload
>  0250/8	2.09+	setup_data	64-bit physical pointer to linked list
>  				of struct setup_data
> +0258/8	2.10+	pref_address	Preferred loading address
> +0260/4	2.10+	init_size	Linear memory required during initialization
>  
>  (1) For backwards compatibility, if the setup_sects field contains 0, the
>      real value is 4.
> @@ -482,11 +489,15 @@ Protocol:	2.03+
>    0x37FFFFFF, you can start your ramdisk at 0x37FE0000.)
>  
>  Field name:	kernel_alignment
> -Type:		read (reloc)
> +Type:		read/modify (reloc)
>  Offset/size:	0x230/4
> -Protocol:	2.05+
> +Protocol:	2.05+ (read), 2.10+ (modify)
>  
> -  Alignment unit required by the kernel (if relocatable_kernel is true.)
> +  Alignment unit required by the kernel (if relocatable_kernel is
> +  true.)  Starting with protocol version 2.10, this reflects the
> +  kernel alignment preferred for optimal performance and can be
> +  modified by the loader; see the min_alignment and pref_address field
> +  below.
>  

Can we say:

   This reflects the kernel alignment preferred for optimal performance.
   
   A relocatable kernel will always run with the alignment specified in
   this field so a relocating bootloader that loads the kernel at a
   lesser alignment must update this field.

>  Field name:	relocatable_kernel
>  Type:		read (reloc)
> @@ -498,6 +509,22 @@ Protocol:	2.05+
>    After loading, the boot loader must set the code32_start field to
>    point to the loaded code, or to a boot loader hook.
>  
> +Field name:	min_alignment
> +Type:		read (reloc)
> +Offset/size:	0x235/1
> +Protocol:	2.10+
> +
> +  This field, if nonzero, indicates as a power of 2 the minimum
> +  alignment required, as opposed to preferred, by the kernel to boot.
> +  If a boot loader makes use of this field, it should update the
> +  kernel_alignment field with the alignment unit desired; typically:
> +
> +	kernel_alignment = 1 << min_alignment
> +
> +  There may be a considerable performance cost with an excessively
> +  misaligned kernel.  Therefore, a loader should typically try each
> +  power-of-two alignment from kernel_alignment down to this alignment.
> +
>  Field name:	cmdline_size
>  Type:		read
>  Offset/size:	0x238/4
> @@ -582,6 +609,27 @@ Protocol:	2.09+
>    sure to consider the case where the linked list already contains
>    entries.
>  
> +Field name:	pref_address
> +Type:		read (reloc)
> +Offset/size:	0x258/8
> +Protocol:	2.10+
> +
> +  This field, if nonzero, represents a preferred load address for the
> +  kernel.  A relocating bootloader should attempt to load at this
> +  address if possible.

We should document that a non-relocating kernel moves itself here.


> +Field name:	init_size
> +Type:		read
> +Offset/size:	0x25c/4
> +
> +  This field indicates the amount of linear contiguous memory starting
> +  at the kernel load address (rounded up to kernel_alignment) that the
> +  kernel needs before it is capable of examining its memory map.  This
> +  is not the same thing as the total amount of memory the kernel needs
> +  to boot, but it can be used by a relocating boot loader to help
> +  select a safe load address for the kernel.

This wording is a bit unclear.

Can we finally say that it is safe to put the initrd immediately after
the kernel?

The rounding up part of that comment is unclear.

...

Peter did your implementation of init_size take into account the maximum expansion
during decompression?  At a quick glance at your previous patches I couldn't
tell.  I know were in that direction with zoffset.h and voffset.h but I don't
recognize the formula for where I put the pic decompressor in your calculation
of this.

Eric
