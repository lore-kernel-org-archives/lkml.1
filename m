Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbYH1SKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbYH1SKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbYH1SKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:10:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:44845 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbYH1SKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:10:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Sl5NpjrLt6KsUIjHoJrC4ASCjk2ON1kD66m7IiaqWNCiDY5wy+ZzUQEujkAd8lKMdY
         8uIMECfCqFpIT84l7OJHzWHQef2+B+yBY2Goj4atIFKGY0U+VmATcvX0ORXcbBX+csBV
         SUKHLe4D5oukXOhdq6NiDqwFM1bqshPxXTs2E=
Message-ID: <a4e6962a0808281110s6ee6c86ak3ff6e28c51981656@mail.gmail.com>
Date: Thu, 28 Aug 2008 11:10:21 -0700
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Abhishek Kulkarni" <kulkarni@lanl.gov>
Subject: Re: [PATCH] 9p bug fix: return non-zero error value in p9_put_data
Cc: v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1219771831.16125.12.camel@blender>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219771831.16125.12.camel@blender>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 10:30 AM, Abhishek Kulkarni <kulkarni@lanl.gov> wrote:
> p9_put_data is called by p9_create_twrite which expects it to return a
> non-zero value on error. This was the reason why every p9_client_write
> was failing. This patch also adds a check for buffer overflow in
> p9_put_data.
>

I'm a bit confused about when this is even getting called -- O thought
all writes were following the p9_client_uwrite path?

Also, we do the bufoverflow check in p9_create_write -- so with your
patch aren't we doing this twice?

           -eric


> Signed-off-by: Abhishek Kulkarni <kulkarni@lanl.gov>
> ---
>  net/9p/conv.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> diff --git a/net/9p/conv.c b/net/9p/conv.c
> index 4454720..7f6db15 100644
> --- a/net/9p/conv.c
> +++ b/net/9p/conv.c
> @@ -451,8 +451,11 @@ p9_put_data(struct cbuf *bufp, const char *data,
> int count,
>                   unsigned char **pdata)
>  {
>        *pdata = buf_alloc(bufp, count);
> +       if (buf_check_overflow(bufp))
> +               return -EIO;
> +
>        memmove(*pdata, data, count);
> -       return count;
> +       return 0;
>  }
>
>  static int
>
>
> Thanks,
>  -- Abhishek
>
>
