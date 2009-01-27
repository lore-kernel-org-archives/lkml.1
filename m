Return-Path: <linux-kernel-owner+w=401wt.eu-S1752156AbZA0Wdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbZA0Wdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 17:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbZA0Wd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 17:33:27 -0500
Received: from mail.fieldses.org ([141.211.133.115]:48945 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbZA0WdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 17:33:25 -0500
Date: Tue, 27 Jan 2009 17:33:25 -0500
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
       teigland@redhat.com
Subject: Re: [PATCH 2/2] nfsd: only set file_lock.fl_lmops in nfsd4_lockt
	if a stateowner is found
Message-ID: <20090127223325.GK9151@fieldses.org>
References: <1232651764-10799-1-git-send-email-jlayton@redhat.com> <1232651764-10799-3-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232651764-10799-3-git-send-email-jlayton@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 02:16:04PM -0500, Jeff Layton wrote:
> nfsd4_lockt does a search for a lockstateowner when building the lock
> struct to test. If one is found, it'll set fl_owner to it. Regardless of
> whether that happens, it'll also set fl_lmops. Given that this lock is
> basically a "lightweight" lock that's just used for checking conflicts,
> setting fl_lmops is probably not appropriate for it.
> 
> This behavior exposed a bug in DLM's GETLK implementation where it
> wasn't clearing out the fields in the file_lock before filling in
> conflicting lock info. While we were able to fix this in DLM, it
> still seems pointless and dangerous to set the fl_lmops this way
> when we may have a NULL lockstateowner.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>

Thanks, applied.--b.

> ---
>  fs/nfsd/nfs4state.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
> index 88db7d3..b6f60f4 100644
> --- a/fs/nfsd/nfs4state.c
> +++ b/fs/nfsd/nfs4state.c
> @@ -2871,7 +2871,6 @@ nfsd4_lockt(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
>  		file_lock.fl_owner = (fl_owner_t)lockt->lt_stateowner;
>  	file_lock.fl_pid = current->tgid;
>  	file_lock.fl_flags = FL_POSIX;
> -	file_lock.fl_lmops = &nfsd_posix_mng_ops;
>  
>  	file_lock.fl_start = lockt->lt_offset;
>  	file_lock.fl_end = last_byte_offset(lockt->lt_offset, lockt->lt_length);
> -- 
> 1.5.5.6
> 
