Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbYJMG5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbYJMG5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 02:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbYJMG5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 02:57:45 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59424 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbYJMG5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 02:57:45 -0400
Subject: Re: [PROBLEM] hard-lock with kmemtrace, relayfs, and splice
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Tom Zanussi <zanussi@comcast.net>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org
In-Reply-To: <1223701131.7489.25.camel@charm-linux>
References: <20080923212914.GB5237@localhost>
	 <1223386477.28348.42.camel@penberg-laptop>
	 <1223623191.8959.26.camel@penberg-laptop>
	 <1223628687.8959.37.camel@penberg-laptop>
	 <1223629803.8959.40.camel@penberg-laptop>
	 <1223631723.8959.46.camel@penberg-laptop>
	 <1223701131.7489.25.camel@charm-linux>
Date: Mon, 13 Oct 2008 09:57:47 +0300
Message-Id: <1223881068.31587.1.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom,

On Fri, 2008-10-10 at 23:58 -0500, Tom Zanussi wrote:
> It looks like you hit the same problem as described here:
> 
> commit 8191ecd1d14c6914c660dfa007154860a7908857
> 
>     splice: fix infinite loop in generic_file_splice_read()
> 
> relay uses the same loop but it never got noticed or fixed.  Can you try
> the following patch:
> 
> diff --git a/kernel/relay.c b/kernel/relay.c
> index 8d13a78..6a4d439 100644
> --- a/kernel/relay.c
> +++ b/kernel/relay.c
> @@ -1318,12 +1318,9 @@ static ssize_t relay_file_splice_read(struct file *in,
>  		if (ret < 0)
>  			break;
>  		else if (!ret) {
> -			if (spliced)
> -				break;
> -			if (flags & SPLICE_F_NONBLOCK) {
> +			if (flags & SPLICE_F_NONBLOCK)
>  				ret = -EAGAIN;
> -				break;
> -			}
> +			break;
>  		}
>  
>  		*ppos += ret;
> 

Indeed. That fixes the deadlock.

However, now I don't get anything to the cpu*.out files if I run
kmemtraced with kmemtrace disabled. If I enable kmemtrace manually and
then run kmemtraced, I do receive some data. I did apply the
kmemtrace-user patch as well.

Hmm?

		Pekka

