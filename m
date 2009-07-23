Return-Path: <linux-kernel-owner+w=401wt.eu-S1752434AbZGWBqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbZGWBqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 21:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbZGWBqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 21:46:45 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35075 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbZGWBqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 21:46:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 23 Jul 2009 10:44:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, menage@google.com,
       vda.linux@googlemail.com, mikew@google.com, lizf@cn.fujitsu.com,
       xiyou.wangcong@gmail.com
Subject: Re: [RFC][PATCH] flexible array implementation v3
Message-Id: <20090723104450.e0d421ca.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090722175345.7154C2F2@kernel>
References: <20090722175345.7154C2F2@kernel>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009 10:53:45 -0700
Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> 
> 
> Changes from v2:
> - renamed some of the index functions
> - added preallocation function
> - added flex_array_free_parts() for use with
>   statically allocated bases
> - killed append() function
> 
> Changes from v1:
> - to vs too typo
> - added __check_part_and_nr() and gave it a warning
> - fixed off-by-one check on __nr_part_ptrs()
> - added FLEX_ARRAY_INIT() macro
> - some kerneldoc comments about the capacity
>   with various sized objects
> - comments to note lack of locking semantice
> 

Seems nice, thank you. but a nitpick..

+struct flex_array *flex_array_alloc(int element_size, int total, gfp_t flags)
+{
+	struct flex_array *ret;
+	int max_size = nr_base_part_ptrs() * __elements_per_part(element_size);
+
+	/* max_size will end up 0 if element_size > PAGE_SIZE */
+	if (total > max_size)
+		return NULL;

Can't we store "total" somewhere and do error check ?

And some magic value as following can't be defined for 'total' ?

#define FLEX_ARRAY_MAX_ELEMENTS		(-1) // Use maximum flex array.


> +/**
> + * flex_array_get - pull data back out of the array
> + * @element_nr:	index of the element to fetch from the array
> + *
> + * Returns a pointer to the data at index @element_nr.  Note
> + * that this is a copy of the data that was passed in.  If you
> + * are using this to store pointers, you'll get back &ptr.
> + *
> + * Locking must be provided by the caller.
> + */
> +void *flex_array_get(struct flex_array *fa, int element_nr)
> +{
> +	int part_nr = fa_element_to_part_nr(fa, element_nr);
> +	struct flex_array_part *part;
> +	int offset;
> +
> +	if (__check_part_nr(fa, part_nr))
> +		return NULL;
return -EINVAL, here ?
(Can't we compared with stored "total" ?)

> +	if (!fa->parts[part_nr])
> +		return NULL;
> +

The caller can't know whether
 - there are no entry or
 - NULL(0) is stored at the array.

Then, he has to check gotten value is valid or not by himself.

Can't we return -ENOENT here(especially when prealloc() is called) ?
But ah, anyway, all-zero elements in allocated array exists ;(
and the user can get value from an entry never be put.

If we can fill the first 4bytes of _unused_ index by some magic code like this
#define FLEX_ARRAY_UNUSED_MAGIC		(0xa5a5a5a5)
(if maintaining bitmap/status of usage is nonsense)
and flex_array_get() can return -ENOENT, the users will feel easy.

Overprotection ;) ?


Thanks,
-Kame

> +	part = fa->parts[part_nr];
> +	offset = index_inside_part(fa, element_nr);
> +	return &part->elements[index_inside_part(fa, element_nr)];
> +}








