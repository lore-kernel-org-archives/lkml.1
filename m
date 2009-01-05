Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbZAEOr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbZAEOr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 09:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754907AbZAEOrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:47:43 -0500
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:22946 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754680AbZAEOrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:47:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JOH+fDDN4SJBLSpJFVFu4oiOhCednEPn9/mHAYsqaJMe5/YLMBpOWC6yC/iuxYe1YY+xwlhe38RY/K7RG0Cm68F+g6tEePgjBj9VQTKBnyQN6GQbJsGlyUl7AunVbne1fV86DZ0J+DyIl4zGz01owbZVWi8xeeIuuJVY6KxW5LM=  ;
X-YMail-OSG: O35RuyAVM1lmv9k1oZ24baxGgAOZ5kQ._l.MuPFsIDCimZw_vHx3nSonlVPkIZ6JDXTtA6jUJMgIf8GULJVUbyq7D7J1QhTKYDJ2vvCVdWwY6XRzRD1azGjdo4gYoZhIDKKtJqSvcF.EFPVZIK0i51GgK5AMQqJvr3hibgopSTnMODexbQOyzUkOzsc1eQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Btrfs for mainline
Date: Tue, 6 Jan 2009 01:47:23 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
       "linux-btrfs" <linux-btrfs@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <1231093310.27690.5.camel@twins> <20090104184103.GE2002@parisc-linux.org>
In-Reply-To: <20090104184103.GE2002@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901060147.24285.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 January 2009 05:41:03 Matthew Wilcox wrote:
> On Sun, Jan 04, 2009 at 07:21:50PM +0100, Peter Zijlstra wrote:
> > The -rt tree has adaptive spin patches for the rtmutex code, its really
> > not all that hard to do -- the rtmutex code is way more tricky than the
> > regular mutexes due to all the PI fluff.
> >
> > For kernel only locking the simple rule: spin iff the lock holder is
> > running proved to be simple enough. Any added heuristics like max spin
> > count etc. only made things worse. The whole idea though did make sense
> > and certainly improved performance.
>
> That implies moving
>
>         struct thread_info      *owner;
>
> out from under the CONFIG_DEBUG_MUTEXES code.  One of the original
> justifications for mutexes was:
>
>  - 'struct mutex' is smaller on most architectures: .e.g on x86,
>    'struct semaphore' is 20 bytes, 'struct mutex' is 16 bytes.
>     A smaller structure size means less RAM footprint, and better
>     CPU-cache utilization.
>
> I'd be reluctant to reverse that decision just for btrfs.
>
> Benchmarking required!  Maybe I can put a patch together that implements
> the simple 'spin if it's running' heuristic and throw it at our
> testing guys on Monday ...

adaptive locks have traditionally (read: Linus says) indicated the locking
is suboptimal from a performance perspective and should be reworked. This
is definitely the case for the -rt patchset, because they deliberately
trade performance by change even very short held spinlocks to sleeping locks. 

So I don't really know if -rt justifies adaptive locks in mainline/btrfs.
Is there no way for the short critical sections to be decoupled from the
long/sleeping ones?

