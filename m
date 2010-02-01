Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab0BADaH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 22:30:07 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:61410 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab0BADaE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 22:30:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=m3PWt+vrznAgalieqtAj/Xcj9tbXHIrMBpVUn2cxw9UYCdgFTb/1WmpY0hbPd89V3h
         kb1kSB2LfWkXyuwgMqwFuCLHAx1VaNt7yS5EUhWCxG6d4DOjgZdPoiAqUERQXCM6VCKV
         DW1KzYbZ/ZrpmBUwTWwlT1nvT70cNDs1EuRPU=
MIME-Version: 1.0
In-Reply-To: <d3IDKWHT5gE.A.8sB.Q7hZLB@chimera>
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera>
	 <d3IDKWHT5gE.A.8sB.Q7hZLB@chimera>
Date: Mon, 1 Feb 2010 11:30:02 +0800
Message-ID: <7b6bb4a51001311930i7d72f60dj3b15ca3e1a715607@mail.gmail.com>
Subject: Re: [Bug #15196] kmem_cache_create: duplicate cache ccid2_h
From: Xiaotian Feng <xtfeng@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, htd@fancy-poultry.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       nhorman@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 1, 2010 at 8:22 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15196
> Subject         : kmem_cache_create: duplicate cache ccid2_h
> Submitter       : Heinz Diehl <htd@fancy-poultry.org>
> Date            : 2010-01-30 18:33 (2 days old)
> References      : http://marc.info/?l=linux-kernel&m=126487640324942&w=4

Cced Neil,

I think this one is introduced by commit
de4ef86cfce60d2250111f34f8a084e769f23b16,
passing char *slab_name_fmt as function parameter, but vsnprintf is
using sizeof(slab_name_fmt),
which is 8 (or 4 in 32bit kernel) instead of 32 as old version.

Does following patch resolve this bug, Heinz?

diff --git a/net/dccp/ccid.c b/net/dccp/ccid.c
index 57dfb9c..6e52879 100644
--- a/net/dccp/ccid.c
+++ b/net/dccp/ccid.c
@@ -77,13 +77,14 @@ int ccid_getsockopt_builtin_ccids(struct sock *sk, int len,
        return err;
 }

-static struct kmem_cache *ccid_kmem_cache_create(int obj_size, char
*slab_name_fmt, const char *fmt,...)
+static struct kmem_cache *ccid_kmem_cache_create(int obj_size, char
*slab_name_fmt,
+                                                int length,const char *fmt,...)
 {
        struct kmem_cache *slab;
        va_list args;

        va_start(args, fmt);
-       vsnprintf(slab_name_fmt, sizeof(slab_name_fmt), fmt, args);
+       vsnprintf(slab_name_fmt, length, fmt, args);
        va_end(args);

        slab = kmem_cache_create(slab_name_fmt, sizeof(struct ccid) +
obj_size, 0,
@@ -104,6 +105,7 @@ static int ccid_activate(struct ccid_operations *ccid_ops)
        ccid_ops->ccid_hc_rx_slab =
                        ccid_kmem_cache_create(ccid_ops->ccid_hc_rx_obj_size,
                                               ccid_ops->ccid_hc_rx_slab_name,
+
sizeof(ccid_ops->ccid_hc_rx_slab_name),
                                               "ccid%u_hc_rx_sock",
                                               ccid_ops->ccid_id);
        if (ccid_ops->ccid_hc_rx_slab == NULL)
@@ -112,6 +114,7 @@ static int ccid_activate(struct ccid_operations *ccid_ops)
        ccid_ops->ccid_hc_tx_slab =
                        ccid_kmem_cache_create(ccid_ops->ccid_hc_tx_obj_size,
                                               ccid_ops->ccid_hc_tx_slab_name,
+
sizeof(ccid_ops->ccid_hc_tx_slab_name),
                                               "ccid%u_hc_tx_sock",
                                               ccid_ops->ccid_id);
        if (ccid_ops->ccid_hc_tx_slab == NULL)

>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
