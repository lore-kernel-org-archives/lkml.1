Return-Path: <linux-kernel-owner+w=401wt.eu-S1758630AbZLGStV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630AbZLGStV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 13:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758119AbZLGStU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 13:49:20 -0500
Received: from exprod7og113.obsmtp.com ([64.18.2.179]:38799 "HELO
	exprod7og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757860AbZLGStT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 13:49:19 -0500
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Dec 2009 13:49:18 EST
From: "Jacques, Hugo" <Hugo.Jacques@verint.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Jacques, Hugo" <Hugo.Jacques@verint.com>
Date: Mon, 7 Dec 2009 13:43:00 -0500
Subject: Error in SEND(2) man page ?
Thread-Topic: Error in SEND(2) man page ?
Thread-Index: Acp3bRotwJDtdyu+SUm0y0Rk60tvJw==
Message-ID: <579B119545DAEF4689C8FBEEFEC5793F01FA2F6FC6C8@ATLMBX.verint.corp.verintsystems.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I think I found a discrepancy between the man page of send()and the actual implementation.

Man page mentions that:

"[...] When the message does not fit into the send buffer of the socket, send() normally blocks, unless the socket has been placed in non-blocking I/O mode. In non-blocking mode it would fail with the error EAGAIN or EWOULDBLOCK in this case.  [...]"

This tells me that if doing a send() on a tcp non-blocking socket whose send buffer is full, the call should return with -1 and errno=EAGAIN.

But running a trivial test app (code below), send() will indicate (return value) that is sent some but not all of the data buffer when the socket's send buffer is full.

Am I missing anything?
Is the man page or the code wrong?

Please CC answers/comments to me personally (I am not a lkml subscriber)

Thanks,

Hugo Jacques

Sample code: 

#include <sys/socket.h>
#include <arpa/inet.h>
#include <string.h>
#include <pthread.h>
#include <stdio.h>

#define MY_IP_ADDR 0x7F000001
#define MY_PORT 12345
#define MY_CHUNK_SIZE 100

static int server_ready = 0;

static void* server_function(void* arg)
{
	struct sockaddr_in serv_addr;
	int conn_socket = -1;	
	/* server socket */	
	int serv_socket= socket(AF_INET,SOCK_STREAM,0);	   	
   	memset(&serv_addr, 0, sizeof(struct sockaddr_in));
   	serv_addr.sin_family = AF_INET;
   	serv_addr.sin_port   = htons(MY_PORT);
   	serv_addr.sin_addr.s_addr = htonl(MY_IP_ADDR);		
	bind(serv_socket,(struct sockaddr*)&serv_addr,sizeof(serv_addr));	
	listen(serv_socket,1);	
	server_ready = 1;
	conn_socket = accept(serv_socket,NULL,NULL);	
	if (conn_socket != 1)
	{
		printf("got connection on socket %d\n",conn_socket);		
		while(1)
		{		
			sleep(1);
		}			
	}							
}	

int main(void)
{
	pthread_t thread;
	int client_socket = -1;
	struct sockaddr_in client_addr;
	int ret = -1;
	int bytes_sent = 0;
		
	pthread_create(&thread,NULL,&server_function,NULL);
	
	/* lazy wait for the server to be ready */
	while (!server_ready)
	{
		sleep(1);		
	}		
	printf("Connecting to server\n");	
	client_socket = socket(AF_INET,SOCK_STREAM,0);	
   	memset(&client_addr, 0, sizeof(struct sockaddr_in));
   	client_addr.sin_family = AF_INET;
   	client_addr.sin_port   = htons(MY_PORT);
   	client_addr.sin_addr.s_addr = htonl(INADDR_ANY);	
	ret = connect(	client_socket,
			(struct sockaddr*)&client_addr,
			sizeof(client_addr));
	if (ret != 0)
		perror("connect failed\n");	
	printf("Connected to server\n");
	
	/* send data in chunks to server */
	while (1)
	{
		char data[MY_CHUNK_SIZE];		
		/* send data in non-blocking manner */
		int send_ret = send(	client_socket,
					data,
					MY_CHUNK_SIZE,
					MSG_DONTWAIT);
		
		if (send_ret != MY_CHUNK_SIZE)		
		{
			if (send_ret == -1)
				perror("send failed\n");			
			else
				printf("send returned %d while attempting to send %d bytes (total data sent=%d)\n",send_ret,MY_CHUNK_SIZE,bytes_sent+send_ret);
			break;				
		}
		else
			bytes_sent+=MY_CHUNK_SIZE;
	}		
	return 0;	
}
This electronic message may contain proprietary and confidential information of Verint Systems Inc., its affiliates and/or subsidiaries.
The information is intended to be for the use of the individual(s) or
entity(ies) named above.  If you are not the intended recipient (or authorized to receive this e-mail for the intended recipient), you may not use, copy, disclose or distribute to anyone this message or any information contained in this message.  If you have received this electronic message in error, please notify us by replying to this e-mail.

