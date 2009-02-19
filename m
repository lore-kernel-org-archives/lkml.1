Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbZBSQRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbZBSQRN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 11:17:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbZBSQQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 11:16:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34472 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbZBSQQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 11:16:58 -0500
Date: Thu, 19 Feb 2009 17:16:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Definition of BUG on x86
Message-ID: <20090219161649.GC9556@elte.hu>
References: <20090219121027.GB1703@elte.hu> <1235045971.15053.42.camel@nathan.suse.cz> <20090219122211.GE1703@elte.hu> <1235047082.15053.49.camel@nathan.suse.cz> <20090219124702.GC22044@elte.hu> <1235048535.15053.52.camel@nathan.suse.cz> <20090219144902.GA8650@elte.hu> <499D7B9D.7060001@goop.org> <20090219153544.GA31637@elte.hu> <1235059883.15053.68.camel@nathan.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1235059883.15053.68.camel@nathan.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Petr Tesarik <ptesarik@suse.cz> wrote:

> Ingo Molnar píše v Čt 19. 02. 2009 v 16:35 +0100:
> >[...]
> > * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > 
> > > Ingo Molnar wrote:
> > >> * Petr Tesarik <ptesarik@suse.cz> wrote:
> > >>
> > >>   
> > >>> Ingo Molnar píše v Čt 19. 02. 2009 v 13:47 +0100:
> > >>>     
> > >>>> so GCC should be fixed and improved here, on several levels.
> > >>>>       
> > >>> Agree.
> > >>>
> > >>> But it takes some time, even if we start pushing right now. What's 
> > >>> your suggestion for the meantime? Keep the dummy jmp? And in case 
> > >>> anybody is concerned about saving every byte in the text section, 
> > >>> they can apply my dirty patch?
> > >>>
> > >>> Actually, this doesn't sound too bad.
> > >>>     
> > >>
> > >> yeah. Please forward the problem to the appropriate GCC list in any 
> > >> case.
> > >>
> > >>   
> > >
> > > I think the official answer for this case is to use __builtin_trap.  But:
> > >
> > > -- Built-in Function: void __builtin_trap (void)
> > >     This function causes the program to exit abnormally.  GCC
> > >     implements this function by using a target-dependent mechanism
> > >     (such as intentionally executing an illegal instruction) or by
> > >     calling `abort'.  ***The mechanism used may vary from release to
> > >     release so you should not rely on any particular implementation.***
> > >
> > > which in principle is hard for us to make use of.  In practice I think  
> > > it has always been ud2a on x86.
> > 
> > could we just do:
> > 
> > 	__builtin_trap();
> > 	for (;;);
> 
> I'm afraid that's not the point of the exercise. I'm trying to 
> trim BUG() to two bytes, while still making sure that the 
> Illegal Opcode exception is generated at the exact code point, 
> so we can track it down using the info in __bug_table. If 
> __builtin_trap() ever translates to anything else than ud2a in 
> the above code snippet, there will be no BUG reported. 
> Instead, the CPU that encountered the BUG() will burn CPU 
> cycles forever without any apparent reason.

Well, the important question is thatGCC will optimize out 
whatever comes after the __builtin_trap(), right? To guarantee 
an assert we can do something like:

 	__builtin_trap();
	panic("should never get here");

to guarantee a message. (But realistically GCC will at most 
generate a build error.)

	Ingo
