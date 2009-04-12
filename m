Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbZDLUb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbZDLUb0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 16:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbZDLUbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 16:31:15 -0400
Received: from mail2.shareable.org ([80.68.89.115]:58707 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbZDLUbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 16:31:14 -0400
Date: Sun, 12 Apr 2009 21:31:07 +0100
From: Jamie Lokier <jamie@shareable.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
       Hugh Dickins <hugh@veritas.com>, Tejun Heo <tj@kernel.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [RFC][PATCH 8/9] vfs: Implement generic revoked file operations
Message-ID: <20090412203107.GH4394@shareable.org>
References: <m1skkf761y.fsf@fess.ebiederm.org> <m1prfj5qxp.fsf@fess.ebiederm.org> <20090412185659.GE4394@shareable.org> <m11vrxprk6.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11vrxprk6.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> >> revoked_file_ops return 0 from reads (aka EOF). Tell poll the file is
> >> always ready for I/O and return -EIO from all other operations.
> >
> > I think read should return -EIO too.  If a program is reading from a
> > /proc file (say), and the thing it's reading suddenly disappears, EOF
> > gives the false impression that it's read to the end of formatted data
> > from that file and it can process the data as if it's complete, which
> > is wrong.
> 
> Good point EIO is the current read return value for a removed proc file.
> 
> For closed pipes, and hung up ttys the read return value is 0, and from
> my reading that is what bsd returns after a sys_revoke.

A few suggestions below.  Feel free to ignore them on account of the
basic revoking functionality being more important :-)

I'm not sure a revoked pipe should look like a normally closed one.
ECONNRESET?

For hung up ttys, I agree.  But where's the SIGHUP :-) You probably do
want the process using it to die if it's not handling SIGHUP, because
terminal-using processes don't always terminate themselves on EOF.

For things writing to a pipe or file, SIGPIPE may be appropriate in
addition to EIO, to avoid runaway processes.  Looks odd I know.  For
writing to a terminal, SIGHUP again.

> The reason I have f_op settable is because I never expected complete
> agreement on the return codes, and because it makes auditing and spotting
> this kind of thing easier.
>
> I guess I should make two variations on revoked_file_ops then.  Say
> eof_file_ops, eio_file_ops.  Identical except for their treatment of
> reads.

Fair enough.  It's good to have good defaults.  I'm not convinced
eof_file_ops is ever a good default.  sighup_file_ops and
sigpipe_file_ops maybe :-)

-- Jamie
