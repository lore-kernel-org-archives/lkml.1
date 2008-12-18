Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbYLRW3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbYLRW3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 17:29:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbYLRW26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:28:58 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:55456 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbYLRW25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:28:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=YmB7Jo8PofsdSpzWaW7bED4XL4TpIRQDgWG72IrldHUB7neQu0Dq+rSOdu76Z8i8ur
         8G+z2MUPo2FuBoWY5iSzYnTtcEfXSIi+AXGxsYEsjXL42MuyUHBJ7lWv9lFYTFEMSHWM
         GRKgVYmY+bo/em/P08l8FvWeZUTojI1qe2U/A=
Message-ID: <c6d9bea0812181428s2ae78e30y1e700b2eca07ca96@mail.gmail.com>
Date: Thu, 18 Dec 2008 17:28:56 -0500
From: "C. Scott Ananian" <cscott@laptop.org>
To: "Eric Paris" <eparis@redhat.com>
Subject: Re: [RFC PATCH -v4 12/14] fsnotify: add correlations between events
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       viro@zeniv.linux.org.uk, hch@infradead.org, zbr@ioremap.net,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20081212215217.27112.75137.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
	 <20081212215217.27112.75137.stgit@paris.rdu.redhat.com>
X-Google-Sender-Auth: 0d09585199ed3cac
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 4:52 PM, Eric Paris <eparis@redhat.com> wrote:
> inotify sends userspace a correlation between events when they are related
> (aka when dentries are moved).  This adds that same support for all
> fsnotify events.
> diff --git a/fs/notify/notification.c b/fs/notify/notification.c
> index 8ed9d32..7243b20 100644
> --- a/fs/notify/notification.c
> +++ b/fs/notify/notification.c
> @@ -34,6 +35,13 @@
>
>  static struct kmem_cache *event_kmem_cache;
>  static struct kmem_cache *event_holder_kmem_cache;
> +static atomic_t fsnotify_sync_cookie = ATOMIC_INIT(0);
> +
> +u32 fsnotify_get_cookie(void)
> +{
> +        return atomic_inc_return(&fsnotify_sync_cookie);
> +}
> +EXPORT_SYMBOL_GPL(fsnotify_get_cookie);
>
>  int fsnotify_check_notif_queue(struct fsnotify_group *group)
>  {

atomic_inc_return seems rather expensive to put on a hot path in
almost every fs operation.  On a multiprocessor system, the cache line
for fsnotify_sync_cookie would be ping-ponging constantly between
processors.  The canonical solution is to form the cookie by
concatenating the processor number with a per-processor cookie, so
that generating a new cookie would not require synchronization between
processors.  Surely this code already exists to be used somewhere in
Linux.
 --scott

-- 
                         ( http://cscott.net/ )
