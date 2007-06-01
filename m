Return-Path: <linux-kernel-owner+w=401wt.eu-S1764543AbXFAUal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764543AbXFAUal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762756AbXFAUad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:30:33 -0400
Received: from gw.goop.org ([64.81.55.164]:59979 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762327AbXFAUad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:30:33 -0400
Message-ID: <466081DE.70205@goop.org>
Date: Fri, 01 Jun 2007 13:30:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Srinivasa Ds <srinivasa@in.ibm.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, pj@sgi.com, simon.derr@bull.net,
       clameter@sgi.com, clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
References: <465FCA79.70207@in.ibm.com> <200706011620.05756.srinivasa@in.ibm.com>
In-Reply-To: <200706011620.05756.srinivasa@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Srinivasa Ds wrote:
> ---
>  kernel/cpuset.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> Index: linux-2.6.22-rc3/kernel/cpuset.c
> ===================================================================
> --- linux-2.6.22-rc3.orig/kernel/cpuset.c
> +++ linux-2.6.22-rc3/kernel/cpuset.c
> @@ -1741,6 +1741,13 @@ static int cpuset_tasks_open(struct inod
>  	 * show up until sometime later on.
>  	 */
>  	npids = atomic_read(&cs->count);
> +	if (!npids) {
> +		ctr->buf = NULL;
> +		ctr->bufsz = 0;
> +		file->private_data = ctr;
> +		return 0;
> +	}
> +
>   

I think this is a good example of why having to special-case kmalloc(0)
is a bad idea.  The original code was straightforward and, barring
silliness, should be completely correct with npids==0.  This new code
does nothing other than make things more complex.

    J
