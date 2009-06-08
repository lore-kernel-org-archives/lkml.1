Return-Path: <linux-kernel-owner+w=401wt.eu-S1756677AbZFHRBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbZFHRBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 13:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756083AbZFHRBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 13:01:18 -0400
Received: from mx2.netapp.com ([216.240.18.37]:11181 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755960AbZFHRBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 13:01:16 -0400
X-IronPort-AV: E=Sophos;i="4.41,325,1241420400"; 
   d="scan'208";a="187596733"
Subject: Re: [PATCH 5/5] sunrpc/auth_gss: Call rcu_barrier() on module
 unload.
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: paulmck@linux.vnet.ibm.com
Cc: Jesper Dangaard Brouer <hawk@comx.dk>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, urs.thuermann@volkswagen.de,
       oliver.hartkopp@volkswagen.de, wg@grandegger.com,
       vladislav.yasevich@hp.com, sri@us.ibm.com, linux-sctp@vger.kernel.org,
       linux-nfs@vger.kernel.org, netfilter-devel@vger.kernel.org
In-Reply-To: <20090608162656.GF6961@linux.vnet.ibm.com>
References: <20090608130959.10052.54590.stgit@localhost>
	 <20090608131148.10052.39869.stgit@localhost>
	 <20090608162656.GF6961@linux.vnet.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Mon, 08 Jun 2009 13:00:49 -0400
Message-Id: <1244480449.5040.4.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
X-OriginalArrivalTime: 08 Jun 2009 17:00:50.0186 (UTC) FILETIME=[ACE06EA0:01C9E85A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-08 at 09:26 -0700, Paul E. McKenney wrote:
> On Mon, Jun 08, 2009 at 03:11:48PM +0200, Jesper Dangaard Brouer wrote:
> > As the module uses rcu_call() we should make sure that all
> > rcu callback has been completed before removing the code.
> 
> Good improvement!!!  Assuming that gss_svc_shutdown() and
> rpcauth_unregister() prevent any future RCU callbacks to be registered,
> this patch will fix things up.
> 
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> > Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>
> > ---
> > 
> >  net/sunrpc/auth_gss/auth_gss.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
> > index e630b38..66d458f 100644
> > --- a/net/sunrpc/auth_gss/auth_gss.c
> > +++ b/net/sunrpc/auth_gss/auth_gss.c
> > @@ -1548,6 +1548,7 @@ static void __exit exit_rpcsec_gss(void)
> >  {
> >  	gss_svc_shutdown();
> >  	rpcauth_unregister(&authgss_ops);
> > +	rcu_barrier(); /* Wait for completion of call_rcu()'s */
> >  }
> > 
> >  MODULE_LICENSE("GPL");
> > 

Hmm... If this is about ensuring that all the call_rcu() callbacks
complete before we remove the module, then don't we also need similar
barriers in net/sunrpc/sunrpc_syms.c:cleanup_sunrpc() and in
fs/nfs/inode.c:exit_nfs_fs()?

Cheers
  Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
