Return-Path: <linux-kernel-owner+w=401wt.eu-S1757643AbXJ0U7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643AbXJ0U7m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 16:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbXJ0U7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 16:59:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:42134 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbXJ0U7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 16:59:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=rglYQMtCcj7ATzE5aL3/DRU0+vH3NnXsyCFX0ItSxlFSI1QmCx6PanXZFKtZCzDFq9r5blVwOHSsyZQpEas403laHOBvXVauPl60yn+taq3BpZfPg8gLt7gI9TSNd/fF5ToaU9apsAJwzUe0a13F/7CTEloO6aewYzr05AwrjA4=
Date: Sat, 27 Oct 2007 11:01:12 +0200
To: casey@schaufler-ca.com
Cc: akpm@osdl.org, torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Version 9 (2.6.24-rc1) Smack: Simplified Mandatory Access Control Kernel
Message-ID: <20071027090112.GA5460@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4720118C.5020906@schaufler-ca.com>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +/**
> + * smk_write_cipso - write() for /smack/cipso
> + * @filp: file pointer, not actually used
> + * @buf: where to get the data from
> + * @count: bytes sent
> + * @ppos: where to start
> + *
> + * Returns number of bytes written or error code, as appropriate
> + */
> +static ssize_t smk_write_cipso(struct file *file, const char __user *buf,
> +			       size_t count, loff_t *ppos)
> +{

[...]

> +
> +	/*
> +	 * Only allow one writer at a time. Writes should be
> +	 * quite rare and small in any case.
> +	 */
> +	mutex_lock(&smack_cipso_lock);
> +
> +	*(data + count) = '\0';
> +
> +	for (eolp = strchr(data, '\n'), linep = data;
> +		eolp != NULL && rc >= 0;
> +		linep = eolp + 1, eolp = strchr(linep, '\n')) {
> +

The problem here (As discussed in private mails) is that the for loop 
assumes that the beginning of given user-space buffer is the beginning
of a rule. This leads to situations where the rule becomes "ecret 20",
or "cret 20" instead of "Secret 20". Big input buffers/files leads 
smack to recieve a rule like "Secret 20" in fragmented chunks like:

write("<lots of rules before ours>\nSec", ..)
write("r", 1, ..)
write("et 20\n<remaing rules after ours>", ..)

Parsing a rule in such tough conditions in _kernel space_ is very
hard. I began to feel that it will be much easier if we do the parsing 
in a userspace utility and let smack accept only small buffers (80 char). 

i.e. A user space utility that takes a big input file like
exit 10/3,7,4
exit 10/3,7,4
exit 10/3,7,4
<100 times>

And transform it to 100 small write() calls. By this way we can return
-EINVAL if write()'s count field > 80, or if input contains no \n or
more than one.

Any Ideas ?. 

Casey, I can begin modifying cipso_write() and writing this small 
user-space utility now if you agree on this.

Regards,

-- 
Ahmed S. Darwish
HomePage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
