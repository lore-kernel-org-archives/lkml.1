Return-Path: <linux-kernel-owner+w=401wt.eu-S1753523AbYEOF01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbYEOF01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 01:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbYEOF0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 01:26:19 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:35798 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbYEOF0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 01:26:17 -0400
Message-ID: <482BC96F.1030008@linux.vnet.ibm.com>
Date: Thu, 15 May 2008 10:56:07 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080505)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       shemminger@vyatta.com, linville@tuxdriver.com, sri@us.ibm.com,
       davem@davemloft.net, adobriyan@gmail.com, apw@shadowen.org,
       balbir@linux.vnet.ibm.com, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] list_for_each_rcu must die: networking
References: <20080424033849.GA4401@linux.vnet.ibm.com> <20080515001607.GB20811@linux.vnet.ibm.com>
In-Reply-To: <20080515001607.GB20811@linux.vnet.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> All uses of list_for_each_rcu() can be profitably replaced by the
> easier-to-use list_for_each_entry_rcu().  This patch makes this change
> for networking, in preparation for removing the list_for_each_rcu()
> API entirely.
> 
> Updated to remove the two now-unused variables as noted by Dave Miller,
> and also to fix my bonehead error detected by Kamalesh Babulal and
> Alexey Dobriyan.  It now passes LTP on POWER.  And also has valid SOB.
> Some days it just doesn't pay to get out of bed...

Hi Paul,

Thanks, the patch fixes the oops.

Tested-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> Acked-by: David S. Miller <davem@davemloft.net> (lkml.org/lkml/2008/4/23/448)
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
>  802/psnap.c     |    4 +---
>  ipv4/af_inet.c  |    9 +++------
>  ipv6/af_inet6.c |    9 +++------
>  3 files changed, 7 insertions(+), 15 deletions(-)
> 
> diff -urpNa -X dontdiff linux-2.6.26-rc2/net/802/psnap.c linux-2.6.26-rc2-lfer-net/net/802/psnap.c
> --- linux-2.6.26-rc2/net/802/psnap.c	2008-04-16 19:49:44.000000000 -0700
> +++ linux-2.6.26-rc2-lfer-net/net/802/psnap.c	2008-05-14 13:38:13.000000000 -0700
> @@ -30,11 +30,9 @@ static struct llc_sap *snap_sap;
>   */
>  static struct datalink_proto *find_snap_client(unsigned char *desc)
>  {
> -	struct list_head *entry;
>  	struct datalink_proto *proto = NULL, *p;
> 
> -	list_for_each_rcu(entry, &snap_list) {
> -		p = list_entry(entry, struct datalink_proto, node);
> +	list_for_each_entry_rcu(p, &snap_list, node) {
>  		if (!memcmp(p->type, desc, 5)) {
>  			proto = p;
>  			break;
> diff -urpNa -X dontdiff linux-2.6.26-rc2/net/ipv4/af_inet.c linux-2.6.26-rc2-lfer-net/net/ipv4/af_inet.c
> --- linux-2.6.26-rc2/net/ipv4/af_inet.c	2008-05-14 13:35:32.000000000 -0700
> +++ linux-2.6.26-rc2-lfer-net/net/ipv4/af_inet.c	2008-05-14 13:46:26.000000000 -0700
> @@ -267,7 +267,6 @@ static inline int inet_netns_ok(struct n
>  static int inet_create(struct net *net, struct socket *sock, int protocol)
>  {
>  	struct sock *sk;
> -	struct list_head *p;
>  	struct inet_protosw *answer;
>  	struct inet_sock *inet;
>  	struct proto *answer_prot;
> @@ -284,13 +283,12 @@ static int inet_create(struct net *net, 
>  	sock->state = SS_UNCONNECTED;
> 
>  	/* Look for the requested type/protocol pair. */
> -	answer = NULL;
>  lookup_protocol:
>  	err = -ESOCKTNOSUPPORT;
>  	rcu_read_lock();
> -	list_for_each_rcu(p, &inetsw[sock->type]) {
> -		answer = list_entry(p, struct inet_protosw, list);
> +	list_for_each_entry_rcu(answer, &inetsw[sock->type], list) {
> 
> +		err = 0;
>  		/* Check the non-wild match. */
>  		if (protocol == answer->protocol) {
>  			if (protocol != IPPROTO_IP)
> @@ -305,10 +303,9 @@ lookup_protocol:
>  				break;
>  		}
>  		err = -EPROTONOSUPPORT;
> -		answer = NULL;
>  	}
> 
> -	if (unlikely(answer == NULL)) {
> +	if (unlikely(err)) {
>  		if (try_loading_module < 2) {
>  			rcu_read_unlock();
>  			/*
> diff -urpNa -X dontdiff linux-2.6.26-rc2/net/ipv6/af_inet6.c linux-2.6.26-rc2-lfer-net/net/ipv6/af_inet6.c
> --- linux-2.6.26-rc2/net/ipv6/af_inet6.c	2008-05-14 13:35:32.000000000 -0700
> +++ linux-2.6.26-rc2-lfer-net/net/ipv6/af_inet6.c	2008-05-14 13:45:08.000000000 -0700
> @@ -87,7 +87,6 @@ static int inet6_create(struct net *net,
>  	struct inet_sock *inet;
>  	struct ipv6_pinfo *np;
>  	struct sock *sk;
> -	struct list_head *p;
>  	struct inet_protosw *answer;
>  	struct proto *answer_prot;
>  	unsigned char answer_flags;
> @@ -101,13 +100,12 @@ static int inet6_create(struct net *net,
>  		build_ehash_secret();
> 
>  	/* Look for the requested type/protocol pair. */
> -	answer = NULL;
>  lookup_protocol:
>  	err = -ESOCKTNOSUPPORT;
>  	rcu_read_lock();
> -	list_for_each_rcu(p, &inetsw6[sock->type]) {
> -		answer = list_entry(p, struct inet_protosw, list);
> +	list_for_each_entry_rcu(answer, &inetsw6[sock->type], list) {
> 
> +		err = 0;
>  		/* Check the non-wild match. */
>  		if (protocol == answer->protocol) {
>  			if (protocol != IPPROTO_IP)
> @@ -122,10 +120,9 @@ lookup_protocol:
>  				break;
>  		}
>  		err = -EPROTONOSUPPORT;
> -		answer = NULL;
>  	}
> 
> -	if (!answer) {
> +	if (err) {
>  		if (try_loading_module < 2) {
>  			rcu_read_unlock();
>  			/*
> --

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
