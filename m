Return-Path: <linux-kernel-owner+w=401wt.eu-S1755168AbZBCW3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbZBCW3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 17:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbZBCW3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 17:29:44 -0500
Received: from waste.org ([66.93.16.53]:43689 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbZBCW3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 17:29:43 -0500
Subject: Re: [PATCH 2/4] Convert epoll to a bitlock
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>, corbet@lwn.net,
       linux-kernel@vger.kernel.org, andi@firstfloor.org, oleg@redhat.com,
       viro@ZenIV.linux.org.uk, davidel@xmailserver.org, davem@davemloft.net,
       hch@lst.de, linux-api@vger.kernel.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20090203140543.6e915f97.akpm@linux-foundation.org>
References: <1233598811-6871-1-git-send-email-corbet@lwn.net>
	 <1233598811-6871-3-git-send-email-corbet@lwn.net>
	 <20090203133942.2ecec281.akpm@linux-foundation.org>
	 <4988BD4E.8080206@cosmosbay.com>
	 <20090203140543.6e915f97.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 16:22:02 -0600
Message-Id: <1233699722.3243.127.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-03 at 14:05 -0800, Andrew Morton wrote:
> On Tue, 03 Feb 2009 22:55:26 +0100
> Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
> > Andrew Morton a __crit :
> > > On Mon,  2 Feb 2009 11:20:09 -0700
> > > Jonathan Corbet <corbet@lwn.net> wrote:
> > > 
> > >> Matt Mackall suggested converting epoll's ep_lock to a bitlock as a way of
> > >> saving space in struct file.  This patch makes that change.
> > > 
> > > hrm.  bit_spin_lock() makes people upset (large penguiny people).  iirc
> > > it doesn't have all the correct/well-understood memory/compiler
> > > ordering semantics which spinlocks have.  And lockdep doesn't know about
> > > it.
> > > 
> > 
> > In a previous attempt (2005), I suggested using a single global lock.
> > 
> > http://search.luky.org/linux-kernel.2005/msg50862.html
> 
> ok..
> 
> > Probably an array of hashed spinlocks would be more than enough.
> > 
> 
> yes, f_ep_lock is a teeny innermost lock.  Perhaps using
> f->f_dentry->d_inode->i_lock would be a decent speed/space compromise.

That seems eminently reasonable.

But that re-opens the question of what to do about poor Jon's quest.

I got confused halfway through as he went from using a global fasync
spinlock to a non-locked but atomic flag bit. Not sure why using a
per-file or per-inode lock doesn't work for the fasync code.

-- 
http://selenic.com : development and support for Mercurial and Linux


