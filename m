Return-Path: <linux-kernel-owner+w=401wt.eu-S1753607AbYIJPkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbYIJPkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 11:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYIJPkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 11:40:24 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:43607 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbYIJPkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 11:40:23 -0400
Date: Wed, 10 Sep 2008 08:40:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Doc/RCU: fix pseudocode in rcuref.txt
Message-ID: <20080910154018.GE6742@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <48C73873.1010708@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C73873.1010708@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 11:01:07AM +0800, Lai Jiangshan wrote:
> 
> atomic_inc_not_zero(v) return 0 if *v = 0.
> use spin_lock instead of write_lock for update lock.

Good catch, Jiangshan, thank you!

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/Documentation/RCU/rcuref.txt b/Documentation/RCU/rcuref.txt
> index 451de2a..4202ad0 100644
> --- a/Documentation/RCU/rcuref.txt
> +++ b/Documentation/RCU/rcuref.txt
> @@ -29,9 +29,9 @@ release_referenced()			delete()
>  					}
> 
>  If this list/array is made lock free using RCU as in changing the
> -write_lock() in add() and delete() to spin_lock and changing read_lock
> -in search_and_reference to rcu_read_lock(), the atomic_get in
> -search_and_reference could potentially hold reference to an element which
> +write_lock() in add() and delete() to spin_lock() and changing read_lock()
> +in search_and_reference() to rcu_read_lock(), the atomic_inc() in
> +search_and_reference() could potentially hold reference to an element which
>  has already been deleted from the list/array.  Use atomic_inc_not_zero()
>  in this scenario as follows:
> 
> @@ -40,20 +40,20 @@ add()					search_and_reference()
>  {					{
>      alloc_object			    rcu_read_lock();
>      ...					    search_for_element
> -    atomic_set(&el->rc, 1);		    if (atomic_inc_not_zero(&el->rc)) {
> -    write_lock(&list_lock);		        rcu_read_unlock();
> +    atomic_set(&el->rc, 1);		    if (!atomic_inc_not_zero(&el->rc)) {
> +    spin_lock(&list_lock);		        rcu_read_unlock();
>  					        return FAIL;
>      add_element				    }
>      ...					    ...
> -    write_unlock(&list_lock);		    rcu_read_unlock();
> +    spin_unlock(&list_lock);		    rcu_read_unlock();
>  }					}
>  3.					4.
>  release_referenced()			delete()
>  {					{
> -    ...					    write_lock(&list_lock);
> +    ...					    spin_lock(&list_lock);
>      if (atomic_dec_and_test(&el->rc))       ...
>          call_rcu(&el->head, el_free);       delete_element
> -    ...                                     write_unlock(&list_lock);
> +    ...                                     spin_unlock(&list_lock);
>  } 					    ...
>  					    if (atomic_dec_and_test(&el->rc))
>  					        call_rcu(&el->head, el_free);
> 
> 
