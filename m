Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbZLBNYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbZLBNYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 08:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbZLBNYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 08:24:31 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:48274 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbZLBNYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 08:24:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=KVl0HQ9bYYWrlp5YFq2gN9TBQ3tz6KpKjH3hy2RQKnOmSI97owgHX/KfaVrVmDJEV8
         FUXah+6Dc3KtNAPcyoBeolvH3FE+uVk3Apj4HXKsGgJA6gMIW/c3/8QZHWo57l7+7+9G
         0V36wewYZFzqwpVIw37W0nqiYr+OMMeDbZ6iA=
Date: Wed, 2 Dec 2009 15:24:27 +0200
From: Dan Carpenter <error27@gmail.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [Patch] net: fix an array index overflow
Message-ID: <20091202132427.GE5224@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
References: <20091201082901.4678.16688.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091201082901.4678.16688.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 01, 2009 at 03:26:02AM -0500, Amerigo Wang wrote:
> 
> Don't use the address of an out-of-boundary element.
> 
> Maybe this is not harmful at runtime, but it is still
> good to improve it.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: David S. Miller <davem@davemloft.net>
> 

It may be coincidence but my static checker smatch also complains 
about the code you modified.

It's the wrong idea to fix code to please a checker.  You end up
doing things like adding an extra "return -ENOTREACHED" to silence
warnings.  Then the next person who writes a checker has to figure
out how to seperate the unreachable code which was added to suppress
gcc warnings from bits which are unreachable because of typos.

Really any code that a human can read, a static checker should also
be able to read.  Computer programs are just state machines.  At 
the function level they are quite small state machines.  It's all
logic and math which computers are very good at.  So it should be 
fairly easy to fix the checker.  ;)

(The above paragraph is funnier if you knew how sucky smatch is).

regards,
dan carpenter

> ---
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index 57737b8..2669361 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -1586,7 +1586,7 @@ static int __init inet_init(void)
>  #endif
>  
>  	/* Register the socket-side information for inet_create. */
> -	for (r = &inetsw[0]; r < &inetsw[SOCK_MAX]; ++r)
> +	for (r = &inetsw[0]; r <= &inetsw[SOCK_MAX-1]; ++r)
>  		INIT_LIST_HEAD(r);
>  
>  	for (q = inetsw_array; q < &inetsw_array[INETSW_ARRAY_LEN]; ++q)
