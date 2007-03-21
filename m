Return-Path: <linux-kernel-owner+w=401wt.eu-S933330AbXCUSUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330AbXCUSUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 14:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933339AbXCUSUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 14:20:14 -0400
Received: from smtp.telefonica.net ([213.4.149.66]:50892 "EHLO
	ctsmtpout3.frontal.correo" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933330AbXCUSUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 14:20:12 -0400
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: linux-kernel@vger.kernel.org
Subject: Problem with sockets an 2.6.21-rc4 kernel
Date: Wed, 21 Mar 2007 19:20:07 +0100
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_XdXAGVDKC3RNvEJ"
Message-Id: <200703211920.07296.jareguero@telefonica.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_XdXAGVDKC3RNvEJ
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I had two python programs, server.py and client.py(attached)

With server.py in  a kernel 2.6.21-rc4 x86_64 and client.py in the same 
machine,  server.py get the message.

With server.py in  a kerner 2.6.21-rc4 x86_64 and client.py in another 
machine, server.py don't get the message.

The same with the programs in c(attached).

With kernel 2.6.20.3 the programs work well.
Thanks.

Jose Alberto

--Boundary-00=_XdXAGVDKC3RNvEJ
Content-Type: application/x-python;
  name="client.py"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="client.py"

# Echo client program
import socket

mcast_adress = "227.234.253.9"
port = 15922

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_UDP)
s.sendto('Hello, world', (mcast_adress, port))
s.close()

--Boundary-00=_XdXAGVDKC3RNvEJ
Content-Type: text/x-csrc;
  charset="us-ascii";
  name="client.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="client.c"

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

--Boundary-00=_XdXAGVDKC3RNvEJ
Content-Type: text/x-csrc;
  charset="us-ascii";
  name="server.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="server.c"

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

--Boundary-00=_XdXAGVDKC3RNvEJ
Content-Type: application/x-python;
  name="server.py"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="server.py"

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

--Boundary-00=_XdXAGVDKC3RNvEJ--
