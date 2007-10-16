Return-Path: <linux-kernel-owner+w=401wt.eu-S933860AbXJPOsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933860AbXJPOsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 10:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932549AbXJPOsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 10:48:45 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:39455 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387AbXJPOsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 10:48:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:x-url:organization:user-agent:sender;
        b=EEgrWXk5QnxVJKNookVqP2jgvp7p+EDzfaRTLoypgHYh4cbHSqyszdoWSHZpkRzt84lD6Jbi+jXnt3szvqCawdqdYZJSbsjZrnRYMdtJM4cEhgcQBN3NUu61KhJdgl+nDFVgyJKLbmku/mPruAker2RZK8JVtBoq328XelAtzbs=
Date: Tue, 16 Oct 2007 12:48:30 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Gerrit Renker <gerrit@erg.abdn.ac.uk>,
       Ian McDonald <ian.mcdonald@jandi.co.nz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] net/DCCP: fix link error with !CONFIG_SYSCTL
Message-ID: <20071016144830.GA9773@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	"David S. Miller" <davem@davemloft.net>,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	Gerrit Renker <gerrit@erg.abdn.ac.uk>,
	Ian McDonald <ian.mcdonald@jandi.co.nz>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20071015161113.GA569@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015161113.GA569@elte.hu>
X-Url: http://oops.ghostprotocols.net:81/blog
Organization: OOPS Labs
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Oct 15, 2007 at 06:11:13PM +0200, Ingo Molnar escreveu:
> Subject: net/DCCP: fix link error with !CONFIG_SYSCTL
> From: Ingo Molnar <mingo@elte.hu>
> 
> do not define the sysctl_dccp_sync_ratelimit sysctl variable in
> the CONFIG_SYSCTL dependent sysctl.c module - move it to input.c instead.
> 
> this fixes the following build bug:
> 
>  net/built-in.o: In function `dccp_check_seqno':
>  input.c:(.text+0xbd859): undefined reference to `sysctl_dccp_sync_ratelimit'
>  distcc[29953] ERROR: compile (null) on localhost failed
>  make: *** [vmlinux] Error 1
> 
> found via 'make randconfig' build testing.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Thanks Ingo, David, please apply.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

> ---
>  net/dccp/input.c  |    3 +++
>  net/dccp/sysctl.c |    3 ---
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> Index: linux/net/dccp/input.c
> ===================================================================
> --- linux.orig/net/dccp/input.c
> +++ linux/net/dccp/input.c
> @@ -19,6 +19,9 @@
>  #include "ccid.h"
>  #include "dccp.h"
>  
> +/* rate-limit for syncs in reply to sequence-invalid packets; RFC 4340, 7.5.4 */
> +int sysctl_dccp_sync_ratelimit	__read_mostly = HZ / 8;
> +
>  static void dccp_fin(struct sock *sk, struct sk_buff *skb)
>  {
>  	sk->sk_shutdown |= RCV_SHUTDOWN;
> Index: linux/net/dccp/sysctl.c
> ===================================================================
> --- linux.orig/net/dccp/sysctl.c
> +++ linux/net/dccp/sysctl.c
> @@ -18,9 +18,6 @@
>  #error This file should not be compiled without CONFIG_SYSCTL defined
>  #endif
>  
> -/* rate-limit for syncs in reply to sequence-invalid packets; RFC 4340, 7.5.4 */
> -int sysctl_dccp_sync_ratelimit	__read_mostly = HZ / 8;
> -
>  static struct ctl_table dccp_default_table[] = {
>  	{
>  		.procname	= "seq_window",
