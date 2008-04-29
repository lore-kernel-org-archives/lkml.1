Return-Path: <linux-kernel-owner+w=401wt.eu-S1764778AbYD2QDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764778AbYD2QDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 12:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbYD2QDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 12:03:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:11522 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbYD2QDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 12:03:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tTwef3QbWzl0icNNbezMbLejMmneLR5xx7QXkVbM03kTP2IjM9H4dl84peR/3PM5wHZnO52ySLSwaJGjJUCxvdgIkVPVca18rIC6DxXIjdg9E/1oAICmhpRTVVkw7S0PKeQ+3Oy8Ad433bRxuPq6oj9w3HPi5IFUERpbYu6C5gA=
Message-ID: <e2e108260804290903x44ad1cb7x1278027ab51b0831@mail.gmail.com>
Date: Tue, 29 Apr 2008 18:03:26 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/8] lockdep: fix recursive read lock validation
Cc: ego@in.ibm.com, linux-kernel@vger.kernel.org,
       "Zdenek Kabelac" <zdenek.kabelac@gmail.com>,
       "Oleg Nesterov" <oleg@tv-sign.ru>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Srivatsa Vaddagiri" <vatsa@in.ibm.com>
In-Reply-To: <1209482101.13978.91.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080429125659.GA23562@in.ibm.com>
	 <20080429125750.GB23562@in.ibm.com>
	 <e2e108260804290616l489ac8c2udcb2e80fc268b72b@mail.gmail.com>
	 <1209481050.13978.72.camel@twins>
	 <e2e108260804290803u75764b56t1c475a6d186aca8d@mail.gmail.com>
	 <1209482101.13978.91.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 5:15 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> On Tue, 2008-04-29 at 17:03 +0200, Bart Van Assche wrote:
>  > On Tue, Apr 29, 2008 at 4:57 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>  > >
>  > > On Tue, 2008-04-29 at 15:16 +0200, Bart Van Assche wrote:
>  > >  > On Tue, Apr 29, 2008 at 2:57 PM, Gautham R Shenoy <ego@in.ibm.com> wrote:
>  > >  > > Subject: lockdep: fix recursive read lock validation
>  > >  > >  This means that the following sequence is now invalid, whereas previously
>  > >  > >  it was considered valid:
>  > >  > >
>  > >  > >   rlock(a); rlock(b); runlock(b); runlock(a)
>  > >  > >   rlock(b); rlock(a);
>  > >  >
>  > >  > Why are you marking this sequence as invalid ? Although it can be
>  > >  > debated whether it is good programming practice to be inconsistent
>  > >  > about the order of read-locking, the above sequence can't be involved
>  > >  > in a deadlock.
>  > >
>  > >  Not for pure read locks, but when you add write locks to it, it does get
>  > >  deadlocky. Lockdep does not keep separate chains for read and write
>  > >  locks.
>  >
>  > Nesting writer locks inside reader locks is always a bad idea. So
>  > please come up with an example of how varying the reader lock nesting
>  > order can trigger a deadlock (when no writer locks are nested inside
>  > reader locks and nested writer locks are always nested in the same
>  > order).
>
>  It can't deadlock when only readers are involved, but lockdep will not
>  be able to distinguish between the cases where only read locks are
>  involved and a mix of readers and writers is involved.
>
>  Hence disallow both.
>
>  But hitting this requires you do a series of rather unfortunate things:
>
>   1) use recursive locking
>   2) don't have strict lock order
>   3) make it work by using read locks only
>
>  Seriously, any code that triggers this might want to have its locking
>  re-throught.

You did not get my point.

My point is that if you follow the following locking discipline, a
deadlock will never be triggered:
* Always obtain writer locks in a consistent order.
* Never nest writer locks inside reader locks.
* Nesting reader locks inside writer locks is okay, and nesting reader
locks inside other reader locks is also OK.

Again: if you do not agree with the above, please post an example that
proves me wrong.

Or: whether or not to allow a sequence like "rlock(a); rlock(b);
runlock(b); runlock(a); rlock(b); rlock(a);" is something we can
choose. We do not have to forbid this sequence -- we can choose
whether or not we allow this sequence.

Bart.
