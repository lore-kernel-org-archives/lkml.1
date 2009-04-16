Return-Path: <linux-kernel-owner+w=401wt.eu-S1758706AbZDPTk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706AbZDPTk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 15:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757676AbZDPTkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 15:40:07 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:17690 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758018AbZDPTkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 15:40:03 -0400
Subject: Re: [PATCH RFC] ext3 data=guarded v3
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>, Jan Kara <jack@suse.cz>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0904161129460.4042@localhost.localdomain>
References: <1239816159-6868-1-git-send-email-chris.mason@oracle.com>
	 <1239881953.20254.17.camel@marge.simson.net>
	 <1239893771.4346.0.camel@think.oraclecorp.com>
	 <1239901977.4346.3.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0904161129460.4042@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 15:38:07 -0400
Message-Id: <1239910687.21233.93.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.49E7892A.0220:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-16 at 11:37 -0700, Linus Torvalds wrote:
> 
> On Thu, 16 Apr 2009, Chris Mason wrote:
> > 
> > Ah ok, it is just a missed i_size update.  Basically because file_write
> > doesn't wait for page writeback to finish, someone can be updating
> > i_size at the same time the end_io handler for the last page is running.
> > 
> > Git triggers this when it does the sha1flush just before closing the
> > file.
> 
> Can you say exactly what the IO pattern is?
> 
> One of the original git design issues was to actually never _ever_ do 
> anything even half-way strange in the filesystem patterns, exactly because 
> I've seen so many filesystem bugs over the years.
> 

I wish it were git doing something fancy, but this is a good old
fashioned bug in the guarded code.  I was missing the on disk update
when you appended onto the end of the file without adding a new block. 

The race in my code I mentioned was there too, but when doing small
appends to the file without other writes, the size of the race window is
infinite.

The bug was usually hidden because the updated i_size was usually copied
out when the orphan link was deleted, but small appends with no other
file traffic didn't trigger that code.  This is the old "works fine
under load but fails when lightly used" problem.

Git made the whole thing much easier to track down.  I didn't have to
read the git code to know the packed files from the good data=ordered
and bad data=guarded run were supposed to be the same, the sha was right
in the filename ;)  Just a quick diff of the hexdumps made it clear
where the bug had to be.

-chris


