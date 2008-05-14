Return-Path: <linux-kernel-owner+w=401wt.eu-S1760202AbYENCAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760202AbYENCAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 22:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757474AbYENB7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 21:59:54 -0400
Received: from relay1.sgi.com ([192.48.171.29]:57797 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757088AbYENB7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 21:59:53 -0400
Date: Tue, 13 May 2008 20:59:52 -0500
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: menage@google.com, xemul@openvz.org, balbir@in.ibm.com, serue@us.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [RFC/PATCH 1/8]: CGroup Files: Add locking mode to cgroups
 control files
Message-Id: <20080513205952.8ad44617.pj@sgi.com>
In-Reply-To: <20080513143206.ef259829.akpm@linux-foundation.org>
References: <20080513063707.049448000@menage.corp.google.com>
	<20080513071522.133586000@menage.corp.google.com>
	<20080513130127.fcd46a41.akpm@linux-foundation.org>
	<6599ad830805131417m4f8cc2e6iac42c0fb089a8cb1@mail.gmail.com>
	<20080513143206.ef259829.akpm@linux-foundation.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew wrote:
> As Matt observed, this is just a poorly-named variable.

How about the following code for cgroup_file_write():


	char buf[64];		/* avoid kmalloc() in small cases */
	char *p;		/* buf[] or kmalloc'd buffer */

	...

	if (nbytes < sizeof(buf)) {
		p = buf;
	} else {
		p = kmalloc(nbytes + 1, GFP_KERNEL);
		if (p == NULL)
			return -ENOMEM;
	}


Possible advantages of above code:

  * Uses short names for local variables of limited scope.

  * Doesn't set p until needed, so as:
	1) to highlight the symmetry of its setting, to either buf[]
	   (small cases) or to a kmalloc'd buffer (large cases), and
	2) to avoid implying that p needs to be set in the intervening
	   "..." code above.

  * Comments variable declarations.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
