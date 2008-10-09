Return-Path: <linux-kernel-owner+w=401wt.eu-S1759436AbYJINRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436AbYJINRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 09:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758163AbYJINRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 09:17:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43319 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758139AbYJINRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 09:17:44 -0400
Date: Thu, 9 Oct 2008 15:17:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>, jeremy@goop.org, arnd@arndb.de,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC v6][PATCH 0/9] Kernel based checkpoint/restart
Message-ID: <20081009131701.GA21112@elte.hu>
References: <1223461197-11513-1-git-send-email-orenl@cs.columbia.edu> <20081009124658.GE2952@elte.hu> <1223557122.11830.14.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223557122.11830.14.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> On Thu, 2008-10-09 at 14:46 +0200, Ingo Molnar wrote:
> > * Oren Laadan <orenl@cs.columbia.edu> wrote:
> > 
> > > These patches implement basic checkpoint-restart [CR]. This version 
> > > (v6) supports basic tasks with simple private memory, and open files 
> > > (regular files and directories only). Changes mainly cleanups. See 
> > > original announcements below.
> > 
> > i'm wondering about the following productization aspect: it would be 
> > very useful to applications and users if they knew whether it is safe to 
> > checkpoint a given app. I.e. whether that app has any state that cannot 
> > be stored/restored yet.
> 
> Absolutely!
> 
> My first inclination was to do this at checkpoint time: detect and 
> tell users why an app or container can't actually be checkpointed.  
> But, if I get you right, you're talking about something that happens 
> more during the runtime of the app than during the checkpoint.  This 
> sounds like a wonderful approach to me, and much better than what I 
> was thinking of.
> 
> What kind of mechanism do you have in mind?
> 
> int sys_remap_file_pages(...)
> {
> 	...
> 	oh_crap_we_dont_support_this_yet(current);
> }
> 
> Then the oh_crap..() function sets a task flag or something?

yeah, something like that. A key aspect of it is that is has to be very 
low-key on the source code level - we dont want to sprinkle the kernel 
with anything ugly. Perhaps something pretty explicit:

  current->flags |= PF_NOCR;

as we do the same thing today for certain facilities:

  current->flags |= PF_NOFREEZE;

you probably want to hide it behind:

  set_current_nocr();

and have a set_task_nocr() as well, in case there's some proxy state 
installed by another task.

Via such wrappers there's no overhead at all in the 
!CONFIG_CHECKPOINT_RESTART case.

Plus you could drive the debug mechanism via it as well, by using a 
trivial extension of the facility:

  set_current_nocr("CR: sys_remap_file_pages not supported yet.");
  ...
  set_task_nocr(t, "CR: PI futexes not supported yet.");

	Ingo
