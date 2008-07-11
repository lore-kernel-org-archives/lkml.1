Return-Path: <linux-kernel-owner+w=401wt.eu-S1758013AbYGKIqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbYGKIqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 04:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757322AbYGKIqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 04:46:01 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:52372 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757295AbYGKIqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 04:46:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=ngc3J1pyYAHsoScEJf7zZhjtWOmbI3cork7A/nQB5oUbfuUb8ikoczQhIks1oeDUk+
         DugDUfogtiKBwoNimY2BLhxmtWOYGGnQz853pFsLkY23Zrs4idX8n0T9BvhLAucq0X0u
         12xPVSomJavp4trOCauVwPO34gic5HCcwjAQs=
Message-ID: <84144f020807110145g3467d77md54e3d734ecba2c6@mail.gmail.com>
Date: Fri, 11 Jul 2008 11:45:59 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>
Subject: Re: [RFC PATCH 4/5] kmemtrace: SLUB hooks.
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "Christoph Lameter" <cl@linux-foundation.org>
In-Reply-To: <20080710210617.70975aed@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1215712946-23572-1-git-send-email-eduard.munteanu@linux360.ro>
	 <1215712946-23572-2-git-send-email-eduard.munteanu@linux360.ro>
	 <1215712946-23572-3-git-send-email-eduard.munteanu@linux360.ro>
	 <1215712946-23572-4-git-send-email-eduard.munteanu@linux360.ro>
	 <20080710210617.70975aed@linux360.ro>
X-Google-Sender-Auth: ca6b8e71d310d1a8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduard-Gabriel,

On Thu, Jul 10, 2008 at 9:06 PM, Eduard - Gabriel Munteanu
<eduard.munteanu@linux360.ro> wrote:
> This adds hooks for the SLUB allocator, to allow tracing with kmemtrace.
>
> Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>

> @@ -205,7 +206,13 @@ void *__kmalloc(size_t size, gfp_t flags);
>
>  static __always_inline void *kmalloc_large(size_t size, gfp_t flags)
>  {
> -       return (void *)__get_free_pages(flags | __GFP_COMP, get_order(size));
> +       unsigned int order = get_order(size);
> +       void *ret = (void *) __get_free_pages(flags, order);
> +
> +       kmemtrace_mark_alloc(KMEMTRACE_KIND_KERNEL, _THIS_IP_, ret,
> +                            size, PAGE_SIZE << order, flags);

Oh, I missed this on the first review. Here we have, like in SLOB,
page allocator pass-through, so wouldn't KIND_PAGES be more
appropriate?
