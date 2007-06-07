Return-Path: <linux-kernel-owner+w=401wt.eu-S1759662AbXFGM10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759662AbXFGM10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 08:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbXFGM1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 08:27:19 -0400
Received: from wine.ocn.ne.jp ([220.111.47.146]:61780 "EHLO
	smtp.wine.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088AbXFGM1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 08:27:18 -0400
X-Greylist: delayed 2793 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Jun 2007 08:27:18 EDT
To: linux-kernel@vger.kernel.org
Subject: [2.6.22-rc4] UDP's local port assignment not working correctly.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <200706072040.BEC00116.MQFFtSOVOHFOLJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50]
X-Accept-Language: ja,en
Date: Thu, 7 Jun 2007 20:40:39 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Same local ports are assigned to multiple sockets.
The following program should print different local port number.

----- Start of program -----
#include <stdio.h>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>

int main(int argc, char *argv[]) {
	struct sockaddr_in addr;
	socklen_t size = sizeof(addr);
	int server = socket(PF_INET, SOCK_DGRAM, 0), client = socket(PF_INET, SOCK_DGRAM, 0);
	addr.sin_family = AF_INET;
	addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
	addr.sin_port = htons(0);
	
	printf("Server: Binding UDP 127.0.0.1 0 ... ");
	bind(server, (struct sockaddr *) &addr, sizeof(addr));
	getsockname(server, (struct sockaddr *) &addr, &size);
	printf("bound to port %d\n", ntohs(addr.sin_port));
	
	printf("Client: Connecting UDP 127.0.0.1 %d ... ", ntohs(addr.sin_port));
	connect(client, (struct sockaddr *) &addr, sizeof(addr));
	getsockname(client, (struct sockaddr *) &addr, &size);
	printf("bound to port %d\n", ntohs(addr.sin_port));
	
	return 0;
}
----- End of program -----

I told YOSHIFUJI Hideaki and he answered me that
this is a regression caused by changing UDP's hash search algorithm to 2-pass.

Thanks.
