Return-Path: <linux-kernel-owner+w=401wt.eu-S933578AbZINXRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933578AbZINXRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 19:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757468AbZINXRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 19:17:53 -0400
Received: from mail-ew0-f217.google.com ([209.85.219.217]:56910 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870AbZINXRw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 19:17:52 -0400
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Sep 2009 19:17:52 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZBmqCxSiPicYLhIaFsswaVjR33P9uv20ScsVFNaPn3BqQNvWV4byfhXE5FE2ZplSTj
         FpdCS7taLpznpPB23/vYukYfVz/qzJLnfzz7MFYF/1taHiJSCxTTa5i6zUJ69OJsEIbo
         31QPrc334fFX+CB9vB0jFxx7J1wIVgrs6/9pQ=
MIME-Version: 1.0
In-Reply-To: <1252965340-31735-11-git-send-email-ddaney@caviumnetworks.com>
References: <4AAEBAC2.1050905@caviumnetworks.com>
	 <1252965340-31735-11-git-send-email-ddaney@caviumnetworks.com>
Date: Mon, 14 Sep 2009 19:12:45 -0400
Message-ID: <73c1f2160909141612i32f46361q7430cecf0b68d07b@mail.gmail.com>
Subject: Re: [PATCH 11/11] Use unreachable() in asm-generic/bug.h for 
	!CONFIG_BUG case.
From: Brian Gerst <brgerst@gmail.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 5:55 PM, David Daney <ddaney@caviumnetworks.com> wrote:
> The subject says it all (most).  The only drawback here is that for a
> pre-GCC-5.4 compiler, instead of expanding to nothing we now expand
> BUG() to an endless loop.  Before the patch when configured with
> !CONFIG_BUG() you might get some warnings, but the code would be
> small.  After the patch there are no warnings, but there is an endless
> loop at each BUG() site.
>
> Of course for the GCC-4.5 case we get the best of both worlds.
>
> Signed-off-by: David Daney <ddaney@caviumnetworks.com>
> Suggested-by: Ingo Molnar <mingo@elte.hu>
> CC: Ingo Molnar <mingo@elte.hu>
> ---
>  include/asm-generic/bug.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
> index 4b67559..e952242 100644
> --- a/include/asm-generic/bug.h
> +++ b/include/asm-generic/bug.h
> @@ -89,11 +89,11 @@ extern void warn_slowpath_null(const char *file, const int line);
>
>  #else /* !CONFIG_BUG */
>  #ifndef HAVE_ARCH_BUG
> -#define BUG() do {} while(0)
> +#define BUG() unreachable()
>  #endif
>
>  #ifndef HAVE_ARCH_BUG_ON
> -#define BUG_ON(condition) do { if (condition) ; } while(0)
> +#define BUG_ON(condition) do { if (condition) unreachable(); } while (0)
>  #endif
>
>  #ifndef HAVE_ARCH_WARN_ON
> --

This seems wrong to me.  Wouldn't you always want to do the endless
loop?  In the absence of an arch-specific method to jump to an
exception handler, it isn't really unreachable.  On gcc 4.5 this would
essentially become a no-op.

--
Brian Gerst
