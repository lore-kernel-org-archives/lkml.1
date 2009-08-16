Return-Path: <linux-kernel-owner+w=401wt.eu-S1753793AbZHPOG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbZHPOG3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 10:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbZHPOG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 10:06:28 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:3503 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbZHPOG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 10:06:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=wJ7FLvmFaCefMulKR1Knk2+n3C6t6PTQ0jsG5ObcZCbX+TihAcfAfOuRsJvsaixEd8
         uSLfroM5yAyKSI2DaUz0t0ss3nT7jyPW5/MECcV05XOKzBLLuBs9Jw8l1G8mgaTyrsw8
         RoYfvBDARQ0YD2pi/I03Jsuufxe63Rm7TDHFs=
Date: Sun, 16 Aug 2009 16:06:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf: Enable more compiler warnings
Message-ID: <20090816140623.GB6031@nowhere>
References: <tip-83a0944fa919fb2ebcfc1f8933d86e437b597ca6@git.kernel.org> <20090816124641.GA6031@nowhere> <20090816140154.GA9408@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090816140154.GA9408@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 16, 2009 at 04:01:54PM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Sun, Aug 16, 2009 at 08:57:54AM +0000, tip-bot for Ingo Molnar wrote:
> > > Commit-ID:  83a0944fa919fb2ebcfc1f8933d86e437b597ca6
> > > Gitweb:     http://git.kernel.org/tip/83a0944fa919fb2ebcfc1f8933d86e437b597ca6
> > > Author:     Ingo Molnar <mingo@elte.hu>
> > > AuthorDate: Sat, 15 Aug 2009 12:26:57 +0200
> > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > CommitDate: Sun, 16 Aug 2009 10:47:47 +0200
> > > 
> > > perf: Enable more compiler warnings
> > > 
> > > Related to a shadowed variable bug fix Valdis Kletnieks noticed
> > > that perf does not get built with -Wshadow, which could have
> > > helped us avoid the bug.
> > > 
> > > So enable -Wshadow and also enable the following warnings on
> > > perf builds, in addition to the already enabled -Wall -Wextra
> > > -std=gnu99 warnings:
> > > 
> > >  -Wcast-align
> > >  -Wformat=2
> > >  -Wshadow
> > >  -Winit-self
> > >  -Wpacked
> > >  -Wredundant-decls
> > >  -Wstack-protector
> > >  -Wstrict-aliasing=3
> > >  -Wswitch-default
> > >  -Wswitch-enum
> > 
> > 
> > 
> > This one looks like more a pain than something useful.
> > 
> > I have this code in perf trace:
> > 
> > static int event_item_type(enum event_type type)
> > {
> > 	switch (type) {
> > 	case EVENT_ITEM:
> > 	case EVENT_DQUOTE:
> > 	case EVENT_SQUOTE:
> > 		return 1;
> > 	default:
> > 		return 0;
> > 	}
> > }
> > 
> > Which results in:
> > 
> > util/trace-event-parse.c: In function ‘event_item_type’:
> > util/trace-event-parse.c:377: erreur: enumeration value ‘EVENT_ERROR’ not handled in switch
> > util/trace-event-parse.c:377: erreur: enumeration value ‘EVENT_NONE’ not handled in switch
> > util/trace-event-parse.c:377: erreur: enumeration value ‘EVENT_SPACE’ not handled in switch
> > util/trace-event-parse.c:377: erreur: enumeration value ‘EVENT_NEWLINE’ not handled in switch
> > util/trace-event-parse.c:377: erreur: enumeration value ‘EVENT_OP’ not handled in switch
> > util/trace-event-parse.c:377: erreur: enumeration value ‘EVENT_DELIM’ not handled in switch
> > 
> > The default case already handles these and I guess we don't want workarounds like:
> > 
> > static int event_item_type(enum event_type type)
> > {
> >         switch (type) {
> >         case EVENT_ITEM:
> >         case EVENT_DQUOTE:
> >         case EVENT_SQUOTE:
> >                 return 1;
> > 	case EVENT_ERROR:
> > 	case EVENT_NONE:
> > 	case EVENT_SPACE:
> > 	case EVENT_NEWLINE:
> > 	case EVENT_OP:
> > 	case EVENT_DELIM:
> >         default:
> >                 return 0;
> >         }
> > }
> > 
> > 
> > Right? :-)
> > 
> > This warning might be useful for *very* specific cases, but not here IMO.
> 
> i think it's useful when an enum gets extended. Say we add a new 
> event enum and want to make sure it's handled in _all_ switch 
> statements that deals with them. This warning ensures that we 
> propagate the new case to all usage sites.
> 
> 	Ingo


Ok, it's a bit annoying to cover all enum cases but well, I agree
with the above possibility...

