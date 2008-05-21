Return-Path: <linux-kernel-owner+w=401wt.eu-S1765470AbYEUWa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765470AbYEUWa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 18:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755619AbYEUWar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 18:30:47 -0400
Received: from phunq.net ([64.81.85.152]:40193 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754214AbYEUWaq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 18:30:46 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Wed, 21 May 2008 15:30:14 -0700
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Eric Sandeen <sandeen@redhat.com>, Theodore Tso <tytso@mit.edu>,
       Andi Kleen <andi@firstfloor.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <482DDA56.6000301@redhat.com> <20080518211140.b29bee30.akpm@linux-foundation.org> <200805191316.27551.chris.mason@oracle.com>
In-Reply-To: <200805191316.27551.chris.mason@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200805211530.14831.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 May 2008 10:16, Chris Mason wrote:
> root@opti:~# fsck -f /dev/sda2
> fsck 1.40.8 (13-Mar-2008)
> e2fsck 1.40.8 (13-Mar-2008)
> /dev/sda2: recovering journal
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Problem in HTREE directory inode 281377 (/barrier-test): bad block number 
> 13543.
> Clear HTree index<y>?    

Nice, htree as a canary for disk corruption.  This makes sense since
directory data is the only verifiable structure at the logical data
level and htree offers the only large scale, verifiable structure.

Thanks for the lovely test methodology example.  Let me additionally
offer this tool:

   http://code.google.com/p/zumastor/source/browse/trunk/ddsnap/tests/devspam.c?r=1564
   devspam

The idea is to write an efficiently verifiable pattern across a range
of a file, including a mix of position-dependent codes and a user
supplied code.  In read mode, devspam will check that the position
dependent codes are correct and match the user supplied code.  This
can be easily extended to a "check that all the user supplied codes
are the same" mode, which would help detect consistency failure in
regular data files much as htree does with directories.  Hmm, this
probably wants to incorporate a sequence number as well, to detect
corruption under a random block update load as you have triggered
with htree.

I used this tool to exorcise the majority of bugs in ddsnap.  It is
a wonderful canary, not only catching bugs early but showing where
where they occurred.

>From what I have seen, Sun seems to rely mostly on MD5 checksums for
detecting corruption in ZFS.  We should do more of that too.

Regards,

Daniel
