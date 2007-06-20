Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444AbXFTOwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbXFTOwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 10:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbXFTOwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 10:52:32 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:54085 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbXFTOwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 10:52:31 -0400
Subject: Re: [PATCH] relay-file-read-start-pos-fix.patch
From: Tom Zanussi <zanussi@us.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: David Wilder <dwilder@us.ibm.com>, linux-kernel@vger.kernel.org,
       systemtap@sources.redhat.com,
       Yumiko Sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi Oshima <soshima@redhat.com>, Hideo Aoki <haoki@redhat.com>
In-Reply-To: <4678E5FF.7030301@hitachi.com>
References: <4676109F.8020202@us.ibm.com>  <467750E9.4090808@hitachi.com>
	 <1182231301.30702.82.camel@ubuntu>  <4678E5FF.7030301@hitachi.com>
Content-Type: text/plain
Date: Wed, 20 Jun 2007 09:46:57 -0500
Message-Id: <1182350817.30702.112.camel@ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-20 at 17:31 +0900, Masami Hiramatsu wrote:

[...]

> P.S.
> I attached my patch (relay-file-read-overwrite-mode-fix.patch)
> which fixed the problem pointed in previous mail.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 

Hi,

Thanks for sending the test case.  I wrote my own program that tests for
the same thing, and it also works fine.  To make sure it doesn't break
no-overwrite mode, I also ran several tests with blktrace and that looks
good too.

Thanks very much for analyzing the problem and providing the patch!

Just to summarize - the problem this fixes is that in overwrite mode,
the current read code doesn't pick up all the data it could if the whole
buffer is filled - it will leave behind sub-buffers at the beginning.
With this patch, the data in those sub-buffers is read as well.

Acked-by: Tom Zanussi <zanussi@us.ibm.com>

> ---
>  kernel/relay.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.22-rc4-mm2/kernel/relay.c
> ===================================================================
> --- linux-2.6.22-rc4-mm2.orig/kernel/relay.c	2007-06-13 20:22:02.000000000 +0900
> +++ linux-2.6.22-rc4-mm2/kernel/relay.c	2007-06-20 10:53:06.000000000 +0900
> @@ -812,7 +812,10 @@
>  	}
> 
>  	buf->bytes_consumed += bytes_consumed;
> -	read_subbuf = read_pos / buf->chan->subbuf_size;
> +	if (!read_pos)
> +		read_subbuf = buf->subbufs_consumed % n_subbufs;
> +	else
> +		read_subbuf = read_pos / buf->chan->subbuf_size;
>  	if (buf->bytes_consumed + buf->padding[read_subbuf] == subbuf_size) {
>  		if ((read_subbuf == buf->subbufs_produced % n_subbufs) &&
>  		    (buf->offset == subbuf_size))
> @@ -841,8 +844,9 @@
>  	}
> 
>  	if (unlikely(produced - consumed >= n_subbufs)) {
> -		consumed = (produced / n_subbufs) * n_subbufs;
> +		consumed = produced - n_subbufs + 1;
>  		buf->subbufs_consumed = consumed;
> +		buf->bytes_consumed = 0;
>  	}
>  	
>  	produced = (produced % n_subbufs) * subbuf_size + buf->offset;
> 
> 
> 
> 


