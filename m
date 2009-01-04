Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbZADBpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbZADBpt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 20:45:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbZADBpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 20:45:39 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:49952
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbZADBpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 20:45:38 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Date: Sat, 3 Jan 2009 19:45:34 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: Matthieu CASTET <matthieu.castet@parrot.com>,
       Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       linux-kernel@vger.kernel.org,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <200901020207.30359.rob@landley.net> <200901031346.01325.rob@landley.net> <20090103201059.GA4875@uranus.ravnborg.org>
In-Reply-To: <20090103201059.GA4875@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901031945.35163.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 January 2009 14:10:59 Sam Ravnborg wrote:
> > I'll fix this and resubmit, it just wasn't ready last night.  (If the
> > merge window is closing soon I could resubmit the other two with Sam's
> > suggestions and resubmit this one next time 'round, but it was only a
> > couple days to write in the first place, once I finally figured out what
> > the perl version was trying to _do_...)
>
> For kbuild only fixes and trivial stuff will be merged until next merge
> window. Neither of the three patches fall into that category.

*shrug*  I poke my head into kernel development every few months, and have 
just enough familiarity with it to remember that "changes go in during the 
merge window".  Seemed a good time to post 'em.

> With respect to your three patches the plan is to:
> - add the updated timeconst patch to kbuild-next
> - add the updated cpu-feature patch to kbuild-next
>
> - the patch touching headers_install will not be merged.
>   The way forward for headers_install is to combine the
>   unifdef feature and the header modifications.

Since you're turning down an existing patch in favor of a theoretical patch, I 
assume you have plans to do this yourself?

>   And this must be in a single program that can process
>   all headers in one go so the install process becomes so fast
>   that we do not worry about if it was done before or not.
>   Then we can avoid all the .* files in the directory
>   where we isntall the headers.

What if they run out of disk space halfway through writing a file and thus it 
creates a short file (or a 0 length file where the dentry was created but no 
blocks could be allocated for the write)?

I expected headers_install to overwrite destination files and create 
directories with -p, so if you interrupt it you can just re-run it again with 
the same arguments and it could install everything again cleanly over existing 
partial output.  I take it this isn't what's happening, or that isn't 
sufficient somehow?

I didn't look too closely at what the makefile was doing (it makes my eyes 
bleed), I just rewrote the perl script and changed the call.  I could try to 
upgrade the script to not need the makefile to tell it what files to work on, 
and just take the appropriate top level include directory and the output 
directory and figure out which files it needs to operate on by itself so it 
_does_ work that way.  Figuring out where the make file is getting this info 
from now shouldn't be too much harder than reading perl scripts and figuring 
out what they're doing.

Not during this merge window, though.

>   The program is a prime candidate for a small C program
>   and I hope someone can take the challenge to write it.

Good luck with that.  Having written most of the busybox sed implementation, 
and before that having written my own regex implementation back under OS/2, 
I've pretty much gotten my fill of doing regexes in C, at least without a good 
reason.

I suppose if I was feeling really bored I could try to implement unifdef as a 
sed script, but the only way to get a single invocation of sed to work on a 
bunch of individual files coherently is to use -i mode, which A) ain't in 
susv3 (although busybox sed supports it), B) would involve a cp of all the 
files to the destination first, which is kind of ugly.

>   Migrating from perl to shell does not help us here
>   and the shell version was less readable than the perl version.

The shell version is less readable but you never noticed that the perl version 
isn't using its $ARCH argument?  *shrug*  Ok.

I can try to make the shell version more readable, and more powerful.  It's 
already noticeably faster than the perl version.  I have no objections to 
making unifdef do all of this, I just haven't got any interest either.

> 	Sam

Rob
