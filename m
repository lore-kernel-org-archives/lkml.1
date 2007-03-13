Return-Path: <linux-kernel-owner+w=401wt.eu-S1753118AbXCMEqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbXCMEqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 00:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbXCMEqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 00:46:05 -0400
Received: from 1wt.eu ([62.212.114.60]:1153 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118AbXCMEqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 00:46:03 -0400
Date: Tue, 13 Mar 2007 05:45:56 +0100
From: Willy Tarreau <w@1wt.eu>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, Nish Aravamudan <nish.aravamudan@gmail.com>,
       Douglas McNaught <doug@mcnaught.org>, Patrick Mau <mau@oscar.ping.de>
Subject: Re: Stracing Amanda (was: RSDL for 2.6.21-rc3- 0.29)
Message-ID: <20070313044555.GO943@1wt.eu>
References: <20070311013506.GD10459@waste.org> <200703122239.29256.gene.heskett@gmail.com> <29495f1d0703122001x67158365s53dea258acb1aa24@mail.gmail.com> <200703130004.42854.gene.heskett@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703130004.42854.gene.heskett@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 12:04:42AM -0400, Gene Heskett wrote:
> On Monday 12 March 2007, Nish Aravamudan wrote:
> >On 3/12/07, Gene Heskett <gene.heskett@gmail.com> wrote:
> >> On Monday 12 March 2007, Douglas McNaught wrote:
> >> >Patrick Mau <mau@oscar.ping.de> writes:
> >> >> Why not temporarly replace "/bin/tar" with a shell script that
> >> >> does:
> >> >>
> >> >> #!/bin/sh
> >> >> exec strace -f -o output /bin/real.tar $@
> >> >
> >> >You beat me to it.  :) I've done that before; it's a great
> >> > suggestion.
> >> >
> >> >Except that if you expect 'tar' to be invoked multiple times in a
> >> > run, you should probably use 'output.$$' for the output filename so
> >> > things don't get clobbered.
> >> >
> >> >-Doug
> >>
> >> In my case, Doug, it will get invoked 64 times, amanda does a dummy
> >> run to get an estimate, calculates what to do based on that output
> >> which is 32 runs, 1 per disklist entry and I have 32, and then reruns
> >> tar with the appropriate level options against each individual
> >> disklist entry.
> >>
> >> But I'm puzzled a bit, what does the double $$ do?, or it buried
> >> someplace in the bash manpage?  Its not something I've stumbled over
> >> yet.
> >
> >buried indeed:
> >
> >"Special Parameters:
> >  ...
> >       $      Expands to the process ID of the shell.  In a  () 
> > subshell,  it expands  to  the  process  ID of the current shell, not
> > the sub?$B!> shell.
> >"
> 
> Well, that's clear enough, but what of the double $$ case?  Would this 
> them make a PID unique to each invocation untill it finally wraps a 16 
> bit value, or will the kernel re-use them because they won't all be 
> running simultainiously, but limited by the number of unique 'spindle' 
> numbers on the system, this to prevent as best as it can, the thrashing 
> of a drive by having tar working on 2 separate (or more) partitions at 
> the same time.  In my case 2 are possible, as /var is on a separate 
> drive.

Yes there a risk of wrapping, but it is very small. You can add the command
line arguments to the file name if you want, like this :

#!/bin/sh
exec strace -f -o "output.$$.${*//\//_}" /bin/real.tar $@

It will name the output file "output.<pid>.<args>", replacing slashes with
underscores. This is very dirty but can help.

Cheers,
Willy

