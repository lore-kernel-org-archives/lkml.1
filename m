Return-Path: <linux-kernel-owner+w=401wt.eu-S1751363AbZIZKpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363AbZIZKpd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 06:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750990AbZIZKpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 06:45:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38282 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbZIZKpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 06:45:31 -0400
Subject: Re: [GIT PULL v2] bkl tracepoints + filter regex support
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
In-Reply-To: <20090925103806.GA6467@nowhere>
References: <1253821775-8618-1-git-send-email-fweisbec@gmail.com>
	 <20090924201509.GA26573@elte.hu> <20090924201622.GA15459@elte.hu>
	 <1253824200.18939.173.camel@laptop> <20090924204357.GB8662@nowhere>
	 <1253825489.18939.180.camel@laptop> <20090924213631.GA2661@nowhere>
	 <1253866792.10287.0.camel@twins> <20090925091229.GB4686@nowhere>
	 <1253871601.10287.23.camel@twins>  <20090925103806.GA6467@nowhere>
Content-Type: text/plain
Date: Sat, 26 Sep 2009 06:44:21 -0400
Message-Id: <1253961861.12145.148.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-25 at 12:38 +0200, Frederic Weisbecker wrote:

>  
> > Using globs in string matches most certainly is useful, no question
> > about that.
> > 
> > But I had understood from previous communications we were going to have
> > a C syntax, and there == is a straight comparison.
> > 
> > If however people have changed their minds (fine with me) and we're now
> > going to script like things..
> 
> 
> 
> Well, indeed we talked about C syntax, but I didn't think the idea
> was that fixed in the rock, hence why I was suprised.

Once we add globs, we just blew away C syntax.

> 
> 
> > Anyway, a glob in == just means we have to use another operator if we
> > ever want to support actual regexes, ~ would then be recommened I think,
> > since that's what awk and I think perl do.

Perhaps when we put full perl regex into the kernel (my goal ;-) then we
should look to keep different kinds of equals.

  ==  - is direct match. Only use of strcmp is needed.

  ~ - is globing. We can add a '*' which means match anything.

and if we do add true regex...

  =~ could be that.  field =~ '^spin.*{lock|unlock}$'

> 
> 
> Yeah. For example one may know python but not perl or awk,
> other people may be in the opposite situation. But most
> developers know the C (at least its basic syntax).

awk is much more known than either python nor perl. It is expected that
any unix person have a basic idea of sed and awk. If not a simple search
on the internet can help them.

It takes 5 minutes to figure out how to do something with awk, where as
we all know it takes a much longer time to figure out python or perl.

> 
> So I'm not sure using such ~ operator is a good idea. I think you're
> right in the fact we should stay tight to the C syntax.

I disagree.

> 
> 
> > Personally I wouldn't mind things like:
> > 
> >  glob_match(string, pattern)
> >  regex_match(string, pattern)

In a filter string. Yuck!

note I don't like python, which is probably why I don't like the above.

> 
> 
> 
> Yeah, actually that sounds more flexible and more something that people
> are familar with, once we consider the future evolutions.

please no! I hate that syntax. Again, this is probably one of the major
reasons I avoid python. (that and column forcing)


> 
> 
> 
> > But everybody involved in this filter stuff needs to agree what
> > direction you want to take the language in.
> 
> 
> 
> Right!

Yes, and I agree that == should not mean globing. We should have another
syntax, but I really don't want "functions" for matching.

> 
>  
> 
> > > I just don't want that this bridge turns out any ftrace uses through debugfs
> > > into an overkill.
> > > Instead I'd prefer to satisfy both, hence the above proposition.
> > 
> > So you're proposing to split the filter language? I'm sure that's going
> > to confuse a few people ;-)
> 
> 
> 
> Hmm, just at this level. That could even be a trace option.
> Anyway, it would nice to have other tracing developers
> opinion.

Finally getting around to it ;-)

> 
> 
>  
> > Thing is, if you (or others) have a need to experiment with the
> > language, then I'm not sure its the right moment to freeze bits into an
> > ABI.

Correct, and this is why I propose a "tracefs" that can become the place
that we add a stable API, and let debugfs be our playground.

> > 
> > I'm really fine with thing, as long as everybody on the filter side
> > knows experimenting isn't really an option and agrees on the direction
> > they want to take the language.
> 
> 
> Well, I talked about experimenting the language before pushing it as
> an ABI because I was afraid we were going too fast.
> 
> But I guess the ABI is a requirement to use it through perf ioctl,
> and delay that would keep it as a hostage, may be even slow its
> development.
> 
> 
> > Is there no existing language with a proper license and clean code-base
> > we can 'borrow'? That would avoid creating yet another funny language,
> > and learning how to implement things all over again.
> > 
> > Personally I don't think the kernel is the place to experiment in script
> > language design, but that's me ;-)
> 
> 
> Python? :-)

Perl is considered a much better language for regex. It has one of the
most (if not the most) powerful regex engines. I'm sure recordmcount.pl
would be much larger if I chose to do it in python. Same goes with
streamline_config.pl.  They both have strong needs for complex regex.

> 
> More seriously, as I said above, I think most developers are familiar with C
> syntax, so IMHO this is one of our best possibility.
> 

To avoid the Python vs Perl, I say we stick with sed/awk. That is also a
requirement for most unix developers.

-- Steve


