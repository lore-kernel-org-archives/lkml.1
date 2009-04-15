Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125AbZDOPkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbZDOPkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 11:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbZDOPkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 11:40:20 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:46367 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbZDOPkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 11:40:18 -0400
Message-ID: <49E5FFD3.6090309@linux.vnet.ibm.com>
Date: Wed, 15 Apr 2009 10:40:03 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: kirkland@canonical.com, ecryptfs-devel@lists.launchpad.net,
       linux-fsdevel@vger.kernel.org,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       xatrix101@gmail.com
Subject: Re: ecryptfs lock loop
References: <49E4E5A4.80109@gmail.com>
In-Reply-To: <49E4E5A4.80109@gmail.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=5D35E502
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> Hi,
> 
> one student (in CC) found out a suspicioous locking dependence in
> ecryptfs code while debugging/running a static lockdep analyzer.
> 
> I'm unable to say whether it is only a theoretical issue or a real bug,
> any ideas?

Hi Jiri - This looks to be a real bug.  Thanks for pointing it out!

> 
> Here it comes:
> 
> function ecryptfs_send_message:
> ------------------------------
> ecryptfs_daemon_hash_mux <- ecryptfs_msg_ctx_lists_mux
> (in function ecryptfs_send_message_locked)

It would be nice if we could keep from having to hold the
ecryptfs_daemon_hash_mux for the entire execution of
ecryptfs_send_message_locked().  Maybe we could just hold it in
ecryptfs_send_message(), while it calls ecryptfs_find_daemon_by_euid().
 I think we would need to grab the daemon->mux before releasing the
ecryptfs_daemon_hash_mux to make sure that a QUIT message wasn't
received and the daemon freed before we add the msg_ctx to the
daemon->msg_ctx_out_queue in ecryptfs_send_miscdev().

It would remove the first lock dependency you pointed out, but I'll need
some more time to determine if it creates another bad lock loop.  Thanks
again!

Tyler

> 
> function ecryptfs_wait_for_response:
> -----------------------------------
> cryptfs_msg_ctx_lists_mux <- msg_ctx->mux
> 
> function ecryptfs_process_response:
> ----------------------------------
> msg_ctx->mux <- ecryptfs_daemon_hash_mux
> 
> 
> <- means lock dependency

