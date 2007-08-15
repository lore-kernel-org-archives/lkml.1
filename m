Return-Path: <linux-kernel-owner+w=401wt.eu-S1758858AbXHOUf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858AbXHOUf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 16:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbXHOUfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 16:35:12 -0400
Received: from web52507.mail.re2.yahoo.com ([206.190.48.190]:20491 "HELO
	web52507.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752374AbXHOUfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 16:35:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=PzMv8eQep+xH6TwU1ZMOcXebMc236vMiFuvvgaW3u2oeVgd9J01er16FK20kmsCKdw/MVDOEoi5a6kdXer7zDL+tNsw6uBvOMEF0M4r/cnWbnxHUFfeu7snYoQ1jvY2lKxDh2QAg/U+4CvWOUIiGu6fvy/7qbWQN9zpVBGnPVPM=;
X-YMail-OSG: LAquYKQVM1n6181cClM7mx5U9rZIOWIl.sjc5rOWs.vF1458vecC72Yo9FDH9gSswAFq7gh6p_rqnhAL7.H0CTwzjBYUhtFg6Xe5ef.MtcfusSU8dhQZa2xZHZ01rzWmSROPfLZ5_Gt.lMnFxzg.Wl96Iw--
Date: Wed, 15 Aug 2007 13:35:08 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: Thinking outside the box on file systems
To: Craig Ruff <cruff@ucar.edu>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
In-Reply-To: <20070815182252.GA14104@ucar.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <614991.75774.qm@web52507.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Craig Ruff <cruff@ucar.edu> wrote:

> On Wed, Aug 15, 2007 at 10:30:19AM -0700, Marc
> Perkel wrote:
> > --- Kyle Moffett <mrmacman_g4@mac.com> wrote:
> > > Except they do, and without directories the
> > > performance of your average filesystem is going
> to suck.
> > 
> > Actually you would get a speed improvement. You
> hash
> > the full name and get the file number. You don't
> have
> > to break up the name into sections except for
> > evaluating name permissions.
> > 
> > The important concept here is that files and name
> > aren't stored by levels of directories. The name
> > points to the file number. Directory levels are
> > emulated based on name separation characters or
> any
> > other algorithm that you want to use.
> > 
> > One could create a file system and permission
> system
> > that gets rid of the concept of directories
> entirely
> > if one chooses to.
> 
> I would like to add support for Kyle's assertion.
> 
> The model described by Marc is exactly the method
> used by the current
> version of the NCAR Mass Storage Service (MSS),
> which is data archive
> of 4+ petabytes contained in 40+ million files.  To
> the user's point
> of view, it looks somewhat like a POSIX file system
> with both some
> extensions and deficiencies.  The MSS was designed
> in the mid-1980s,
> in an era where the costs of the supercomputers
> (Cray-1s at that time)
> were paramount.  This lead to some MSS design
> decisions to minimize the
> need for users to rerun jobs on the expensive
> supercomputer just because
> they messed up their MSS file creation statements.
> 
> Files names are a maximum of 128 bytes, with a
> dynamically managed
> directory structure indicated by '/' characters in
> the name.  The file
> name is hashed, and the hash table provides the
> internal file number (the
> address in the Master File Directory (MFD)).  Any
> parent directories
> are created automatically by the system upon file
> creation, and are
> automatically deleted if empty upon file deletion. 
> Directories also
> have a self pointer, and both files and directories
> are chained together
> to allow the user to list (or otherwise manipulate)
> the contents of
> a directory.
> 
> The biggest problem with this model is that to
> manipulate the a directory
> itself, you have to simulate the operation on all of
> the files contained
> within it.  For example to rename a directory with
> 'n' descendants,
> you must perform:
> 
> 	n+1 hash table removals
> 	n+1 hash table insertions (with collision
> detection)
> 	n+1 MFD record updates
> 	1   directory chain removal
> 	1   directory chain insertion
> 
> This is, needless to say, very painful when n is
> large.  Since users
> must use directory trees to efficiently manage their
> data holdings,
> efficient directory manipulation is essential. 
> Contrast this with
> the number of operations required for a directory
> rename if files
> do not record their complete pathname:
> 
> 	1 directory chain removal
> 	1 directory chain insertion
> 
> Fortunately we are currently working to change from
> using a model like
> Marc describes to one Kyle describes.
> 


I am describing a kind of functionality and not tied
to the method that implements that functionality.
Perhaps a straight hash of the name isn't the best way
to implement it. Just because someone tried to do
something like what I'm suggesting years ago and it
didn't work doesn't mean that it can't be done. You
just have to come up with a better method.

Lets take this example. We are moving a million files
from one branch if a tree to another. Do we wait for a
million renames and hashes to occur? Of course not. So
what to we do? We continue to be innovative.

One must first adopt the attitude that anything can be
done - you just have to be persistent until you figure
out how.

In this case we could have a name translation layer so
if you want to do a move you change the translation
layer indicating that a move occurred. Thus access to
the new files get translated into the old name and
accessed until the files are rehashed.

Or - maybe there is some sort of tokenizer database
for the names in the directory sections and you can
just rename the section. Sort of a tree like database
of hashes data within hashes.

My point - you start with what you want to do and then
you figure out how to make it happen. I can't answer
all the details of how to make it happen but when I do
something I start with the idea that if this were done
right it would work this way and then I figure out
how.




Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


       
____________________________________________________________________________________
Take the Internet to Go: Yahoo!Go puts the Internet in your pocket: mail, news, photos & more. 
http://mobile.yahoo.com/go?refer=1GNXIC
