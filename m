Return-Path: <linux-kernel-owner+w=401wt.eu-S1759439AbZBERFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759439AbZBERFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 12:05:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbZBERE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 12:04:59 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:22234 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758841AbZBERE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 12:04:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XIVm480QiVV1/pFoDnluJ77IhTLJjFusdzgy5lpZXHwda7NhZARNfpIbpYv31jByOP
         gnRbd9ZKUV6nuXIjlX/SHnTn/HQAb2vwUJ6xk4Tc2uKBOJDYWpZFbDevLa7qpdo58hB9
         FSFqCDIqsWboP82Fbc2ecU7ctbl9ahXPkb/wA=
Date: Thu, 5 Feb 2009 20:10:55 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       haradats@nttdata.co.jp,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [TOMOYO #15 6/8] LSM adapter functions.
Message-ID: <20090205171055.GA2809@x200.localdomain>
References: <20090205081810.331987920@nttdata.co.jp> <20090205082232.562805442@nttdata.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205082232.562805442@nttdata.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 05:18:16PM +0900, Kentaro Takeda wrote:
> +/**
> + * tomoyo_sysctl_path - return the realpath of a ctl_table.
> + * @table: pointer to "struct ctl_table".
> + *
> + * Returns realpath(3) of the @table on success.
> + * Returns NULL on failure.
> + *
> + * This function uses tomoyo_alloc(), so the caller must call tomoyo_free()
> + * if this function didn't return NULL.
> + */
> +static char *tomoyo_sysctl_path(struct ctl_table *table)
> +{
> +	int buflen = TOMOYO_MAX_PATHNAME_LEN;
> +	char *buf = tomoyo_alloc(buflen);
> +	char *end = buf + buflen;
> +	int error = -ENOMEM;
> +
> +	if (!buf)
> +		return NULL;
> +
> +	*--end = '\0';
> +	buflen--;
> +	while (table) {
> +		char buf[32];
> +		const char *sp = table->procname;
> +
> +		if (!sp) {
> +			memset(buf, 0, sizeof(buf));
> +			snprintf(buf, sizeof(buf) - 1, "=%d=", table->ctl_name);
> +			sp = buf;
> +		}
> +		if (tomoyo_prepend(&end, &buflen, sp) ||
> +		    tomoyo_prepend(&end, &buflen, "/"))
> +			goto out;
> +		table = table->parent;
> +	}
> +	if (tomoyo_prepend(&end, &buflen, "/proc/sys"))

Hardcoded path?

> +		goto out;
> +	error = tomoyo_encode(buf, end - buf, end);
> + out:
> +	if (!error)
> +		return buf;
> +	tomoyo_free(buf);
> +	return NULL;
> +}
