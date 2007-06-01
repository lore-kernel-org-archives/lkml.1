Return-Path: <linux-kernel-owner+w=401wt.eu-S1763716AbXFATsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763716AbXFATsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 15:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762763AbXFATr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 15:47:59 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46942 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762435AbXFATr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 15:47:58 -0400
Date: Fri, 1 Jun 2007 12:47:57 -0700
From: Paul Jackson <pj@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: srinivasa@in.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       vatsa@in.ibm.com, dino@in.ibm.com, simon.derr@bull.net,
       clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
Message-Id: <20070601124757.fe91a002.pj@sgi.com>
In-Reply-To: <Pine.LNX.4.64.0706011217510.3406@schroedinger.engr.sgi.com>
References: <465FCA79.70207@in.ibm.com>
	<200706011620.05756.srinivasa@in.ibm.com>
	<Pine.LNX.4.64.0706011107540.2284@schroedinger.engr.sgi.com>
	<20070601121114.b165f1e8.pj@sgi.com>
	<Pine.LNX.4.64.0706011217510.3406@schroedinger.engr.sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The allocated array has 0 bytes. Any dereference is an error.

Well, then, that doesn't work either.

We -agree- we can't have this failing. You suggested (if I understood
correctly, which I doubt) that we set the pointer to NULL, and noted
that derefencing a NULL pointer would fail.  I agree such derefences
would fail, and tried to point out that this would be bad.  We can't
have pointer dereferences failing in the kernel ... duh.

Your reply seems like a non sequiter to me, pointing out that having
a pointer to an array of 0 bytes fails as well.  Ok - that's bad too.

So we cannot have a NULL pointer, used unchecked, and we cannot have
a non-NULL pointer to a zero byte array, used unchecked.

As I said, and as I thought Srinivasa coded, with these patch lines:

@@ -1772,6 +1779,9 @@ static ssize_t cpuset_tasks_read(struct 
 {
 	struct ctr_struct *ctr = file->private_data;
 
+	if (!ctr->buf)     /* No tasks in this cpuset */
+		return 0;
+
 	return simple_read_from_buffer(buf, nbytes, ppos, ctr->buf, ctr->bufsz);
 }

we actually have to check the NULL-ness (or emptiness) of this thing,
down where it would be used, to avoid using NULL or empty things.

Summary - Srinivasa's patch still looks ok to me.  This followup
discussion between you and I is just confusing me - sorry.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
