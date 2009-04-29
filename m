Return-Path: <linux-kernel-owner+w=401wt.eu-S1758284AbZD2A3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284AbZD2A3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 20:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbZD2A3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 20:29:24 -0400
Received: from tundra.namei.org ([65.99.196.166]:52199 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121AbZD2A3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 20:29:23 -0400
Date: Wed, 29 Apr 2009 10:29:06 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Oleg Nesterov <oleg@redhat.com>
cc: David Howells <dhowells@redhat.com>, Eric Paris <eparis@parisplace.org>,
       Roland McGrath <roland@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       linux-kernel@vger.kernel.org
Subject: Re: Q: selinux_bprm_committed_creds() && signals/do_wait
In-Reply-To: <20090428223025.GA11997@redhat.com>
Message-ID: <alpine.LRH.2.00.0904291024001.5246@tundra.namei.org>
References: <20090428223025.GA11997@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009, Oleg Nesterov wrote:

> selinux_bprm_committed_creds:
> 
> 	rc = avc_has_perm()
> 	if (rc) {
> 		flush_signals(current);
> 
> This doesn't look right. If the task was SIGKILL'ed we must not proceed,
> the task should die. The fix is simple, we should check SIGNAL_GROUP_EXIT
> and do nothing in this case, the task will exit before return to user
> space. If SIGNAL_GROUP_EXIT is set, it is just wrong to drop SIGKILL and
> continue.

I'm not quite sure what you're asking.  This is a permission check to see 
if the new task can inherit the signal state of the parent, and if not, 
the new task's signal state is flushed.

Where does a consideration of SIGKILL arise?

> But, before fixing, I'd like to understand why we are doing
> 
> 		flush_signal_handlers(current, 1);
> 		sigemptyset(&current->blocked);
> 
> later. Could someone explain ? This looks unneeded.

This is part of clearing all the signal state in the child.

> 
> 
> Another question,
> 
> 	wake_up_interruptible(&current->parent->signal->wait_chldexit);
> 
> Shouldn't we use ->real_parent ? Afaics, we shouldn't worry about the tracer
> if current is ptraced, exec must not succeed if the tracer has no rights to
> trace this task after cred changing. But we should notify ->real_parent which
> is, well, real parent.
> 
> Also, we don't need _irq to take tasklist_lock, and we don't actually need
> ->siglock.
> 
> Oleg.
> 

-- 
James Morris
<jmorris@namei.org>
