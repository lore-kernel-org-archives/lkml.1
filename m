Return-Path: <linux-kernel-owner+w=401wt.eu-S1760176AbZDWTTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176AbZDWTTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758051AbZDWTTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:19:37 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:58194 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbZDWTTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:19:36 -0400
Date: Thu, 23 Apr 2009 13:19:35 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: Ingo Molnar <mingo@elte.hu>, Jonathan Corbet <corbet@lwn.net>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       LFSDEV <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 2/5 -tip] cifs: umount_begin BKL pushdown
Message-ID: <20090423191934.GW1926@parisc-linux.org>
References: <1240513925-5603-1-git-send-email-abogani@texware.it> <1240513925-5603-2-git-send-email-abogani@texware.it> <1240513925-5603-3-git-send-email-abogani@texware.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240513925-5603-3-git-send-email-abogani@texware.it>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 09:12:02PM +0200, Alessio Igor Bogani wrote:
> @@ -525,18 +526,26 @@ static void cifs_umount_begin(struct super_block *sb)
>  	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
>  	struct cifsTconInfo *tcon;
>  
> -	if (cifs_sb == NULL)
> +	lock_kernel();
> +
> +	if (cifs_sb == NULL) {
> +		unlock_kernel();
>  		return;

OK, what are you doing here?  Either the BKL protects the sb here,
and you need to lock_kernel() before calling CIFS_SB(sb), or the BKL
protects nothing, and the lock_kernel() should be moved down below the
test for cifs_sb.

> +	}
>  
>  	tcon = cifs_sb->tcon;
> -	if (tcon == NULL)
> +	if (tcon == NULL) {
> +		unlock_kernel();
>  		return;
> +	}

Likewise -- does cifs rely on the BKL to protect the 'tcon' or not?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
