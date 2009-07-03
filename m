Return-Path: <linux-kernel-owner+w=401wt.eu-S1758334AbZGCQLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334AbZGCQLx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 12:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756959AbZGCQLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 12:11:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44922 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756369AbZGCQLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 12:11:44 -0400
Date: Fri, 3 Jul 2009 09:11:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] selinux_bprm_committed_creds: use __wake_up_parent()
Message-Id: <20090703091100.a9667969.akpm@linux-foundation.org>
In-Reply-To: <20090703092311.GA3712@redhat.com>
References: <200906301951.n5UJpUSY013305@imap1.linux-foundation.org>
	<11314.1246585948@turing-police.cc.vt.edu>
	<20090702192047.10b81ada.akpm@linux-foundation.org>
	<20090703081821.GA4051@redhat.com>
	<20090703092311.GA3712@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jul 2009 11:23:11 +0200 Oleg Nesterov <oleg@redhat.com> wrote:

> (depends on ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
>  which exports __wake_up_parent)
> 
> Spotted by Valdis.Kletnieks@vt.edu.
> 
> selinux_bprm_committed_creds() should not play with ->wait_chldexit, now
> that __wake_up_parent() is exported change the code to use this helper.

That's a bit vague.  Why shouldn't it play with wait_chldexit?  What
changed to make that wrong?

Is this a -mm fix?  If so, which -mm patch introduced the problem?

If not, how come the crash isn't being reported in mainline?

Confused.

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> 
> --- WAIT/security/selinux/hooks.c~SEL_WAKE_PARENT	2009-06-16 17:01:42.000000000 +0200
> +++ WAIT/security/selinux/hooks.c	2009-07-03 11:15:08.000000000 +0200
> @@ -2404,7 +2404,7 @@ static void selinux_bprm_committed_creds
>  	/* Wake up the parent if it is waiting so that it can recheck
>  	 * wait permission to the new task SID. */
>  	read_lock(&tasklist_lock);
> -	wake_up_interruptible(&current->real_parent->signal->wait_chldexit);
> +	__wake_up_parent(current, current->real_parent);
>  	read_unlock(&tasklist_lock);
>  }
>  
