Return-Path: <linux-kernel-owner+w=401wt.eu-S932548AbZKMXvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548AbZKMXvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 18:51:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932313AbZKMXvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 18:51:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932291AbZKMXve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 18:51:34 -0500
Date: Fri, 13 Nov 2009 15:51:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-mm@kvack.org, gerald.schaefer@de.ibm.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow memory hotplug and hibernation in the same kernel
Message-Id: <20091113155102.3480907f.akpm@linux-foundation.org>
In-Reply-To: <20091113105944.GA16028@basil.fritz.box>
References: <20091113105944.GA16028@basil.fritz.box>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Nov 2009 11:59:44 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> Allow memory hotplug and hibernation in the same kernel
> 
> Memory hotplug and hibernation was excluded in Kconfig. This is obviously
> a problem for distribution kernels who want to support both in the same
> image.
> 
> After some discussions with Rafael and others the only problem is 
> with parallel memory hotadd or removal while a hibernation operation
> is in process. It was also working for s390 before.
> 
> This patch removes the Kconfig level exclusion, and simply
> makes the memory add / remove functions grab the pm_mutex
> to exclude against hibernation.
> 
> ...
>
> +extern struct mutex pm_mutex;

Am a bit worried by the new mutex.

>  #ifndef CONFIG_HIBERNATION
>  static inline void register_nosave_region(unsigned long b, unsigned long e)
>  {
> @@ -308,8 +310,23 @@ static inline void register_nosave_regio
>  static inline void register_nosave_region_late(unsigned long b, unsigned long e)
>  {
>  }
> -#endif
>  
> -extern struct mutex pm_mutex;
> +static inline void lock_hibernation(void) {}
> +static inline void unlock_hibernation(void) {}
> +
> +#else
> +
> +/* Let some subsystems like memory hotadd exclude hibernation */
> +
> +static inline void lock_hibernation(void)
> +{
> +	mutex_lock(&pm_mutex);
> +}
> +
> +static inline void unlock_hibernation(void)
> +{
> +	mutex_unlock(&pm_mutex);
> +}
> +#endif

Has this been carefully reviewed and lockdep-tested to ensure that we
didn't introduce any ab/ba nasties?


