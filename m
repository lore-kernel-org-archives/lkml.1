Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbYKSWbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbYKSWbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 17:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750747AbYKSWbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 17:31:10 -0500
Received: from mail-out2.uio.no ([129.240.10.58]:40426 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbYKSWbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 17:31:08 -0500
Subject: Re: High load in 2.6.27, NFS / rpcauth_lookup_credcache()?
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Max Kellermann <max@duempel.org>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
In-Reply-To: <20081117123536.GA16539@squirrel.roonstrasse.net>
References: <20081022091207.GA12996@squirrel.roonstrasse.net>
	 <20081023123628.GA18549@squirrel.roonstrasse.net>
	 <1224773745.7625.4.camel@localhost>
	 <20081024083913.GA15197@squirrel.roonstrasse.net>
	 <1224871763.22672.33.camel@localhost>
	 <20081027095843.GA10937@squirrel.roonstrasse.net>
	 <1225122503.14242.12.camel@heimdal.trondhjem.org>
	 <20081117123536.GA16539@squirrel.roonstrasse.net>
Content-Type: text/plain
Date: Wed, 19 Nov 2008 17:31:01 -0500
Message-Id: <1227133861.28898.26.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 252FC67014880D524B1122B855461AE84D400838
X-UiO-SPAM-Test: remote_host: 68.40.183.129 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 1 total 208 max/h 9 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-17 at 13:35 +0100, Max Kellermann wrote:
> On 2008/10/27 16:48, Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> > OK. That points a finger at the garbage collector. Does the following
> > patch help at all?
> 
> Hi Trond,
> 
> the server's load seems to be a little bit lower with 2.6.27.6 plus
> your patch, but OProfile still gives me 45% in
> rpcauth_lookup_credcache().  See:
> 
> 1060627  45.1474  (no location information)   rpcauth_lookup_credcache
> 289362   12.3172  auth_generic.c:0            generic_match
> 31886     1.3573  page_alloc.c:0              get_page_from_freelist
> 23932     1.0187  (no location information)   page_fault
> 22176     0.9440  (no location information)   schedule
> 14613     0.6220  (no location information)   __d_lookup
> [...]
> 
> Max

Looking at the above, it seems that you're spending an inordinate amount
of time in generic_match too.
Could you see if the following patch helps?

Cheers
  Trond

-------------------------------------------------------------------------------
From: Trond Myklebust <Trond.Myklebust@netapp.com>
SUNRPC: Fix up generic_match()

Cut down on the number of similar copies of group_info.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 net/sunrpc/auth_generic.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)


diff --git a/net/sunrpc/auth_generic.c b/net/sunrpc/auth_generic.c
index 744b79f..4028502 100644
--- a/net/sunrpc/auth_generic.c
+++ b/net/sunrpc/auth_generic.c
@@ -133,13 +133,29 @@ static int
 generic_match(struct auth_cred *acred, struct rpc_cred *cred, int flags)
 {
 	struct generic_cred *gcred = container_of(cred, struct generic_cred, gc_base);
+	int i;
 
 	if (gcred->acred.uid != acred->uid ||
 	    gcred->acred.gid != acred->gid ||
-	    gcred->acred.group_info != acred->group_info ||
 	    gcred->acred.machine_cred != acred->machine_cred)
-		return 0;
+		goto out_nomatch;
+
+	/* Optimisation in the case where pointers are identical... */
+	if (gcred->acred.group_info == acred->group_info)
+		goto out_match;
+
+	/* Slow path... */
+	if (gcred->acred.group_info->ngroups != acred->group_info->ngroups)
+		goto out_nomatch;
+	for (i = 0; i < gcred->acred.group_info->ngroups; i++) {
+		if (GROUP_AT(gcred->acred.group_info, i) !=
+				GROUP_AT(acred->group_info, i))
+			goto out_nomatch;
+	}
+out_match:
 	return 1;
+out_nomatch:
+	return 0;
 }
 
 void __init rpc_init_generic_auth(void)


