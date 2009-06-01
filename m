Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbZFASMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbZFASMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 14:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbZFASMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 14:12:13 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:49945 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbZFASMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 14:12:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=WFKfcN6ilJ/cU2YzYAY8XVEXzDiLC5DDdgvcoBRRRMa/u2jaI9TtT9DMaK12R4RbZx
         JYPTqmfL14t9rxj84HfuStuWssptzoJfmahXI9jVVwCYBsUTNzsaZjd9HqcAyYooX/Q5
         wJZkoO8xTtKqjIJ/USRws3lzG91h1O0itZVJE=
Date: Mon, 1 Jun 2009 20:12:08 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Borislav Petkov <borislav.petkov@amd.com>, greg@kroah.com,
       mingo@elte.hu, norsk5@yahoo.com, tglx@linutronix.de, mchehab@redhat.com,
       aris@redhat.com, edt@aei.ca, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 0/4] amd64_edac: misc fixes
Message-ID: <20090601181208.GA30565@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Borislav Petkov <borislav.petkov@amd.com>, greg@kroah.com,
	mingo@elte.hu, norsk5@yahoo.com, tglx@linutronix.de,
	mchehab@redhat.com, aris@redhat.com, edt@aei.ca,
	linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
	Sam Ravnborg <sam@ravnborg.org>
References: <1242845037-1029-1-git-send-email-borislav.petkov@amd.com> <20090528164720.0af5752b.akpm@linux-foundation.org> <20090529103329.GB23530@aftab> <20090529130115.a44efaee.akpm@linux-foundation.org> <20090530081954.GA21954@liondog.tnic> <20090530014007.3c1e22d5.akpm@linux-foundation.org> <4A218761.5080607@zytor.com> <20090601145326.GA28260@liondog.tnic> <4A2407D1.5050706@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4A2407D1.5050706@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 09:54:41AM -0700, H. Peter Anvin wrote:
> Borislav Petkov wrote:
> > 
> > How about we pin the src/dst into a register:
> > 
> > #define popcnt_spelled(x)                                       \
> > ({                                                              \
> >         typeof(x) __ret;                                        \
> >         __asm__(".byte 0xf3\n\t.byte 0x48\n\t.byte 0x0f\n\t"    \
> >                 ".byte 0xb8\n\t.byte 0xc0\n\t"                  \
> >                 : "=a" (__ret)                                  \
> >                 : "0" (x));                                     \
> >         __ret;                                                  \
> > })
> > 
> > which generates
> > 
> >   40055e:       48 8b 45 e8             mov    -0x18(%rbp),%rax
> >   400562:       f3 48 0f b8 c0          popcnt %rax,%rax
> >   400567:       48 89 45 f8             mov    %rax,-0x8(%rbp)
> > 
> > here.
> > 
> 
> Yes, we would have to do something like that.
> 
> However, if you're doing that you shouldn't use typeof() there...
> instead this should be turned into an inline function with explicit
> 64-bit types.

right.

> It would be good if we could get Kbuild to export some kind of macro
> that we can use to test binutils version, so we can do something like:
> 
> #if BINUTILS_VERSION >= KERNEL_VERSION(2,18,50)
> /* Do the right thing */
> #else
> /* Do the wrong thing */
> #endif

Actually, popcnt got added to gas in July 2006 so checking the gas
version should suffice, IMHO.

Anyway, I proposed something similar before but Andrew suggested that we
should simply slap in the opcode so we don't need the Kbuild changes.
The advantage of the approach is that it works unconditionally on all
toolchains and introduces less code changes. Hmm...

-- 
Regards/Gruss,
    Boris.
