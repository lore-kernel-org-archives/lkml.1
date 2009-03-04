Return-Path: <linux-kernel-owner+w=401wt.eu-S1757281AbZCDUON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281AbZCDUON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 15:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZCDUN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 15:13:58 -0500
Received: from mx1.emlix.com ([193.175.82.87]:53370 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbZCDUN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 15:13:57 -0500
Date: Wed, 4 Mar 2009 21:13:54 +0100
From: Johannes Weiner <jw@emlix.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       Russell King <rmk@arm.linux.org.uk>, Bryan Wu <cooloney@kernel.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Paul Mundt <lethal@linux-sh.org>, Greg Ungerer <gerg@uclinux.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -v2] flat: fix data sections alignment
References: <E1LerUo-0000NE-Q3@mailer.emlix.com> <8bd0f97a0903041004g467cbe47jc7c66261da01348c@mail.gmail.com> <E1LewqM-0005Tp-R1@mailer.emlix.com> <8bd0f97a0903041200y4dfa9556r8709c4331a12002b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0903041200y4dfa9556r8709c4331a12002b@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Message-Id: <E1LexT4-00063F-Vp@mailer.emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 04, 2009 at 03:00:25PM -0500, Mike Frysinger wrote:
> On Wed, Mar 4, 2009 at 14:33, Johannes Weiner wrote:
> > On Wed, Mar 04, 2009 at 01:04:00PM -0500, Mike Frysinger wrote:
> >> On Wed, Mar 4, 2009 at 08:51, Johannes Weiner wrote:
> >> > The flat loader uses an architecture's flat_stack_align() to align the
> >> > stack but assumes word-alignment is enough for the data sections.
> >> >
> >> > However, on the Xtensa S6000 we have registers up to 128bit width
> >> > which can be used from userspace and therefor need userspace stack and
> >> > data-section alignment of at least this size.
> >>
> >> could this perhaps be a gcc problem ?  x86 has a similar problem with
> >> sse and they addressed it with a function attribute.  after all, just
> >> because your stack started out 128bit aligned doesnt mean gcc will
> >> keep it that way when calling other functions.  so having the stack
> >> start out aligned would only "fix" the stack for the application's
> >> entry point right (which would in practice bubble up to main()) ?  so
> >> you'd be right back where you started ...
> >
> > gcc generates sp changes only ever in multiples of 16 deltas, I just
> > checked it again with various amounts of stack variables.
> >
> > The stack frames allocate themselves with an ENTRY instruction and the
> > generated code I read here allocates stack frames of n * 16 bytes.
> >
> > So we are good to go as long as the initial stack frame is properly
> > aligned.
> 
> throwing a few random cases at gcc isnt really a good way to validate.
>  this would have worked for x86 too with older versions.  only when
> common code in later gcc versions got more aggressive with stack
> packing did people notice the issue.
> 
> so, lets look at the authoritative place: the gcc source code for xtensa
> 
> $ grep define.*STACK_BOUNDARY -B 2 gcc/config/xtensa/*.h
> xtensa.h-/* Align stack frames on 128 bits for Xtensa.  This is necessary for
> xtensa.h-   128-bit datatypes defined in TIE (e.g., for Vectra).  */
> xtensa.h:#define STACK_BOUNDARY 128
> 
> ok, now i believe that forcing a stack alignment of 128bits in the
> kernel is correct ;)

Now I do too.  Heh.

Seriously, thanks for fishing this out.  Is this an Ack? ;)

> -mike

	Hannes
