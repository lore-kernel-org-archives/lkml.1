Return-Path: <linux-kernel-owner+w=401wt.eu-S1757746AbZDXJQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746AbZDXJQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 05:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755743AbZDXJQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 05:16:22 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:50147 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbZDXJQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 05:16:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HMBjKly79Vnc+F/FiD9PIm4g8FHAlU3gLembrvx+a0lvszs/Ax3+0YMPJ9FfzY3t9u
         NG6/crsLNNyZYCjyAhlcjVg4qhap5v291EmOiyB+/kpsCrV+NTa2Gn/WD5rdKBog7vww
         M19vpijJi5d/f/Sz7jsX6zP0vPI4jIG1A6b08=
MIME-Version: 1.0
In-Reply-To: <20090424085017.GB28592@infradead.org>
References: <20090423191934.GW1926@parisc-linux.org>
	 <1240556813-8739-1-git-send-email-abogani@texware.it>
	 <1240556813-8739-2-git-send-email-abogani@texware.it>
	 <20090424071312.GE8633@ZenIV.linux.org.uk>
	 <20090424071853.GG8633@ZenIV.linux.org.uk>
	 <20090424080634.GG24912@elte.hu>
	 <20090424085017.GB28592@infradead.org>
Date: Fri, 24 Apr 2009 11:16:18 +0200
Message-ID: <c62985530904240216j2760e3dbvca5b8e9da22d009f@mail.gmail.com>
Subject: Re: [PATCH 1/1] vfs: umount_begin BKL pushdown v2
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Al Viro <viro@zeniv.linux.org.uk>,
       Alessio Igor Bogani <abogani@texware.it>,
       Jonathan Corbet <corbet@lwn.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       LFSDEV <linux-fsdevel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/24 Christoph Hellwig <hch@infradead.org>:
>> Furthermore, by doing this you are also hindering the
>> tip:kill-the-BKL effort (which has been ongoing for a year chipping
>> away at various BKL details) which facilitated these changes.
>> Alessio did these fixes to fix bugs he can trigger in that tree.
>>
>> You've also not explained why you have done it this way. It would
>> cost you almost nothing to apply these bits into a separate branch
>> and merge that branch into your main tree. Lots of other maintainer
>> are doing that.
>
> Having a separate kill the BKL tree is a stupid idea.  Locking changes
> need deep subsystem knowledge and should always go through the subsystem
> trees.


I disagree with you. The kill-the-BKL tree does not only aggregate patches
to turn the BKL into more traditional locks. The Bkl has been
converted to a common mutex in
this tree, making it losing its common horrid properties:

- release/reacquire on schedule
- not preemptable
- can be reacquired recursively by a same task

Such a basis is very useful because we can easily find these places
which won't support a usual lock conversion without reworking the
locking scheme.
This is a necessary preliminary for the Bkl removal.
All the places which have been designed very tightly with Bkl
properties are rapidly detected
with lockdep in this tree and reworked, still using lockdep, code
reviewing and the help of
this Bkl-to-mutex conversion.

The work done with this tree can be merged inside and also on the
matching subsytem tree for
each patchset. That's a very sane workflow IMHO.

Thanks,
Frederic.
