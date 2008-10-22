Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbYJVJoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbYJVJoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 05:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755877AbYJVJlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 05:41:20 -0400
Received: from gir.skynet.ie ([193.1.99.77]:35167 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811AbYJVJlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 05:41:17 -0400
Date: Wed, 22 Oct 2008 10:41:14 +0100
To: Albert Cahalan <acahalan@gmail.com>
Cc: adobriyan@gmail.com, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Report the size of pages backing VMAs in /proc V3
Message-ID: <20081022094033.GA18510@csn.ul.ie>
References: <787b0d920810200218o5f26ee7bj9f8c0e71606dd5cb@mail.gmail.com> <20081020100643.GA22647@csn.ul.ie> <787b0d920810201107p7ea3c1een2b7809d5cbfbc6bc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <787b0d920810201107p7ea3c1een2b7809d5cbfbc6bc@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 02:07:28PM -0400, Albert Cahalan wrote:
> On Mon, Oct 20, 2008 at 6:06 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> > On (20/10/08 05:18), Albert Cahalan didst pronounce:
> 
> >> Looping on stat() while chopping off suspected tags is dreadful.
> >> Besides just being gross, it's slow.
> >
> > You're probably right. It's a bit weird that it's what you have to do to
> > figure out if the file in /proc/PID/maps is really there or not.
> 
> Actually you can't do this, because of directory permissions.
> 

Good point.

> >> Obviously, every author of a /proc-based tool has been forced to
> >> take a random guess at the ABI. The /proc/*/smaps is so gross and
> >> that I put off writing a parser for years.
> >
> > I intend to take a stab at it for the purposes of teaching pmap to print
> > the pagesizes if the smaps change gets picked up.
> 
> FYI, "KernelPageSize" is at least unique under the perfect
> hash function I'm using to parse the damn smaps file.
> 
> hash = ( ( (s[8]&15) + (s[1]&15) ) ^ (s[0]&3) ) & 31;
> 

Good to know.

> I have to wonder if we'll be getting mixed page sizes
> within a single mapping, making such info unusable.
> 

It's not planned right now, but even if it is, KernelPageSize would
remain as the intended page size. VMAs would either split around each
mixed page size in which case there will be separate VMAs or an
additional field will be added that indicates what number of each
pagesize makes up the mapping.

> >> Right before the filename, you can add anything except a '/'.
> >> You could add a few columns of numbers or a second flags field.
> >
> > My fear was about parsers that hard-coded what number field stored the
> > filename. If a column was added for pagesize for example, then parsers
> > would think the pagesize was the filename.
> 
> It's possible. Every parser I've examined does strchr()
> or similar to find that '/' character.
> 

I might be the only criminal. A mucky shell script used awk to display
field X and everything past it to find the filename. A more rational
person would have used strchr or found the first / with cut or similar.

> Maybe try some dummy patches in a linux-next kernel?
> Give each one a month. You could do "xyz" concatenated
> to the flags, a second "rwx" concatenated to the flags,
> a single column of "0" before the filename, and several
> columns of "parsertest" before the filename.
> 

That sounds reasonable.

> > Now, that is an interested idea, albeit it's not one that is easily
> > human-readable and would need a second parser like pmap but that's ok. If
> > parsing smaps turns into a total pain in the ass
> 
> I assure you that parsing smaps is a total pain in the ass,
> especially if you want tolerable performance. Something
> like "top" is not viable if it performs like a Python script.
> 

I had assumed that smaps + performance were mutually exclusive because
of the PSS calculation and any active monitoring from something like top
would blow bigtime. That's why I tried modifying maps as well.

> >> BTW, I'm thinking that the /proc/*/*maps files fail when the
> >> lines exceed 4096 bytes. The pathname may legitimately be that
> >> long, plus it can be backslash escaped, plus there is all the
> >> junk on the beginning.
> >
> > Yes. While it's unlikely to be exceeded, a file could be 4096 bytes long
> > and the other fields will then cause a problem. It was because of things
> > like this, I was ok with dropping the idea of adding (attribute[=value])
> > from the end of the filename.
> 
> "unlikely" is not something one should trust. I think you
> can even get a name longer than 4096 bytes if you make
> directories relative to the current directory and keep
> changing directories as you make the directories.
> Then double that with backslashes becoming \\ or
> newlines becoming \n (must be escaped) in the output.
> 
> I think /proc/*/maps has been broken ever since it was
> converted to seq_file, and maybe ever since it got filenames.
> Prior to the filenames, lines were fixed-width records.
> 

You could be right. Only one way to find out for sure really.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
