Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbZESGjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbZESGjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 02:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbZESGj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 02:39:29 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:38376 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbZESGj1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 02:39:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=aJXrHILiIwJpxrN1a0BKCuzu8lNeLJ67VTXuaPdWcQ6RV+5k2uM3yXm4Zjy1/Ytw13
         mQczlTbVF9EDVVmf6FP56KwU1WRm7HHiVT8s5gCkv5d0cRWIpcf1FEYaLk2YiX/pFyLo
         2VTY3dkZBrWbYns891oQT+zaj+OWbigdqrO3M=
MIME-Version: 1.0
In-Reply-To: <20090516090448.410032840@intel.com>
References: <20090516090005.916779788@intel.com>
	 <20090516090448.410032840@intel.com>
Date: Tue, 19 May 2009 09:39:27 +0300
X-Google-Sender-Auth: 1164d3de21dc9cca
Message-ID: <84144f020905182339o5fb1e78eved95c4c20fd9ffa7@mail.gmail.com>
Subject: Re: [PATCH 2/3] vmscan: make mapped executable pages the first class 
	citizen
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Sat, May 16, 2009 at 12:00 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> @@ -1272,28 +1273,40 @@ static void shrink_active_list(unsigned
>
>                /* page_referenced clears PageReferenced */
>                if (page_mapping_inuse(page) &&
> -                   page_referenced(page, 0, sc->mem_cgroup, &vm_flags))
> +                   page_referenced(page, 0, sc->mem_cgroup, &vm_flags)) {
>                        pgmoved++;
> +                       /*
> +                        * Identify referenced, file-backed active pages and
> +                        * give them one more trip around the active list. So
> +                        * that executable code get better chances to stay in
> +                        * memory under moderate memory pressure.  Anon pages
> +                        * are ignored, since JVM can create lots of anon
> +                        * VM_EXEC pages.
> +                        */
> +                       if ((vm_flags & VM_EXEC) && !PageAnon(page)) {
> +                               list_add(&page->lru, &l_active);
> +                               continue;
> +                       }

Why do we need to skip JIT'd code? There are plenty of desktop
applications that use Mono, for example, and it would be nice if we
gave them the same treatment as native applications. Likewise, I am
sure all browsers that use JIT for JavaScript need to be considered.

                                   Pekka
