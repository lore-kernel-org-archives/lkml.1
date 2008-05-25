Return-Path: <linux-kernel-owner+w=401wt.eu-S1755200AbYEYEyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbYEYEyS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 00:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYEYEyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 00:54:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:7524 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbYEYEyC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 00:54:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uSGAKr1EQNaaXjHdR45F0P1UiVfpr5q1rULcOQJAClmFlcKF7mNtGEOAx8gE7jlSEMGKwJA1Zee/Fp9FzhCFDTzrvEjdgon5DxGI/d2DW+3cq8k5Z1aafW/xDY9Gxn1My+D7OykoY5MfWOPkJliQRjhsTqs+f9bgs3g3zbSjCzA=
Message-ID: <86802c440805242154k74e4c63dl9617b6e1b907b300@mail.gmail.com>
Date: Sat, 24 May 2008 21:54:01 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "=?ISO-8859-1?Q?Kristian_H=F8gsberg?=" <krh@redhat.com>
Subject: Re: [PATCH 2/2 v2] Only print "Decompressing Linux" etc when 'debug' is passed.
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1211687267-12962-1-git-send-email-krh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1211687267-12962-1-git-send-email-krh@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 8:47 PM, Kristian Høgsberg <krh@redhat.com> wrote:
> Signed-off-by: Kristian Høgsberg <krh@redhat.com>
> ---
>
> Updated to use the standard 'debug' parameter instead of 'noisy'.
>
>  arch/x86/boot/compressed/misc.c |   30 +++++++++++++++++++++++++++---
>  1 files changed, 27 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
> index 0d03579..017df26 100644
> --- a/arch/x86/boot/compressed/misc.c
> +++ b/arch/x86/boot/compressed/misc.c
> @@ -190,6 +190,7 @@ static void gzip_release(void **);
>  */
>  static struct boot_params *real_mode;          /* Pointer to real-mode data */
>  static struct screen_info *rm_screen_info;     /* Pointer to real-mode data */
> +static int debug;
>
>  extern unsigned char input_data[];
>  extern int input_len;
> @@ -391,7 +392,8 @@ static void parse_elf(void *output)
>                return;
>        }
>
> -       putstr("Parsing ELF... ");
> +       if (debug)
> +               putstr("Parsing ELF... ");
>
>        phdrs = malloc(sizeof(*phdrs) * ehdr.e_phnum);
>        if (!phdrs)
> @@ -419,11 +421,27 @@ static void parse_elf(void *output)
>        }
>  }
>
> +static const char *strnstr(const char *string, int len, const char *s)
> +{
> +       int i, j;
> +
> +       for (i = 0; i < len; i++) {
> +               for (j = 0; i + j < len && s[j]; j++)
> +                       if (string[i + j] != s[j])
> +                               break;
> +               if (s[j] == '\0')
> +                       return string + i;
> +       }
> +
> +       return NULL;
> +}
>  asmlinkage void decompress_kernel(void *rmode, memptr heap,
>                                  unsigned char *input_data,
>                                  unsigned long input_len,
>                                  unsigned char *output)
>  {
> +       char *cmdline;
> +
>        real_mode = rmode;
>
>        if (rm_screen_info->orig_video_mode == 7) {
> @@ -437,6 +455,10 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
>        lines = rm_screen_info->orig_video_lines;
>        cols = rm_screen_info->orig_video_cols;
>
> +       cmdline = (char *) real_mode->hdr.cmd_line_ptr;
> +       if (strnstr(cmdline, real_mode->hdr.cmdline_size, "debug"))
> +               debug = 1;
> +
>        window = output;                /* Output buffer (Normally at 1M) */
>        free_mem_ptr     = heap;        /* Heap */
>        free_mem_end_ptr = heap + BOOT_HEAP_SIZE;
> @@ -461,9 +483,11 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
>  #endif
>
>        makecrc();
> -       putstr("\nDecompressing Linux... ");
> +       if (debug)
> +               putstr("\nDecompressing Linux... ");
>        gunzip();
>        parse_elf(output);
> -       putstr("done.\nBooting the kernel.\n");
> +       if (debug)
> +               putstr("done.\nBooting the kernel.\n");
>        return;
>  }
> --

does that printout hurt anything?

YH
