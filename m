Return-Path: <linux-kernel-owner+w=401wt.eu-S1752265AbXCMGYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbXCMGYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 02:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbXCMGYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 02:24:50 -0400
Received: from ozlabs.org ([203.10.76.45]:33085 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbXCMGYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 02:24:49 -0400
Subject: Re: _proxy_pda still makes linking modules fail
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Marcin 'Qrczak' Kowalczyk" <qrczak@knm.org.pl>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1173736726.10618.1.camel@localhost.localdomain>
References: <1173315479.12472.9.camel@qrnik>
	 <p73lki39s3a.fsf@bingen.suse.de> <45F49E0A.3090607@goop.org>
	 <20070312094805.GA11644@one.firstfloor.org>
	 <1173736726.10618.1.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 13 Mar 2007 17:23:52 +1100
Message-Id: <1173767032.10618.43.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 08:59 +1100, Rusty Russell wrote:
> On Mon, 2007-03-12 at 10:48 +0100, Andi Kleen wrote:
> > > Rusty's pda->per_cpu patch will deal with this once and for all; have
> > 
> > Not on x86-64.
> 
> Indeed.  Perhaps it's time I join the modern world and compile a 64-bit
> kernel...
> 
> Will prepare patches,

No, I don't think I will.  The PDA concept has gone too far in x86-64 to
be undone.  In particular, it's been put in GCC 4.1 for
CONFIG_CC_STACKPROTECTOR, which assumes %gs:40 will give the stack
canary.

For the record: the PDA should never have existed, that's what percpu
vars were supposed to be for.  Something went wrong here 8(

%gs is best set to the offset of the local cpu's area from the "master"
per-cpu area, not set to the local cpu area's address.  In the former
case, booting with %gs at offset 0 works naturally, in the latter case,
hoops need to be jumped through to make it work.  See how much nicer the
x86 code is post pda->percpu conversion.

So, even if we leave the PDA and place the per-cpu area immediately
after it, we still can't use "%gs:var" to access a per-cpu variable: we
need to do a subtract, so why bother using the segment reg?

The ideal solution has always been to use __thread, but no architecture
has yet managed it (I tried for i386, and it quickly caused unbearable
pain).  On x86-64 that uses "%fs" on x86-64, not "%gs" as the kernel
does, but I might try that if I feel particularly masochistic soon...

In summary, containing the PDA infection to x86-64 is possible, but
curing that patient is non-trivial 8)

Rusty.

