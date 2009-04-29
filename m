Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbZD2Ori@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbZD2Ori (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 10:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbZD2Or3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 10:47:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38095 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752151AbZD2Or2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 10:47:28 -0400
Date: Wed, 29 Apr 2009 15:47:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Oleg Nesterov <oleg@redhat.com>, James Morris <jmorris@namei.org>,
       David Howells <dhowells@redhat.com>, Eric Paris <eparis@parisplace.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: selinux_bprm_committed_creds() && signals/do_wait
Message-ID: <20090429154701.2e5b15f6@lxorguk.ukuu.org.uk>
In-Reply-To: <1241011014.18249.192.camel@localhost.localdomain>
References: <20090428223025.GA11997@redhat.com>
	<alpine.LRH.2.00.0904291024001.5246@tundra.namei.org>
	<20090429065809.GA477@redhat.com>
	<1241007630.18249.141.camel@localhost.localdomain>
	<20090429125606.GA27901@redhat.com>
	<1241011014.18249.192.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > For example, a user does "nohup setuid_app". Now, why should we change
> > SIG_IGN to SIG_DFL for SIGHUP? This makes setuid_app more "vulnerable"
> > to SIGHUP, not more "protected". Confused.
> 
> Not if the app was depending on the default handler for SIGHUP to
> correctly handle vhangup().  The point is that we don't necessarily
> trust the caller to define the handling behavior for signals in the
> callee.  If we trust the caller to do so, then we can grant the
> corresponding permission.

You are changing standards defined behaviour - so apps that rely on
correct behaviour maybe misbehave or become vulnerable in ways not
anticipated

A classic example here is SIGPIPE. What you are doing by dropping to
default signal behaviour is breaking various inetd style setups that know
the child will inherit SIGPIPE as SIG_IGN and therefore will cleanly
process network connection loss.

Instead the child will now suffer immediate termination and not
have a chance to clean up. 

So mucking with signal masks is actually not improving security - it's
randomly changing things - and randomly changing things to disagree with
the spec is a very very bad idea IMHO as you will harm correctly written
code.

> But we still have the problem of the caller setting up the signal
> handlers or blocked signal mask prior to exec'ing the privileged
> program, right

No.

A signal handler function is cleared across a setuid exec so you can't
set an address and jump to it in the new binary. K&R thought of that
one ;)

A signal mask is inherited and this is *required to be so*. Changing it
breaks stuff and may itself introduce security problems.

Any setuid app has to be reasonably robust because it may get very
strange file handles, very strange signal masks, quotas, resource limits
and other stuff. Signals are just one trivial detail.

Clearing a lot of these is hard as you don't know what the resource
limits etc for the setuid target are and you don't want a pair of setuid
user A and user B apps co-operating to evade things.

The correct way to do most of this is not to use setuid apps run by the
user but to pass authority information to service daemons that run
services within a known non-user influencable environment in the first
place... the very daemons that randomly clearing the SIG_IGN on SIGPIPE
will break !

Alan

