Return-Path: <linux-kernel-owner+w=401wt.eu-S932413AbZJ1B4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413AbZJ1B4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 21:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756907AbZJ1B4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 21:56:17 -0400
Received: from mail.vyatta.com ([76.74.103.46]:49271 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756838AbZJ1B4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 21:56:15 -0400
Date: Tue, 27 Oct 2009 18:56:13 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Stephen Hemminger <stephen.hemminger@vyatta.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Octavian Purdila <opurdila@ixiacom.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] dcache: better name hash function
Message-ID: <20091027185613.1a7e8398@nehalam>
In-Reply-To: <alpine.LFD.2.01.0910271744560.31845@localhost.localdomain>
References: <19864844.24581256620784317.JavaMail.root@tahiti.vyatta.com>
	<4AE68E23.20205@gmail.com>
	<4AE69829.9070207@gmail.com>
	<4AE6A16F.4020002@gmail.com>
	<20091027100736.5303f1ab@nehalam>
	<alpine.LFD.2.01.0910271017170.31845@localhost.localdomain>
	<20091027160822.384dc109@nehalam>
	<alpine.LFD.2.01.0910271636100.31845@localhost.localdomain>
	<20091027171035.39e18383@nehalam>
	<alpine.LFD.2.01.0910271744560.31845@localhost.localdomain>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009 17:58:53 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Tue, 27 Oct 2009, Stephen Hemminger wrote:
> > 
> > Agreed. Here is the reduced version of the program.
> > To run:
> >   find /home -printf '%f\n' 2>/dev/null | ./htest -n 100
> 
> The timings are very sensitive to random I$ layout at least on Nehalem. 
> The reason seems to be that the inner loop is _so_ tight that just 
> depending on exactly where the loop ends up, you can get subtle 
> interactions with the loop cache.
> 
> Look here:
> 
> 	[torvalds@nehalem ~]$ find /home -printf '%f\n' 2>/dev/null | ./htest -n 100
> 	Algorithm             Time       Ratio       Max   StdDev
> 	full_name_hash       1.141899     1.03      4868 263.37
> 	djb2                 0.980200     1.03      4835 266.05
> 	string10             0.909175     1.03      4850 262.67
> 	string10a            0.673915     1.03      4850 262.67
> 	string10b            0.909374     1.03      4850 262.67
> 	string_hash17        0.966050     1.03      4805 263.68
> 	string_hash31        1.008544     1.03      4807 259.37
> 	fnv32                0.774806     1.03      4817 259.17
> 
> what do you think the difference between 'string10', 'string10a' and 
> 'string10b' are?
> 
> None. None what-so-ever. The source code is identical, and gcc generates 
> identical assembly language. Yet those timings are extremely stable for 
> me, and 'string10b' is 25% faster than the identical string10 and 
> string10a functions.
> 
> The only difference? 'string10a' starts aligned to just 16 bytes, but that 
> in turn happens to mean that the tight inner loop ends up aligned on a 
> 128-byte boundary. And being cacheline aligned just there seems to matters 
> for some subtle micro-architectural reason.
> 
> The reason I noticed this is that I wondered what small modifications to 
> 'string10' would do for performance, and noticed that even _without_ the 
> small modifications, performance fluctuated.
> 
> Lesson? Microbenchmarks like this can be dangerous and misleading. That's 
> _especially_ true if the loop ends up being just tight enough that it can 
> fit in some trace cache or similar. In real life, the name hash is 
> performance-critical, but at the same time almost certainly won't be run 
> in a tight enough loop that you'd ever notice things like that.
> 
> 		Linus

Thanks. I wasn't putting huge amount of stock in the micro benchmark,
was more interested in how the distribution worked out (which is CPU
independent) rather than the time. As long as all usage of name hashing
fold properly, there isn't a lot of reason to change.



-- 
