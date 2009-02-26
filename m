Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbZBZMJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbZBZMJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 07:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbZBZMJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 07:09:33 -0500
Received: from sineb-mail-1.sun.com ([192.18.19.6]:61997 "EHLO
	sineb-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbZBZMJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 07:09:32 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain
Date: Thu, 26 Feb 2009 20:08:42 +0800
From: Li Wei <W.Li@Sun.COM>
Subject: Re: [PATCH 3/4] gcov: add gcov profiling infrastructure
In-reply-to: <49A6812F.4030303@linux.vnet.ibm.com>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Sam Ravnborg <sam@ravnborg.org>
Message-id: <1235650122.7166.6.camel@localhost>
X-Mailer: Evolution 2.24.3
References: <49883CD7.2060602@linux.vnet.ibm.com>
 <1235643104.13052.10.camel@localhost> <49A6812F.4030303@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 12:46 +0100, Peter Oberparleiter wrote:
> necessary. My proposed fix looks something like this (unless there
> are objections, I'll include this one in the re-post):

I'd prefer a goto. But this looks nice too. Thanks! :)

> ---
>  kernel/gcov/fs.c |   21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> Index: linux-2.6.29-rc6/kernel/gcov/fs.c
> ===================================================================
> --- linux-2.6.29-rc6.orig/kernel/gcov/fs.c
> +++ linux-2.6.29-rc6/kernel/gcov/fs.c
> @@ -453,15 +453,22 @@ static ssize_t reset_write(struct file *
>  			   size_t len, loff_t *pos)
>  {
>  	struct gcov_node *node;
> -	struct gcov_node *r;
> +	int restart;
>  
>  	mutex_lock(&node_lock);
> -	list_for_each_entry_safe(node, r, &all_head, all) {
> -		if (node->info)
> -			gcov_info_reset(node->info);
> -		else
> -			remove_node(node);
> -	}
> +	do {
> +		restart = 0;
> +		list_for_each_entry(node, &all_head, all) {
> +			if (node->info)
> +				gcov_info_reset(node->info);
> +			else if (list_empty(&node->children)) {
> +				remove_node(node);
> +				/* Several nodes may have gone - restart. */
> +				restart = 1;
> +				break;
> +			}
> +		}
> +	} while (restart);
>  	mutex_unlock(&node_lock);
>  
>  	return len;
> 

