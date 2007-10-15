Return-Path: <linux-kernel-owner+w=401wt.eu-S933617AbXJOT4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617AbXJOT4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 15:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933313AbXJOT4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 15:56:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51561 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933295AbXJOT4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 15:56:18 -0400
Date: Mon, 15 Oct 2007 12:49:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anton Arapov <aarapov@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-netdev@vger.kernel.org,
       davem@redhat.com, jgarzik@redhat.com
Subject: Re: [PATCH] ipv4: kernel panic when only one unsecured port
 available
Message-Id: <20071015124919.30ed8f06.akpm@linux-foundation.org>
In-Reply-To: <m3fy0k9yod.fsf@bandura.englab.brq.redhat.com>
References: <m3fy0k9yod.fsf@bandura.englab.brq.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Oct 2007 15:59:14 +0200
Anton Arapov <aarapov@redhat.com> wrote:

> Steps to reproduce:
> Server:
>   [root@server ~]# cat /etc/exports
>   /export *(ro,insecure)
> // there is insecure ... I am using ports like "1024 to 61000"
>   [root@server ~] service nfs restart 
> 
> Client:
>   1.[root@client ~]# echo 32768 32768 > /proc/sys/net/ipv4/ip_local_port_range
>   32768   32768
> // two same numbers, for ex "32769 32769" etc.
>   2.[root@client ~]# cat /proc/sys/net/ipv4/ip_local_port_range
>   32768   32768
>   3.[root@client ~]# mount server:/export /import
>   
> Actual results:
>   Kernel always panics 
> 
> --------------------------------------------------------------------
> [PATCH] ipv4: kernel panic when only one unsecured port available
> 
>   Patch prevents division by zero. Kernel panics if only one 
> unsecured port available.
> 
> Signed-off-by: Anton Arapov <aarapov@redhat.com>
> ---
> 
>  net/ipv4/inet_connection_sock.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index fbe7714..00ad079 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -80,7 +80,7 @@ int inet_csk_get_port(struct inet_hashinfo *hashinfo,
>  		int low = sysctl_local_port_range[0];
>  		int high = sysctl_local_port_range[1];
>  		int remaining = (high - low) + 1;
> -		int rover = net_random() % (high - low) + low;
> +		int rover = net_random() % remaining + low;
>  
>  		do {
>  			head = &hashinfo->bhash[inet_bhashfn(rover, hashinfo->bhash_size)];
> 

This code has recently been reworked, but from my reading, that
divide-by-zero can still occur.  And given that the numbers in
/proc/sys/net/ipv4/ip_local_port_range are inclusive, the arithmetic in
inet_csk_get_port() seems to just be wrong?

So we have this, against David's current devel tree:

--- a/net/ipv4/inet_connection_sock.c~ipv4-kernel-panic-when-only-one-unsecured-port-available
+++ a/net/ipv4/inet_connection_sock.c
@@ -93,7 +93,7 @@ int inet_csk_get_port(struct inet_hashin
 		int remaining, rover, low, high;
 
 		inet_get_local_port_range(&low, &high);
-		remaining = high - low;
+		remaining = high - low + 1;
 		rover = net_random() % remaining + low;
 
 		do {
_


btw, mime-mangled gpg-fancified emails are rather a pain to handle at the
receivnig end.  Good old text/plain works better, please.
