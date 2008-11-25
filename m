Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbYKYAl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbYKYAl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 19:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbYKYAlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 19:41:20 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:25755 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbYKYAlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 19:41:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VNehuAag4XkE8IANsZPj2GIn4Nmz0uCM2ojm6wkknUqk0gOhXVQ4duBTB0BxNnCrp7
         fmNYKFmu28q9ZZy41i/L37ATldxxwHwVdUrm8hCWgTH/D7dEqJ4AUaeVAlkNA/IRqljj
         1Y4n/LBQxmVS2yoycwIk8tupwmVaTalZb1pPU=
Date: Tue, 25 Nov 2008 03:45:11 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrey Mirkin <major@openvz.org>
Cc: orenl@cs.columbia.edu, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Add support for in-kernel process creation during
	restart
Message-ID: <20081125004024.GA4440@x200.localdomain>
References: <1227541175-30301-1-git-send-email-major@openvz.org> <1227541175-30301-2-git-send-email-major@openvz.org> <1227541175-30301-3-git-send-email-major@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227541175-30301-3-git-send-email-major@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2008 at 06:39:35PM +0300, Andrey Mirkin wrote:
> +static int cr_rstr_task_struct(struct cr_ctx *ctx, struct cr_hdr_task *ht)
> +{
> +	struct task_struct *t = current;
> +	char *buf;
> +	int ret = -EINVAL;
> +
> +	/* upper limit for task_comm_len to prevent DoS */
> +	if (ht->task_comm_len < 0 || ht->task_comm_len > PAGE_SIZE)
> +		goto out;
> +
> +	buf = kmalloc(ht->task_comm_len, GFP_KERNEL);
> +	if (!buf)
> +		goto out;
> +	ret = cr_read_string(ctx, buf, ht->task_comm_len);
> +	if (!ret) {
> +		/* if t->comm is too long, silently truncate */
> +		memset(t->comm, 0, TASK_COMM_LEN);
> +		memcpy(t->comm, buf, min(ht->task_comm_len, TASK_COMM_LEN));
> +	}
> +	kfree(buf);
> +
> +	/* FIXME: restore remaining relevant task_struct fields */
> +out:
> +	return ret;
> +}

->comm is only 16 bytes wide, you can just use on-stack variable.
