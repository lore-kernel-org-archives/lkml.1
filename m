Return-Path: <linux-kernel-owner+w=401wt.eu-S2992474AbXDLKeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992474AbXDLKeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 06:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992466AbXDLKeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 06:34:21 -0400
Received: from cs.columbia.edu ([128.59.16.20]:40309 "EHLO cs.columbia.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992463AbXDLKeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 06:34:19 -0400
Message-ID: <461E0AE3.10608@cs.columbia.edu>
Date: Thu, 12 Apr 2007 06:33:07 -0400
From: Shaya Potter <spotter@cs.columbia.edu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: jjohansen@suse.de
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org
Subject: Re: [AppArmor 00/41] AppArmor security module overview
References: <20070412090809.917795000@suse.de>
In-Reply-To: <20070412090809.917795000@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PerlMx-Spam: Gauge=IIIIIII, Probability=7%, X-Seen-By filter1.cs.columbia.edu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

jjohansen@suse.de wrote:
> This post contains patches to include the AppArmor application security
> framework, with request for inclusion.

question in general, these seems like a fairly invasive series of 
patches.  back when I first started graduate school, I prototyped a 
relatively simple stackable file system on 2.4 that seems to be able to 
do a lot of what app armor does (or at least seems to be easily 
extensible to o everything app armor does) from an fs perspective, 
without having to modify the kernel at all, why not use that approach?

What I did back then was I took Erez Zadok's fist, created his base0fs, 
which basically does nothing, just passes everything directly down.  I 
viewed it as a null stackable fs.  I then modified it to

a) contain a set of rules (be able to add, delete, modify them)

b) fs's private lookup() determines if a dentry matches a rule and tags
it (stored in dentry private data, but inode can be used as well)

c) fs's private permission() checks the rule data stored in private data 
to determine if the generic_permission should be even called.

what I didn't do is mmap or hard link, but those are additional checks 
one can do in those specific f_ops.

Basically, why force the VFS to change, when one can create an 
apparmorfs that stacks on top of whatever fs you want to use app armor 
rules with, create a namespace containing that new stacked fs only (to 
contain processes within the stacked fs).

This approach doesn't suffer from the normal stackable file system 
"issue" since  there should be no complex what I'll call "cache 
coherency" issues due to the stackable "directory entry" namespace being 
the same exact as the underlying namespace and it passing down page 
cache operations directly to the lower fs.  So one could stack on top of 
a file system one is using for both apparmor protected and unprotected 
processes.

I could imagine there might be an issue w/ how one deals with special 
file systems (ala proc and others).  But the way we approached this in 
general, is that this is an aspect of containers. namely, each protected 
area is a container itself, and hence has its own private virtualized 
proc....

my code was mostly prototype level (As well as only for 2.4), but it 
would seem to very easily to duplicate in a production level quailty for 
2.6.

anyways, just a thought
