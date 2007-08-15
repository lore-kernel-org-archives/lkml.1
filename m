Return-Path: <linux-kernel-owner+w=401wt.eu-S935539AbXHOSt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935539AbXHOSt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 14:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbXHOStS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 14:49:18 -0400
Received: from nscan3.ucar.edu ([192.43.244.193]:44227 "EHLO nscan3.ucar.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374AbXHOStR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 14:49:17 -0400
X-Greylist: delayed 1584 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Aug 2007 14:49:17 EDT
Date: Wed, 15 Aug 2007 12:22:52 -0600
From: Craig Ruff <cruff@ucar.edu>
To: Marc Perkel <mperkel@yahoo.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: Thinking outside the box on file systems
Message-ID: <20070815182252.GA14104@ucar.edu>
Mail-Followup-To: Marc Perkel <mperkel@yahoo.com>,
	Kyle Moffett <mrmacman_g4@mac.com>,
	Michael Tharp <gxti@partiallystapled.com>,
	alan <alan@clueserver.org>,
	LKML Kernel <linux-kernel@vger.kernel.org>,
	Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
References: <152F34EE-58BE-43BE-9E33-597F2AE1DFAA@mac.com> <767509.60425.qm@web52501.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <767509.60425.qm@web52501.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 10:30:19AM -0700, Marc Perkel wrote:
> --- Kyle Moffett <mrmacman_g4@mac.com> wrote:
> > Except they do, and without directories the
> > performance of your average filesystem is going to suck.
> 
> Actually you would get a speed improvement. You hash
> the full name and get the file number. You don't have
> to break up the name into sections except for
> evaluating name permissions.
> 
> The important concept here is that files and name
> aren't stored by levels of directories. The name
> points to the file number. Directory levels are
> emulated based on name separation characters or any
> other algorithm that you want to use.
> 
> One could create a file system and permission system
> that gets rid of the concept of directories entirely
> if one chooses to.

I would like to add support for Kyle's assertion.

The model described by Marc is exactly the method used by the current
version of the NCAR Mass Storage Service (MSS), which is data archive
of 4+ petabytes contained in 40+ million files.  To the user's point
of view, it looks somewhat like a POSIX file system with both some
extensions and deficiencies.  The MSS was designed in the mid-1980s,
in an era where the costs of the supercomputers (Cray-1s at that time)
were paramount.  This lead to some MSS design decisions to minimize the
need for users to rerun jobs on the expensive supercomputer just because
they messed up their MSS file creation statements.

Files names are a maximum of 128 bytes, with a dynamically managed
directory structure indicated by '/' characters in the name.  The file
name is hashed, and the hash table provides the internal file number (the
address in the Master File Directory (MFD)).  Any parent directories
are created automatically by the system upon file creation, and are
automatically deleted if empty upon file deletion.  Directories also
have a self pointer, and both files and directories are chained together
to allow the user to list (or otherwise manipulate) the contents of
a directory.

The biggest problem with this model is that to manipulate the a directory
itself, you have to simulate the operation on all of the files contained
within it.  For example to rename a directory with 'n' descendants,
you must perform:

	n+1 hash table removals
	n+1 hash table insertions (with collision detection)
	n+1 MFD record updates
	1   directory chain removal
	1   directory chain insertion

This is, needless to say, very painful when n is large.  Since users
must use directory trees to efficiently manage their data holdings,
efficient directory manipulation is essential.  Contrast this with
the number of operations required for a directory rename if files
do not record their complete pathname:

	1 directory chain removal
	1 directory chain insertion

Fortunately we are currently working to change from using a model like
Marc describes to one Kyle describes.
