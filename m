Return-Path: <linux-kernel-owner+w=401wt.eu-S1758391AbYCYSpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758391AbYCYSpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 14:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbYCYSpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 14:45:35 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:45590 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbYCYSpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:45:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=TeJBvlaJSufoSag2oLs+r7XEmgRyVNCDVwCcpH79UZ04psPKhK0V2gvZ9TzYh58CI7Wk2cb2CkqOFtNZRWXaySjBmWnW2/Com/dMrsOyrVQgXZnBgOuodIO4rllvRypJFdAQOe3ACT7ZRXYvzWbrx5DKI/YFxV180ow6lQlLJ18=
Message-ID: <84144f020803251145m6672e0acv16d27aaae1acb4d9@mail.gmail.com>
Date: Tue, 25 Mar 2008 20:45:33 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Daniel Yeisley" <dan.yeisley@unisys.com>
Subject: Re: [PATCH] list_add corruption in slab.c
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <1206464258.13473.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206464258.13473.11.camel@localhost.localdomain>
X-Google-Sender-Auth: 9af8ead7f2758d09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Tue, Mar 25, 2008 at 6:57 PM, Daniel Yeisley <dan.yeisley@unisys.com> wrote:
> I've been seeing list_add corruption in slab.c on the ES7000 since the
>  2.6.24.1 kernel.  There are several places where the initkmem_list3
>  array is access by [somevalue + node].  This also needs to be done in
>  kmem_cache_init().
>
>  Signed-off-by: Dan Yeisley <dan.yeisley@unisys.com>
>
>  ---
>  diff -Naur linux-2.6.25-rc5/mm/slab.c linux-2.6.25-rc5-new/mm/slab.c
>  --- linux-2.6.25-rc5/mm/slab.c  2008-03-10 01:22:27.000000000 -0400
>  +++ linux-2.6.25-rc5-new/mm/slab.c      2008-03-20 13:59:24.000000000 -0400
>  @@ -1481,7 +1481,7 @@
>         list_add(&cache_cache.next, &cache_chain);
>         cache_cache.colour_off = cache_line_size();
>         cache_cache.array[smp_processor_id()] = &initarray_cache.cache;
>  -       cache_cache.nodelists[node] = &initkmem_list3[CACHE_CACHE];
>  +       cache_cache.nodelists[node] = &initkmem_list3[CACHE_CACHE + node];

Good catch! You'd need to fix up the use of initkmem_list3 farther
down in kmem_init_cache():

>        /* 5) Replace the bootstrap kmem_list3's */
>        {
>                int nid;
>
>                for_each_online_node(nid) {
>                        init_list(&cache_cache, &initkmem_list3[CACHE_CACHE], nid);

Care to send a tested patch that fixes that as well?

                          Pekka
