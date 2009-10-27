Return-Path: <linux-kernel-owner+w=401wt.eu-S1753458AbZJ0K1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbZJ0K1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 06:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbZJ0K1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 06:27:38 -0400
Received: from mail2.shareable.org ([80.68.89.115]:56952 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbZJ0K1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 06:27:37 -0400
Date: Tue, 27 Oct 2009 10:27:34 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, Jan Kara <jack@suse.cz>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: symlinks with permissions
Message-ID: <20091027102734.GA32063@shareable.org>
References: <20091025062953.GC1391@ucw.cz> <20091026163157.GB7233@duck.suse.cz> <20091026165729.GF23564@us.ibm.com> <20091026173629.GB16861@fieldses.org> <20091026174631.GD7233@duck.suse.cz> <1256579869.8576.7.camel@heimdal.trondhjem.org> <20091025093604.GA1501@ucw.cz> <1256581336.8576.20.camel@heimdal.trondhjem.org> <20091027081141.GF5019@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027081141.GF5019@elf.ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Mon 2009-10-26 14:22:16, Trond Myklebust wrote:
> > On Sun, 2009-10-25 at 10:36 +0100, Pavel Machek wrote:
> > > Well, it is unexpected and mild security hole.
> > > 
> > > Part of the problem is that even  if you have read-only
> > > filedescriptor, you can upgrade it to read-write, even if path is
> > > inaccessible to you.
> > > 
> > > So if someone passes you read-only filedescriptor, you can still write
> > > to it.
> > 
> > If someone passes you a file descriptor, can't you in any case play
> > games with, openat(fd,"",O_RDWR), in order to achieve the same thing? I
> > must admit I haven't tried it yet, but at a first glance I can't see
> > anything that prevents me from doing this...
> 
> According to my documentation, openat needs directory fd.

Correct.  There has been something about fstatat() and similar
allowing a non-directory when passed a NULL path, but openat() does
not.  (It's probably ok to extend openat() to allow a NULL path, if it
does the equivalent of re-opening /proc/self/fd/NN).

I think this whole issue is neatly solved by enforcing the file access
mode for open(/proc/PID/fd/NN) to be a safe subset of the original
file access mode.

It should use the original file access mode so that O_APPEND can
be enforced too.  Checking symlink permissions wouldn't do that.

Anything you can change with fcntl(F_SETFL) is fair game for changing.

The ptrace permission check is nice, but even with ptrace you can't
convert a read-only descriptor to a writable one (or write-only to
readable, or append-only to writable, etc.)

-- Jamie
