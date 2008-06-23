Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbYFWChT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbYFWChT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 22:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbYFWChF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 22:37:05 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:41598 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752376AbYFWChD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 22:37:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ISKkHJrCDAAIhr2osdNN7QKVMXlks17pHTRjf4fdbpicVZ6NyWwEKTdvsDQ1Xdd7LyowbxNfByC3M4/7gE11tK2u5yTOnc3D6zcGVkRfUZajZUI6spACuNwbZBJVOxSzpuwRcd6iPzZw5WZlF0H3ZT3BgrOfJp+90ARi+kN5600=  ;
X-YMail-OSG: 2ZQVbpAVM1mLfgD.BynRInOEqY_TrNjsZ02gYXgugCknNI26ATPoxE27bmCKv0f63Hqx.ON4hoA2KERXdGBt0RPCUHSnyVXr9uyfEoOgRBvZW61bADK6SykrGM.rhypwcFo-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH]rcu,inet,fib_trie,route,radix-tree,DECnet,mac80211: fix meaningless rcu_dereference(local_var)
Date: Mon, 23 Jun 2008 12:36:50 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Luis Carlos Cobo <luisca@cozybit.com>,
       Steve Whitehouse <SteveW@acm.org>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <485CCFC9.2070007@cn.fujitsu.com>
In-Reply-To: <485CCFC9.2070007@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806231236.51341.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 June 2008 19:54, Lai Jiangshan wrote:

> diff --git a/lib/radix-tree.c b/lib/radix-tree.c
> index 169a2f8..bfae4e2 100644
> --- a/lib/radix-tree.c
> +++ b/lib/radix-tree.c
> @@ -703,9 +703,9 @@ __lookup(struct radix_tree_node *slot, void **results,
> unsigned long index, for (i = index & RADIX_TREE_MAP_MASK; i <
> RADIX_TREE_MAP_SIZE; i++) { struct radix_tree_node *node;
>  		index++;
> -		node = slot->slots[i];
> +		node = rcu_dereference(slot->slots[i]);
>  		if (node) {
> -			results[nr_found++] = rcu_dereference(node);
> +			results[nr_found++] = node;
>  			if (nr_found == max_items)
>  				goto out;
>  		}
> @@ -815,7 +815,7 @@ __lookup_tag(struct radix_tree_node *slot, void
> **results, unsigned long index, index++;
>  				if (!tag_get(slot, tag, j))
>  					continue;
> -				node = slot->slots[j];
> +				node = rcu_dereference(slot->slots[j]);
>  				/*
>  				 * Even though the tag was found set, we need to
>  				 * recheck that we have a non-NULL node, because
> @@ -827,7 +827,6 @@ __lookup_tag(struct radix_tree_node *slot, void
> **results, unsigned long index, * rely on its value remaining the same).
>  				 */
>  				if (node) {
> -					node = rcu_dereference(node);
>  					results[nr_found++] = node;
>  					if (nr_found == max_items)
>  						goto out;

This was done like this IIRC to avoid the barrier when possible.
