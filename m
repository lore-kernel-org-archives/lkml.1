Return-Path: <linux-kernel-owner+w=401wt.eu-S1764874AbXLPWAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764874AbXLPWAg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 17:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763883AbXLPV7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 16:59:49 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34377
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1763551AbXLPV7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 16:59:46 -0500
Date: Sun, 16 Dec 2007 13:59:39 -0800 (PST)
Message-Id: <20071216.135939.00534238.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: miles.lane@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       mingo@elte.hu, a.p.zijlstra@chello.nl
Subject: Re: 2.6.24-rc5-mm1 -- inconsistent {in-softirq-W} ->
 {softirq-on-R} usage.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071214153633.5d8f609a.akpm@linux-foundation.org>
References: <a44ae5cd0712141413u4ddbfd06gca259cfc3bc0ab1a@mail.gmail.com>
	<20071214153633.5d8f609a.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 14 Dec 2007 15:36:33 -0800

> The networking bug looks to be around sock_i_ino()'s taking of
> sk_callback_lock with softirq's enabled.  Perhaps this will fix it.

One should be suspicious of any case where write_lock is performed
on sk->sk_callback_lock in softint context.  And that's the only
way this can trigger, so this patch is wrong.

Generally, sock_orphan() and sock_graft() are the only primary
places where sk->sk_callback_lock is acquired as a writer.  And
these should be invoked only from process context.

Perhaps there is some exception to this in some specialized layer such
as SUNRPC, which are the only other spots I see potentially doing
sk->sk_callback_lock write acquires in softint context, which as
stated should not be done.

OCFS2 and ISCSI seem to be following the rules in it's write lock
calls on this lock.
