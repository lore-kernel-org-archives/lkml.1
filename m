Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbZEZBO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbZEZBO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 21:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbZEZBOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 21:14:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53502 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752508AbZEZBOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 21:14:51 -0400
Message-ID: <4A1B42D8.3020809@cn.fujitsu.com>
Date: Tue, 26 May 2009 09:16:08 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] tracing/stat: simplify rbtree freeing code
References: <4A1A5AD1.3070804@cn.fujitsu.com> <4A1A5AE5.70609@cn.fujitsu.com> <20090525155939.GB7121@nowhere>
In-Reply-To: <20090525155939.GB7121@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Mon, May 25, 2009 at 04:46:29PM +0800, Li Zefan wrote:
>> When closing a trace_stat file, we destroy the rbtree constructed during
>> file open, but there is memory leak that the root node is not freed:
>>
>> static struct rb_node *release_next(struct rb_node *node)
>> {
>> 	...
>> 	else {
>> 		if (!parent)		<-- here we leak @node
>> 			return NULL;
>> 	...
>> }
>>
>> This patch keeps removing root node until the tree is empty. We regress
>> from O(n) to O(nlogn), but since both open() and read() are O(nlogn) and
>> it's a slow path, this change won't affect scalibility.
>>
>> [ Impact: fix memory leak when closing a trace_stat file ]
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> ---
>>  kernel/trace/trace_stat.c |   39 +++++----------------------------------
>>  1 files changed, 5 insertions(+), 34 deletions(-)
>>
>> diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
>> index 6efbcb4..ed18701 100644
>> --- a/kernel/trace/trace_stat.c
>> +++ b/kernel/trace/trace_stat.c
>> @@ -42,47 +42,18 @@ static DEFINE_MUTEX(all_stat_sessions_mutex);
>>  /* The root directory for all stat files */
>>  static struct dentry		*stat_dir;
>>  
>> -/*
>> - * Iterate through the rbtree using a post order traversal path
>> - * to release the next node.
>> - * It won't necessary release one at each iteration
>> - * but it will at least advance closer to the next one
>> - * to be released.
>> - */
>> -static struct rb_node *release_next(struct rb_node *node)
>> +static void reset_stat_session(struct stat_session *session)
>>  {
>>  	struct stat_node *snode;
>> -	struct rb_node *parent = rb_parent(node);
>> -
>> -	if (node->rb_left)
>> -		return node->rb_left;
>> -	else if (node->rb_right)
>> -		return node->rb_right;
>> -	else {
>> -		if (!parent)
>> -			return NULL;
>> -		if (parent->rb_left == node)
>> -			parent->rb_left = NULL;
>> -		else
>> -			parent->rb_right = NULL;
>> +	struct rb_root *sroot = &session->stat_root;
>>  
>> -		snode = container_of(node, struct stat_node, node);
>> +	while (!RB_EMPTY_ROOT(sroot)) {
>> +		snode = rb_entry(sroot->rb_node, struct stat_node, node);
>> +		rb_erase(&snode->node, sroot);
> 
> 
> 
> Why not just keep the previous version but sligthly
> modified:
> 
> 
> 	while (node)
> 		node = release_next(node);
> 
> 	if (!RB_EMPTY_ROOT(root)) {
> 		node = rb_entry(...)
> 		kfree(....)
> 		root = RB_ROOT
> 	}
> 

The easiest fix:

 		if (!parent)
-			return NULL;
-		if (parent->rb_left == node)
+			;
+		else if (parent->rb_left == node)

;)

> Because the problem with rb_erase() is the wasteful color based rebalancing
> performed whereas here we just need to walk into the tree and free
> the nodes.
> 
> Hm?
> 

Less code, less bugs.

But actually I don't know how costly rb_erase() is, if it's really better to
avoid rb_erase(), I'll send another fix.

> Frederic.
> 
