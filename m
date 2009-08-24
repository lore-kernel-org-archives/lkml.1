Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbZHXXyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbZHXXyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 19:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbZHXXyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 19:54:53 -0400
Received: from elasmtp-curtail.atl.sa.earthlink.net ([209.86.89.64]:33207 "EHLO
	elasmtp-curtail.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753703AbZHXXyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 19:54:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=EVW5T3WPJjLKwx5R0Bqw6ihF3AI/n4EcUy3o0kok+NL3Zc6b8MdQxR8xY8EefC5d;
  h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4A93284C.7060604@earthlink.net>
Date: Mon, 24 Aug 2009 16:54:52 -0700
From: Jeff Shanab <jshanab@earthlink.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090714 SeaMonkey/1.1.17
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Starting a grad project that may change kernel VFS. Early research
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: 41b7b48e67ad7886d780f4a490ca6956abb457f1b4332f5290c0074dd29e3d8bab95434d3cf70b6c350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 75.150.3.226
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Title: "Pay it forward patch set"
Goal: Desire to change the dentry and inode functionality so commands
like du -s appear to have greatly improved performance.
How: TBD? 2 phase ubdate walking up the tree to root.

   Prior to actually starting my Grad Project in Computer science, I am
taking 1 semester to do research for it at the recommendation of my
advisory.  I need to of course make sure it doesn't already exist.  It
may be that all the changes end up in a file system and the kernel will
be left alone, just one of the things I want help determining.

1) First question, where to put this functionality?
    I originally thought to put my functionality in the VFS so that all
mounted file systems could share it, but after reading fs.h, and
inode.c, it looks like the VFS is purely an abstract interface and
functionality at that level may not be wanted? Also I guess certain file
systems may not have needed on disk structures to save the info (ie
VFAT,NFS, etc)

2) Second Question. The two part idea.
    I was thinking that a good way to handle this is that it starts with
a file change in a directory. The directory entry contains a sum already
for itself and all the subdirs and an adjustment is made immediately to
that, it should be in the cache. Then we queue up the change to be sent
to the parent(s?). These queued up events should be a low priority at a
more human time like 1 second. If a large number of changes come to a
directory, multiple adjustments hit the queue with the same (directory
name, inode #?) and early ones are thrown out. So levels above would see
at most a 1 per second low priority update.

    So when you issue a 'du -sh' or use anything that uses stat like
filelight, it can get the size of all the subdirs without actually
recursing through them, they have been built up over time.

    I have a second set of changes I am considering and I think would
fit more completely in a file system, but I bring them up here in case
it influences the above.
title: "User Metadata" aka "pet peeve reduction"
    I would like to maintain a few classifications of metadata, most
optional and configurable.

        1) OriginalFileName: Default on. The original filename is hung
onto. A warning is issued if it is attempted to be saved again in same
directory. This is primarily for  all those darn auto generated youtube
and pdf filenames.

       2) UserClasification: User Optional: User defined classifications
can be applied. Most examples I can think of can be usually handled by
directories, or file types, but users are surprising. Maybe
clasifications like personnel, buisness, job, school, can span directory
structures.

       3) KeyWords: Auto Gen or user defined: Allow google type searches
of files. Obviously faster to keep in a central location, we leave that
up to the application. we need it attached to file so an index can be
rebuilt  or it moves with the file.
   
       4) Description: User Optional: A user friendly Description can be
applied to any file. File Managers in a GUI can display original
filename and this Description on mouse hoover.

       5) Extension Specific Metadata: Configurable. An index page into
metadata specific to a file type. For example, security video may be
broken into many segments and may have motion events and alarms and
analytic information. A index to the frame containing this for the file
type may be useful.

Hopefully the cost of these would be relatively small, and most users
would only chose a few of them per file, so not all in use for every
file, but all available.

Sorry for the length of this. If you have read this far, thankyou!
