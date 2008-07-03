Return-Path: <linux-kernel-owner+w=401wt.eu-S1759541AbYGCVpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541AbYGCVpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 17:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756685AbYGCVo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 17:44:57 -0400
Received: from smtp-out.google.com ([216.239.33.17]:8882 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157AbYGCVo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 17:44:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=IC0E/14NM8G9nvRvjFImMTGBQsn7pYc376GXXiMRzpPo878Qw08zD5IXsOKu/HHDm
	Hb+haEpQf3doRbbJUNuMw==
Date: Thu, 3 Jul 2008 14:44:33 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: John Blackwood <john.blackwood@ccur.com>
cc: linux-kernel@vger.kernel.org, Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Joe Korty <joe.korty@ccur.com>
Subject: Re: [bug ?] do_get_mempolicy()
In-Reply-To: <486D3A4A.6000502@ccur.com>
Message-ID: <alpine.DEB.1.10.0807031440170.17955@chino.kir.corp.google.com>
References: <486D3A4A.6000502@ccur.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jul 2008, John Blackwood wrote:

> Hi Lee,
> 
> I'm having unexpected results with get_mempolicy(2) in 2.6.26, and
> I am hoping that you can either agree with me, or maybe comment on my
> misconceptions.
> 
> When I have a task with no special task mempolicy (the default mempolicy),
> when I call get_mempolicy(2), it returns a policy value of 2 (MPOL_BIND)
> with a NULL nodemask.
> 
> I believe that this is because of the code in do_get_mempolicy() that does:
> 
>  *policy |= pol->flags;
> 
> in the else case when flags do not contain MPOL_F_NODE.
> 
> I guess I don't understand why we are ORing in the pol->flags into the
> *policy value.  For example, when this is for the default_policy, the
> MPOL_F_LOCAL flag (which has a value of 2) gets stuffed into the *policy
> location, and a get_mempolicy(2) caller sees this as the MPOL_BIND
> mempolicy.
> 
> Maybe the "*policy |= pol->flags;" line should be removed ?
> 

You're right, the flags member of struct mempolicy has subsequently 
changed to carry "internal" flags that are not supposed to be exposed to 
userspace via the get_mempolicy() API.

The following patch probably fixes it.

Lee?

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/mempolicy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -729,7 +729,7 @@ static long do_get_mempolicy(int *policy, nodemask_t *nmask,
 	} else {
 		*policy = pol == &default_policy ? MPOL_DEFAULT :
 						pol->mode;
-		*policy |= pol->flags;
+		*policy |= (pol->flags & MPOL_MODE_FLAGS);
 	}
 
 	if (vma) {
