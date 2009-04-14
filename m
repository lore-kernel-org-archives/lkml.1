Return-Path: <linux-kernel-owner+w=401wt.eu-S1759316AbZDNSxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316AbZDNSxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757301AbZDNSxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:53:36 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53699 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbZDNSxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:53:36 -0400
Subject: Re: [PATCH 26/30] cr: mount namespace
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, serue@us.ibm.com, mingo@elte.hu,
       orenl@cs.columbia.edu, hch@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090410024004.GA27788@x200.localdomain>
References: <20090410024004.GA27788@x200.localdomain>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 11:53:31 -0700
Message-Id: <1239735211.32604.107.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-10 at 06:40 +0400, Alexey Dobriyan wrote:
> +int cr_collect_all_mnt_ns(struct cr_context *ctx)
> +{
> +       struct cr_object *obj;
> +       int rv;
> +
> +       for_each_cr_object(ctx, obj, CR_CTX_NSPROXY) {
> +               struct nsproxy *nsproxy = obj->o_obj;
> +
> +               rv = cr_collect_mnt_ns(ctx, nsproxy->mnt_ns);
> +               if (rv < 0)
> +                       return rv;
> +       }
> +       for_each_cr_object(ctx, obj, CR_CTX_MNT_NS) {
> +               struct mnt_namespace *mnt_ns = obj->o_obj;
> +               unsigned int cnt = atomic_read(&mnt_ns->count);
> +
> +               if (obj->o_count != cnt) {
> +                       printk("%s: mnt_ns %p has external references %lu:%u\n", __func__, mnt_ns, obj->o_count, cnt);
> +                       return -EINVAL;
> +               }
> +       }
> +       return 0;
> +}

I worry about depending on refcounts like this, especially when
userspace has an interface that can elevate them.  If someone is holding
open /proc/$pid/mounts, this will get elevated and trip the check.  This
check is also naturally racy.  You check once if there are references,
but there is no locking to keep new references from coming in.  

That said, I do like how this for_each_cr_object() stuff looks.  It's
pretty clean.

-- Dave

