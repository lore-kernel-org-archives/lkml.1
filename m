Return-Path: <linux-kernel-owner+w=401wt.eu-S1753348AbXCYMWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbXCYMWG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 08:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbXCYMWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 08:22:06 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33945 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753348AbXCYMWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 08:22:04 -0400
Date: Sun, 25 Mar 2007 14:22:07 +0200
From: Adrian Bunk <bunk@stusta.de>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, jareguero@telefonica.net,
       oliver.pntr@gmail.com, g3vbv@blueyonder.co.uk
Subject: Re: [1/5] 2.6.21-rc4: known regressions (v2)
Message-ID: <20070325122207.GC16477@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070323184816.GO752@stusta.de> <20070324.214509.98750566.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <20070324.214509.98750566.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Sat, Mar 24, 2007 at 09:45:09PM -0700, David Miller wrote:
> From: Adrian Bunk <bunk@stusta.de>
> Date: Fri, 23 Mar 2007 19:48:17 +0100
> 
> > Subject    : problem with sockets
> > References : http://lkml.org/lkml/2007/3/21/248
> > Submitter  : Jose Alberto Reguero <jareguero@telefonica.net>
> > Status     : unknown
> 
> Not enough information in his report, for example for the
> case he says does not work he fails to indicate what kernel
> or system type the Client runs on.
> 
> Furthermore, his scripts don't even execute properly when
> I try to run them myself, for example server.py gives me
> this syntax error when python tries to parse the script:
> 
> davem@sunset:~/src/GIT/net-2.6$ /usr/bin/python server.py
>   File "server.py", line 9
>     struct sockaddr_in ServerAddr;
>                      ^
> SyntaxError: invalid syntax
> 
> Can someone help de-crapify this bug report?

He described one Python and one C example, and attached 2+2 programs.

The mailing list archive I quoted only contains the C files and doesn't 
display the Python files with the error message
"unhandled content-type:application/x-python" - but that's not the fault 
of the submitter, the bug report itself is OK.

I've attached all 4 files to this email.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


--+QahgC5+KEYLbs62
Content-Type: text/x-python; charset=utf-8
Content-Disposition: attachment; filename="client.py"

# Echo client program
import socket

mcast_adress = "227.234.253.9"
port = 15922

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_UDP)
s.sendto('Hello, world', (mcast_adress, port))
s.close()

--+QahgC5+KEYLbs62
Content-Type: text/x-python; charset=utf-8
Content-Disposition: attachment; filename="server.py"

# Echo server program
import socket
import struct

HOST = ''                 # Symbolic name meaning the local host
PORT = 15922              # Arbitrary non-privileged port
mcast_adress = "227.234.253.9"

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_UDP)
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
s.bind((HOST, PORT))
mreq = struct.pack('4si', socket.inet_aton(mcast_adress), socket.INADDR_ANY)
s.setsockopt(socket.IPPROTO_IP, socket.IP_ADD_MEMBERSHIP, mreq)
data = s.recv(1024)
if (data):
    print (data)
s.close()

--+QahgC5+KEYLbs62
Content-Type: text/x-csrc; charset=utf-8
Content-Disposition: attachment; filename="client.c"

#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>

main()
{
	int sock = socket (AF_INET, SOCK_DGRAM, IPPROTO_UDP);
	struct sockaddr_in ClientAddr;
	memset(&ClientAddr, 0, sizeof(ClientAddr));
	ClientAddr.sin_family = AF_INET;
	ClientAddr.sin_addr.s_addr = inet_addr("227.234.253.9");
	int port = 15922;
	ClientAddr.sin_port = htons((short) port);
	char str[] = "Hello, world";
	sendto(sock, str, strlen(str), 0, (struct sockaddr *)&ClientAddr, sizeof(ClientAddr));
	close(sock);
}

--+QahgC5+KEYLbs62
Content-Type: text/x-csrc; charset=utf-8
Content-Disposition: attachment; filename="server.c"

#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string.h>
#include <stdio.h>

main()
{
        struct sockaddr_in ServerAddr;
        int sock = socket (AF_INET, SOCK_DGRAM, IPPROTO_UDP);
        int reuse = 1;
        setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &reuse, sizeof(int));
        memset(&ServerAddr, 0, sizeof(ServerAddr));
        ServerAddr.sin_family = AF_INET;
        ServerAddr.sin_addr.s_addr = htonl(INADDR_ANY);
        int port = 15922;
        ServerAddr.sin_port = htons((short) port);
        bind(sock, (struct sockaddr *)&ServerAddr, sizeof(ServerAddr));
        struct ip_mreq mreq;
	memset(&mreq, 0, sizeof(mreq));
        mreq.imr_multiaddr.s_addr = inet_addr("227.234.253.9");
	mreq.imr_interface.s_addr = htonl(INADDR_ANY);
        setsockopt(sock, IPPROTO_IP, IP_ADD_MEMBERSHIP, &mreq, sizeof(mreq));
        char str[100];
	memset(&str, 0, sizeof(str));
        recv(sock, str, 100, 0);
        printf(":%s:\n", str);
	close (sock);
}

--+QahgC5+KEYLbs62--
