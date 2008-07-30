Return-Path: <linux-kernel-owner+w=401wt.eu-S1760774AbYG3Jw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760774AbYG3Jw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbYG3JwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:52:20 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:35967 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216AbYG3JwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:52:19 -0400
Date: Wed, 30 Jul 2008 13:56:14 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: David Howells <dhowells@redhat.com>, jmorris@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: Request for documentation of PID handling functions
Message-ID: <20080730095614.GA82@tv-sign.ru>
References: <21590.1217285986@redhat.com> <488FCC14.3070208@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488FCC14.3070208@openvz.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30, Pavel Emelyanov wrote:
>
> David Howells wrote:
> > Hi Pavel,
> > 
> > Can you please provide documentation for the PID handling functions you
> > supplied in commit:
> > 
> > 	7af5729474b5b8ad385adadab78d6e723e7655a3
> > 
> > In particular I'd like to know what locks are required when.  I'm trying to
> > determine if in this piece of code:
> > 
> > 		read_lock(&tasklist_lock);
> > 		ret = 0;
> > 		if (pid != task_pid_vnr(current))
> > 			ret = -EPERM;
> > 		read_unlock(&tasklist_lock);
> > 
> > the lock of tasklist_lock is necessary.
> 
> The RCU protection is enough to get pids from tasks. However, the pids
> are detached under the tasklist lock write-locked, so provided you're
> *already* sitting under it the RCU is excessive.

Yes, tasklist OR rcu is enough.

But, since the task == current, the code above doesn't need any locks at all.

Unless this code runs after exit_notify() of course, in that case we need
rcu/tasklist and task_pid_vnr(current) can return 0.

Oleg.

