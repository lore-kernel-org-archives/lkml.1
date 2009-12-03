Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbZLCEG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbZLCEG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 23:06:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbZLCEG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 23:06:57 -0500
Received: from mail-qy0-f192.google.com ([209.85.221.192]:39039 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbZLCEG4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 23:06:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FdAepW8n5FcZ6Mi1vld4PrcGLEmhtsddWLarSpsbr/jjgJ+aGUawV9ZTK/QVsvv/XR
         dfvpb+P79KXqCERKpP85LvALQ3GiYVv/khTevwu7jLmp2J3z+VFzrJDumDfn7M0oPQFI
         WKFGuafPY+khHvM9vyrNyBPUo7VqqGvZhvGW4=
MIME-Version: 1.0
In-Reply-To: <1259812252-22041-1-git-send-email-vapier@gentoo.org>
References: <1259812252-22041-1-git-send-email-vapier@gentoo.org>
Date: Thu, 3 Dec 2009 12:07:02 +0800
Message-ID: <2375c9f90912022007q2e123ca6gdf95f7aa8f6695a@mail.gmail.com>
Subject: Re: [PATCH] modpost: fix segfault in sym_is() with prefixed arches
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 3, 2009 at 11:50 AM, Mike Frysinger <vapier@gentoo.org> wrote:
> The sym_is() compares a symbol in an attempt to automatically skip symbol
> prefixes.  It does this first by searching the real symbol with the normal
> unprefixed symbol.  But then it uses the length of the original symbol to
> check the end of the substring instead of the length of the symbol it is
> looking for.  On non-prefixed arches, this is effectively the same thing,
> so there is no problem.  On prefixed-arches, since this is exceeds by just
> one byte, a crash is rare and it is usually a NUL byte anyways.  But every
> once in a blue moon, you get the right page alignment and it segfaults.
>
> For example, on the Blackfin arch, sym_is() will be called with the real
> symbol "___mod_usb_device_table" as "symbol" when looking for the normal
> symbol "__mod_usb_device_table" as "name".  The substring will thus return
> one byte into "symbol" and store it into "match".  But then "match" will
> be indexed with the length of "symbol" instead of "name" and so we will
> exceed the storage.  i.e. the code ends up doing:
>        char foo[] = "abc"; return foo[strlen(foo)+1] == '\0';
>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  scripts/mod/file2alias.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
> index 40e0045..1ffd1e4 100644
> --- a/scripts/mod/file2alias.c
> +++ b/scripts/mod/file2alias.c
> @@ -726,7 +726,7 @@ static inline int sym_is(const char *symbol, const char *name)
>        match = strstr(symbol, name);
>        if (!match)
>                return 0;
> -       return match[strlen(symbol)] == '\0';
> +       return match[strlen(name)] == '\0';
>  }
>
>  static void do_table(void *symval, unsigned long size,

Nice catch!

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
