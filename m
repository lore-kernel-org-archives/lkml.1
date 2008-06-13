Return-Path: <linux-kernel-owner+w=401wt.eu-S1758607AbYFMHHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607AbYFMHHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 03:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbYFMHHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 03:07:31 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50706 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbYFMHHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 03:07:31 -0400
Message-ID: <48521C19.6070001@cs.helsinki.fi>
Date: Fri, 13 Jun 2008 10:04:57 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
CC: tzanussi@gmail.com, akpm@linux-foundation.org, compudj@krystal.dyndns.org,
       linux-kernel@vger.kernel.org, righi.andrea@gmail.com
Subject: Re: [PATCH 3/3] relay: Add buffer-only channels; useful for early
 logging.
References: <20080613041013.274ccb28@linux360.ro>
In-Reply-To: <20080613041013.274ccb28@linux360.ro>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduard,

Eduard - Gabriel Munteanu wrote:
> @@ -578,12 +592,15 @@ struct rchan *relay_open(const char *base_filename,
>  	chan->alloc_size = FIX_SIZE(subbuf_size * n_subbufs);
>  	chan->parent = parent;
>  	chan->private_data = private_data;
> -	strlcpy(chan->base_filename, base_filename, NAME_MAX);
> +	if (base_filename) {
> +		chan->has_base_filename = 1;
> +		strlcpy(chan->base_filename, base_filename, NAME_MAX);
> +	}
>  	setup_callbacks(chan, cb);
>  	kref_init(&chan->kref);
>  
>  	mutex_lock(&relay_channels_mutex);
> -	for_each_online_cpu(i) {
> +	for_each_present_cpu(i) {
>  		chan->buf[i] = relay_open_buf(chan, i);
>  		if (!chan->buf[i])
>  			goto free_bufs;
> @@ -594,7 +611,7 @@ struct rchan *relay_open(const char *base_filename,
>  	return chan;
>  
>  free_bufs:
> -	for_each_online_cpu(i) {
> +	for_each_present_cpu(i) {
>  		if (!chan->buf[i])
>  			break;
>  		relay_close_buf(chan->buf[i]);

Why do we need to change for_each_online_cpu to for_each_present_cpu?
I guess it's because we don't have all the CPUs online at early
boot? Wouldn't it then be better to implement CPU hotplug support
instead?

		Pekka
