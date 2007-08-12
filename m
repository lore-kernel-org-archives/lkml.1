Return-Path: <linux-kernel-owner+w=401wt.eu-S938230AbXHLVqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938230AbXHLVqT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 17:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762644AbXHLVqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 17:46:07 -0400
Received: from web36606.mail.mud.yahoo.com ([209.191.85.23]:26651 "HELO
	web36606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759763AbXHLVqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 17:46:05 -0400
X-YMail-OSG: xI9.74AVM1mcLlys0jHluL5KwW6DRwf2yY5y_.DO8ecrjD3FE_527sP8LE7XoKLf3yClEHx55A--
X-RocketYMMF: rancidfat
Date: Sun, 12 Aug 2007 14:46:04 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
To: Andi Kleen <andi@firstfloor.org>, Casey Schaufler <casey@schaufler-ca.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org
In-Reply-To: <20070812213605.GA25883@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <507487.90352.qm@web36606.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andi Kleen <andi@firstfloor.org> wrote:

> On Sun, Aug 12, 2007 at 10:48:05AM -0700, Casey Schaufler wrote:
> > 
> > --- Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > > Entries are never deleted, although they can be modified.
> > > 
> > > The modification case still seems racy then.
> > 
> > Fair enough. I'll look into real list management.
> 
> You don't necessarily need more list management if you don't 
> plan to remove entries, but just replace them.
> 
> e.g. what could work to atomically replace is: 
> 
> - Make the buffer a pointer to an allocated buffer that also
> contains a struct rcu_head.
> - Reader: Does rcu_read_lock() around list walk (that just disables
> preemption on preemptible kernels and is otherwise a nop).
> Also uses rcu_reference for reading the pointer. 
> - Writer: Continues using the mutex to protect against other writers.
> When changing an entry allocate a new buffer + rcu_head. Initialize
> buffer. Replace pointer.  Free old buffer using call_rcu() 
> 
> The RCU would just make sure the buffer is not freed while other
> CPUs are still accessing it. It also means they can use stale
> rules for a time, but it is a strictly bounded time
> (bounded to max time walking the list plus max time any interrupt
> handlers inbetween run [admittedly that can be very long in theory, 
> but it's all logically only a single rule check])

Thank you. You have no idea how helpful that little suggestion was.


Casey Schaufler
casey@schaufler-ca.com
