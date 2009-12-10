Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686AbZLJGwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbZLJGwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 01:52:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbZLJGwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 01:52:32 -0500
Received: from mail-qy0-f202.google.com ([209.85.221.202]:50209 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbZLJGwc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 01:52:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VkkY6UBaerfKWFbcAIhkzhHtZZn46fE5cCOREdXKstUlLYtwIiPIw1RC5dXvRR9kxS
         EUn/tbtesV3ItwKYoYMnJf+ji7H32n7+++lf8JSuTXQVQeZSPztyU5Zu/mwyvScNSQDd
         TxT5RjhR2Ktfs+3bIbU/Zd6VuDXOkjpflwncU=
MIME-Version: 1.0
In-Reply-To: <1260407779-12517-1-git-send-email-vapier@gentoo.org>
References: <20091209155903.GB3247@hack>
	 <1260407779-12517-1-git-send-email-vapier@gentoo.org>
Date: Thu, 10 Dec 2009 14:52:38 +0800
Message-ID: <2375c9f90912092252g7a6fda99vc45b0dc2aff13030@mail.gmail.com>
Subject: Re: [PATCH v2] modpost: fix asprintf warnings
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 9:16 AM, Mike Frysinger <vapier@gentoo.org> wrote:
> On compilers with security warnings enabled by default, we get:
>
> scripts/mod/modpost.c: In function 'get_markers':
> scripts/mod/modpost.c:1562: warning: ignoring return value of 'asprintf',
>                                     declared with attribute warn_unused_result
> scripts/mod/modpost.c: In function 'add_marker':
> scripts/mod/modpost.c:1982: warning: ignoring return value of 'asprintf',
>                                     declared with attribute warn_unused_result
>
> So check the return value and abort on errors.
>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>


Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

> ---
> v2
>        - add missing newline pointed out by Américo Wang
>
>  scripts/mod/modpost.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index 801a16a..6608ebd 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -1559,7 +1559,8 @@ static void get_markers(struct elf_info *info, struct module *mod)
>                        const char *name = strings + sym->st_value;
>                        const char *fmt = strchr(name, '\0') + 1;
>                        char *line = NULL;
> -                       asprintf(&line, "%s\t%s\t%s\n", name, mod->name, fmt);
> +                       if (asprintf(&line, "%s\t%s\t%s\n", name, mod->name, fmt) == -1)
> +                               fatal("asprintf() with %s failed\n", name);
>                        NOFAIL(line);
>                        mod->markers[n++] = line;
>                }
> @@ -1979,7 +1980,8 @@ static void write_dump(const char *fname)
>  static void add_marker(struct module *mod, const char *name, const char *fmt)
>  {
>        char *line = NULL;
> -       asprintf(&line, "%s\t%s\t%s\n", name, mod->name, fmt);
> +       if (asprintf(&line, "%s\t%s\t%s\n", name, mod->name, fmt) == -1)
> +               fatal("asprintf() with %s failed\n", name);
>        NOFAIL(line);
>
>        mod->markers = NOFAIL(realloc(mod->markers, ((mod->nmarkers + 1) *
