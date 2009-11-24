Return-Path: <linux-kernel-owner+w=401wt.eu-S1757826AbZKXCqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826AbZKXCqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 21:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757602AbZKXCqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 21:46:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757584AbZKXCqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 21:46:43 -0500
Date: Mon, 23 Nov 2009 18:46:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vt: Don't exceed max_font_size on copy in
 con_font_get()
Message-Id: <20091123184646.ba8aadc8.akpm@linux-foundation.org>
In-Reply-To: <4B0AEF4E.8070005@gmail.com>
References: <4B0AEF4E.8070005@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Nov 2009 21:23:42 +0100 Roel Kluin <roel.kluin@gmail.com> wrote:

> font.data is kmallocd with max_font_size (defined 65536). Below occurs a
> copy_to_user with `c' as a size argument. Ensure we don't copy too much.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  drivers/char/vt.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> If it is possible for c to be greater than 65536 then I think we may need this.
> Correct?
> 
> diff --git a/drivers/char/vt.c b/drivers/char/vt.c
> index 0c80c68..045af83 100644
> --- a/drivers/char/vt.c
> +++ b/drivers/char/vt.c
> @@ -3861,6 +3861,10 @@ static int con_font_get(struct vc_data *vc, struct console_font_op *op)
>  		goto out;
>  
>  	c = (font.width+7)/8 * 32 * font.charcount;
> +	if (c > max_font_size) {
> +		rc = -EINVAL;
> +		goto out;
> +	}
>  
>  	if (op->data && font.charcount > op->charcount)
>  		rc = -ENOSPC;

Perhaps it is impossible for `c' to exceed max_font_size here.  The
check in con_font_set() will prevent it.

There are probably other places in the kernel which initialise a
console_font_op, and perhaps one of those is buggy - I didn't check.

