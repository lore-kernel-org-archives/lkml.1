Return-Path: <linux-kernel-owner+w=401wt.eu-S1762341AbYFLOER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762341AbYFLOER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 10:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760159AbYFLOEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 10:04:05 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:51305 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756977AbYFLOEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 10:04:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rucdKVzl7KGK+qASumFs7o+720eUkY7rn8xI1RjZJrRQSOPRRu9QuhmXXcso2ORUP3
         473ciUtSw9tiD6vHOgMb+Ag+3p4KnzpbzfARU+DV/C4FwcfEGPFjI72NvHxOcg4gACPn
         IecaZC6vOUbGzVQx4TNQ7a3MHkDAZhAlUFHdo=
Message-ID: <25e057c00806120703g27566bd7ie522a7d5d4664d92@mail.gmail.com>
Date: Thu, 12 Jun 2008 16:03:54 +0200
From: "roel kluin" <roel.kluin@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [GIT PULL] one kbuild fix for powerpc
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Kumar Gala" <galak@kernel.crashing.org>,
       "Paul Mackerras" <paulus@samba.org>, linuxppc-dev@ozlabs.org
In-Reply-To: <20080612131650.GA13702@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080612131650.GA13702@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/12 Sam Ravnborg <sam@ravnborg.org>:

> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index 508c589..b763aba 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -467,6 +467,26 @@ static void parse_elf_finish(struct elf_info *info)
>        release_file(info->hdr, info->size);
>  }
>
> +static int ignore_undef_symbol(struct elf_info *info, const char *symname)
> +{
> +       /* ignore __this_module, it will be resolved shortly */
> +       if (strcmp(symname, MODULE_SYMBOL_PREFIX "__this_module") == 0)
> +               return 1;
> +       /* ignore global offset table */
> +       if (strcmp(symname, "_GLOBAL_OFFSET_TABLE_") == 0)
> +               return 1;
> +       if (info->hdr->e_machine == EM_PPC)
> +               /* Special register function linked on all modules during final link of .ko */
> +               if (strncmp(symname, "_restgpr_", sizeof("_restgpr_") - 1) == 0 ||
> +                   strncmp(symname, "_savegpr_", sizeof("_savegpr_") - 1) == 0 ||
> +                   strncmp(symname, "_rest32gpr_", sizeof("_rest32gpr_") - 1) == 0 ||
> +                   strncmp(symname, "_save32gpr_", sizeof("_save32gpr_") - 1) == 0) {
> +                       return 1;
> +       }

Either the indentation is wrong, or you want to move the opening curly
bracket upwards.

> +       /* Do not ignore this symbol */
> +       return 0;
> +}
> +
>  #define CRC_PFX     MODULE_SYMBOL_PREFIX "__crc_"
>  #define KSYMTAB_PFX MODULE_SYMBOL_PREFIX "__ksymtab_"
>
> @@ -493,11 +513,7 @@ static void handle_modversions(struct module *mod, struct elf_info *info,
>                if (ELF_ST_BIND(sym->st_info) != STB_GLOBAL &&
>                    ELF_ST_BIND(sym->st_info) != STB_WEAK)
>                        break;
> -               /* ignore global offset table */
> -               if (strcmp(symname, "_GLOBAL_OFFSET_TABLE_") == 0)
> -                       break;
> -               /* ignore __this_module, it will be resolved shortly */
> -               if (strcmp(symname, MODULE_SYMBOL_PREFIX "__this_module") == 0)
> +               if (ignore_undef_symbol(info, symname))
>                        break;
>  /* cope with newer glibc (2.3.4 or higher) STT_ definition in elf.h */
>  #if defined(STT_REGISTER) || defined(STT_SPARC_REGISTER)
