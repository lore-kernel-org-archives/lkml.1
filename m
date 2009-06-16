Return-Path: <linux-kernel-owner+w=401wt.eu-S1759204AbZFPHxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759204AbZFPHxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 03:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbZFPHxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 03:53:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37536 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbZFPHxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 03:53:11 -0400
Subject: Re: [PATCH v2 0/8] clean up vdso-layout.lds.S
From: Petr Tesarik <ptesarik@suse.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>
In-Reply-To: <4A3693F8.6000209@zytor.com>
References: <1244814040-5810-1-git-send-email-ptesarik@suse.cz>
	 <20090612180626.GB18203@uranus.ravnborg.org>
	 <1245079002.17481.118.camel@nathan.suse.cz>
	 <1245079649.17481.121.camel@nathan.suse.cz>  <4A367C09.80008@zytor.com>
	 <1245087957.17481.124.camel@nathan.suse.cz>  <4A3693F8.6000209@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Organization: SUSE LINUX
Date: Tue, 16 Jun 2009 09:53:12 +0200
Message-Id: <1245138792.17481.138.camel@nathan.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin píše v Po 15. 06. 2009 v 11:33 -0700:
> Petr Tesarik wrote:
> >>>
> >> *(COMMON) is BSS, not data...
> > 
> > Very true, but for the vDSO we decided to put both writeable and
> > read-only data into one section (called .data for that matter), probably
> > to reduce the number of sections and hence also the size of the
> > resulting binary.
> > 
> 
> BSS is neither,

Right. My typing was once again faster than my thinking. I meant
initialized vs. uninitialized, of course.

>  but I guess for the vDSO there really isn't any such
> thing as uninitialized content.

Right, too. I can't even think of a valid use case, so .broken might be
the right place for both COMMON and .bss.

> I have to admit feeling funny about that, and I'm wondering if we
> shouldn't compile the vDSO with -fno-common.

Oops, sorry. It's already compiled with -fno-common, because it gets
inherited from the top-level Makefile's KBUILD_CFLAGS. Sorry for the
noise.

Anyway, my feeling is that the whole discussion is a bit academic. If I
want to be rigorous, I should take an opt-in approach, i.e. handle all
sections that work fine (e.g. also debugging sections) and then put all
else into .broken with something like:

.broken {
	/* All else is dubious. */
	*(*)
}

But this can become a maintenance PITA. Whenever GCC and/or binutils add
a new extension, the linker script would have to be adjusted
accordingly. Well, maybe that's even correct, because somebody at least
stops and thinks for a while about the implications of the new feature.
But I'm not really offering to become the new maintainer of this file.

Comments?

Petr Tesarik


