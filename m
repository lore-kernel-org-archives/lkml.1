Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbZJBBdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbZJBBdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756323AbZJBBd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:33:29 -0400
Received: from kroah.org ([198.145.64.141]:33226 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756284AbZJBBdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:25 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:16 2009
Message-Id: <20091002012416.615372815@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [067/136] nfsd4: fix null dereference creating nfsv4 callback client
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=nfsd4-fix-null-dereference-creating-nfsv4-callback-client.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: J. Bruce Fields <bfields@citi.umich.edu>

commit 886e3b7fe6054230c89ae078a09565ed183ecc73 upstream.

On setting up the callback to the client, we attempt to use the same
authentication flavor the client did.  We find an rpc cred to use by
calling rpcauth_lookup_credcache(), which assumes that the given
authentication flavor has a credentials cache.  However, this is not
required to be true--in particular, auth_null does not use one.
Instead, we should call the auth's lookup_cred() method.

Without this, a client attempting to mount using nfsv4 and auth_null
triggers a null dereference.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs4callback.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -444,6 +444,7 @@ static struct rpc_cred *lookup_cb_cred(s
 	struct auth_cred acred = {
 		.machine_cred = 1
 	};
+	struct rpc_auth *auth = cb->cb_client->cl_auth;
 
 	/*
 	 * Note in the gss case this doesn't actually have to wait for a
@@ -451,8 +452,7 @@ static struct rpc_cred *lookup_cb_cred(s
 	 * non-uptodate cred which the rpc state machine will fill in with
 	 * a refresh_upcall later.
 	 */
-	return rpcauth_lookup_credcache(cb->cb_client->cl_auth, &acred,
-							RPCAUTH_LOOKUP_NEW);
+	return auth->au_ops->lookup_cred(auth, &acred, RPCAUTH_LOOKUP_NEW);
 }
 
 void do_probe_callback(struct nfs4_client *clp)


