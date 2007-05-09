Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbXEIMB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbXEIMB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757245AbXEIMAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:00:25 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:1179 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756946AbXEIMAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:00:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=a2VKPe4iK52E4mrndjj8ctLhkaJWneH5H3bKROdSv/dILYa6Il+YpwSYwjgNWXo8yMpsqv9m3mzVE7dcB55H+bm9QEqow1Aef2PRwGza9eo0XyC6lQL4WYeeflCjtZmrSVaXpmc66I5a2fCoiSavV49zRM9eb4UXNL4BTd/DSFs=
Message-ID: <6e0cfd1d0705090500u3423877u579ebace44100b77@mail.gmail.com>
Date: Wed, 9 May 2007 14:00:19 +0200
From: "Martin Schwidefsky" <schwidefsky@googlemail.com>
To: "Paul Mackerras" <paulus@samba.org>
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and powerpc
Cc: suparna@in.ibm.com, "Andrew Morton" <akpm@linux-foundation.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       xfs@oss.sgi.com, cmm@us.ibm.com
In-Reply-To: <17985.45682.284634.969153@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070418130600.GW5967@schatzie.adilger.int>
	 <20070424121632.GA10136@amitarora.in.ibm.com>
	 <20070426175056.GA25321@amitarora.in.ibm.com>
	 <20070426180332.GA7209@amitarora.in.ibm.com>
	 <20070503212955.b1b6443c.akpm@linux-foundation.org>
	 <17978.47502.786970.196554@cargo.ozlabs.ibm.com>
	 <20070509101507.GA26056@in.ibm.com>
	 <17985.42884.971318.859402@cargo.ozlabs.ibm.com>
	 <20070509111011.GA21619@in.ibm.com>
	 <17985.45682.284634.969153@cargo.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/9/07, Paul Mackerras <paulus@samba.org> wrote:
> Suparna Bhattacharya writes:
>
> > > Of course the interface used by an application program would have the
> > > fd first.  Glibc can do the translation.
> >
> > I think that was understood.
>
> OK, then what does it matter what the glibc/kernel interface is, as
> long as it works?
>
> It's only a minor point; the order of arguments can vary between
> architectures if necessary, but it's nicer if they don't have to.
> 32-bit powerpc will need to have the two int arguments adjacent in
> order to avoid using more than 6 argument registers at the user/kernel
> boundary, and s390 will need to avoid having a 64-bit argument last
> (if I understand it correctly).

Ah, almost but not quite the point. But I admit it is hard to understand..
The trouble started with the futex call which has been the first
system call with 6 arguments. s390 supported only 5 arguments up to
that point (%r2 - %r6). For futex we added a wrapper to the glibc that
loaded the 6th argument to %r7. In entry.S we set up things so that
%r7 gets stored to the kernel stack where normal C code expects the
first overflow argument. This enabled us to use the standard futex
system call with 6 arguments.
fallocate now has an additional problem: the last argument is a 64 bit
integers AND registers %r2-%r5 are already used. In this case the 64
bit number would have to be split into the high part in %r6 and the
low part on the stack so that the glibc wrapper can load the low part
to %r7. But the C compiler will skip %r6 and store the 64 bit number
on the stack.
If the order of the arguments if modified so that %r6 is assigned to a
32-bit argument, then the entry.S magic with %r7 would work.

-- 
blue skies,
  Martin
