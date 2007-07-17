Return-Path: <linux-kernel-owner+w=401wt.eu-S936150AbXGQVxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936150AbXGQVxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757792AbXGQVxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:53:11 -0400
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:59186 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759372AbXGQVxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:53:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CABvXnEarR7MV/2dsb2JhbAA
X-IronPort-AV: i="4.16,547,1175497200"; 
   d="scan'208"; a="9052494:sNHT13930530"
To: Jeff Garzik <jgarzik@redhat.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       chas@cmf.nrl.navy.mil, rolandd@cisco.com, dwmw2@infradead.org,
       gregkh@suse.de
Subject: Re: [git patches 1/2] warnings: attack valid cases spotted by warnings
X-Message-Flag: Warning: May contain useful information
References: <20070717214239.GF28448@devserv.devel.redhat.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 17 Jul 2007 14:53:02 -0700
In-Reply-To: <20070717214239.GF28448@devserv.devel.redhat.com> (Jeff Garzik's message of "Tue, 17 Jul 2007 17:42:39 -0400")
Message-ID: <ada8x9epuip.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 17 Jul 2007 21:53:02.0918 (UTC) FILETIME=[D9580660:01C7C8BC]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 >     drivers/infiniband/hw/mthca/mthca_qp: kill uninit'd var warning
 >     
 >     drivers/infiniband/hw/mthca/mthca_qp.c: In function
 >       ‘mthca_tavor_post_send’:
 >     drivers/infiniband/hw/mthca/mthca_qp.c:1594: warning: ‘f0’ may be used
 >       uninitialized in this function
 >     drivers/infiniband/hw/mthca/mthca_qp.c: In function
 >       ‘mthca_arbel_post_send’:
 >     drivers/infiniband/hw/mthca/mthca_qp.c:1949: warning: ‘f0’ may be used
 >       uninitialized in this function
 >     
 >     Initializing 'f0' is not strictly necessary in either case, AFAICS.
 >     
 >     I was considering use of uninitialized_var(), but looking at the
 >     complex flow of control in each function, I feel it is wiser and
 >     safer to simply zero the var and be certain of ourselves.
 >     
 >     Signed-off-by: Jeff Garzik <jeff@garzik.org>

I don't really like this.  These functions are in the hottest, most
latency-sensitive code path of this driver, which is used by people
who care about nanoseconds.  I'm quite confident that the code is
correct as written, and it really feels wrong to me to add bloat to
the fastpath just to cover up a shortcoming of gcc.

And I don't like using uninitialized_var() here for a similar
reason... the functions are complex and I would prefer to avoid hiding
future bugs that may creep in.  In fact adding the initialization to 0
has a similar effect, since it shuts up the compiler even if the logic
in the function gets screwed up.

On the other hand I definitely sympathize with the desire to have a
warning-free build so that real warnings are more visible.  I guess I
could live with the uninitialized_var() patch, although I would feel a
little sad.

 - R.
