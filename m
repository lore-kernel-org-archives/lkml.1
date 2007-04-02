Return-Path: <linux-kernel-owner+w=401wt.eu-S932738AbXDBP4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738AbXDBP4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 11:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933030AbXDBP4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 11:56:36 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46412 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932738AbXDBP4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 11:56:36 -0400
Message-ID: <46112763.9070205@us.ibm.com>
Date: Mon, 02 Apr 2007 10:55:15 -0500
From: "Steve French (smfltc)" <smfltc@us.ibm.com>
User-Agent: Mozilla Thunderbird 1.0 (Windows/20041206)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Wilhelm Meier <wilhelm.meier@fh-kl.de>
CC: linux-cifs-client@lists.samba.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: cifs and kthread_run / kernel_thread
References: <20070331120030.BE6A916387F@lists.samba.org> <4610B80F.9020102@mail.ru> <200704021058.37987.wilhelm.meier@fh-kl.de> <200704021740.48668.wilhelm.meier@fh-kl.de>
In-Reply-To: <200704021740.48668.wilhelm.meier@fh-kl.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wilhelm Meier wrote:

>m Montag, 2. April 2007 schrieb Wilhelm Meier:
>  
>
>>>It seems to me that I rewrote cifs_demultiplex_thread to use kthread_run
>>>in DFS patch.
>>>      
>>>
>>o.k., I found the patch on the list. Will do some testing with it.
>>    
>>
>
>o.k., the patch seems to be fine for linux-vserver. cifs-mounting inside the 
>guest is now possible.
>
>Do you see any possiblility to include this part of Igors work (not the whole 
>DFS thing) to the mainline? It fixes the use of the deprecated api.
>
>-
>Wilhelm
>  
>
>------------------------------------------------------------------------
>
>Index: connect.c
>===================================================================
>--- connect.c	(.../2.6.19.1)	(revision 20)
>+++ connect.c	(.../kthread_support)	(revision 20)
>@@ -30,6 +30,7 @@
> #include <linux/mempool.h>
> #include <linux/delay.h>
> #include <linux/completion.h>
>+#include <linux/kthread.h>
> #include <linux/pagevec.h>
> #include <asm/uaccess.h>
> #include <asm/processor.h>
>@@ -119,7 +120,7 @@
> 	struct mid_q_entry * mid_entry;
> 	
> 	spin_lock(&GlobalMid_Lock);
>-	if(server->tcpStatus == CifsExiting) {
>+	if( kthread_should_stop() ) {
> 		/* the demux thread will exit normally 
> 		next time through the loop */
> 		spin_unlock(&GlobalMid_Lock);
>@@ -181,7 +182,7 @@
> 	spin_unlock(&GlobalMid_Lock);
> 	up(&server->tcpSem); 
>
>-	while ((server->tcpStatus != CifsExiting) && (server->tcpStatus != CifsGood))
>+	while ( (!kthread_should_stop()) && (server->tcpStatus != CifsGood))
> 	{
> 		try_to_freeze();
> 		if(server->protocolType == IPV6) {
>@@ -198,7 +199,7 @@
> 		} else {
> 			atomic_inc(&tcpSesReconnectCount);
> 			spin_lock(&GlobalMid_Lock);
>-			if(server->tcpStatus != CifsExiting)
>+			if( !kthread_should_stop() )
> 				server->tcpStatus = CifsGood;
> 			server->sequence_number = 0;
> 			spin_unlock(&GlobalMid_Lock);			
>@@ -344,7 +345,6 @@
> 	int isMultiRsp;
> 	int reconnect;
>
>-	daemonize("cifsd");
> 	allow_signal(SIGKILL);
> 	current->flags |= PF_MEMALLOC;
> 	server->tsk = current;	/* save process info to wake at shutdown */
>@@ -360,7 +360,7 @@
> 			GFP_KERNEL);
> 	}
>
>-	while (server->tcpStatus != CifsExiting) {
>+	while (!kthread_should_stop()) {
> 		if (try_to_freeze())
> 			continue;
> 		if (bigbuf == NULL) {
>@@ -399,7 +399,7 @@
> 		    kernel_recvmsg(csocket, &smb_msg,
> 				 &iov, 1, 4, 0 /* BB see socket.h flags */);
>
>-		if (server->tcpStatus == CifsExiting) {
>+		if ( kthread_should_stop() ) {
> 			break;
> 		} else if (server->tcpStatus == CifsNeedReconnect) {
> 			cFYI(1, ("Reconnect after server stopped responding"));
>@@ -523,7 +523,7 @@
> 		     total_read += length) {
> 			length = kernel_recvmsg(csocket, &smb_msg, &iov, 1,
> 						pdu_length - total_read, 0);
>-			if((server->tcpStatus == CifsExiting) ||
>+			if( kthread_should_stop() ||
> 			    (length == -EINTR)) {
> 				/* then will exit */
> 				reconnect = 2;
>@@ -756,7 +756,6 @@
> 			GFP_KERNEL);
> 	}
> 	
>-	complete_and_exit(&cifsd_complete, 0);
> 	return 0;
> }
>
>@@ -1779,10 +1778,11 @@
> 			so no need to spinlock this init of tcpStatus */
> 			srvTcp->tcpStatus = CifsNew;
> 			init_MUTEX(&srvTcp->tcpSem);
>-			rc = (int)kernel_thread((void *)(void *)cifs_demultiplex_thread, srvTcp,
>-				      CLONE_FS | CLONE_FILES | CLONE_VM);
>-			if(rc < 0) {
>-				rc = -ENOMEM;
>+			srvTcp->tsk = kthread_run((void *)(void *)cifs_demultiplex_thread, srvTcp, "cifsd");
>+			if( IS_ERR(srvTcp->tsk) ) {
>+				rc = PTR_ERR(srvTcp->tsk);
>+				cERROR(1,("error %d create cifsd thread", rc));
>+				srvTcp->tsk = NULL;
> 				sock_release(csocket);
> 				kfree(volume_info.UNC);
> 				kfree(volume_info.password);
>@@ -1973,7 +1973,7 @@
> 			spin_unlock(&GlobalMid_Lock);
> 			if(srvTcp->tsk) {
> 				send_sig(SIGKILL,srvTcp->tsk,1);
>-				wait_for_completion(&cifsd_complete);
>+				kthread_stop(srvTcp->tsk);
> 			}
> 		}
> 		 /* If find_unc succeeded then rc == 0 so we can not end */
>@@ -1987,9 +1987,9 @@
> 					temp_rc = CIFSSMBLogoff(xid, pSesInfo);
> 					/* if the socketUseCount is now zero */
> 					if((temp_rc == -ESHUTDOWN) &&
>-					   (pSesInfo->server->tsk)) {
>+					   (pSesInfo->server) && (pSesInfo->server->tsk)) {
> 						send_sig(SIGKILL,pSesInfo->server->tsk,1);
>-						wait_for_completion(&cifsd_complete);
>+						kthread_stop(pSesInfo->server->tsk);
> 					}
> 				} else
> 					cFYI(1, ("No session or bad tcon"));
>@@ -3273,7 +3273,7 @@
> 				cFYI(1,("Waking up socket by sending it signal"));
> 				if(cifsd_task) {
> 					send_sig(SIGKILL,cifsd_task,1);
>-					wait_for_completion(&cifsd_complete);
>+					kthread_stop(cifsd_task);
> 				}
> 				rc = 0;
> 			} /* else - we have an smb session
>  
>
Yes.   I can merge this today in cifs-2.6 development tree after I try 
it out (and to 2.6.22 when it opens up
soon).

I also plan to merge a somewhat simpler change tothe inet_pton related 
change that Q made, since that can be
pulled out to make the final dfs change smaller to finish review (but it 
requires an additional change to
fs/cifs/connect.c to recognize ipv6 connections)..
