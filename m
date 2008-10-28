Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbYJ1P0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbYJ1P0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 11:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbYJ1P0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 11:26:22 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:35018 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbYJ1P0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 11:26:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=m8VhcnbW2riBA58w/m+6EVvIiUS1gh6W5/tHz6AlTKi1tAUDYPkcDvXhDPt6EUASke
         vO+801XWRG6cymDb3Y/OnyfHyG5mctWyYZgUoDZZlichJndUZVFWtfG/TPqLA6PwJg4l
         TA38AvlfABJX7aJCnQFLdfjgFdw5qk42uIjgY=
Date: Tue, 28 Oct 2008 18:29:43 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: On spreading atomic_t initialization
Message-ID: <20081028152943.GA20989@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote stupid runtime checker to look for atomic_t uninitialized usage
and the amount of screaming in logs is surprisingly very big.

So the question: is there really really an arch for which setting atomic_t
by hand (kzalloc) is not equivalent to atomic_set()?

Given the following patch, there is none almost certainly.

--- a/kernel/user.c
+++ b/kernel/user.c
@@ -405,6 +405,9 @@ struct user_struct *alloc_uid(struct user_namespace *ns, uid_t uid)
 
 		new->uid = uid;
 		atomic_set(&new->__count, 1);
+		atomic_set(&new->processes, 0);
+		atomic_set(&new->files, 0);
+		atomic_set(&new->sigpending, 0);
 
 		if (sched_create_user(new) < 0)
 			goto out_free_user;


Such checker will still be useful to catch genuine uninitialized usages,
but the amount of stuff to shut up before it can realistically be put in -mm
is amazing.
