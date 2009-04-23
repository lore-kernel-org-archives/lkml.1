Return-Path: <linux-kernel-owner+w=401wt.eu-S1760047AbZDWTPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760047AbZDWTPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757293AbZDWTPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:15:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45180 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757322AbZDWTPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:15:22 -0400
Date: Thu, 23 Apr 2009 20:15:16 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: Ingo Molnar <mingo@elte.hu>, Jonathan Corbet <corbet@lwn.net>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       LFSDEV <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 2/5 -tip] cifs: umount_begin BKL pushdown
Message-ID: <20090423191516.GV8633@ZenIV.linux.org.uk>
References: <1240513925-5603-1-git-send-email-abogani@texware.it> <1240513925-5603-2-git-send-email-abogani@texware.it> <1240513925-5603-3-git-send-email-abogani@texware.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240513925-5603-3-git-send-email-abogani@texware.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 09:12:02PM +0200, Alessio Igor Bogani wrote:
>  	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
>  	struct cifsTconInfo *tcon;
>  
> -	if (cifs_sb == NULL)
> +	lock_kernel();
> +
> +	if (cifs_sb == NULL) {
> +		unlock_kernel();
>  		return;
> +	}

Huh?  Why would a bleeding *local* *variable* care about BKL at all?

>  	tcon = cifs_sb->tcon;
> -	if (tcon == NULL)
> +	if (tcon == NULL) {
> +		unlock_kernel();
>  		return;
> +	}
>  
>  	read_lock(&cifs_tcp_ses_lock);
>  	if (tcon->tc_count == 1)
>  		tcon->tidStatus = CifsExiting;
>  	read_unlock(&cifs_tcp_ses_lock);
>  
> +	unlock_kernel();
> +
>  	/* cancel_brl_requests(tcon); */ /* BB mark all brl mids as exiting */
>  	/* cancel_notify_requests(tcon); */

... and why would the rest of it *not* care?

>  	if (tcon->ses && tcon->ses->server) {
> -- 
> 1.6.0.4
> 
