Return-Path: <linux-kernel-owner+w=401wt.eu-S1946004AbXEAVzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946004AbXEAVzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946005AbXEAVzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:55:32 -0400
Received: from mx1.suse.de ([195.135.220.2]:44696 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946004AbXEAVza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:55:30 -0400
From: Neil Brown <neilb@suse.de>
To: Jeff Layton <jlayton@redhat.com>
Date: Wed, 2 May 2007 07:54:57 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17975.46897.298001.690089@notabene.brown>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [NFS] [PATCH] RPC: add wrapper for svc_reserve to account for
	checksum
In-Reply-To: message from Jeff Layton on Tuesday May 1
References: <20070421131523.GA18100@dantu.rdu.redhat.com>
	<17974.41587.666167.650575@notabene.brown>
	<20070501170123.GB15222@salusa.poochiereds.net>
	<20070501171121.GC15222@salusa.poochiereds.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday May 1, jlayton@redhat.com wrote:
> 
> Resending patch with a proper signed-off-by line. Also cc'ing Andrew:

Thanks, but it isn't much good to Andrew without a changelog entry,
though probably it should just go in as
  rpc--add-wrapper-for-svc_reserve-to-account-for-checksum-fix

Acked-by: NeilBrown <neilb@suse.de>

(If it doesn't appear in the next -mm, I'll send it all nicely
formated and changeloged).

NeilBrown

> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> 
> diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
> index 9114f11..ed7cbf1 100644
> --- a/include/linux/sunrpc/svc.h
> +++ b/include/linux/sunrpc/svc.h
> @@ -399,10 +399,9 @@ char *		   svc_print_addr(struct svc_rqst *, char *, size_t);
>  /*
>   * When we want to reduce the size of the reserved space in the response
>   * buffer, we need to take into account the size of any checksum data that
> - * may be at the end of the packet. For now, just use a hardcoded value
> - * for each possible authflavor. This will need to be updated when new
> - * encryption types or algorithms are added, or we'll have to come up with
> - * a way to reasonably calculate this on the fly (maybe via a new auth_op).
> + * may be at the end of the packet. This is difficult to determine exactly
> + * for all cases without actually generating the checksum, so we just use a
> + * static value.
>   */
>  static inline void 
>  svc_reserve_auth(struct svc_rqst *rqstp, int space)
> @@ -411,7 +410,7 @@ svc_reserve_auth(struct svc_rqst *rqstp, int space)
>  
>  	switch(rqstp->rq_authop->flavour) {
>  		case RPC_AUTH_GSS:
> -			added_space = 56; /* determined empirically */
> +			added_space = RPC_MAX_AUTH_SIZE;
>  	}
>  	return svc_reserve(rqstp, space + added_space);
>  }
