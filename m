Return-Path: <linux-kernel-owner+w=401wt.eu-S1753128AbZISXSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbZISXSM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 19:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbZISXSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 19:18:12 -0400
Received: from THUNK.ORG ([69.25.196.29]:41356 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbZISXSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 19:18:11 -0400
Date: Sat, 19 Sep 2009 19:18:10 -0400
From: Theodore Tso <tytso@mit.edu>
To: wbrana@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: EXT4 RAID read performance
Message-ID: <20090919231810.GE7121@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, wbrana@gmail.com,
	linux-kernel@vger.kernel.org
References: <a769871e0909191112t3adb852cn93d72dc5fd94b9fd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a769871e0909191112t3adb852cn93d72dc5fd94b9fd@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 19, 2009 at 08:12:31PM +0200, wbrana@gmail.com wrote:
> 
> I'm considering replacing Reiser3 filesystem with some newer one.
> I ran compilebench benchmark. Read performance is lower with ext4.
> Is it expected or is it possible to fix it?

You didn't say which version of the kernel you are using, which could
be important when asking these sorts of questions about potential
performance problems.

However, in this case, I suspect the issue is the nature of how
compilebench is structured.  Compilebench does the following which
makes it work particularly well for filesystems like reiserfs and
btrfs, and not so much for ext3 and ext4.  Quoting from the
compilebench web page:

   compilebench starts by putting these lists of file names into an
   order native to the filesystem it is working on. The files are
   created in sorted order based on the filename, and then readdir is
   used to find the order the filesystem uses for storing the
   names. After this initial phase, the filesystem native order is
   used for creates, patches and compile. Deleting, reading and
   stating the trees are done in readdir order.

The key here is that it reads the tree in readdir order.  Normally,
when you compile a kernel, the order in which you read and write files
is controlled by the Makefile; you don't get to read and write the
files in the order which just happens to be the most convenient for
the file system's b-tree hash algorithm.

Now, there are some workloads which compilebench might accurately
model --- for example, tar'ing up a directory.  However, despite the
name of the benchmark, it doesn't accurately model a kernel compile.

If you only care about compilebench numbers, you can try creating the
file system with the dir_index feature disabled.  This is the feature
that speeds up random access to directories; unfortunately, it means
that when you read files in readdir order, it causes extra random
reads to th einode table.  However, if your real-life workload is one
where file reads are always magically in readdir order, dir_index adds
overhead without adding any benefit.   

The bottom line is that I'm not terribly worried about trying to
improve ext4's performance on compilebench, since I don't believe it's
a benchmark that models realistic real-life workloads.

Regards,

						- Ted
