Return-Path: <linux-kernel-owner+w=401wt.eu-S1759597AbYCCJoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597AbYCCJoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 04:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYCCJoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 04:44:09 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:2352 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbYCCJoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 04:44:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=O9i3tUvuuoa1/4uB3oOBlG4u9gYXQJ2N2oF7unEajaZbLf8jv5GvxqlfBaAdcAFA8BLZmsIqWzUGtlr7Zf4gyNDEuIvGrMGuXnfEMEfTi2RCetuqrxtXKHRLZTkTwxbinME9n0JyEkR9+pA0aTT1cmOeUP2llGsYbA7h/mJxCuU=
Message-ID: <84144f020803030144v17544936ybe222e8f4850dfa2@mail.gmail.com>
Date: Mon, 3 Mar 2008 11:44:07 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Nick Piggin" <npiggin@suse.de>
Subject: Re: [rfc][patch 1/3] slub: fix small HWCACHE_ALIGN alignment
Cc: netdev@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, "David Miller" <davem@davemloft.net>,
       "Christoph Lameter" <clameter@engr.sgi.com>,
       "Eric Dumazet" <dada1@cosmosbay.com>
In-Reply-To: <20080303093449.GA15091@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080303093449.GA15091@wotan.suse.de>
X-Google-Sender-Auth: 68219a03eb70b04c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Mon, Mar 3, 2008 at 11:34 AM, Nick Piggin <npiggin@suse.de> wrote:
>  SLUB should pack even small objects nicely into cachelines if that is what
>  has been asked for. Use the same algorithm as SLAB for this.

The patches look good but this changelog is missing context. Why do we
want to do this?

On Mon, Mar 3, 2008 at 11:34 AM, Nick Piggin <npiggin@suse.de> wrote:
>  @@ -1896,12 +1896,15 @@ static unsigned long calculate_alignment
>          * specified alignment though. If that is greater
>          * then use it.
>          */

You might want to fix the above comment too.

>  -       if ((flags & SLAB_HWCACHE_ALIGN) &&
>  -                       size > cache_line_size() / 2)
>  -               return max_t(unsigned long, align, cache_line_size());
>  +       if (flags & SLAB_HWCACHE_ALIGN) {
>  +               unsigned long ralign = cache_line_size();
>  +               while (size <= ralign / 2)
>  +                       ralign /= 2;
>  +               align = max(align, ralign);
>  +       }
