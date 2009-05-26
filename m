Return-Path: <linux-kernel-owner+w=401wt.eu-S1757437AbZEZTdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437AbZEZTdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 15:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756178AbZEZTd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 15:33:28 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:64518 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbZEZTd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 15:33:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Y4wqmKbr/q87ApHuyVdcuXLwehkXN+8TIckO+g8jU/OtGDdbA26X1j2mWMQVp7jAn9
         kEex2+evETSF/d27zg3J7U5tTaiDKj5VX6Nb+V9MZ7gRbsVGtdInfpy67DIAk/cIkZDx
         6BbjbXJNj1GdDOfdT9bJOS5AKLGF/gMukU2jA=
Date: Tue, 26 May 2009 21:33:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] tracing/stat: simplify rbtree freeing code
Message-ID: <20090526193322.GC5969@nowhere>
References: <4A1A5AD1.3070804@cn.fujitsu.com> <4A1A5AE5.70609@cn.fujitsu.com> <20090525155939.GB7121@nowhere> <4A1B42D8.3020809@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1B42D8.3020809@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 09:16:08AM +0800, Li Zefan wrote:
> Frederic Weisbecker wrote:
> > On Mon, May 25, 2009 at 04:46:29PM +0800, Li Zefan wrote:
> >> When closing a trace_stat file, we destroy the rbtree constructed during
> >> file open, but there is memory leak that the root node is not freed:
> >>
> >> static struct rb_node *release_next(struct rb_node *node)
> >> {
> >> 	...
> >> 	else {
> >> 		if (!parent)		<-- here we leak @node
> >> 			return NULL;
> >> 	...
> >> }
> >>
> >> This patch keeps removing root node until the tree is empty. We regress
> >> from O(n) to O(nlogn), but since both open() and read() are O(nlogn) and
> >> it's a slow path, this change won't affect scalibility.
> >>
> >> [ Impact: fix memory leak when closing a trace_stat file ]
> >>
> >> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> >> ---
> >>  kernel/trace/trace_stat.c |   39 +++++----------------------------------
> >>  1 files changed, 5 insertions(+), 34 deletions(-)
> >>
> >> diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
> >> index 6efbcb4..ed18701 100644
> >> --- a/kernel/trace/trace_stat.c
> >> +++ b/kernel/trace/trace_stat.c
> >> @@ -42,47 +42,18 @@ static DEFINE_MUTEX(all_stat_sessions_mutex);
> >>  /* The root directory for all stat files */
> >>  static struct dentry		*stat_dir;
> >>  
> >> -/*
> >> - * Iterate through the rbtree using a post order traversal path
> >> - * to release the next node.
> >> - * It won't necessary release one at each iteration
> >> - * but it will at least advance closer to the next one
> >> - * to be released.
> >> - */
> >> -static struct rb_node *release_next(struct rb_node *node)
> >> +static void reset_stat_session(struct stat_session *session)
> >>  {
> >>  	struct stat_node *snode;
> >> -	struct rb_node *parent = rb_parent(node);
> >> -
> >> -	if (node->rb_left)
> >> -		return node->rb_left;
> >> -	else if (node->rb_right)
> >> -		return node->rb_right;
> >> -	else {
> >> -		if (!parent)
> >> -			return NULL;
> >> -		if (parent->rb_left == node)
> >> -			parent->rb_left = NULL;
> >> -		else
> >> -			parent->rb_right = NULL;
> >> +	struct rb_root *sroot = &session->stat_root;
> >>  
> >> -		snode = container_of(node, struct stat_node, node);
> >> +	while (!RB_EMPTY_ROOT(sroot)) {
> >> +		snode = rb_entry(sroot->rb_node, struct stat_node, node);
> >> +		rb_erase(&snode->node, sroot);
> > 
> > 
> > 
> > Why not just keep the previous version but sligthly
> > modified:
> > 
> > 
> > 	while (node)
> > 		node = release_next(node);
> > 
> > 	if (!RB_EMPTY_ROOT(root)) {
> > 		node = rb_entry(...)
> > 		kfree(....)
> > 		root = RB_ROOT
> > 	}
> > 
> 
> The easiest fix:
> 
>  		if (!parent)
> -			return NULL;
> -		if (parent->rb_left == node)
> +			;
> +		else if (parent->rb_left == node)
> 
> ;)



Ah, yeah :)


> 
> > Because the problem with rb_erase() is the wasteful color based rebalancing
> > performed whereas here we just need to walk into the tree and free
> > the nodes.
> > 
> > Hm?
> > 
> 
> Less code, less bugs.
> 
> But actually I don't know how costly rb_erase() is, if it's really better to
> avoid rb_erase(), I'll send another fix.



It is more costly because the tree is rebalanced after erasing
each node.
I don't think the change could be really visualized though. Not
for now at least, but it could if a future tracer has a huge mass of
entries.

 
> > Frederic.
> > 

