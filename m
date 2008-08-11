Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbYHKVsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbYHKVsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 17:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbYHKVr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 17:47:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:52694 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbYHKVr7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 17:47:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: checkpoint/restart ABI
Date: Mon, 11 Aug 2008 23:47:49 +0200
User-Agent: KMail/1.9.9
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org
References: <20080807224033.FFB3A2C1@kernel> <200808111853.13854.arnd@arndb.de> <1218484114.5598.43.camel@nimitz>
In-Reply-To: <1218484114.5598.43.camel@nimitz>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808112347.50245.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+SgG1fbAMHgx3bedH92UOwNbSJCwyJCbq3FzV
 SzkWvMDTqwhGzDE3BOnYzEv4ngusrU0d+lXJkbDT8w4sXIfXqo
 eZQJmi9endqz+Oo7WtuRA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 August 2008, Dave Hansen wrote:
> Thanks for all of the very interesting comments about the ABI.  
> 
> Considering that we're still *really* early in getting this concept
> merged up into mainline, what do you all think we should do now?

I think the two most important aspects here need to be security and
simplicity. If you have to choose between the two, it probably makes
sense to put security first, because loading untrusted data into
the kernel puts you at a significant risk to start with. If you
can show a restart interface that lets regular users restart their
tasks in a way anyone can verify to be secure, that will be a
good indication that you're on the right track.

The other problem that you really need to solve is interface
stability. What you are creating is a binary representation
of many kernel internal data structures, so in our common
rules, you have to make sure that you remain forward and
backward compatible. Simply saying that you need to run
an identical kernel when restarting from a checkpoint is not
enough IMHO.


Some more words on specific interfaces that we have discussed:

The single-file-descriptor approach has the big advantage of
keeping the complexity in one place (the kernel). To be consistent
with other kernel interfaces, I would make the kernel hand out a
file descriptor, not let the user open a file and pass that into
the kernel as you do now.

A new file system is a good idea for many complex interfaces that
make their way into the kernel, but I don't think it will help
in this case.

For checkpointing a single task, or even a task with its children,
a different interface I could imagine would be to have a new
file in procfs per pid that you can read as a pipe giving our
the same data that you currently save in the checkpoint file
descriptor. It does mean that you won't be able to pass flags
down easily (you could write to the pipe before you start reading,
but that's not too nice).

On the restart side, I think the most consistent interface would
be a new binfmt_chkpt implementation that you can use to execve
a checkpoint, just like you execute an ELF file today. The binfmt
can be a module (unlike a syscall), so an administrator that is
afraid of the security implications can just disable it by not
loading the module. In an execve model, the parent process can
set up anything related to credentials as good as it's allowed
to and then let the kernel do the rest.

	Arnd <><
