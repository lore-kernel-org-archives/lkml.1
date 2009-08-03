Return-Path: <linux-kernel-owner+w=401wt.eu-S932196AbZHCUqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196AbZHCUqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 16:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbZHCUqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 16:46:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753368AbZHCUqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 16:46:34 -0400
Date: Mon, 3 Aug 2009 13:46:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Julia Lawall <julia@diku.dk>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 1/5] drivers/video: Add kmalloc NULL tests
Message-Id: <20090803134632.7cff1658.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0907301559530.8734@ask.diku.dk>
References: <Pine.LNX.4.64.0907301559530.8734@ask.diku.dk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jul 2009 16:00:33 +0200 (CEST)
Julia Lawall <julia@diku.dk> wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> Check that the result of kmalloc is not NULL before passing it to other
> functions.
> 
> The semantic match that finds this problem is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @@
> expression *x;
> identifier f;
> constant char *C;
> @@
> 
> x = \(kmalloc\|kcalloc\|kzalloc\)(...);
> ... when != x == NULL
>     when != x != NULL
>     when != (x || ...)
> (
> kfree(x)
> |
> f(...,C,...,x,...)
> |
> *f(...,x,...)
> |
> *x->f
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/video/au1100fb.c            |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/au1100fb.c b/drivers/video/au1100fb.c
> index 378f277..1766846 100644
> --- a/drivers/video/au1100fb.c
> +++ b/drivers/video/au1100fb.c
> @@ -716,6 +716,10 @@ int au1100fb_setup(char *options)
>  			/* Mode option (only option that start with digit) */
>  			else if (isdigit(this_opt[0])) {
>  				mode = kmalloc(strlen(this_opt) + 1, GFP_KERNEL);
> +				if (!mode) {
> +					print_err("memory allocation failed");
> +					return -ENOMEM;
> +				}
>  				strncpy(mode, this_opt, strlen(this_opt) + 1);
>  			}
>  			/* Unsupported option */

We may as well clean up that open-coded kstrdup() too?

--- a/drivers/video/au1100fb.c~drivers-video-add-kmalloc-null-tests-fix
+++ a/drivers/video/au1100fb.c
@@ -715,12 +715,11 @@ int au1100fb_setup(char *options)
 			}
 			/* Mode option (only option that start with digit) */
 			else if (isdigit(this_opt[0])) {
-				mode = kmalloc(strlen(this_opt) + 1, GFP_KERNEL);
+				mode = kstrdup(this_opt, GFP_KERNEL);
 				if (!mode) {
 					print_err("memory allocation failed");
 					return -ENOMEM;
 				}
-				strncpy(mode, this_opt, strlen(this_opt) + 1);
 			}
 			/* Unsupported option */
 			else {
_

