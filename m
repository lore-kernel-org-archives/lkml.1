Return-Path: <linux-kernel-owner+w=401wt.eu-S932423AbZKDUWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423AbZKDUWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 15:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932372AbZKDUWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 15:22:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932363AbZKDUWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 15:22:39 -0500
Date: Wed, 4 Nov 2009 15:22:34 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Eric Blake <ebb9@byu.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: make getdents/readdir POSIX compliant wrt mount-point 
 dirent.d_ino
Message-ID: <20091104152234.1d4b2b81@tlielax.poochiereds.net>
In-Reply-To: <loom.20090903T164650-995@post.gmane.org>
References: <87y6oyhkz8.fsf@meyering.net>
	<20090901201943.GB6996@mit.edu>
	<a36005b50909011503y73efdf56yabc4d981db2989bc@mail.gmail.com>
	<loom.20090903T164650-995@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Sep 2009 14:50:52 +0000 (UTC)
Eric Blake <ebb9@byu.net> wrote:

> Ulrich Drepper <drepper <at> gmail.com> writes:
> 
> > I guess that this is really a difficult way to solve.  I wouldn't want
> > to pay for something which is hardly ever really used.
> > 
> > But there are programs out there which would like to use the inode
> > uniqueness.  Therefore the next best thing to do is perhaps to return
> > a flag in the getdents information (in d_type, perhaps) to indicate
> > that this is a mount point and/or that there are multiple ways to
> > access the file in question.  Then programs which can use the inode
> > information can be watching for this flag and enter the slow path only
> > if it's set.
> 
> An alternative to a flag in d_type might be setting d_ino to a sentinel value
> (there is plenty of existing code that refuses to use a readdir entry with d_ino
> of 0, so it would have to be something else; but maybe -1 would work).  But I
> definitely like your idea of making it obvious to the application (whether by
> d_ino or d_type) when it is necessary to use lstat to validate the inode number,
> and promising that if the flag is not set then d_ino is correct.
> 

The only problem with those schemes is that they assume that you're
using getdents. If you just lstat something then it's not clear.

It seems like a better scheme might be to do something that makes this
clear when using an lstat call too. Maybe we could coopt a bit in the
st_mode?

S_IFXDEV          020000

That's outside of the S_IFMT mask, so it shouldn't break S_IS* checks,
right?

-- 
Jeff Layton <jlayton@redhat.com>
