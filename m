Return-Path: <linux-kernel-owner+w=401wt.eu-S1765702AbYETQmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765702AbYETQmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 12:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758165AbYETQmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 12:42:31 -0400
Received: from gv-out-0910.google.com ([216.239.58.189]:35060 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829AbYETQma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 12:42:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ddBtiHSMEcOpeYNAdmyMnvgSPEcaKJ+gCASiLODIBVFvcL2I9eDeRtGvcSS29Yr2FPtM67KyGLNIzKTn5QzzZUqcx859HodHRepMb7vgX65sVzOBD2Ve4ZcAUkvS8YPF6c1jo3PcO8ESWCKHl/NiokWNpjQqZVVPyTNiPA5LS14=
Date: Tue, 20 May 2008 20:42:17 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Michael A. Halcrow" <mhalcrow@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] eCryptFS: mutex lock-unlock ordering fix
Message-ID: <20080520164217.GB6926@cvg>
References: <20080520163928.GA6926@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520163928.GA6926@cvg>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Tue, May 20, 2008 at 08:39:28PM +0400]
| We should lock/unlock mutexes by a proper way which means
| there should not be chains like ABAB but ABBA otherwise the
| race window is opened.
| 
| Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| CC: Michael A. Halcrow <mhalcrow@us.ibm.com>
| ---
| 
|  check_list:
[...]
|  	if (list_empty(&daemon->msg_ctx_out_queue)) {
NIT ---> | +		if (mutex_is_locked(&ecryptfs_daemon_hash_mux))
| +			mutex_unlock(&ecryptfs_daemon_hash_mux);
|  		mutex_unlock(&daemon->mux);
| -		rc = wait_event_interruptible(
| -			daemon->wait, !list_empty(&daemon->msg_ctx_out_queue));
| +		rc = wait_event_interruptible(daemon->wait,
| +			!list_empty(&daemon->msg_ctx_out_queue));
|  		mutex_lock(&daemon->mux);
|  		if (rc < 0) {
|  			rc = 0;
| @@ -357,6 +358,8 @@ out_unlock_msg_ctx:
|  out_unlock_daemon:
|  	daemon->flags &= ~ECRYPTFS_DAEMON_IN_READ;
|  	mutex_unlock(&daemon->mux);
| +	if (mutex_is_locked(&ecryptfs_daemon_hash_mux))
| +		mutex_unlock(&ecryptfs_daemon_hash_mux);
|  	return rc;
|  }
|  

It's a bit wrong (could release mutex being ack'ed by another thread)
will fix - please DROP this patch. Sorry!

		- Cyrill -
