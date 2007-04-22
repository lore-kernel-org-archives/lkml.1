Return-Path: <linux-kernel-owner+w=401wt.eu-S1161338AbXDVQQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161338AbXDVQQg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 12:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161359AbXDVQQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 12:16:35 -0400
Received: from qb-out-0506.google.com ([72.14.204.237]:41006 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161338AbXDVQQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 12:16:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lb1HSM8xC4jsM/P32JXf3w91y53MoSWhZnfkf8eLjyYigVKJth5P+wjsEOgwuX1RlY/LlI0WhRDD4XtFjC0xutZoKt53b7lf3U6v3omurGY5RY+xulT5LHG3EpjI7m4bFmyk5Yh80NbJaz21ZUojUlePH/gHGipruvrTXpWYcak=
Message-ID: <a36005b50704220916u1ac5bd35gd1fa978761f02ab8@mail.gmail.com>
Date: Sun, 22 Apr 2007 09:16:31 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "William Lee Irwin III" <wli@holomorphy.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Kyle Moffett" <mrmacman_g4@mac.com>, "Willy Tarreau" <w@1wt.eu>,
       "Ingo Molnar" <mingo@elte.hu>, "Con Kolivas" <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>, "Mike Galbraith" <efault@gmx.de>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Peter Williams" <pwil3058@bigpond.net.au>,
       "Thomas Gleixner" <tglx@linutronix.de>, caglar@pardus.org.tr,
       "Gene Heskett" <gene.heskett@gmail.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>
In-Reply-To: <20070422084843.GJ2986@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070421154614.GA26169@elte.hu>
	 <alpine.LFD.0.98.0704210931370.9964@woody.linux-foundation.org>
	 <20070421164241.GF2986@holomorphy.com>
	 <E1192E83-5E64-4782-8F92-DDCA09CA2F55@mac.com>
	 <a36005b50704211249pb771b79k227914515b5f9906@mail.gmail.com>
	 <alpine.LFD.0.98.0704211634130.9964@woody.linux-foundation.org>
	 <a36005b50704211846g4ed1256fpad6a3a5670318314@mail.gmail.com>
	 <20070422070238.GH2986@holomorphy.com>
	 <a36005b50704220017y664eef89u5f78f1e089c5014@mail.gmail.com>
	 <20070422084843.GJ2986@holomorphy.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/22/07, William Lee Irwin III <wli@holomorphy.com> wrote:
> On Sun, Apr 22, 2007 at 12:17:31AM -0700, Ulrich Drepper wrote:
> > For futex(), the extension is needed for the FUTEX_WAIT operation.  We
> > need a new operation FUTEX_WAIT_FOR or so which takes another (the
> > fourth) parameter which is the PID of the target.
> > For FUTEX_LOCK_PI we need no extension.  The futex value is the PID of
> > the current owner.  This is required for the whole interface to work
> > in the first place.
>
> We'll have to send things out and see what sticks here. There seems to
> be some pickiness above.

I know Rusty will shudder since it makes futexes yet more complicated
(although only if the user wants it) but if you introduce the concept
of "yield to" then this extension makes really sense and it is a quite
simple extension.  Plus: I'm the most affected by the change since I
have to change code to use it and I'm fine with it.

Oh, last time I didn't explicitly mention the cases of
waitpid()/wait4()/waitid() explicitly naming a process to wait on.  I
think it's clear that those cases also should be changed to use yield
to if possible.  I don't have a good suggestion what to do when the
call waits for any child.  Perhaps yielding to the last created one is
fine.  If delays through reading on a pipe are recognized as well and
handle with yield to then the time slot will automatically be
forwarded to the first runnable process in the pipe sequence.  I.e.,
running

    grep foo /etc/passwd | cut -d: -f2 | crack

probably will create 'crack' last.  Giving the remainder of the time
slot should result is recognizing it waits for 'cut' which in turn
waits for 'grep'.  So in the end 'grep' gets the timeslot.  Seems
quite complicated from the outside but I can imagine quite good
results from this.
