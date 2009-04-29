Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbZD2NeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbZD2NeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbZD2NeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:34:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40083 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492AbZD2NeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:34:09 -0400
Date: Wed, 29 Apr 2009 15:30:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: David Howells <dhowells@redhat.com>, Eric Paris <eparis@parisplace.org>,
       James Morris <jmorris@namei.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Q: selinux_bprm_committed_creds() && signals/do_wait
Message-ID: <20090429133015.GA30505@redhat.com>
References: <20090428223025.GA11997@redhat.com> <1241011116.18249.193.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241011116.18249.193.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29, Stephen Smalley wrote:
>
> On Wed, 2009-04-29 at 00:30 +0200, Oleg Nesterov wrote:
> > selinux_bprm_committed_creds:
> > 
> > 	rc = avc_has_perm()
> > 	if (rc) {
> > 		flush_signals(current);
> > 
> > This doesn't look right. If the task was SIGKILL'ed we must not proceed,
> > the task should die. The fix is simple, we should check SIGNAL_GROUP_EXIT
> > and do nothing in this case, the task will exit before return to user
> > space. If SIGNAL_GROUP_EXIT is set, it is just wrong to drop SIGKILL and
> > continue.
> > 
> > But, before fixing, I'd like to understand why we are doing
> > 
> > 		flush_signal_handlers(current, 1);
> > 		sigemptyset(&current->blocked);
> > 
> > later. Could someone explain ? This looks unneeded.
> > 
> > 
> > Another question,
> > 
> > 	wake_up_interruptible(&current->parent->signal->wait_chldexit);
> > 
> > Shouldn't we use ->real_parent ? Afaics, we shouldn't worry about the tracer
> > if current is ptraced, exec must not succeed if the tracer has no rights to
> > trace this task after cred changing. But we should notify ->real_parent which
> > is, well, real parent.
> 
> That makes sense to me - yes, s/parent/real_parent/.

Great, thanks. Will send the patch soon.

Oleg.

