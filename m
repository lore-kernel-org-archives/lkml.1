Return-Path: <linux-kernel-owner+w=401wt.eu-S1752419AbZDTXT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbZDTXT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 19:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbZDTXTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 19:19:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750922AbZDTXTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 19:19:46 -0400
Date: Mon, 20 Apr 2009 16:07:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: spock@gentoo.org
Cc: krzysztof.h1@poczta.fm, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] fbdev: fix fillrect for 24bpp modes
Message-Id: <20090420160733.07e27238.akpm@linux-foundation.org>
In-Reply-To: <20090418185234.GA17853@tria>
References: <20090413170954.GA8403@tria>
	<20090417183617.ed7553cd.krzysztof.h1@poczta.fm>
	<20090417115048.0c5ca35d.akpm@linux-foundation.org>
	<20090418185234.GA17853@tria>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Apr 2009 20:52:34 +0200
Michal Januszewski <spock@gentoo.org> wrote:

>  		while (height--) {
> -			dst += dst_idx >> (ffs(bits) - 1);
> +			dst += dst_idx / bits;
>  			dst_idx &= (bits - 1);
> -			fill_op(p, dst, dst_idx, pat, left, right,
> +			r = dst_idx % bpp;
> +			/* rotate pattern to the correct start position */
> +#ifdef __LITTLE_ENDIAN
> +			pat2 = pat << r | pat >> (bpp-r);
> +#else
> +			pat2 = pat << (bpp-r) | pat >> r;
> +#endif
> +			fill_op(p, dst, dst_idx, pat2, left, right,
>  				width*bpp, bits);
> -			r = (p->fix.line_length*8) % bpp;
> -			pat = pat << (bpp-r) | pat >> r;
>  			dst_idx += p->fix.line_length*8;

hm, that's fairly eye-popping.

Could we do something like

	pat2 = le32_to_cpu(rol32(cpu_to_le32(pat), r));

(might be wrong, but you see what I mean...)
