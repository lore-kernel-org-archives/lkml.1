Return-Path: <linux-kernel-owner+w=401wt.eu-S1759849AbYGKWU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759849AbYGKWU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 18:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755642AbYGKWUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 18:20:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751059AbYGKWUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 18:20:21 -0400
Date: Fri, 11 Jul 2008 15:19:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andres Salomon <dilinger@queued.net>
Cc: linux-kernel@vger.kernel.org, Cortland Setlow <csetlow@tower-research.com>,
       corbet@lwn.net, video4linux-list@redhat.com,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH resend] ov7670: clean up ov7670_read semantics
Message-Id: <20080711151919.9cda44ea.akpm@linux-foundation.org>
In-Reply-To: <20080711165216.4dc32c4c@fred>
References: <20080711165216.4dc32c4c@fred>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008 16:52:16 -0400 Andres Salomon <dilinger@queued.net> wrote:

> [note: this should probably go in for 2.6.26, as it fixes a bug in
> ov7670_s_fmt where we incorrectly think that we've failed because we
> return !0]
> 

In which case 2.6.25.x wants the fix as well?

> 
> Cortland Setlow pointed out a bug in ov7670.c where the result from
> ov7670_read() was just being checked for !0, rather than <0.  This
> made me realize that ov7670_read's semantics were rather confusing;
> it both fills in 'value' with the result, and returns it.  This is
> goes against general kernel convention; so rather than fixing callers,
> let's fix the function.
> 
> This makes ov7670_read return <0 in the case of an error, and 0 upon
> success. Thus, code like:
> 
> res = ov7670_read(...);
> if (!res)
> 	goto error;
> 
> ..will work properly.
> 
> Signed-off-by: Cortland Setlow <csetlow@tower-research.com>
> Signed-off-by: Andres Salomon <dilinger@debian.org>
> Acked-by: Jonathan Corbet <corbet@lwn.net>
> ---
>  drivers/media/video/ov7670.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/ov7670.c b/drivers/media/video/ov7670.c
> index 2bc6bdc..d7bfd30 100644
> --- a/drivers/media/video/ov7670.c
> +++ b/drivers/media/video/ov7670.c
> @@ -406,8 +406,10 @@ static int ov7670_read(struct i2c_client *c,
> unsigned char reg, int ret;

You have some wordwrapping happening there.

>  	ret = i2c_smbus_read_byte_data(c, reg);
> -	if (ret >= 0)
> +	if (ret >= 0) {
>  		*value = (unsigned char) ret;
> +		ret = 0;
> +	}
>  	return ret;
>  }
>  
> -- 
> 1.5.5.3
