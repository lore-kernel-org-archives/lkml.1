Return-Path: <linux-kernel-owner+w=401wt.eu-S1763981AbZDIG1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763981AbZDIG1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 02:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754983AbZDIG1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 02:27:22 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:50345 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440AbZDIG1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 02:27:21 -0400
Date: Thu, 9 Apr 2009 08:29:24 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: tj@kernel.org, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/12]: sparc64: Refactor OBP cpu scanning code using an iterator.
Message-ID: <20090409062924.GA14255@uranus.ravnborg.org>
References: <20090408.223738.63750701.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408.223738.63750701.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 10:37:38PM -0700, David Miller wrote:
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  arch/sparc/include/asm/prom.h |    1 +
>  arch/sparc/kernel/prom_64.c   |  235 ++++++++++++++++++++++-------------------
>  2 files changed, 127 insertions(+), 109 deletions(-)
> 
> diff --git a/arch/sparc/include/asm/prom.h b/arch/sparc/include/asm/prom.h
> index 900d447..1b15212 100644
> --- a/arch/sparc/include/asm/prom.h
> +++ b/arch/sparc/include/asm/prom.h
> @@ -86,6 +86,7 @@ extern int of_node_to_nid(struct device_node *dp);
>  #endif
>  
>  extern void prom_build_devicetree(void);
> +extern void of_populate_present_mask(void);
>  
>  /* Dummy ref counting routines - to be implemented later */
>  static inline struct device_node *of_node_get(struct device_node *node)
> diff --git a/arch/sparc/kernel/prom_64.c b/arch/sparc/kernel/prom_64.c
> index ca55c70..04b518d 100644
> --- a/arch/sparc/kernel/prom_64.c
> +++ b/arch/sparc/kernel/prom_64.c
> @@ -374,75 +374,26 @@ static const char *get_mid_prop(void)
>  	return (tlb_type == spitfire ? "upa-portid" : "portid");
>  }
>  
> -struct device_node *of_find_node_by_cpuid(int cpuid)
> -{
> -	struct device_node *dp;
> -	const char *mid_prop = get_mid_prop();
> -
> -	for_each_node_by_type(dp, "cpu") {
> -		int id = of_getintprop_default(dp, mid_prop, -1);
> -		const char *this_mid_prop = mid_prop;
> -
> -		if (id < 0) {
> -			this_mid_prop = "cpuid";
> -			id = of_getintprop_default(dp, this_mid_prop, -1);
> -		}
> -
> -		if (id < 0) {
> -			prom_printf("OF: Serious problem, cpu lacks "
> -				    "%s property", this_mid_prop);
> -			prom_halt();
> -		}
> -		if (cpuid == id)
> -			return dp;
> -	}
> -	return NULL;
> -}
> -
> -void __init of_fill_in_cpu_data(void)
> +static void *of_iterate_over_cpus(void *(*func)(struct device_node *, int, void *), void *arg)

You never pass a "void *" as argument to this iterator.
It seems cleaner to use a long or even an int as this is closer
to the typical usage, and one can always pass a '0' when the
argument is not used.

I have not looked through all patches yet so it may come later.

	Sam
