Return-Path: <linux-kernel-owner+w=401wt.eu-S1758780AbZKYOPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780AbZKYOPB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 09:15:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758385AbZKYOPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 09:15:01 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:48252 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbZKYOPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 09:15:00 -0500
Date: Wed, 25 Nov 2009 07:15:05 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Liuweni <qingshenlwy@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       strongzgy <strongzgy@gmail.com>, xgr178 <xgr178@163.com>,
       Liu Hui <onlyflyer@gmail.com>, viro <viro@zeniv.linux.org.uk>,
       akpm <akpm@linux-foundation.org>, jack <jack@suse.cz>,
       npiggin <npiggin@suse.de>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1/3]fs/inode: iunique() Optimize Performance
Message-ID: <20091125141505.GH9482@parisc-linux.org>
References: <200911252209432039291@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911252209432039291@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 10:09:45PM +0800, Liuweni wrote:
> ---
> move the if condition out the while{}.
> While the function executing, the if 
> condition won't check again and again.
> And this code won't change the function
> of iunique().

That's not true.

> @@ -838,9 +838,10 @@ ino_t iunique(struct super_block *sb, ino_t max_reserved)
>  	ino_t res;
>  
>  	spin_lock(&inode_lock);
> +
> +	if (counter <= max_reserved)
> +		counter = max_reserved + 1;
>  	do {
> -		if (counter <= max_reserved)
> -			counter = max_reserved + 1;
>  		res = counter++;

'counter' is incremented here, so if it wraps around, we'll blunder into 
the reserved space again.

>  		head = inode_hashtable + hash(sb, res);
>  		inode = find_inode_fast(sb, head, res);
> 
>  				
> --------------
> Best Regards,
> Liuweni
> 2009-11-25
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
