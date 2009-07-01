Return-Path: <linux-kernel-owner+w=401wt.eu-S1752344AbZGAXyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbZGAXyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 19:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbZGAXyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 19:54:40 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:58045 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750969AbZGAXyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 19:54:39 -0400
Date: Thu, 2 Jul 2009 09:54:39 +1000
From: David McCullough <David_Mccullough@securecomputing.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       David Howells <dhowells@redhat.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>, uclinux-dev@uclinux.org
Subject: Re: [PATCH] FLAT: use IS_ERR_VALUE() helper macro
Message-ID: <20090701235439.GC16727@securecomputing.com>
References: <1246472802-15824-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246472802-15824-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jivin Mike Frysinger lays it down ...
> There is a common macro now for testing mixed pointer/errno values, so use
> that rather than handling the casts ourself.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Acked-by: David McCullough <david_mccullough@securecomputing.com>

Cheers,
Davidm

> ---
>  fs/binfmt_flat.c |   22 ++++++++++------------
>  1 files changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
> index 697f6b5..f22b312 100644
> --- a/fs/binfmt_flat.c
> +++ b/fs/binfmt_flat.c
> @@ -278,8 +278,6 @@ static int decompress_exec(
>  		ret = bprm->file->f_op->read(bprm->file, buf, LBUFSIZE, &fpos);
>  		if (ret <= 0)
>  			break;
> -		if (ret >= (unsigned long) -4096)
> -			break;
>  		len -= ret;
>  
>  		strm.next_in = buf;
> @@ -335,7 +333,7 @@ calc_reloc(unsigned long r, struct lib_info *p, int curid, int internalp)
>  					"(%d != %d)", (unsigned) r, curid, id);
>  			goto failed;
>  		} else if ( ! p->lib_list[id].loaded &&
> -				load_flat_shared_library(id, p) > (unsigned long) -4096) {
> +				IS_ERR_VALUE(load_flat_shared_library(id, p))) {
>  			printk("BINFMT_FLAT: failed to load library %d", id);
>  			goto failed;
>  		}
> @@ -545,7 +543,7 @@ static int load_flat_file(struct linux_binprm * bprm,
>  		textpos = do_mmap(bprm->file, 0, text_len, PROT_READ|PROT_EXEC,
>  				  MAP_PRIVATE|MAP_EXECUTABLE, 0);
>  		up_write(&current->mm->mmap_sem);
> -		if (!textpos  || textpos >= (unsigned long) -4096) {
> +		if (!textpos || IS_ERR_VALUE(textpos)) {
>  			if (!textpos)
>  				textpos = (unsigned long) -ENOMEM;
>  			printk("Unable to mmap process text, errno %d\n", (int)-textpos);
> @@ -560,7 +558,7 @@ static int load_flat_file(struct linux_binprm * bprm,
>  			PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE, 0);
>  		up_write(&current->mm->mmap_sem);
>  
> -		if (realdatastart == 0 || realdatastart >= (unsigned long)-4096) {
> +		if (realdatastart == 0 || IS_ERR_VALUE(realdatastart)) {
>  			if (!realdatastart)
>  				realdatastart = (unsigned long) -ENOMEM;
>  			printk("Unable to allocate RAM for process data, errno %d\n",
> @@ -587,7 +585,7 @@ static int load_flat_file(struct linux_binprm * bprm,
>  			result = bprm->file->f_op->read(bprm->file, (char *) datapos,
>  					data_len + (relocs * sizeof(unsigned long)), &fpos);
>  		}
> -		if (result >= (unsigned long)-4096) {
> +		if (IS_ERR_VALUE(result)) {
>  			printk("Unable to read data+bss, errno %d\n", (int)-result);
>  			do_munmap(current->mm, textpos, text_len);
>  			do_munmap(current->mm, realdatastart, data_len + extra);
> @@ -607,7 +605,7 @@ static int load_flat_file(struct linux_binprm * bprm,
>  			PROT_READ | PROT_EXEC | PROT_WRITE, MAP_PRIVATE, 0);
>  		up_write(&current->mm->mmap_sem);
>  
> -		if (!textpos  || textpos >= (unsigned long) -4096) {
> +		if (!textpos || IS_ERR_VALUE(textpos)) {
>  			if (!textpos)
>  				textpos = (unsigned long) -ENOMEM;
>  			printk("Unable to allocate RAM for process text/data, errno %d\n",
> @@ -641,7 +639,7 @@ static int load_flat_file(struct linux_binprm * bprm,
>  			fpos = 0;
>  			result = bprm->file->f_op->read(bprm->file,
>  					(char *) textpos, text_len, &fpos);
> -			if (result < (unsigned long) -4096)
> +			if (!IS_ERR_VALUE(result))
>  				result = decompress_exec(bprm, text_len, (char *) datapos,
>  						 data_len + (relocs * sizeof(unsigned long)), 0);
>  		}
> @@ -651,13 +649,13 @@ static int load_flat_file(struct linux_binprm * bprm,
>  			fpos = 0;
>  			result = bprm->file->f_op->read(bprm->file,
>  					(char *) textpos, text_len, &fpos);
> -			if (result < (unsigned long) -4096) {
> +			if (!IS_ERR_VALUE(result)) {
>  				fpos = ntohl(hdr->data_start);
>  				result = bprm->file->f_op->read(bprm->file, (char *) datapos,
>  					data_len + (relocs * sizeof(unsigned long)), &fpos);
>  			}
>  		}
> -		if (result >= (unsigned long)-4096) {
> +		if (IS_ERR_VALUE(result)) {
>  			printk("Unable to read code+data+bss, errno %d\n",(int)-result);
>  			do_munmap(current->mm, textpos, text_len + data_len + extra +
>  				MAX_SHARED_LIBS * sizeof(unsigned long));
> @@ -830,7 +828,7 @@ static int load_flat_shared_library(int id, struct lib_info *libs)
>  
>  	res = prepare_binprm(&bprm);
>  
> -	if (res <= (unsigned long)-4096)
> +	if (!IS_ERR_VALUE(res))
>  		res = load_flat_file(&bprm, libs, id, NULL);
>  	if (bprm.file) {
>  		allow_write_access(bprm.file);
> @@ -873,7 +871,7 @@ static int load_flat_binary(struct linux_binprm * bprm, struct pt_regs * regs)
>  	stack_len += FLAT_DATA_ALIGN - 1;  /* reserve for upcoming alignment */
>  	
>  	res = load_flat_file(bprm, &libinfo, 0, &stack_len);
> -	if (res > (unsigned long)-4096)
> +	if (IS_ERR_VALUE(res))
>  		return res;
>  	
>  	/* Update data segment pointers for all libraries */
> -- 
> 1.6.3.3
> 

-- 
David McCullough,  david_mccullough@securecomputing.com,  Ph:+61 734352815
McAfee - SnapGear  http://www.snapgear.com                http://www.uCdot.org
