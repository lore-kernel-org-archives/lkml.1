Return-Path: <linux-kernel-owner+w=401wt.eu-S1761221AbZEKXGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761221AbZEKXGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 19:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760292AbZEKXFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 19:05:43 -0400
Received: from mail.fieldses.org ([141.211.133.115]:50186 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761006AbZEKXFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 19:05:41 -0400
Date: Mon, 11 May 2009 19:05:41 -0400
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/sunrpc/svc.c: fix sparse warning
Message-ID: <20090511230541.GL793@fieldses.org>
References: <BD79186B4FD85F4B8E60E381CAEE1909015F8D20@mi8nycmail19.Mi8.com> <20090416190601.GA1145@fieldses.org> <BD79186B4FD85F4B8E60E381CAEE1909015F8F97@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE1909015F8F97@mi8nycmail19.Mi8.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 03:15:17PM -0400, H Hartley Sweeten wrote:
> On Thursday, April 16, 2009 12:06 PM, J. Bruce Fields wrote:
> > On Wed, Apr 15, 2009 at 03:46:13PM -0400, H Hartley Sweeten wrote:
> >> Fix sparse warning in net/sunrpc/svc.c.
> >> 
> >> 	warning: symbol 'node' shadows an earlier one
> >
> > What's the other symbol?
> 
> Sorry. Left that out...
> 
> include/linux/nodemask.h
> 
> #define any_online_node(mask)			\
> ({						\
> 	int node;				\
> 	for_each_node_mask(node, (mask))	\
> 		if (node_online(node))		\
> 			break;			\
> 	node;					\
> })
> 
> arch/powerpc/mm/numa.c is the only other user of that macro. In that
> file the local variable is called nid, hence the name change in this
> patch.

Stupid question (and sorry for the delay): any reason that macro
couldn't just be a static inline function?

I'm sort of resistant to the idea that the caller should have to care
what local variable names the implementation uses.

--b.

> 
> Regards,
> Hartley
> 
> >> 
> >> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> >> 
> >> ---
> >> 
> >> diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
> >> index 8847add..e781135 100644
> >> --- a/net/sunrpc/svc.c
> >> +++ b/net/sunrpc/svc.c
> >> @@ -122,7 +122,7 @@ module_param_call(pool_mode, param_set_pool_mode,
> >> param_get_pool_mode,
> >>  static int
> >>  svc_pool_map_choose_mode(void)
> >>  {
> >> -	unsigned int node;
> >> +	unsigned int nid;
> >>  
> >>  	if (num_online_nodes() > 1) {
> >>  		/*
> >> @@ -132,8 +132,8 @@ svc_pool_map_choose_mode(void)
> >>  		return SVC_POOL_PERNODE;
> >>  	}
> >>  
> >> -	node = any_online_node(node_online_map);
> >> -	if (nr_cpus_node(node) > 2) {
> >> +	nid = any_online_node(node_online_map);
> >> +	if (nr_cpus_node(nid) > 2) {
> >>  		/*
> >>  		 * Non-trivial SMP, or CONFIG_NUMA on
> >>  		 * non-NUMA hardware, e.g. with a generic 
