Return-Path: <linux-kernel-owner+w=401wt.eu-S1752814AbZGKW3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbZGKW3o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 18:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbZGKW3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 18:29:35 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:60262 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbZGKW3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 18:29:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H32NTV5MWvNba4guWkHOM4jRuKmvyYZ8BASvZeuki1qJrHk5r7y1TyJW+KB5sEGkN+
         XE1NVvi0Y7u1HY6ipBwT5Re/jcMsbnpfmSQeN1iPeEQonQ1bIzMvctUirpZ7hkU2E1mO
         oolKCch+4dxIe3v53FeBlEYJ6xBszyNjyEdj4=
Date: Sun, 12 Jul 2009 00:29:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [rfc -tip] lib,rb-tree - introduce rb_for_each helper
Message-ID: <20090711222928.GD6641@nowhere>
References: <20090711220009.GA16028@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090711220009.GA16028@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 12, 2009 at 02:00:09AM +0400, Cyrill Gorcunov wrote:
> perftools already use a number of opencoded
> for() iterators over rbtree. The patch introduce
> rb_for_each helper for this purpose.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
> 
> The real conversion for this macro usage should be
> done later.
> 
> Also I think having rb_for_each_entry for being used
> with container_of inbetween could be convinient as
> well.
> 
> Anyway if we don't need such a helper -- just drop
> the patch.
> 
>  include/linux/rbtree.h |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux-2.6.git/include/linux/rbtree.h
> =====================================================================
> --- linux-2.6.git.orig/include/linux/rbtree.h
> +++ linux-2.6.git/include/linux/rbtree.h
> @@ -145,6 +145,9 @@ extern struct rb_node *rb_prev(const str
>  extern struct rb_node *rb_first(const struct rb_root *);
>  extern struct rb_node *rb_last(const struct rb_root *);
>  
> +#define rb_for_each(nd, root) \
> +	for (nd = rb_first((root)); nd; nd = rb_next(nd))
> +
>  /* Fast replacement of a single node without remove/rebalance/add/rebalance */
>  extern void rb_replace_node(struct rb_node *victim, struct rb_node *new, 
>  			    struct rb_root *root);


Nice idea!
This pattern is often taken in perfcounter tools.
Also to complete this pattern, an abstract container retrieval
would be also useful as an iterator:

#define rb_for_each_entry(tpos, pos, root, memb) \
	for (pos = rb_first(root); pos && tpos = rb_entry(pos, typeof(*tpos), memb); \
	     pos = rb_next(pos->memb, typeof(*pos), memb))

Or something like that...


