Return-Path: <linux-kernel-owner+w=401wt.eu-S1763732AbXJOGul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763732AbXJOGul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 02:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764420AbXJOGub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 02:50:31 -0400
Received: from brick.kernel.dk ([87.55.233.238]:14936 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754657AbXJOGua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 02:50:30 -0400
Date: Mon, 15 Oct 2007 08:50:22 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Milan Broz <mbroz@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>,
       dm-devel@redhat.com, neilb@suse.de
Subject: Re: 2.6.23-mm1
Message-ID: <20071015065022.GC5380@kernel.dk>
References: <64bb37e0710130740u78613f83wbd4f43d073bbe13d@mail.gmail.com> <64bb37e0710130813le68c48dve36f8473b197b84b@mail.gmail.com> <47110500.8050503@garzik.org> <64bb37e0710131105m7c64fca0kb71f3955170e8bec@mail.gmail.com> <20071013111853.7e67c6c3.akpm@linux-foundation.org> <64bb37e0710140454s61325fdfya43179b14ea26dc4@mail.gmail.com> <20071014113914.7654759d.akpm@linux-foundation.org> <64bb37e0710141212k58c5fc66s620d1f28e80bb40@mail.gmail.com> <20071014122613.5bbe4fc3.akpm@linux-foundation.org> <4712922F.6010005@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4712922F.6010005@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15 2007, Milan Broz wrote:
> Andrew Morton wrote:
> > On Sun, 14 Oct 2007 21:12:08 +0200 "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:
> ...
> >> 354036 Page allocated via order 0, mask 0x11202
> >>             1 (PFN/Block always differ) PFN 3072 Block 6 type 0          Flags
> >> 354338 [0xffffffff80266373] mempool_alloc+83
> >> 354338 [0xffffffff80266373] mempool_alloc+83
> >> 354025 [0xffffffff802bb389] bio_alloc_bioset+185
> >> 354058 [0xffffffff804d2b40] kcryptd_do_crypt+0
> >> 354052 [0xffffffff804d2cc7] kcryptd_do_crypt+391
> >> 354058 [0xffffffff804d2b40] kcryptd_do_crypt+0
> >> 354052 [0xffffffff80245d3c] run_workqueue+204
> >> 354062 [0xffffffff802467b0] worker_thread+0
> >>
> >> I'm using dm-crypt with CONFIG_CRYPTO_TWOFISH_X86_64
> >>
> >>> The other info shows a tremendous memory leak, not via slab.  Looks like
> >>> someone is running alloc_pages() directly and isnb't giving them back.
> >> Blaming it on dm-crypt looks right, as the leak seems to happens, if
> >> there is (heavy) disk activity.
> >> (updatedb just ate ~500 Mb)
> >>
> > 
> > Yup, it does appear that dm-crypt is leaking.  Let's add some cc's.
> 
> More precisely - change below from git-block.patch update
> caused that pages are not deallocated at all.
> (cc-ing Jens)
> 
> -static int crypt_endio(struct bio *clone, unsigned int done, int error)
> +static void crypt_endio(struct bio *clone, int error)
> ...
> -	 * free the processed pages, even if
> -	 * it's only a partially completed write
> +	 * free the processed pages
>  	 */
> -	if (!read_io)
> -		crypt_free_buffer_pages(cc, clone, done);
> -
> -	/* keep going - not finished yet */
> -	if (unlikely(clone->bi_size))
> -		return 1;
> -
> -	if (!read_io)
> +	if (!read_io) {
> +		crypt_free_buffer_pages(cc, clone, clone->bi_size);
>  		goto out;
> +	}
> 
> clone->bi_size is zero here now, so crypt_free_buffer_pages will not
> work correctly (previously there was count of processed bytes).
> 
> But because it seems that bio cannot be processed partially now, we can
> simplify crypt_free_buffer_pages to always remove all allocated pages.

Neil, this doesn't look very good. dm-crypt needs to know the clone io
size, so ->bi_size was definitely used properly in this context before.
Now it's gone. Suggestions on how to fix that up?

I've been less than impressed with the bi_end_io() patchset so far, it's
been full of typos and bad conversions. I'm tempted to revert the whole
thing, clearly it wasn't ready for merge.

-- 
Jens Axboe

