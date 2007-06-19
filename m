Return-Path: <linux-kernel-owner+w=401wt.eu-S1759823AbXFSSDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759823AbXFSSDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 14:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759919AbXFSSD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 14:03:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759913AbXFSSD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 14:03:27 -0400
Message-ID: <46781A5B.9090104@redhat.com>
Date: Tue, 19 Jun 2007 14:03:07 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jack Stone <jack@hawkeye.stone.uk.eu.org>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk, hpa@zytor.com,
       alan <alan@clueserver.org>
Subject: Re: Versioning file system
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <4673182B.4090800@redhat.com> <46739E89.1080003@hawkeye.stone.uk.eu.org>
In-Reply-To: <46739E89.1080003@hawkeye.stone.uk.eu.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jack Stone wrote:
> Chris Snook wrote:
>> The underlying internal implementation of something like this wouldn't
>> be all that hard on many filesystems, but it's the interface that's the
>> problem.  The ':' character is a perfectly legal filename character, so
>> doing it that way would break things.
> 
> But to work without breaking userspace it would need to be a character
> that would pass through any path checking routines, ie be a legal path
> character.
> 
>> I think NetApp more or less got the interface right by putting a 
>> .snapshot directory in each directory, with time-versioned
>> subdirectories each containing snapshots of that directory's contents
>> at those points in time.  It keeps the backups under the same
>> hierarchy as the original files, to avoid permissions headaches,
>> it's accessible over NFS without modifying the client at all,
>> and it's hidden just enough to make it hard for users to do something
>> stupid.
> 
> My personal implementation idea was to store lots of files for the form
> file:revision_number (I'll keep using that until somebody sugests
> something better) on the file system itself, with a hard link form the
> latest version to file (this is probably not a major imporvement and
> having the hard link coudl make it hard to implement deltas). This could
> mean no changes to the file system itself (except maybe a flag to say
> its versioned). The kernel would then do the translation to find the
> correct file, and would only show the latest version to userapps not
> requesting a specific version.

I pointed out NetApp's .snapshot directories because that's a method that uses 
legal path character, but doesn't break anything.  With this method, userspace 
tools will have to be taught that : is suddenly a special character.  Userspace 
already knows that files beginning with . are special and treat them specially. 
  We don't need a new special character for every new feature.  We've got one, 
and it's flexible enough to do what you want, as proven by NetApp's extremely 
successful implementation.  Perhaps you want a slightly different interface from 
what NetApp has implemented, but what you're suggesting will change the default 
behavior of basic tools like tar and ls.  This is not a good thing.

>> If you want to do something like this (and it's generally not a bad
>> idea), make sure you do it in a way that's not going to change the
>> behavior seen by existing applications, and that is accessible to
>> unmodified remote clients.  Hidden .snapshot directories are one way, a
>> parallel /backup filesystem could be another, whatever.  If you break
>> existing apps, I won't touch it with a ten foot pole.
> 
> The whole interface would be designed to give existing behavior as
> default for two reasons: users are used to opening a file and getting
> the latest version and not to break userspace. I personally wouldn't
> touch this either if it broke userspace. The only userspace change would
> be the addition of tools to manage the revisions etc. Userspace could
> later upgrade to take advantage of the new functionality but I cannot
> see the worth in breaking it.

But what you're talking about *will* break userspace.  If I do an ls in a 
directory, and get pages upon pages of versions of just one file, that's broken. 
  If I tar up a directory and get a tarball that's hundreds of times larger than 
it should be, that's broken.  If you want the files to be hidden from userspace 
applications that don't know about your backup scheme, (and it sounds like you 
do) then use the existing convention for hidden files, the prepended '.'  This 
is the universal sign for "don't mess with me unless you know what you're doing".

	-- Chris
