Return-Path: <linux-kernel-owner+w=401wt.eu-S1751771AbXDHSu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbXDHSu3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 14:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbXDHSu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 14:50:29 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:47380 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbXDHSu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 14:50:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GIXq9sP/mbiPaS0kbmuh1S2NHg6KBh9KXy1+pZt+pYogbDxcgY3nEympN5ef5G1yu9qIwK0FWgtcx1a/qIdnW0vCk0u209w8I19zr39DDpv9jXcsYzuPBHcbR7BDno4I67pL+OriJq5AsMV+vtx4IhN98M1DPaiBo5S5gM+IMMc=
Message-ID: <a36005b50704081150i5a457963w2ab5928f873eeabf@mail.gmail.com>
Date: Sun, 8 Apr 2007 11:50:27 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>, "Theodore Tso" <tytso@mit.edu>,
       "Ulrich Drepper" <drepper@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
In-Reply-To: <20070407233037.GA16508@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com>
	 <20070407203633.GA21555@thunk.org>
	 <20070407233037.GA16508@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/7/07, Christoph Hellwig <hch@infradead.org> wrote:
> It's not going to solve anything at all.  We can't stop supporting
> functionality that has been there forever.

Not necessarily.

One problem here is that the interface for using readdir() with and
without telldir()/seekdir() is the same.  A second problem is that the
functionality is universally required.  Both of these problems can be
addressed.

For the second problem, I certainly could imagine that making the
functionality to to use seekdir()/telldir() optional.  It might be
hard in POSIX but this does not mean anything about implementations.
Implementations just have to provide a way to allow these functions to
be used.  It does not mean it always and everywhere has to work.  What
this means is that if, for instance, a filesystem would be (for now)
be able to have a mount option to not allow seekdir()/telldir() the
system still can conform to POSIX.  At the same time we can gather
information as to whether seekdir()/telldir() are really needed.  I
personally think the number of apps which depend on this functionality
is miniscule.

Using a mount option isn't the nicest solution, though.  If a
filesystem can support seekdir()/telldir() the better solution from
the userlevel API POV would be to provide a better, alternative
interface.  Maybe an alternative opendir() call (opendir2?) which
takes a second parameter as to whether seeking is needed or not.  Then
this opendir2() function can use a new getdents() syscall and return
the entries.  The difference would be that if the user wants to use
seekdir()/telldir() the userlevel code would cache the old results and
the seekdir()/telldir() handling would be entirely at userlevel.

It's not a good idea to make this the default behavior for the old
opendir() since the vast majority of the current users don't want to
seek and therefore the caching would significantly impact the
performance.  With the extra argument saying when caching is needed
this is no problem anymore.  Over time people would migrate off of
opendir() and towards opendir2() (with some "careful" encouragement)
and the whole problem will go away.

And the best: this is certainly a path I can see being viable for
POSIX.  But it requires that we have
a) established existing practice
b) shown the impact is really low

So, I think it would be great to get started writing this new getdents
call.  Yes, for now it means maintaining two separate versions.  If
all goes well those filsystems which feel a high burden can simply
stop supporting the old syscall or at least the seek functionality.
