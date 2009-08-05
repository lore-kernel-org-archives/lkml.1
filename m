Return-Path: <linux-kernel-owner+w=401wt.eu-S933638AbZHEHNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933638AbZHEHNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 03:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933520AbZHEHNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 03:13:33 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:63647 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933506AbZHEHNc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 03:13:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cyS/eNShpaFz+wgHZ69os8EvnvW3hZxORk0jfO0Cn+lNs/FZX+jbMeDfSJt4IddTZ1
         ipxQe7258PXGuNL2GQHzH8KRwGyokP0XeCHRf73rLL1+ufpTOW62GBKinYf2B5revdHK
         jcQnsE77OWCcuvsZ95ecD66eLousfs2EmMxxE=
MIME-Version: 1.0
Date: Wed, 5 Aug 2009 17:13:33 +1000
Message-ID: <21d7e9970908050013m71ce7500x1d04a591de21ca30@mail.gmail.com>
Subject: Please revert fc4c73554c9d93b3e495f2f7acae1323b0d5db84. Re: [PATCH 
	1/2] ftrace: Fix the conditional that updates $ref_func
From: Dave Airlie <airlied@gmail.com>
To: Matt Fleming <matt@console-pimps.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Dave Jones <davej@codemonkey.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 2:16 AM, Matt Fleming<matt@console-pimps.org> wrote:
> Fix the conditional that checks if we already have a $ref_func and that
> the new function is weak. The code as previously checking whether either
> condition was false, and we really need to only update $ref_func is both
> cconditions are false.
>

This breaks the powerpc build on Fedora.

When building on ppc64 this commit causes the links of drivers/hwmon/lm93.o
to fail.

It introduces an undefined symbol
                 U .LM93_IN_FROM_REG

that isn't produced when this patch is reverted

This was found when the Fedora kernel failed to build when I pulled in
-rc5-git3.

can be seen at the end of:
http://koji.fedoraproject.org/koji/getfile?taskID=1582002&name=build.log

So can we revert this (at this stage in -rc5 or maybe fix it).

Dave.

> Signed-off-by: Matt Fleming <matt@console-pimps.org>
> ---
>  scripts/recordmcount.pl |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index 7109e2b..16c5563 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -414,7 +414,7 @@ while (<IN>) {
>            $read_function = 0;
>        } else {
>            # if we already have a function, and this is weak, skip it
> -           if (!defined($ref_func) || !defined($weak{$text})) {
> +           if (!defined($ref_func) && !defined($weak{$text})) {
>                $ref_func = $text;
>            }
>        }
> --
> 1.6.4.rc0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
