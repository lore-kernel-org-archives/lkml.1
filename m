Return-Path: <linux-kernel-owner+w=401wt.eu-S1755717AbYC2UGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbYC2UGJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 16:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277AbYC2UFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 16:05:54 -0400
Received: from pat.uio.no ([129.240.10.15]:49183 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754251AbYC2UFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 16:05:53 -0400
Subject: Re: [PATCH] SUNRPC: have soft RPC tasks return -ETIMEDOUT instead
	of -EIO on major connect timeout
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-nfs@vger.kernel.org, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080329152424.6857ee86@tleilax.poochiereds.net>
References: <1206794957-17010-1-git-send-email-jlayton@redhat.com>
	 <1206809051.8480.33.camel@heimdal.trondhjem.org>
	 <20080329152424.6857ee86@tleilax.poochiereds.net>
Content-Type: text/plain
Date: Sat, 29 Mar 2008 16:05:49 -0400
Message-Id: <1206821149.8455.13.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: F29E64605B983F863B8F3EB01132E2518CF3683B
X-UiO-SR-test: 6086ADDA04983661EA44F8BADCF5874191F827DF
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 31 total 7591356 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-03-29 at 15:24 -0400, Jeff Layton wrote:
> On Sat, 29 Mar 2008 12:44:11 -0400
> Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> > Userland has the clnt_geterr() function that returns more detailed 'RPC
> > level' errors. While that 'error function call' approach doesn't work in
> > a multi-threaded environment, we might still be able to add the
> > equivalent of a pointer to an 'rpc_err' structure to the rpc_task, and
> > then have functions like call_timeout() (and especially call_verify()!)
> > fill in more detailed error info if that pointer is non-zero?
> >
> 
> I'm not sure we really need this, do we?
> 
> Should it really be the business of the RPC layer to sanitize the
> tk_status like this? It seems like the NFS layer ought to be
> translating "illegal" errors from the RPC layer into more generic ones
> where needed rather than relying on the RPC layer to do it, though
> maybe I'm not thinking about the RPC layer in the right way here...

Yes and no. The RPC error reports are sometimes more complex than what
we can fit into a single 32-bit error code. I'm thinking in particular
of the RPC_AUTH_* errors (EACCESS just doesn't do them justice), and
RPC_PROG_MISMATCH error.

In the case of RPC_PROG_MISMATCH, it would, for instance, be really
useful for the in-kernel mount code to be able to also retrieve the
'mismatch_info' structure (see RFC1831), which tells you exactly which
program versions are actually supported on that port.

An extra optional pointer to a structure in the rpc_task won't cost us
much, but could possibly provide a lot of interesting information that
we are currently ignoring.

Cheers
  Trond

