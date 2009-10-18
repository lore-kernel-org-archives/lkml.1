Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbZJRXJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbZJRXJU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 19:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbZJRXJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 19:09:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:13334 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbZJRXJT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 19:09:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=edk3Jp57YP9XjQqY3wvc4N8HuCgk9YaqTwVH96a7B6qcgLDGn7bx3pqWm1lbND7N3L
         4ZEhehQSq1ns9uJ4vm8015UBYy8oX1oPTqbNIxfYfhXZEYPRO0UUvGfjq2NTrjWpcqQm
         P43x6esrLGMPGCfC+VbiMpy/NbplZ1C4pS0JA=
MIME-Version: 1.0
In-Reply-To: <1255906474-25091-2-git-send-email-felipe.contreras@gmail.com>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>
	 <1255906474-25091-2-git-send-email-felipe.contreras@gmail.com>
Date: Mon, 19 Oct 2009 02:09:22 +0300
Message-ID: <94a0d4530910181609u33955cd5tf9e56b7d2ae9a616@mail.gmail.com>
Subject: Re: [PATCH 1/7] usb: trivial cleanups
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org,
       Felipe Contreras <felipe.contreras@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>,
       Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 1:54 AM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> It seems 'min_t' was used before, and looks cleaner, plus white-space
> stuff.
>
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> ---
>  drivers/usb/core/hcd.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> index 34de475..e6d754e 100644
> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c
> @@ -396,8 +396,7 @@ rh_string(int id, struct usb_hcd const *hcd, u8 *data, unsigned len)
>        case 0:
>                /* Array of LANGID codes (0x0409 is MSFT-speak for "en-us") */
>                /* See http://www.usb.org/developers/docs/USB_LANGIDs.pdf */
> -               if (len > 4)
> -                       len = 4;
> +               len = min_t(unsigned, len, sizeof(langids));
>                memcpy(data, langids, len);
>                return len;
>        case 1:

I still have an unfixed warning:
drivers/usb/core/hcd.c: In function ‘rh_string’:
/data/public/src/linux/arch/x86/include/asm/string_32.h:74: warning:
array subscript is above array bounds

Apparently there's a problem with the optimized memcpy for x86 with this code:
static char const langids[4] = {4, USB_DT_STRING, 0x09, 0x04};
len = min_t(unsigned, len, sizeof(langids));
memcpy(data, langids, len);
return len;

gcc 4.4 is trying to optimize the memcpy, but it's not able to realize
that 'len' will always be <= 4 and the memcpy will not exceed langids.
One way to solve this is by replacing len with the min_t expression:
memcpy(data, langids, min_t(unsigned, len, sizeof(langids)));

However, that looks ugly and we need the expression again for the
return. Another way is to remove 'const' from langids.

AFAIK the code is perfectly correct as it is, I think the fact that
gcc 4.4 complains is a bug on gcc side.

Cheers.

-- 
Felipe Contreras
