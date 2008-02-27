Return-Path: <linux-kernel-owner+w=401wt.eu-S932190AbYB0Bbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbYB0Bbb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 20:31:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757019AbYB0BbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 20:31:23 -0500
Received: from smtp-out.google.com ([216.239.45.13]:28917 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080AbYB0BbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 20:31:22 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=UHk1zttBhg6ZO7Ib9sav/0lwzqCpG9gdtLeVsNcpE2ogFk6/4PXfQJE7PQHNVnoRO
	i0V8kuOVs1cDMy3Bb2ECw==
Date: Tue, 26 Feb 2008 17:31:05 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 5/6] mempolicy: add MPOL_F_RELATIVE_NODES flag
In-Reply-To: <alpine.DEB.1.00.0802261704310.25919@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.00.0802261727440.30676@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com> <alpine.DEB.1.00.0802250013580.12368@chino.kir.corp.google.com> <alpine.DEB.1.00.0802250014170.12368@chino.kir.corp.google.com> <alpine.DEB.1.00.0802250014410.12368@chino.kir.corp.google.com>
 <alpine.DEB.1.00.0802250016120.12368@chino.kir.corp.google.com> <alpine.DEB.1.00.0802261704310.25919@chino.kir.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008, David Rientjes wrote:

> 			MPOL_PREFERRED | MPOL_F_RELATIVE_NODES
> 			--------------------------------------
> 	mems	nodemask	result		rebind		result[***]
> 	1-3	0		1		0		1
> 	1-3	2		3		4-7		3
> 	1-3	5		3		0-7		3
> 

I'll fold the following patch into my next posting that corrects this 
error as follows:

			MPOL_PREFERRED | MPOL_F_RELATIVE_NODES
			--------------------------------------
	mems	nodemask	result		rebind		result
	1-3	0		1		0		0
	1-3	2		3		4-7		6
	1-3	5		3		0-7		5
---
 mm/mempolicy.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1809,8 +1809,7 @@ static void mpol_rebind_policy(struct mempolicy *pol,
 		} else if (relative_nodes) {
 			mpol_relative_nodemask(&tmp, &pol->w.user_nodemask,
 					       newmask);
-			pol->v.preferred_node = node_remap(pol->v.preferred_node,
-					pol->w.cpuset_mems_allowed, tmp);
+			pol->v.preferred_node = first_node(tmp);
 		} else {
 			pol->v.preferred_node = node_remap(pol->v.preferred_node,
 					pol->w.cpuset_mems_allowed, *newmask);
