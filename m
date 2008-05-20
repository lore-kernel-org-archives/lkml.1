Return-Path: <linux-kernel-owner+w=401wt.eu-S935449AbYETPiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935449AbYETPiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934930AbYETPfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:35:01 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:56357 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934926AbYETPe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:34:58 -0400
Date: Tue, 20 May 2008 09:34:57 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Tom Spink <tspink@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] Introduce filesystem type tracking
Message-ID: <20080520153456.GN2638@parisc-linux.org>
References: <1211196126-7442-1-git-send-email-tspink@gmail.com> <7b9198260805200606u6ebc2681o8af7a8eebc1cb96@mail.gmail.com> <20080520134306.GA28946@ZenIV.linux.org.uk> <20080520135732.GA30349@infradead.org> <7b9198260805200818v687fc495nb7db5ffd6c8b6ba1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b9198260805200818v687fc495nb7db5ffd6c8b6ba1@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 04:18:14PM +0100, Tom Spink wrote:
> +	
> +	mutex_lock(&type->fs_supers_lock);
> +	if (list_empty(&type->fs_supers) && type->init) {
> +		err = type->init();
> +		if (err) {
> +			mutex_unlock(&type->fs_supers_lock);
> +			spin_unlock(&sb_lock);
> +			destroy_super(s);
> +			return ERR_PTR(err);
> +		}
> +	}
> +	
> +	list_add(&s->s_instances, &type->fs_supers);
> +	mutex_unlock(&type->fs_supers_lock);
> +
>  	s->s_type = type;
>  	strlcpy(s->s_id, type->name, sizeof(s->s_id));
>  	list_add_tail(&s->s_list, &super_blocks);
> -	list_add(&s->s_instances, &type->fs_supers);
> +	
>  	spin_unlock(&sb_lock);

You can't take a mutex while holding a spinlock -- what if you had to
sleep to acquire the mutex?

I imagine you also don't want to hold a spinlock while calling the
->init or ->exit -- what if the fs wants to sleep in there (eg allocate
memory with GFP_KERNEL).

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
