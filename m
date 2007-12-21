Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbXLUVeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbXLUVeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 16:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755040AbXLUVeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 16:34:09 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:52381 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742AbXLUVeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 16:34:08 -0500
Date: Fri, 21 Dec 2007 15:33:55 -0600
From: Corey Minyard <minyard@acm.org>
Subject: Re: [PATCH 3/4] docs: convert kref semaphore to mutex
In-reply-to: <20071221205859.010632996@mvista.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux@bohmer.net, jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com
Message-id: <476C3143.2040800@acm.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <20071221205854.408865412@mvista.com>
 <20071221205859.010632996@mvista.com>
User-Agent: Icedove 1.5.0.14pre (X11/20071018)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, a good idea.

Acked-by: Corey Minyard <minyard@acm.org>

Daniel Walker wrote:
> Just converting this documentation semaphore reference, since we don't
> want to promote semaphore usage.
>
> Signed-off-by: Daniel Walker <dwalker@mvista.com>
>
> ---
>  Documentation/kref.txt |   20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
>
> Index: linux-2.6.23/Documentation/kref.txt
> ===================================================================
> --- linux-2.6.23.orig/Documentation/kref.txt
> +++ linux-2.6.23/Documentation/kref.txt
> @@ -141,10 +141,10 @@ The last rule (rule 3) is the nastiest o
>  instance, you have a list of items that are each kref-ed, and you wish
>  to get the first one.  You can't just pull the first item off the list
>  and kref_get() it.  That violates rule 3 because you are not already
> -holding a valid pointer.  You must add locks or semaphores.  For
> -instance:
> +holding a valid pointer.  You must add a mutex (or some other lock).
> +For instance:
>  
> -static DECLARE_MUTEX(sem);
> +static DEFINE_MUTEX(mutex);
>  static LIST_HEAD(q);
>  struct my_data
>  {
> @@ -155,12 +155,12 @@ struct my_data
>  static struct my_data *get_entry()
>  {
>  	struct my_data *entry = NULL;
> -	down(&sem);
> +	mutex_lock(&mutex);
>  	if (!list_empty(&q)) {
>  		entry = container_of(q.next, struct my_q_entry, link);
>  		kref_get(&entry->refcount);
>  	}
> -	up(&sem);
> +	mutex_unlock(&mutex);
>  	return entry;
>  }
>  
> @@ -174,9 +174,9 @@ static void release_entry(struct kref *r
>  
>  static void put_entry(struct my_data *entry)
>  {
> -	down(&sem);
> +	mutex_lock(&mutex);
>  	kref_put(&entry->refcount, release_entry);
> -	up(&sem);
> +	mutex_unlock(&mutex);
>  }
>  
>  The kref_put() return value is useful if you do not want to hold the
> @@ -191,13 +191,13 @@ static void release_entry(struct kref *r
>  
>  static void put_entry(struct my_data *entry)
>  {
> -	down(&sem);
> +	mutex_lock(&mutex);
>  	if (kref_put(&entry->refcount, release_entry)) {
>  		list_del(&entry->link);
> -		up(&sem);
> +		mutex_unlock(&mutex);
>  		kfree(entry);
>  	} else
> -		up(&sem);
> +		mutex_unlock(&mutex);
>  }
>  
>  This is really more useful if you have to call other routines as part
>
>   

