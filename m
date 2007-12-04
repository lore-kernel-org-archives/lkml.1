Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbXLDWna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbXLDWna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 17:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbXLDWnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 17:43:23 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:49879 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbXLDWnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 17:43:22 -0500
Date: Tue, 4 Dec 2007 15:43:21 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Liam Howlett <howlett@gmail.com>
Cc: linux-kernel@vger.kernel.org, neilb@suse.de, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Subject: Re: NFS Killable tasks request comments on patch
Message-ID: <20071204224321.GD14152@parisc-linux.org>
References: <20071204212543.GA6907@solidsnake>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204212543.GA6907@solidsnake>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 04:25:43PM -0500, Liam Howlett wrote:
> @@ -433,15 +433,11 @@ static int nfs_wait_schedule(void *word)
>   */
>  static int nfs_wait_on_inode(struct inode *inode)
>  {
> -	struct rpc_clnt	*clnt = NFS_CLIENT(inode);
>  	struct nfs_inode *nfsi = NFS_I(inode);
> -	sigset_t oldmask;
>  	int error;
>  
> -	rpc_clnt_sigmask(clnt, &oldmask);
>  	error = wait_on_bit_lock(&nfsi->flags, NFS_INO_REVALIDATING,
>  					nfs_wait_schedule, TASK_INTERRUPTIBLE);
> -	rpc_clnt_sigunmask(clnt, &oldmask);

Looks like you missed one case that should change to KILLABLE?

>  static int nfs4_wait_clnt_recover(struct rpc_clnt *clnt, struct nfs_client *clp)
>  {
> -	sigset_t oldset;
>  	int res;
>  
>  	might_sleep();
>  
>  	rwsem_acquire(&clp->cl_sem.dep_map, 0, 0, _RET_IP_);
>  
> -	rpc_clnt_sigmask(clnt, &oldset);
>  	res = wait_on_bit(&clp->cl_state, NFS4CLNT_STATE_RECOVER,
>  			nfs4_wait_bit_interruptible,
>  			TASK_INTERRUPTIBLE);
> -	rpc_clnt_sigunmask(clnt, &oldset);

Ditto

> @@ -2844,14 +2837,12 @@ static int nfs4_delay(struct rpc_clnt *clnt, long *timeout)
>  		*timeout = NFS4_POLL_RETRY_MIN;
>  	if (*timeout > NFS4_POLL_RETRY_MAX)
>  		*timeout = NFS4_POLL_RETRY_MAX;
> -	rpc_clnt_sigmask(clnt, &oldset);
>  	if (clnt->cl_intr) {
>  		schedule_timeout_interruptible(*timeout);
>  		if (signalled())
>  			res = -ERESTARTSYS;
>  	} else
>  		schedule_timeout_uninterruptible(*timeout);
> -	rpc_clnt_sigunmask(clnt, &oldset);

Hmm ... guess we need a schedule_timeout_killable.  This should probably
look like:

	if (*timeout > NFS4_POLL_RETRY_MAX)
		*timeout = NFS4_POLL_RETRY_MAX;
+	schedule_timeout_killable(*timeout);
+	if (fatal_signalled())
		res = -ERESTARTSYS;
 	*timeout <<= 1;

> @@ -206,10 +204,8 @@ nfs_wait_on_request(struct nfs_page *req)
>  	 * Note: the call to rpc_clnt_sigmask() suffices to ensure that we
>  	 *	 are not interrupted if intr flag is not set
>  	 */
> -	rpc_clnt_sigmask(clnt, &oldmask);
>  	ret = out_of_line_wait_on_bit(&req->wb_flags, PG_BUSY,
>  			nfs_wait_bit_interruptible, TASK_INTERRUPTIBLE);
> -	rpc_clnt_sigunmask(clnt, &oldmask);

Another missing KILLABLE.

> @@ -520,9 +520,7 @@ extern void * nfs_root_data(void);
>  	int __retval = 0;						\
>  	if (clnt->cl_intr) {						\
>  		sigset_t oldmask;					\
> -		rpc_clnt_sigmask(clnt, &oldmask);			\
>  		__retval = wait_event_interruptible(wq, condition);	\
> -		rpc_clnt_sigunmask(clnt, &oldmask);			\
>  	} else								\
>  		wait_event(wq, condition);				\
>  	__retval;							\

wait_event_killable?

Anyway, none of these explain the non-killability of the *stat* calls.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
