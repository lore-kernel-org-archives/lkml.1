Return-Path: <linux-kernel-owner+w=401wt.eu-S1751461AbZKLHW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbZKLHW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 02:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbZKLHW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 02:22:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43949 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbZKLHW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 02:22:27 -0500
Date: Thu, 12 Nov 2009 08:22:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Jeff Garzik <jeff@garzik.org>,
       "Wu, Fengguang" <fengguang.wu@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] vfs: Add a trace point in the mark_inode_dirty function
Message-ID: <20091112072217.GA31719@elte.hu>
References: <20091025225342.007138f5@infradead.org>
 <20091111020108.GA11423@localhost>
 <20091110223456.01ef355f@infradead.org>
 <4AFA6AEF.5060306@garzik.org>
 <20091111081905.270a4e55@infradead.org>
 <y0m3a4kpsiw.fsf@fche.csb>
 <4AFB4AC7.1090405@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFB4AC7.1090405@intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kok, Auke <auke-jan.h.kok@intel.com> wrote:

> If you already know what the file object is, sure. We're interested in 
> the case where we have no clue what the file object actually is to 
> begin with. Having a trace with a random inode number pop up and then 
> disappear into thin air won't help much at all, especially if we can't 
> map it back to something "real" on disk. in time.

Yep.

It's similar to PID/comm tracing, which we already do consistently for 
all major task events such as fork/exit, sleep/wakeup/context-switch, 
etc.

By the 'use inode numbers' argument it should be perfectly fine to only 
trace the physical PID itself, and look up the comm later in /proc, or 
to add a syscall to do it.

In reality it's not fine. Not just the unnecessary overhead (you have to 
look up something you already had) - but also that tasks will exit in 
high-freq workloads (so the comm is lost), the PID might not match up 
anymore, tasks can change their comm, etc.

The most important principle with event logging is that we want the most 
high quality information and we want to a trustable and simple data 
source: so for tasks we want the PID and the comm, and for files we want 
the top name component and perhaps also the inode number (plus a 
filesystem id), captured when the event happened.

	Ingo
