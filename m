Return-Path: <linux-kernel-owner+w=401wt.eu-S1752752AbZHXPlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbZHXPlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 11:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbZHXPlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 11:41:44 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53251 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbZHXPln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 11:41:43 -0400
Subject: Re: [patch 2/4 -mm] flex_array: add flex_array_clear function
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0908211620410.28611@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0908211620410.28611@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Mon, 24 Aug 2009 08:41:28 -0700
Message-Id: <1251128488.22398.7113.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-21 at 16:21 -0700, David Rientjes wrote:
>  /**
> + * flex_array_clear - clear element in array at @element_nr
> + * @element_nr:        index of the position to clear.
> + *
> + * Locking must be provided by the caller.
> + */
> +int flex_array_clear(struct flex_array *fa, unsigned int element_nr)
> +{
> +       int part_nr = fa_element_to_part_nr(fa, element_nr);
> +       struct flex_array_part *part;
> +       void *dst;
> +
> +       if (element_nr >= fa->total_nr_elements)
> +               return -ENOSPC;
> +       if (elements_fit_in_base(fa))
> +               part = (struct flex_array_part *)&fa->parts[0];
> +       else {
> +               part = fa->parts[part_nr];
> +               if (!part)
> +                       return -EINVAL;
> +       }
> +       dst = &part->elements[index_inside_part(fa, element_nr)];
> +       memset(dst, 0, fa->element_size);
> +       return 0;
> +}

My only worry about this is that it's largely a copy-and-paste of
flex_array_put().  If we had a function that just returned a pointer to
'dst', we could use that in both cases.  

Couldn't we implement the above with just:

int flex_array_clear(struct flex_array *fa, unsigned int element_nr)
{
	return flex_array_put(fa, element_nr, &empty_zero_page);
}

-- Dave

