Return-Path: <linux-kernel-owner+w=401wt.eu-S1753943AbZDWFXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbZDWFXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 01:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbZDWFWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 01:22:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002AbZDWFWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 01:22:48 -0400
Date: Wed, 22 Apr 2009 22:17:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valerie Aurora Henson <vaurora@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>, Theodore Tso <tytso@mit.edu>,
       Eric Sandeen <sandeen@redhat.com>, Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [RFC PATCH] fpathconf() for fsync() behavior
Message-Id: <20090422221748.8c9022d1.akpm@linux-foundation.org>
In-Reply-To: <20090423001257.GA16540@shell>
References: <20090423001257.GA16540@shell>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Apr 2009 20:12:57 -0400 Valerie Aurora Henson <vaurora@redhat.com> wrote:

> In the default mode for ext3 and btrfs, fsync() is both slow and
> unnecessary for some important application use cases - at the same
> time that it is absolutely required for correctness for other modes of
> ext3, ext4, XFS, etc.  If applications could easilyl distinguish
> between the two cases, they would be more likely to be correct and
> fast.
> 
> How about an fpathconf() variable, something like _PC_ORDERED?  E.g.:
> 
> 	/* Unoptimized example optional fsync() demo */
> 	write(fd);
> 	/* Only fsync() if we need it */
> 	if (fpath_conf(fd, _PC_ORDERED) != 1)
> 		fsync(fd);
> 	rename(tmp_path, new_path);
> 
> I know of two specific real-world cases in which this would
> significantly improve performance: (a) fsync() before rename(), (b)
> fsync() of the parent directory of a newly created file.  Case (b) is
> particularly nasty when you have multiple threads creating files in
> the same directory because the dir's i_mutex is held across fsync() -
> file creates become limited to the speed of sequential fsync()s.
> 
> Conceptual libc patch below.

Would it be better to implement new syscall(s) with finer-grained control
and better semantics?  Then userspace would just need to to:

	fsync_on_steroids(fd, FSYNC_BEFORE_RENAME);

and that all gets down into the filesystem which can then work out what
it needs to do to implement the command.

