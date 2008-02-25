Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbYBYSwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbYBYSwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 13:52:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755193AbYBYSv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 13:51:58 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48969 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755145AbYBYSv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 13:51:57 -0500
Date: Mon, 25 Feb 2008 10:50:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Antonino Daplas <adaplas@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] fbcon: replace mono_col macro with static inline
Message-Id: <20080225105020.131f3df9.akpm@linux-foundation.org>
In-Reply-To: <1203963237.5582.4.camel@brick>
References: <1203963237.5582.4.camel@brick>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008 10:13:57 -0800 Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Use __u32 for max_len to match the declaration of length in the
> struct fb_bitfield.
> 
> Suppresses sparse shadowed variable warnings from the nested max()
> macros:
> drivers/video/console/fbcon.h:130:8: warning: symbol '_x' shadows an earlier one
> drivers/video/console/fbcon.h:130:8: originally declared here
> drivers/video/console/fbcon.h:130:8: warning: symbol '_x' shadows an earlier one
> drivers/video/console/fbcon.h:130:8: originally declared here
> drivers/video/console/fbcon.h:130:8: warning: symbol '_y' shadows an earlier one
> drivers/video/console/fbcon.h:130:8: originally declared here
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  drivers/video/console/fbcon.h |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/video/console/fbcon.h b/drivers/video/console/fbcon.h
> index 3706307..51a6bf4 100644
> --- a/drivers/video/console/fbcon.h
> +++ b/drivers/video/console/fbcon.h
> @@ -104,10 +104,14 @@ struct fbcon_ops {
>  #define attr_blink(s) \
>  	((s) & 0x8000)
>  	
> -#define mono_col(info)							\
> -	(~(0xfff << (max((info)->var.green.length,			\
> -			 max((info)->var.red.length,			\
> -			     (info)->var.blue.length)))) & 0xff)
> +
> +static inline int mono_col(struct fb_info *info)
> +{
> +	__u32 max_len;
> +	max_len = max(info->var.green.length, info->var.red.length);
> +	max_len = max(info->var.blue.length, max_len);
> +	return ~(0xfff << (max_len & 0xff));
> +}
>  
>  static inline int attr_col_ec(int shift, struct vc_data *vc,
>  			      struct fb_info *info, int is_fg)

Thanks, but please do try to copy a suitable mailing list on the patches. 
Particularly fbdev - Tony has been out of contact for a while, but there
are other fbdev developers who can help us to review code, as long as we
tell them about it.

