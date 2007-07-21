Return-Path: <linux-kernel-owner+w=401wt.eu-S933721AbXGUWDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933721AbXGUWDB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 18:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762993AbXGUWCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 18:02:54 -0400
Received: from barikada.upol.cz ([158.194.242.200]:60760 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762972AbXGUWCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 18:02:53 -0400
Date: Sun, 22 Jul 2007 00:16:27 +0200
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: More effective processing (Re: [PATCH 25/33] kbuild: use POSIX BRE in headers install target)
Message-ID: <20070721221627.GN475@flower.upol.cz>
References: <1184681344985-git-send-email-sam@ravnborg.org> <11846813442810-git-send-email-sam@ravnborg.org> <118468134441-git-send-email-sam@ravnborg.org> <11846813441741-git-send-email-sam@ravnborg.org> <1184681344376-git-send-email-sam@ravnborg.org> <E1ICAEU-0005an-5F@flower> <8bd0f97a0707210127m565f9b2cnc7a8a203f671e948@mail.gmail.com> <20070721100422.GK475@flower.upol.cz> <8bd0f97a0707211221l2c7fedeoea8612876350db6d@mail.gmail.com> <20070721203916.GA2912@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070721203916.GA2912@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2007 at 10:39:16PM +0200, Sam Ravnborg wrote:
> On Sat, Jul 21, 2007 at 03:21:43PM -0400, Mike Frysinger wrote:
[]
> > while you could try and make a claim against memory/cpu effeciency, i
> > fail to see how the first or last claims could possibly be backed up

Less \{\(\\n\t\+\)\} [0] stuff make readings regex much easier. My
confusion shows that i didn't used \{ much, because have another ways
so far. And even after my quick testing i didn't realize that there
was unrelated to main task whitespace cleanup.

[0] http://sed.sf.net/grabbag/tutorials/lookup_tables.txt

> > but again, if you feel that strongly about it, you're certainly free
> > to post a patch
> 
> I would much more prefer this functionality to be integrated into unifdef.
> There is no good reason to have two different preprocesisng methonds, one
> being the sed based one and the other the unidef one.

Clear definition of the task will help to design a solution. I can do
the job, but figuring out all possible corner cases from current
solutions, mixed in Makefiles or everywhere else is not option.

> A sinlge dedicated program that contian the sum of the functionality would
> be faster too.

What do you think about this one? I want to propose to remove
scripts/unifdef.c but to make clear policy about how to mark __KERNEL__
sections in header files. We know how obfuscated C can be, and this also
applies to preprocessing. There's known CodingStyle about some points.
The thing is to specify rules, that will be easy for `sed` to do cleaup
job.

./linux/soundcard.h:#if (!defined(__KERNEL__) && !defined(KERNEL) && !defined(INKERNEL)
                      && !defined(_KERNEL)) || defined(USE_SEQ_MACROS)
./linux/stat.h:#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)

Split __KERNEL__ check, make only positive, i.e.

#if defined(__KERNEL__)
#ifdef __KERNEL__

./linux/stat.h:#ifdef __KERNEL__

No `#else` and ending part to contain comment:

./linux/smb_fs_sb.h:#endif /* __KERNEL__ */

Simple enough:

sed '/^#if[^_]*__KERNEL__/,/^#end[^_]*__KERNEL__/d'
____
