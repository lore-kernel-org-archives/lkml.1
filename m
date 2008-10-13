Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbYJMGf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbYJMGf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 02:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbYJMGfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 02:35:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:46228 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbYJMGfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 02:35:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ayMlAq04AxZ4fGXmaQJxqpp3z0aVViPptkLDnSKAGBjyaoGk+ZtQiiqgxnbogwuzV2
         n74n7LwDq99qs4B3KTE+FNVPcHgbG1jQdpQG776DgYEmhEjA9dlDtkLpkUwDoOXNpBnM
         iy2Cg6IZa5kkfN7whlvYQVlgo6JZP4UAHvl+E=
Date: Mon, 13 Oct 2008 10:38:06 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Paul Jackson <pj@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] seq_file: don't call bitmap_scnprintf_len()
Message-ID: <20081013063806.GB3596@x200.localdomain>
References: <48F1C36D.6080301@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F1C36D.6080301@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2008 at 05:29:17PM +0800, Lai Jiangshan wrote:
> "m->count + len < m->size" is true commonly, so bitmap_scnprintf()
> is commonly called. this fix saves a call to bitmap_scnprintf_len().

This saves a call if seq buffer is already full which is not a common
situation, so you're optimising for rare situations and adding branch
for common ones.

> --- a/fs/seq_file.c
> +++ b/fs/seq_file.c
> @@ -452,17 +452,18 @@ int seq_dentry(struct seq_file *m, struct dentry *dentry, char *esc)
>  
>  int seq_bitmap(struct seq_file *m, unsigned long *bits, unsigned int nr_bits)
>  {
> -	size_t len = bitmap_scnprintf_len(nr_bits);
> -
> -	if (m->count + len < m->size) {
> -		bitmap_scnprintf(m->buf + m->count, m->size - m->count,
> -				 bits, nr_bits);
> -		m->count += len;
> -		return 0;
> +	if (m->count < m->size) {
> +		int len = bitmap_scnprintf(m->buf + m->count,
> +				m->size - m->count, bits, nr_bits);
> +		if (m->count + len < m->size) {
> +			m->count += len;
> +			return 0;
> +		}
>  	}
>  	m->count = m->size;
>  	return -1;
>  }
> +EXPORT_SYMBOL(seq_bitmap);

Modular users, where are they?
