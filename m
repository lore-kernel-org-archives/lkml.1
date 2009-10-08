Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbZJHKqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbZJHKqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 06:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756246AbZJHKqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 06:46:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755393AbZJHKqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 06:46:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20091008092632.7101.62229.sendpatchset@localhost.localdomain>
References: <20091008092632.7101.62229.sendpatchset@localhost.localdomain>
To: Amerigo Wang <amwang@redhat.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       Ben Woodard <bwoodard@llnl.gov>, akpm@linux-foundation.org,
       Brian Behlendorf <behlendorf1@llnl.gov>
Subject: Re: [Patch v4] rwsem: fix rwsem_is_locked() bugs
Date: Thu, 08 Oct 2009 11:45:34 +0100
Message-ID: <19121.1254998734@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang <amwang@redhat.com> wrote:

> rwsem_is_locked() tests ->activity without locks, so we should always
> keep ->activity consistent. However, the code in __rwsem_do_wake()
> breaks this rule, it updates ->activity after _all_ readers waken up,
> this may give some reader a wrong ->activity value, thus cause
> rwsem_is_locked() behaves wrong.
> 
> Quote from Andrew:
> 
> "
> - we have one or more processes sleeping in down_read(), waiting for access.
> 
> - we wake one or more processes up without altering ->activity
> 
> - they start to run and they do rwsem_is_locked().  This incorrectly
>   returns "false", because the waker process is still crunching away in
>   __rwsem_do_wake().
> 
> - the waker now alters ->activity, but it was too late.
> "
> 
> So we need get a spinlock to protect this. And rwsem_is_locked()
> should not block, thus we use spin_trylock.
> 
> Reported-by: Brian Behlendorf <behlendorf1@llnl.gov>
> Cc: Ben Woodard <bwoodard@llnl.gov>
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: WANG Cong <amwang@redhat.com>

I'd say the comment in __rwsem_do_wake() is unnecessary, but other than
that...

Acked-by: David Howells <dhowells@redhat.com>
