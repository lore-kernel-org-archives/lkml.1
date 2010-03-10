Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab0CJAL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 19:11:57 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:55863 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab0CJALx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 19:11:53 -0500
MIME-Version: 1.0
In-Reply-To: <-1645286213079228429@unknownmsgid>
References: <-1645286213079228429@unknownmsgid>
Date: Tue, 9 Mar 2010 16:11:52 -0800
Message-ID: <8bb80c381003091611l7211439ief40c5cf31e782a0@mail.gmail.com>
Subject: Re: [PATCH] omap: resource: Add per-resource mutex for OMAP resource 
	framework
From: Mike Chan <mike@android.com>
Cc: android-kernel@googlegroups.com, Chunqiu Wang <cqwang@motorola.com>,
       Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
       Rajendra Nayak <rnayak@ti.com>, Tero Kristo <tero.kristo@nokia.com>,
       Kalle Jokiniemi <ext-kalle.jokiniemi@nokia.com>,
       Jouni Hogander <jouni.hogander@nokia.com>,
       Kevin Hilman <khilman@deeprootsystems.com>, linux-omap@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 9, 2010 at 4:09 PM,  <y@google.com> wrote:
> From: Chunqiu Wang <cqwang@motorola.com>
>
> Current OMAP resource fwk uses a global res_mutex
> for resource_request and resource_release calls
> for all the available resources.It may cause dead
> lock if resource_request/resource_release is called
> recursively.
>
> For current OMAP3 VDD1/VDD2 resource, the change_level
> implementation is mach-omap2/resource34xx.c/set_opp(),
> when using resource_release to remove vdd1 constraint,
> this function may call resource_release again to release
> Vdd2 constrait if target vdd1 level is less than OPP3.
> in this scenario, the global res_mutex down operation
> will be called again, this will cause the second
> down operation hang there.
>
> To fix the problem, per-resource mutex is added
> to avoid hangup when resource_request/resource_release
> is called recursively.
>
> Signed-off-by: Chunqiu Wang <cqwang@motorola.com>
> Signed-off-by: Mike Chan <mike@android.com>
> ---
>  arch/arm/plat-omap/include/plat/resource.h |    2 ++
>  arch/arm/plat-omap/resource.c              |   21 ++++++++++-----------
>  2 files changed, 12 insertions(+), 11 deletions(-)
>
> diff --git a/arch/arm/plat-omap/include/plat/resource.h b/arch/arm/plat-omap/include/plat/resource.h
> index 9acebcc..b5aff1f 100644
> --- a/arch/arm/plat-omap/include/plat/resource.h
> +++ b/arch/arm/plat-omap/include/plat/resource.h
> @@ -54,6 +54,8 @@ struct shared_resource {
>        /* Shared resource operations */
>        struct shared_resource_ops *ops;
>        struct list_head node;
> +       /* Protect each resource */
> +       struct mutex resource_mutex;
>  };
>
>  struct shared_resource_ops {
> diff --git a/arch/arm/plat-omap/resource.c b/arch/arm/plat-omap/resource.c
> index f1cdecf..0a7b79b 100644
> --- a/arch/arm/plat-omap/resource.c
> +++ b/arch/arm/plat-omap/resource.c
> @@ -277,6 +277,7 @@ int resource_register(struct shared_resource *resp)
>        }
>
>        INIT_LIST_HEAD(&resp->users_list);
> +       mutex_init(&resp->resource_mutex);
>
>        /* Add the resource to the resource list */
>        list_add(&resp->node, &res_list);
> @@ -339,14 +340,13 @@ int resource_request(const char *name, struct device *dev,
>        struct  users_list *user;
>        int     found = 0, ret = 0;
>
> -       down(&res_mutex);
> -       resp = _resource_lookup(name);
> +       resp = resource_lookup(name);
>        if (!resp) {
>                printk(KERN_ERR "resource_request: Invalid resource name\n");
> -               ret = -EINVAL;
> -               goto res_unlock;
> +               return -EINVAL;
>        }
>
> +       mutex_lock(&resp->resource_mutex);
>        /* Call the resource specific validate function */
>        if (resp->ops->validate_level) {
>                ret = resp->ops->validate_level(resp, level);
> @@ -375,7 +375,7 @@ int resource_request(const char *name, struct device *dev,
>        user->level = level;
>
>  res_unlock:
> -       up(&res_mutex);
> +       mutex_unlock(&resp->resource_mutex);
>        /*
>         * Recompute and set the current level for the resource.
>         * NOTE: update_resource level moved out of spin_lock, as it may call
> @@ -406,14 +406,13 @@ int resource_release(const char *name, struct device *dev)
>        struct users_list *user;
>        int found = 0, ret = 0;
>
> -       down(&res_mutex);
> -       resp = _resource_lookup(name);
> +       resp = resource_lookup(name);
>        if (!resp) {
>                printk(KERN_ERR "resource_release: Invalid resource name\n");
> -               ret = -EINVAL;
> -               goto res_unlock;
> +               return -EINVAL;
>        }
>
> +       mutex_lock(&resp->resource_mutex);
>        list_for_each_entry(user, &resp->users_list, node) {
>                if (user->dev == dev) {
>                        found = 1;
> @@ -434,7 +433,7 @@ int resource_release(const char *name, struct device *dev)
>        /* Recompute and set the current level for the resource */
>        ret = update_resource_level(resp);
>  res_unlock:
> -       up(&res_mutex);
> +       mutex_unlock(&resp->resource_mutex);
>        return ret;
>  }
>  EXPORT_SYMBOL(resource_release);
> @@ -458,7 +457,7 @@ int resource_get_level(const char *name)
>                up(&res_mutex);
>                return -EINVAL;
>        }
> -       ret = resp->curr_level;
> +       ret =  resp->curr_level;
>        up(&res_mutex);
>        return ret;
>  }
> --
> 1.6.6.2
>
>

Oops, my git client was slightly screwed up, apologies, I meant to
send this from mike@android.com, the patch is still good though :)

-- Mike
