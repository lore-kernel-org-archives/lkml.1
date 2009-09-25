Return-Path: <linux-kernel-owner+w=401wt.eu-S1752449AbZIYHCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbZIYHCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 03:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbZIYHCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 03:02:32 -0400
Received: from mail-qy0-f174.google.com ([209.85.221.174]:39906 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbZIYHCc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 03:02:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=t4/Kbz67hTKnG+R9/3SfNu9NXd8tGcZTzszKvZ4ayweM84fjl7fF7bRNAxzaJzvwLK
         4OQKjmEPM2A5iKkTW9Sj0xHJprO1bmAQV7KVPXPv+580bkFu8r8bxdA21SwpfZFMv6/X
         jCLD3qyzq68Pm8cRCLeJOM9PImb16tvjPyPU0=
MIME-Version: 1.0
In-Reply-To: <20090925062734.GA9318@c.hsd1.tn.comcast.net>
References: <20090925062734.GA9318@c.hsd1.tn.comcast.net>
Date: Fri, 25 Sep 2009 15:02:35 +0800
Message-ID: <2375c9f90909250002o59d5d375i8a670494db02287a@mail.gmail.com>
Subject: Re: [PATCH] fix %*s%n in sscanf
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Andy Spencer <andy753421@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 2:27 PM, Andy Spencer <andy753421@gmail.com> wrote:
> When using %*s, sscanf should honor conversion specifiers immediately following
> the %*s. For example, the following code should find the position of the end of
> the string "hello".
>
>  int end;
>  char buf[] = "hello    world";
>  sscanf(buf, "%*s%n", &end);
>  printf("%d\n", end);
>
> Ideally, sscanf would advance the fmt and str pointers the same as it would
> without the *, but the code for that is rather complicated and is not included
> in the patch.


Yeah, seems reasonable. So, without your patch, sscanf() in kernel
will ignore everything after '*', right?


>
> Please CC me in replies.
>
>
> Signed-off-by: Andy Spencer <andy753421@gmail.com>


Fortunately, a quick grep shows no one uses '%*' in sscanf()
in kernel space:

% grep 'sscanf(.*\".*%\*.*\".*)' -nr ./

For completeness,

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

>
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 73a14b8..da2daf2 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -1766,7 +1766,7 @@ int vsscanf(const char * buf, const char * fmt, va_list args)
>                 * advance both strings to next white space
>                 */
>                if (*fmt == '*') {
> -                       while (!isspace(*fmt) && *fmt)
> +                       while (!isspace(*fmt) && *fmt != '%' && *fmt)
>                                fmt++;
>                        while (!isspace(*str) && *str)
>                                str++;
>
