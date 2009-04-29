Return-Path: <linux-kernel-owner+w=401wt.eu-S1752354AbZD2NZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbZD2NZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755473AbZD2NZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:25:09 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.67.1]:64101 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758853AbZD2NZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:25:08 -0400
Subject: Re: Q: selinux_bprm_committed_creds() && signals/do_wait
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>, Eric Paris <eparis@parisplace.org>,
       James Morris <jmorris@namei.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090428223025.GA11997@redhat.com>
References: <20090428223025.GA11997@redhat.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 29 Apr 2009 09:18:36 -0400
Message-Id: <1241011116.18249.193.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-29 at 00:30 +0200, Oleg Nesterov wrote:
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
> 
> But, before fixing, I'd like to understand why we are doing
> 
> 		flush_signal_handlers(current, 1);
> 		sigemptyset(&current->blocked);
> 
> later. Could someone explain ? This looks unneeded.
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

That makes sense to me - yes, s/parent/real_parent/.

-- 
Stephen Smalley
National Security Agency

