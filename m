Return-Path: <linux-kernel-owner+w=401wt.eu-S1756358AbZEEB6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbZEEB6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 21:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbZEEB6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 21:58:10 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43948 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbZEEB6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 21:58:09 -0400
Date: Mon, 4 May 2009 18:58:27 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, xemul@parallels.com
Subject: Re: [PATCH 1/2] pidns 1/2: make create_pid_namespace() accept
	parentpidns
Message-ID: <20090505015827.GA6048@linux.vnet.ibm.com>
References: <20090503232700.GD16631@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090503232700.GD16631@x200.localdomain>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan [adobriyan@gmail.com] wrote:
| create_pid_namespace() creates everything, but caller has to assign parent
| pidns by hand, which is unnatural. At the moment of call new ->level has
| to be taken from somewhere and parent pidns is already available.
| 
| Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Acked-By: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

| ---
|  kernel/pid_namespace.c |    8 ++++----
|  1 files changed, 4 insertions(+), 4 deletions(-)
| 
| diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
| index 2d1001b..495d5de 100644
| --- a/kernel/pid_namespace.c
| +++ b/kernel/pid_namespace.c
| @@ -67,9 +67,10 @@ err_alloc:
|  	return NULL;
|  }
| 
| -static struct pid_namespace *create_pid_namespace(unsigned int level)
| +static struct pid_namespace *create_pid_namespace(struct pid_namespace *parent_pid_ns)
|  {
|  	struct pid_namespace *ns;
| +	unsigned int level = parent_pid_ns->level + 1;
|  	int i;
| 
|  	ns = kmem_cache_zalloc(pid_ns_cachep, GFP_KERNEL);
| @@ -86,6 +87,7 @@ static struct pid_namespace *create_pid_namespace(unsigned int level)
| 
|  	kref_init(&ns->kref);
|  	ns->level = level;
| +	ns->parent = get_pid_ns(parent_pid_ns);
| 
|  	set_bit(0, ns->pidmap[0].page);
|  	atomic_set(&ns->pidmap[0].nr_free, BITS_PER_PAGE - 1);
| @@ -125,9 +127,7 @@ struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *old
|  	if (flags & CLONE_THREAD)
|  		goto out_put;
| 
| -	new_ns = create_pid_namespace(old_ns->level + 1);
| -	if (!IS_ERR(new_ns))
| -		new_ns->parent = get_pid_ns(old_ns);
| +	new_ns = create_pid_namespace(old_ns);
| 
|  out_put:
|  	put_pid_ns(old_ns);
| --
| To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
| the body of a message to majordomo@vger.kernel.org
| More majordomo info at  http://vger.kernel.org/majordomo-info.html
| Please read the FAQ at  http://www.tux.org/lkml/
