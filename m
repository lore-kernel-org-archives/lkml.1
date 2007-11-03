Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbXKCR2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbXKCR2Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 13:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754834AbXKCR2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 13:28:01 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:19546 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787AbXKCR2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 13:28:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gh+n3rQG63CgaX3IH1YfmA95rvlQkvXXDyl688f/0fOR+TCybLQK5A/r7Ij+keUDDMsmioRsIkxqjpz9+8HP9ciz1VQcMJbkqF7LmggWaywrTs/7wRidWS1zoGsJiTsiidFp61Rc6coa666SxJZ4g6xJ8e2jpHjUJo45FlsAt8o=
Message-ID: <6101e8c40711031027x3f946b28p324dadeab7c1b2c3@mail.gmail.com>
Date: Sat, 3 Nov 2007 18:27:58 +0100
From: "=?ISO-8859-1?Q?Oliv=E9r_Pint=E9r?=" <oliver.pntr@gmail.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: [PATCH 1/2] slub: fix leakage
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <Pine.LNX.4.64.0711031708040.10266@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0711031708040.10266@blonde.wat.veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Q: It's needed auch to 2.6.22-stable?

On 11/3/07, Hugh Dickins <hugh@veritas.com> wrote:
> Slub has been quite leaky under load.  Taking mm_struct as an example, in
> a loop of swapping kernel builds, after the first iteration slabinfo shows:
> Name        Objects Objsize    Space Slabs/Part/Cpu  O/S O %Fr %Ef Flg
> mm_struct        55     840    73.7K         18/7/4    4 0  38  62 A
> but Objects and Partials steadily creep up - after the 340th iteration:
> mm_struct       110     840   188.4K        46/36/4    4 0  78  49 A
>
> The culprit turns out to be __slab_alloc(), where it copes with the race
> that another task has assigned the cpu slab while we were allocating one.
> Don't rush off to load_freelist there: that assumes c->freelist is empty,
> and will lose all of its free slots when c->page->freelist is not empty.
> Instead just do a local allocation from c->freelist when it has one.
>
> Which fixes the leakage: Objects and Partials then remain stable.
>
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
> I recommend this for 2.6.24-rc2 and 2.6.23-stable.
>
>  mm/slub.c |    5 +++++
>  1 file changed, 5 insertions(+)
>
> --- 2.6.24-rc1/mm/slub.c	2007-10-24 07:16:04.000000000 +0100
> +++ linux/mm/slub.c	2007-11-03 13:22:31.000000000 +0000
> @@ -1525,6 +1525,11 @@ new_slab:
>  				 * want the current one since its cache hot
>  				 */
>  				discard_slab(s, new);
> +				if (c->freelist) {
> +					object = c->freelist;
> +					c->freelist = object[c->offset];
> +					return object;
> +				}
>  				slab_lock(c->page);
>  				goto load_freelist;
>  			}
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
