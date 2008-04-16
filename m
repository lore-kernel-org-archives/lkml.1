Return-Path: <linux-kernel-owner+w=401wt.eu-S1762009AbYDPIdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762009AbYDPIdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 04:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbYDPIdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 04:33:05 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:60577 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbYDPIdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 04:33:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=VWFCLl344XoXPYYqLtPh8ccyNwoEREgqlgHK9FigYOfq3cVaUECOcB1/oSp5jBO9rAX2B18kGHBa8kD/7eZBUncUZDfPWfPDKaaJlnTow2pyF3oE8grnlHhU5+oXcKjQxnEge6MVF7Gp4rkRpMhxIbD/VR4336ZIXVR9fRYyrZg=
Message-ID: <84144f020804160133ye2327b8wb3774e1e0ccf6ff8@mail.gmail.com>
Date: Wed, 16 Apr 2008 11:33:01 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Masami Hiramatsu" <mhiramat@redhat.com>
Subject: Re: [PATCH -mm] relayfs: support larger relay buffer
Cc: "David Wilder" <dwilder@us.ibm.com>, "Tom Zanussi" <zanussi@comcast.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4804C95F.2080204@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4804C95F.2080204@redhat.com>
X-Google-Sender-Auth: 9ad713c5dab51cb3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 6:27 PM, Masami Hiramatsu <mhiramat@redhat.com> wrote:
> Use vmalloc() and memset() instead of kcalloc() to allocate a page* array
>  when the array size is bigger than one page. This enables relayfs to support
>  bigger relay buffers than 64MB on 4k-page system, 512MB on 16k-page system.
>
>  Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
>  ---
>  @@ -130,7 +138,10 @@ static void *relay_alloc_buf(struct rcha
>   depopulate:
>         for (j = 0; j < i; j++)
>                 __free_page(buf->page_array[j]);
>  -       kfree(buf->page_array);
>  +       if (pa_size > PAGE_SIZE)

You can use is_vmalloc_addr() here.

>  +               vfree(buf->page_array);
>  +       else
>  +               kfree(buf->page_array);
>         return NULL;
>   }
>
