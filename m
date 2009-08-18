Return-Path: <linux-kernel-owner+w=401wt.eu-S1759552AbZHRSC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552AbZHRSC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 14:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758706AbZHRSC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 14:02:26 -0400
Received: from mail-vw0-f172.google.com ([209.85.212.172]:64861 "EHLO
	mail-vw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266AbZHRSCZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 14:02:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gUpGN7fjBnIUOtPSDaXF/IuRRHwn1rZykR4LgaBFG/RRdGEqDTDAGNG0ODl0k5/rhv
         V8WxdUYJmnv7ExFe63RnH2LH5+dy7gMb4QNwEUKlqMGYzBzuz+Tlt8mQNdPgQ5t/lCtW
         L8AnSPtJkG6tBWSHE6bHrnfLTkJviI0gsCQvg=
MIME-Version: 1.0
In-Reply-To: <20090817204351.EEE0DDDB@kernel>
References: <20090817204351.EEE0DDDB@kernel>
Date: Tue, 18 Aug 2009 11:02:26 -0700
X-Google-Sender-Auth: e169613a7d104048
Message-ID: <e9c3a7c20908181102q6db970bav737cf26939f84c4c@mail.gmail.com>
Subject: Re: [RFC][PATCH] flex_array: conditionally optimize out divides
From: Dan Williams <dan.j.williams@intel.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17, 2009 at 1:43 PM, Dave Hansen<dave@linux.vnet.ibm.com> wrote:
>
> There are three flex_array operations that require divides:
> 1. figuring out into which "part" we should access
> 2. figuring out where into that part we fit
> 3. figuring out in how many elements fit into a part
>
> Division can get expensive, and we may incur one or two
> divides for each put() or get() that is performed.  If we
> rounded the elements to a power-of-two and stored shifts
> and masks, we could rid ourselves of the divides, but we
> would lose storage space with oddly-sized objects.  We
> could code the implementation to handle divides and special-
> case the shifts when they can be used, but that would
> complicate the code.
>
> This is an alternative.  We introduce variants of
> flex_array_get() and flex_array_put() since they are the
> most common operations.  We append an _es() to their names
> (for Element Size) and get flex_array_get_es() and
> flex_array_put_es().  The allocation and free functions
> remain unoptimized since they're not indended to be hot
> paths.
>
> Passing the element size into each operation, and using it
> like this:
>
>        flex_array_get(fa, nr, sizeof(struct my_struct));
>
> lets the compiler turn the divides into shifts if 'my_struct'
> is a power-of-two in size.
>
> It seems that only gcc 4.1 and up are smart enough to figure
> this out, though.
>
> ---

Hi Dave,

Thanks for this.  I'll give it a shot hopefully in the next few days.
One comment below...

> +/*
> + * Use the _es() variants when you want the compiler to
> + * be able to optimize the divides like when you have a
> + * power-of-two element_size.
> + */
> +static inline void *flex_array_get_es(struct flex_array *fa,
> +               int element_nr, int element_size)
> +{
> +       int part_nr = __fa_element_to_part_nr(element_size, element_nr);
> +       int index_inside = __fa_index_inside_part(element_size, element_nr);
> +
> +       if (element_nr >= fa->total_nr_elements)
> +               return NULL;

This if()...

> +
> +       return flex_array_get_precalc(fa, part_nr, index_inside);
> +}
> +
> +static inline int flex_array_put_es(struct flex_array *fa, int element_nr,
> +               int element_size, void *src, gfp_t flags)
> +{
> +       int part_nr = __fa_element_to_part_nr(element_size, element_nr);
> +       int index_inside = __fa_index_inside_part(element_size, element_nr);
> +
> +       if (element_nr >= fa->total_nr_elements)
> +               return -ENOSPC;

...and this one look like good candidates for unlikely() as these
additional branches may be a concern for the fast path.

Thanks,
Dan
