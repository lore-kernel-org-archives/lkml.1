Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441Ab0CIBSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 20:18:22 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:42038 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398Ab0CIBSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 20:18:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BThd9jtnb5DGYN7/mOyJtVc0/d26Yzg/4RWGKzyMN6cbac5vHfZhWriFD5IyTsj+6U
         BQ9Hb9dLnTC76Dsm2FT2XKXNk6SIkqWZ+OX7UFYNQTU90rYvi+Ve4w1yR0T+vn+s5IvC
         Q053oKXdRTlZRN96qLjPANPR7iuDDs0QFo7Jc=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1003081051130.3989@localhost.localdomain>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org>
	 <20100308094647.GA14268@elte.hu>
	 <20100308173008.7ae389ab@lxorguk.ukuu.org.uk>
	 <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain>
	 <20100308184521.GK30031@ZenIV.linux.org.uk>
	 <alpine.LFD.2.00.1003081051130.3989@localhost.localdomain>
Date: Tue, 9 Mar 2010 02:18:13 +0100
Message-ID: <ff13bc9a1003081718k1e7964f5ta9e582866dea94ee@mail.gmail.com>
Subject: Re: Upstream first policy
From: Luca Barbieri <luca.barbieri@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think the point is actually that, ideally, content-based security is
for _reads_, while path-based security is for _writes_:

For example, in the /etc/shadow case:
1. Unprivileged users must not be able to know the _content_ of the
file (or of any copy of it)
2. It doesn't matter at all if anyone modifies a private copy of the
file (with the same content, but not the same path)
3. Unprivileged users must not change the data the /etc/shadow _path_
is associated with
4. It doesn't matter at all if anyone reads a file that happens to be
at /etc/shadow while not containing shadow passwords (with the same
path, but different content)

So I think we should enforce label/inode-based content security on
reads, but we should enforce path/dentry-based security on writes.

In particular, doing a write on a file, and moving a file to that same
path ought to have exactly the same security checks, since the
user-visible effect is the same.

The unix model is broken regarding this, since one will depend on the
write permissions on the file inode, and the other on the directory.
Ideally, both should depend on the write permissions of the _dentry_
(there would need to be a concept of default dentry permissions for a
directory).

The only thing that breaks this are hard links, since they allow to
change the data associated with multiple unknown dentries in a single
operation. However, completely disallowing writes to inodes with
multiple links solves the problem, and shouldn't require fundamental
(or any) userspace changes (of course, this is to be done by the
security module, not by the generic vfs).
