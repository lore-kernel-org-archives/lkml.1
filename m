Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbYAIIGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbYAIIGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 03:06:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbYAIIGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 03:06:32 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52904 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbYAIIGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 03:06:31 -0500
Date: Wed, 9 Jan 2008 08:06:20 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: grant@torque.net, tim@cyberelk.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Change paride driver to use unlocked_ioctl instead of
	ioctl
Message-ID: <20080109080620.GE32560@infradead.org>
References: <4785B7BC.5040106@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4785B7BC.5040106@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 11:44:20AM +0530, Nikanth Karthikesan wrote:
> -static int pt_ioctl(struct inode *inode, struct file *file,
> -	 unsigned int cmd, unsigned long arg)
> +static long pt_ioctl(struct file *file, unsigned int cmd, unsigned long
> arg)

this looks line-wrapper by your mailer.

> -		if (copy_from_user(&mtop, p, sizeof(struct mtop)))
> +		if (copy_from_user(&mtop, p, sizeof(struct mtop))) {
> +			unlock_kernel();
>  			return -EFAULT;
> +		}
> 
>  		switch (mtop.mt_op) {
> 
>  		case MTREW:
>  			pt_rewind(tape);
> +			unlock_kernel();

It's generally considered good style to only have as few as possible
return values.  And this is especially important when returning from
a section that's under a lock.  So in this case it would be much better
if you changes this function to have a local 'int error' variable
and then just do

	error = -EFOO;
	goto out_unlock;

wherever you have an early return with the end of the function looking
like


out_unlock:
	unlock_kernel();
	return error;
