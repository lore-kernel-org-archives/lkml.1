Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbXJ2WFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbXJ2WFD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 18:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbXJ2WEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 18:04:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbXJ2WEx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 18:04:53 -0400
From: Steve Grubb <sgrubb@redhat.com>
Organization: Red Hat
To: Tony Jones <tonyj@suse.de>
Subject: Re: [PATCH] audit: clear thread flag for new children
Date: Mon, 29 Oct 2007 18:04:31 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, chrisw@sous-sol.org,
       viro@ftp.linux.org.uk
References: <20071026204228.GA1519@suse.de> <200710271021.42093.sgrubb@redhat.com> <20071029172058.GA8433@suse.de>
In-Reply-To: <20071029172058.GA8433@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710291804.31784.sgrubb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 October 2007 01:20:58 pm Tony Jones wrote:
> > The problem is that removing that flag makes the children unauditable in
> > the future. The only place that flag gets set is during fork.
>
> I don't see this.

If the child does not have the TIF_SYSCALL_AUDIT flag, it never goes into 
audit_syscall_entry. It becomes unauditable.


> The case that would be undesirable would be for a task to have an audit
> context but to not have the thread flag enabled.

That would just be a small allocation of memory that will be returned when the 
process exits. From an auditing PoV, something that is undesirable is the 
inability to audit a process that you want to audit.


> > Unless I'm missing something, to make all children auditable again would
> > mean stopping all processes and or'ing that flag into all thread info
> > areas.
>
> I think you are.  Or maybe the code was different two years ago so that the
> above made sense.  
>
> In the above scenario, audit is disabled, a new child is forked, we bail
> early so there is no audit context (and now there is no flag in the thread
> area).   Currently there is no way this task is ever going to be audited as
> there is no audit context. 

So when audit is re-enabled, how do you make that task auditable?


> If this task forks a new child, at this point the value of audit enabled
> will determine if there should be a context allocated and it will allocate
> the TIF flag also.

In the new child, but not the parent.


> I don't see your stopping all processes scenario. 

That is so you can walk the process table and "or" the bit in unconditionally. 
All processes need to be auditable or you've got a security hole.

-Steve
