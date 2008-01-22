Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbYAVRnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbYAVRnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 12:43:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbYAVRmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 12:42:55 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:58722 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbYAVRmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 12:42:54 -0500
In-Reply-To: <20080122033830.GR155259@sgi.com>
To: David Chinner <dgc@sgi.com>
Cc: Andreas Dilger <adilger@clusterfs.com>, linux-ext4@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ric Wheeler <ric@emc.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Valerie Henson <val@vahconsulting.com>
MIME-Version: 1.0
Subject: Re: [RFC] Parallelize IO for e2fsck
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OFCCC72BE7.3EF7DC79-ON882573D8.00601CEE-882573D8.00614CFA@us.ibm.com>
From: Bryan Henderson <hbryan@us.ibm.com>
Date: Tue, 22 Jan 2008 09:42:45 -0800
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Release 8.0|August 02, 2007) at 01/22/2008
 12:42:49,
	Serialize complete at 01/22/2008 12:42:49
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>I think there is a clear need for applications to be able to
>register a callback from the kernel to indicate that the machine as
>a whole is running out of memory and that the application should
>trim it's caches to reduce memory utilisation.
>
>Perhaps instead of swapping immediately, a SIGLOWMEM could be sent ...

The problem with that approach is that the Fsck process doesn't know how 
its need for memory compares with other process' need for memory.  How 
much memory should it give up?  Maybe it should just quit altogether if 
other processes are in danger of deadlocking.  Or maybe it's best for it 
to keep all its memory and let some other frivolous process give up its 
memory instead.

It's the OS's job to have a view of the entire system and make resource 
allocation decisions.

If it's just a matter of the application choosing a better page frame to 
vacate than what the kernel would have taken, (which is more a matter of 
self-interest than resource allocation), then Fsck can do that more 
directly by just monitoring its own page fault rate.  If it's high, then 
it's using more real memory than the kernel thinks it's entitled to and it 
can reduce its memory footprint to improve its speed.  It can even check 
whether an access to readahead data caused a page fault; if so, it knows 
reading ahead is actually making things worse and therefore reduce 
readahead until the page faults stop happening.

--
Bryan Henderson                     IBM Almaden Research Center
San Jose CA                         Filesystems

