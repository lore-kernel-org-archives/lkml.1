Return-Path: <linux-kernel-owner+w=401wt.eu-S935757AbXHLVgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935757AbXHLVgS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 17:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761470AbXHLVgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 17:36:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36898 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759786AbXHLVgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 17:36:07 -0400
Date: Sun, 12 Aug 2007 23:36:05 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
Message-ID: <20070812213605.GA25883@one.firstfloor.org>
References: <20070812114913.GA20669@one.firstfloor.org> <918222.44901.qm@web36614.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <918222.44901.qm@web36614.mail.mud.yahoo.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 10:48:05AM -0700, Casey Schaufler wrote:
> 
> --- Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > Entries are never deleted, although they can be modified.
> > 
> > The modification case still seems racy then.
> 
> Fair enough. I'll look into real list management.

You don't necessarily need more list management if you don't 
plan to remove entries, but just replace them.

e.g. what could work to atomically replace is: 

- Make the buffer a pointer to an allocated buffer that also
contains a struct rcu_head.
- Reader: Does rcu_read_lock() around list walk (that just disables
preemption on preemptible kernels and is otherwise a nop).
Also uses rcu_reference for reading the pointer. 
- Writer: Continues using the mutex to protect against other writers.
When changing an entry allocate a new buffer + rcu_head. Initialize
buffer. Replace pointer.  Free old buffer using call_rcu() 

The RCU would just make sure the buffer is not freed while other
CPUs are still accessing it. It also means they can use stale
rules for a time, but it is a strictly bounded time
(bounded to max time walking the list plus max time any interrupt
handlers inbetween run [admittedly that can be very long in theory, 
but it's all logically only a single rule check])

-Andi

