Return-Path: <linux-kernel-owner+w=401wt.eu-S966269AbYCSVXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966269AbYCSVXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762040AbYCSUAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:00:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48863 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868AbYCSUAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:00:08 -0400
Date: Wed, 19 Mar 2008 11:37:04 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/6] vfs: mountinfo show dominating group id
Message-ID: <20080319113704.GJ10722@ZenIV.linux.org.uk>
References: <20080313212641.989467982@szeredi.hu> <20080313212737.053993902@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313212737.053993902@szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 10:26:45PM +0100, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Show peer group ID of nearest dominating group that has intersection
> with the mount's namespace.

There's an obvious problem here: ->show_options() can spew _anything_,
including a string that ends on " shared:42".  Makes reliable parsing of
the damn thing in userland impossible.  IOW, fs options should go _last_
and they should follow an unconditionally present field.

>  	if (sb->s_op->show_options)
>  		err = sb->s_op->show_options(m, mnt);
> -	if (IS_MNT_SHARED(mnt)) {
> -		seq_printf(m, " shared:%i", get_peer_group_id(mnt));
> -		if (IS_MNT_SLAVE(mnt))
> -			seq_printf(m, ",slave:%i", get_master_id(mnt));
> -	} else if (IS_MNT_SLAVE(mnt)) {
> -		seq_printf(m, " slave:%i", get_master_id(mnt));
> +	seq_putc(m, ' ');
> +	if (IS_MNT_SHARED(mnt) || IS_MNT_SLAVE(mnt)) {
> +		if (IS_MNT_SHARED(mnt))
> +			seq_printf(m, "shared:%i", get_peer_group_id(mnt));
> +		if (IS_MNT_SLAVE(mnt)) {
> +			int dominator_id = get_dominator_id_same_ns(mnt);
