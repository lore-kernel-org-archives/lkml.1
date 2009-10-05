Return-Path: <linux-kernel-owner+w=401wt.eu-S932645AbZJENOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645AbZJENOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 09:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932535AbZJENOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 09:14:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932389AbZJENOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 09:14:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20091005063919.3958.65581.sendpatchset@localhost.localdomain>
References: <20091005063919.3958.65581.sendpatchset@localhost.localdomain>
To: Amerigo Wang <amwang@redhat.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       Brian Behlendorf <behlendorf1@llnl.gov>,
       Ben Woodard <bwoodard@llnl.gov>, Stable Team <stable@kernel.org>,
       akpm@linux-foundation.org
Subject: Re: [Patch v2] rwsem: fix rwsem_is_locked() bugs
Date: Mon, 05 Oct 2009 14:13:22 +0100
Message-ID: <22214.1254748402@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang <amwang@redhat.com> wrote:

> -	return (sem->activity != 0);
> +	return !(sem->activity == 0 && list_empty(&sem->wait_list));

This needs to be done in the opposite order with an smp_rmb() between[*], I
think, because the someone releasing the lock will first reduce activity to
zero, and then attempt to empty the list, so with your altered code as it
stands, you can get:

	CPU 1				CPU 2
	===============================	===============================
	[sem is read locked, 1 queued writer]
	-->up_read()
	sem->activity--			-->rwsem_is_locked()
	[sem->activity now 0]		sem->activity == 0 [true]
					<interrupt>
	-->__rwsem_do_wake()
	sem->activity = -1
	[sem->activity now !=0]
	list_del()
	[sem->wait_list now empty]	</interrupt>
					list_empty(&sem->wait_list) [true]
	wake_up_process()
	<--__rwsem_do_wake()
	<--up_read()
	[sem is write locked]		return false [ie. sem is not locked]

In fact, I don't think even swapping things around addresses the problem.  You
do not prevent the state inside the sem changing under you whilst you try to
interpret it.

[*] there would also need to be an smp_wmb() between the update of
    sem->activity and the deletion from sem->wait_list to balance out the
    smp_rmb().

David
