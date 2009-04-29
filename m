Return-Path: <linux-kernel-owner+w=401wt.eu-S1759449AbZD2QIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449AbZD2QIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 12:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757899AbZD2QHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 12:07:53 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:60181 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012AbZD2QHw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 12:07:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fsmefQq7kx5P2NKa8k59aynEsssUgAdz2ziBAKVb63tQWgf6o8gEMZTkyEN1ANqygD
         hQXeVztQmOnqWnOuGp3J4kxGPNV5bXtk2BQdWHziBicUZ0ydcSGV4DmOx3orJ/hBNgbW
         oni+8AWu/zcJ9u1broDLx5B/yWgZ+KxgqK3Gg=
MIME-Version: 1.0
In-Reply-To: <20090429114708.66114c03@cuia.bos.redhat.com>
References: <20090428044426.GA5035@eskimo.com>
	 <20090428192907.556f3a34@bree.surriel.com>
	 <1240987349.4512.18.camel@laptop>
	 <20090429114708.66114c03@cuia.bos.redhat.com>
Date: Thu, 30 Apr 2009 01:07:51 +0900
X-Google-Sender-Auth: 13702ed1c39fa3f9
Message-ID: <2f11576a0904290907g48e94e74ye97aae593f6ac519@mail.gmail.com>
Subject: Re: [PATCH] vmscan: evict use-once pages first (v2)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Elladan <elladan@eskimo.com>,
       linux-kernel@vger.kernel.org, tytso@mit.edu, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Looks good than previous version. but I have one question.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index eac9577..4471dcb 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1489,6 +1489,18 @@ static void shrink_zone(int priority, struct zone *zone,
>                        nr[l] = scan;
>        }
>
> +       /*
> +        * When the system is doing streaming IO, memory pressure here
> +        * ensures that active file pages get deactivated, until more
> +        * than half of the file pages are on the inactive list.
> +        *
> +        * Once we get to that situation, protect the system's working
> +        * set from being evicted by disabling active file page aging.
> +        * The logic in get_scan_ratio protects anonymous pages.
> +        */
> +       if (nr[LRU_INACTIVE_FILE] > nr[LRU_ACTIVE_FILE])
> +               nr[LRU_ACTIVE_FILE] = 0;
> +
>        while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
>                                        nr[LRU_INACTIVE_FILE]) {
>                for_each_evictable_lru(l) {

we handle active_anon vs inactive_anon ratio by shrink_list().
Why do you insert this logic insert shrink_zone() ?
