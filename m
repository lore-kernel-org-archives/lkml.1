Return-Path: <linux-kernel-owner+w=401wt.eu-S1758589AbXFSQ1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589AbXFSQ1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 12:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbXFSQ1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 12:27:18 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58029 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193AbXFSQ1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 12:27:17 -0400
Subject: Re: [PATCH] relay-file-read-start-pos-fix.patch
From: Tom Zanussi <zanussi@us.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: David Wilder <dwilder@us.ibm.com>, linux-kernel@vger.kernel.org,
       systemtap@sources.redhat.com,
       Yumiko Sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi Oshima <soshima@redhat.com>, Hideo Aoki <haoki@redhat.com>
In-Reply-To: <467750E9.4090808@hitachi.com>
References: <4676109F.8020202@us.ibm.com>  <467750E9.4090808@hitachi.com>
Content-Type: text/plain
Date: Tue, 19 Jun 2007 11:25:25 -0500
Message-Id: <1182270325.30702.87.camel@ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-19 at 12:43 +0900, Masami Hiramatsu wrote:
> Hi David and Tom,
> 
> David Wilder wrote:
> > This patch fixes a bug in the relay read interface causing the number
> > of consumed bytes to be set incorrectly. 
> 
> Thank you. Your patch fixes one of my concerns.
> However there is another bug I found.
> When I use relayfs with "overwrite" mode, read() still set incorrect
> number of consumed bytes.
> I tried to fix that. Please review it.

Hi,

I haven't had a chance to test it myself yet, but it looks ok to me,
except for one problem noted below...

Thanks for fixing it.

> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
> ---
>  kernel/relay.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.22-rc4-mm2/kernel/relay.c
> ===================================================================
> --- linux-2.6.22-rc4-mm2.orig/kernel/relay.c	2007-06-13 20:22:02.000000000 +0900
> +++ linux-2.6.22-rc4-mm2/kernel/relay.c	2007-06-18 23:00:54.000000000 +0900
> @@ -812,7 +812,10 @@
>  	}
> 
>  	buf->bytes_consumed += bytes_consumed;
> -	read_subbuf = read_pos / buf->chan->subbuf_size;
> +	if (!read_pos)
> +		read_subbuf = buf->subbufs_consumed;

I think this should be instead:

+		read_subbuf = buf->subbufs_consumed % n_subbufs;

Tom


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


