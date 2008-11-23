Return-Path: <linux-kernel-owner+w=401wt.eu-S1752404AbYKWXGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbYKWXGt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 18:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751043AbYKWXGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 18:06:41 -0500
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:33249 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYKWXGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 18:06:41 -0500
X-Greylist: delayed 1459 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Nov 2008 18:06:40 EST
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4929DC4A.4020905@cl.cam.ac.uk>
Date: Sun, 23 Nov 2008 22:42:18 +0000
From: Chris Smowton <chris.smowton@cl.cam.ac.uk>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Robust shared memory for unrelated processes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

First of all, my apologies if this is the wrong list for this 
suggestion; I haven't posted here before so I might accidentally break 
some local conventions :)

With that said, my question/suggestion relates to sharing memory between 
processes which are *not* in a parent-child relationship.

Suppose for simplicity's sake that one wishes to share a sizable piece 
of memory with a single other process with which one is already in 
contact (say, by a Unix domain socket).

It seems to me that one cannot do this without introducing the risk of 
the shared section not being deallocated until the system next boots, 
for the following reasons:

1. Suppose I use SysV style SHM. Then I must find a free key, create a 
section with that key, and communicate that key to my partner process so 
that he can also open the section. I cannot issue an IPC_RMID during 
this time, as that will render the key immediately unavailable. If I am 
SIGKILL'd at any time between creating the section and receiving 
confirmation that my partner has opened it, the section will persist 
until reboot. This is a large window of opportunity and a very bad thing.

2. Suppose I use POSIX shared memory (i.e. shm_open and its brethren). 
Then the same problem exists, only keys are replaced by friendlier 
names. The situation is as bad as with SysV SHM.

3. Suppose now I get a bit cleverer; I use POSIX SHM, but I create and 
then immediately unlink my section, before sending the file descriptor 
over a Unix domain socket to my partner (using the ancillary control 
channel). This works, and does mean that I am able to create a shared 
section then immediately unlink it, whilst retaining the ability to 
allow processes to open the effectively anonymous shared section by 
sending them its file descriptor. This nearly accomplishes my goal of 
ensuring the shared section does get tidied up if its users are all 
SIGKILL'd; however, the section's creator does still have to issue two 
calls: shm_open("/mysection", ...); shm_unlink("/mysection");. This is 
not atomic, and therefore a window of opportunity still exists for the 
section to go astray if I am killed at the wrong time.

This option would also work with a regular file residing in a tmpfs, 
since this is all Linux's implementation of shm_open does.

4. Alright, so what if I get still a little cleverer? I will try to use 
BSD-style shared memory, as those sections are anonymous and certainly 
cleaned up when the referring processes die. I open /dev/zero and mmap 
it appropriately, before sending its associated FD to my partner. 
Unfortunately this fails; my partner ends up with a private, zeroed 
block of memory and nothing is shared. Curiously, I can dup() the 
dev-zero file descriptor and share memory with my child processes, and 
sendmsg's documentation declares that it will effectively dup() a file 
descriptor which is passed across a unix domain socket, but this does 
not seem to hold for /dev/zero in particular.

Therefore, it seems that in order to permit sharing of memory with a 
process with which I do not have a parent-child relationship, one of the 
following needs to be the case:

1. It needs to be possible to atomically shm_open and shm_unlink, or
2. It needs to be possible to pass handles to /dev/zero over sockets 
like one can regular files and POSIX section handles (which are just 
files in a tmpfs), or
3. It needs to be possible for a general file to atomically created and 
registered for deletion on closure of its last handle.

Does this seem valid? Or is there a means to achieve SHM between 
unrelated processes without the risk of leaking the memory?

I'm reading the mailing list online rather than getting it delivered at 
the moment, so I'd appreciate any comments CC'd to cs448@cam.ac.uk :)

Thanks in advance to anyone willing to advise!

Chris
