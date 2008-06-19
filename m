Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbYFSC3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbYFSC3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 22:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbYFSC3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 22:29:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44178 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbYFSC3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 22:29:24 -0400
From: Neil Brown <neilb@suse.de>
To: Jeff Layton <jlayton@redhat.com>
Date: Thu, 19 Jun 2008 12:29:16 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18521.50300.572838.123366@notabene.brown>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH - take 2] knfsd: nfsd: Handle ERESTARTSYS from syscalls.
In-Reply-To: message from Jeff Layton on Wednesday June 18
References: <20080619101025.24263.patches@notabene>
	<1080619001109.24338@suse.de>
	<20080618210947.2110a541@tleilax.poochiereds.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday June 18, jlayton@redhat.com wrote:
> 
> No objection to the patch, but what signal was being sent to nfsd when
> you saw this? If it's anything but a SIGKILL, then I wonder if we have
> a race that we need to deal with. My understanding is that we have nfsd
> flip between 2 sigmasks to prevent anything but a SIGKILL from being
> delivered while we're handling the local filesystem operation.

SuSE /etc/init.d/nfsserver does

        killproc -n -KILL nfsd 

so it looks like a SIGKILL.


> 
> From nfsd():
> 
> ----------[snip]-----------
>                 sigprocmask(SIG_SETMASK, &shutdown_mask, NULL);
> 
>                 /*
>                  * Find a socket with data available and call its
>                  * recvfrom routine.
>                  */
>                 while ((err = svc_recv(rqstp, 60*60*HZ)) == -EAGAIN)
>                         ;
>                 if (err < 0)
>                         break;
>                 update_thread_usage(atomic_read(&nfsd_busy));
>                 atomic_inc(&nfsd_busy);
> 
>                 /* Lock the export hash tables for reading. */
>                 exp_readlock();
> 
>                 /* Process request with signals blocked.  */
>                 sigprocmask(SIG_SETMASK, &allowed_mask, NULL);
> 
>                 svc_process(rqstp);
> 
> ----------[snip]-----------
> 
> What happens if this catches a SIGINT after the err<0 check, but before
> the mask is set to allowed_mask? Does svc_process() then get called with
> a signal pending?

Yes, I suspect it does.

I wonder why we have all this mucking about this signal masks anyway.
Anyone have any ideas about what it actually achieves?

NeilBrown
