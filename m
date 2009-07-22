Return-Path: <linux-kernel-owner+w=401wt.eu-S1752947AbZGVUUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbZGVUUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 16:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbZGVUUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 16:20:21 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:43226 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685AbZGVUUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 16:20:20 -0400
Subject: Re: Error mounting FC8 NFS server with 2.6.31-rc3 NFSv4 client.
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andy Adamson <andros@netapp.com>
Cc: Ben Greear <greearb@candelatech.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org
In-Reply-To: <A7103385-4525-4B7B-9CBA-5DBCB99A98F0@netapp.com>
References: <4A64EB1F.4000602@candelatech.com>
	 <1248178527.5222.0.camel@heimdal.trondhjem.org>
	 <4A65F184.5060802@candelatech.com>
	 <1248196339.21343.8.camel@heimdal.trondhjem.org>
	 <4A65FCB2.6080903@candelatech.com>
	 <1248199140.21343.17.camel@heimdal.trondhjem.org>
	 <4A660295.9020807@candelatech.com>
	 <1248200897.21343.19.camel@heimdal.trondhjem.org>
	 <4A6609A9.3000504@candelatech.com>
	 <1248211050.21343.38.camel@heimdal.trondhjem.org>
	 <A7103385-4525-4B7B-9CBA-5DBCB99A98F0@netapp.com>
Content-Type: text/plain
Date: Wed, 22 Jul 2009 16:20:13 -0400
Message-Id: <1248294013.5234.35.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 4 msgs/h 1 sum rcpts/h 6 sum msgs/h 1 total rcpts 932 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 0CF658A44C63D33A1B11EBE73709776582F61A67
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 83 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 15:49 -0400, Andy Adamson wrote:
> On Jul 21, 2009, at 5:17 PM, Trond Myklebust wrote:
> > Note that there is a bug remaining inside nfs4_init_session(): we
> > shouldn't be copying the rsize/wsize into the nfs_client if the latter
> > was already initialised.
> 
> The rsize/wsize is copied into the session prior to the create_session  
> call (triggered by the state management code you moved), and is used  
> for session negotiation. At this point the nfs_client cl_cons_state is  
> set to NFS_CS_SESSION_INITING (see nfs4_alloc_session), so the  
> nfs_client is not initialized.  The cl_cons_state is set to  
> NFS_CS_READY after a successful create_session call.

The call to nfs4_init_session() is in nfs4_create_server(). It can be
called several times _after_ the nfs_client has been initialised when
you mount more than one partition from the same NFS server.

If that is the case, and if you use different rsize/wsize values on
those different mounts, then you will end up clobbering the values of
fc_attrs.max_rqst_sz, and fc_attrs.max_resp_sz, having set them to the
wsize/rsize that was set by the very last mount call.

AFAICS, what you _should_ be doing in nfs4_init_session, is something
like

	if (clp->cl_session->fc_attrs.max_rqst_sz < server->wsize)
		clp->cl_session->fc_attrs.max_rqst_sz = server->wsize;

Trond

