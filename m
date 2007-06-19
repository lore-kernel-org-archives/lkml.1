Return-Path: <linux-kernel-owner+w=401wt.eu-S1763664AbXFSUEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763664AbXFSUEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 16:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765483AbXFSUDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 16:03:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765284AbXFSUDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 16:03:48 -0400
Message-ID: <4678369C.7070908@redhat.com>
Date: Tue, 19 Jun 2007 16:03:40 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jack Stone <jack@hawkeye.stone.uk.eu.org>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk, hpa@zytor.com
Subject: Re: Versioning file system
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <4673182B.4090800@redhat.com> <46739E89.1080003@hawkeye.stone.uk.eu.org> <46781A5B.9090104@redhat.com> <4678292B.6000804@hawkeye.stone.uk.eu.org>
In-Reply-To: <4678292B.6000804@hawkeye.stone.uk.eu.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jack Stone wrote:
> Chris Snook wrote:
>> But what you're talking about *will* break userspace.  If I do an ls in
>> a directory, and get pages upon pages of versions of just one file,
>> that's broken.  If I tar up a directory and get a tarball that's
>> hundreds of times larger than it should be, that's broken.  If you want
>> the files to be hidden from userspace applications that don't know about
>> your backup scheme, (and it sounds like you do) then use the existing
>> convention for hidden files, the prepended '.'  This is the universal
>> sign for "don't mess with me unless you know what you're doing".
> 
> The idea was that if you did an ls you would get the latest version of
> the file without the :revision_num. The only visible version would be
> the latest version, i.e. the current system would not change. The idea
> was that it would only show earlier versions if they were specifically
> requested with a :revision_num suffix. In that case the
> filesystem/kernel would need to recognise the suffix and return the
> earlier version of the file.
> 
> The only userspace it would break is files with :num in their name, as I
> haven't seen any files like that I don't think its too big a problem but
> the way of specifiying revisions could be changed.
> 
> Jack

I have one right now:

$ ls /tmp/ksocket-csnook/kdeinit*
/tmp/ksocket-csnook/kdeinit__0  /tmp/ksocket-csnook/kdeinit-:0

Note, I did not pass any special arguments to ls to make it pull up that file. 
You'd have to modify ls to make it do that.  You'd also need to modify 
everything else out there.  There are decades of programs out there that would 
behave differently with the interface you propose.

The more fundamental problem with your proposed interface is that it treats a 
filesystem like an opaque server, instead of a transparent data structure.  You 
want files to be completely invisible to applications that don't know about it, 
unless the user requests it.  Unfortunately, it doesn't work that way. 
Applications ask for a directory listing, and will open the requested file if 
and only if the filename in question appears in that listing.  If you want to 
use this opaque server model, you'd be better served putting it in some parallel 
file system (say, /backup) that won't interfere with naive applications 
accessing the mundane data.  Personally, I like your idea of putting the older 
versions in the same directory hierarchy, but I think you'd have to use .foo 
hidden directories to do it right.

	-- Chris
