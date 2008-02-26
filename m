Return-Path: <linux-kernel-owner+w=401wt.eu-S1758024AbYBZFqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbYBZFqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 00:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYBZFqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 00:46:21 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39684 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751895AbYBZFqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 00:46:21 -0500
Date: Mon, 25 Feb 2008 23:46:16 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/6] mempolicy: add MPOL_F_STATIC_NODES flag
Message-Id: <20080225234616.777d534c.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802250014170.12368@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802250013580.12368@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802250014170.12368@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
+static inline int mpol_store_user_nodemask(const struct mempolicy *pol)
+{
+	return !!(pol->flags & MPOL_F_STATIC_NODES);
+}

Why the double-negative?  As best as I can tell, the return value of
mpol_store_user_nodemask() is only used in conditional contexts:

    $ grep mpol_store_user_nodemask mm/mempolicy.c
    static inline int mpol_store_user_nodemask(const struct mempolicy *pol)
        if (mpol_store_user_nodemask(policy))
        if (!mpol_store_user_nodemask(a))
        if (!mpol_store_user_nodemask(pol) &&

So I see no need to waste the instructions needed (in the three copies
of this code, since it's static inline) to convert a non-zero value to
exactly the value 1.

Hmmm ... speaking of static inline ... I can knock 600 bytes (that's
IA64 bytes, so equivalent to about 300 x86 bytes) off the kernel text
size by not inlining the mm/mempolicy.c routines check_pgd_range() and
interleave_nid().  I wonder if that would be worth doing.  Perhaps
those two routines are in sufficiently tight corners that the duplicate
copies of them is needed.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
