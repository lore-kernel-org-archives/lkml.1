Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab0BWT5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 14:57:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127Ab0BWT5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 14:57:49 -0500
From: Juan Quintela <quintela@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
       virtualization@lists.osdl.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       markmc@redhat.com, gleb@redhat.com, herbert.xu@redhat.com,
       dlaor@redhat.com, avi@redhat.com
Subject: Re: [PATCH 3/3] vhost: fix get_user_pages_fast error handling
In-Reply-To: <82ba8c97ce55dd4bf9972ad755961cd14e6a0938.1266943453.git.mst@redhat.com>
	(Michael S. Tsirkin's message of "Tue, 23 Feb 2010 18:57:58 +0200")
References: <cover.1266943453.git.mst@redhat.com>
	<82ba8c97ce55dd4bf9972ad755961cd14e6a0938.1266943453.git.mst@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
Date: Tue, 23 Feb 2010 20:56:56 +0100
Message-ID: <m3ocjfsp2v.fsf@trasno.mitica>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> wrote:
> get_user_pages_fast returns number of pages on success, negative value
> on failure, but never 0. Fix vhost code to match this logic.

It can return 0 if you ask for 0 pages :)
>From the comment:

 * Returns number of pages pinned. This may be fewer than the number
 * requested. If nr_pages is 0 or negative, returns 0. If no pages
 * were pinned, returns -errno.
 */

I agree that code was wrong, but the BUG_ON() is not neccessary
IMHO. The important bit is the change in the comparison.

Reviewed-by: Juan Quintela <quintela@redhat.com>


> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/vhost/vhost.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index d4f8fdf..d003504 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -646,8 +646,9 @@ static int set_bit_to_user(int nr, void __user *addr)
>  	int bit = nr + (log % PAGE_SIZE) * 8;
>  	int r;
>  	r = get_user_pages_fast(log, 1, 1, &page);
> -	if (r)
> +	if (r < 0)
>  		return r;
> +	BUG_ON(r != 1);
>  	base = kmap_atomic(page, KM_USER0);
>  	set_bit(bit, base);
>  	kunmap_atomic(base, KM_USER0);
