Return-Path: <linux-kernel-owner+w=401wt.eu-S1760426AbXFGNSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760426AbXFGNSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 09:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753506AbXFGNSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 09:18:41 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:41366 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbXFGNSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 09:18:40 -0400
Date: Thu, 7 Jun 2007 15:18:39 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [2.6.22-rc4] UDP's local port assignment not working correctly.
Message-Id: <20070607151839.d8f1c164.dada1@cosmosbay.com>
In-Reply-To: <200706072040.BEC00116.MQFFtSOVOHFOLJ@I-love.SAKURA.ne.jp>
References: <200706072040.BEC00116.MQFFtSOVOHFOLJ@I-love.SAKURA.ne.jp>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007 20:40:39 +0900
Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:

> Hello.
> 
> Same local ports are assigned to multiple sockets.
> The following program should print different local port number.
> 
> ----- Start of program -----
> #include <stdio.h>
> #include <unistd.h>
> #include <sys/socket.h>
> #include <sys/types.h>
> #include <netinet/in.h>
> 
> int main(int argc, char *argv[]) {
> 	struct sockaddr_in addr;
> 	socklen_t size = sizeof(addr);
> 	int server = socket(PF_INET, SOCK_DGRAM, 0), client = socket(PF_INET, SOCK_DGRAM, 0);
> 	addr.sin_family = AF_INET;
> 	addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
> 	addr.sin_port = htons(0);
> 	
> 	printf("Server: Binding UDP 127.0.0.1 0 ... ");
> 	bind(server, (struct sockaddr *) &addr, sizeof(addr));
> 	getsockname(server, (struct sockaddr *) &addr, &size);
> 	printf("bound to port %d\n", ntohs(addr.sin_port));
> 	
> 	printf("Client: Connecting UDP 127.0.0.1 %d ... ", ntohs(addr.sin_port));
> 	connect(client, (struct sockaddr *) &addr, sizeof(addr));
> 	getsockname(client, (struct sockaddr *) &addr, &size);
> 	printf("bound to port %d\n", ntohs(addr.sin_port));
> 	
> 	return 0;
> }
> ----- End of program -----
> 
> I told YOSHIFUJI Hideaki and he answered me that
> this is a regression caused by changing UDP's hash search algorithm to 2-pass.
> 
> Thanks.

CC netdev

Yes, this was discovered two days ago and David reverted four commits.

http://git.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commitdiff;h=82c5fde20031375cd93fa5a247cf15603ea1f152

So it should probably be included in Linus tree very very soon.

