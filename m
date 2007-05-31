Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbXEaOx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbXEaOx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 10:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbXEaOxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 10:53:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:6059 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbXEaOxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 10:53:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=N6L6JncIpe7NESELer9JzmJSQ3xKOThMEiMx27/Pvedr8TYt2bE27z/3B7F9d5gX931o573rdOTHFgm+aL1Qs4WZrts9RPMf2rpN4WyYvwxTBRilxaIMT4vSlvYtMxyE0VyqXppIcyxz1DnO+TiUqon9818Vlk3sGk5ePvzhqRc=
Message-ID: <a36005b50705310753x2a09172boa6ceb63f9ca4d4b8@mail.gmail.com>
Date: Thu, 31 May 2007 07:53:49 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [BUG] futex_unlock_pi() hurts my brain and may cause application deadlock
Cc: "john stultz" <johnstul@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Sripathi Kodi" <sripathik@in.ibm.com>
In-Reply-To: <1180574993.21781.22.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1180572567.6126.44.camel@localhost.localdomain>
	 <1180574993.21781.22.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/07, Steven Rostedt <rostedt@goodmis.org> wrote:
> >       if (!(uval & FUTEX_OWNER_DIED)) {
> >               pagefault_disable();
> >               uval = futex_atomic_cmpxchg_inatomic(uaddr, current->pid, 0);
> >               pagefault_enable();
> >       }
> [...]
> This code is in futex_unlock_pi.  Can the owner of the mutex really die?
> Isn't the owner the one doing the unlock?

This is part of the implementation of robust PI futexes.  The
semantics is that if the owner of a robust futex dies the futex is
marked with FUTEX_OWNER_DIED.  The next locking thread then has to
clear that bit before calling pthread_mutex_unlock.  If the bit is
still set while unlocking the mutex is permanently marked unusable.  I
cannot say right now whether this is the semantics implemented above.
I'll have to check the glibc test suite whether we check for that
semantic.
