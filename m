Return-Path: <linux-kernel-owner+w=401wt.eu-S1754322AbYHGPUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbYHGPUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 11:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbYHGPUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 11:20:23 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:42071 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbYHGPUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 11:20:23 -0400
Date: Thu, 7 Aug 2008 17:20:05 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: Daryl Tester <dt-lkml@handcraftedcomputers.com.au>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM?: "permission denied" when accessing /proc/self/fd/*
 after setuid
In-Reply-To: <489A9357.50105@handcraftedcomputers.com.au>
Message-ID: <alpine.LNX.1.10.0808071311300.16201@titan.stealer.net>
References: <489A9357.50105@handcraftedcomputers.com.au>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.5
X-Spam-Bar: --
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Thu, 07 Aug 2008 15:20:21 +0000
	Bayes: 0.0051 Tokens: new, 319; hammy, 5; neutral, 7; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0051]
X-Spam-Signature: 06496e97b332a6f8c152ac8683a229224ec30516
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Aug 2008, Daryl Tester wrote:

> When a process setuid's to a non root user, under some circumstances
> it can no longer open /dev/stdout or /dev/stderr (which symlink to
> /proc/self/fd/1 & 2 respectively), which results in EACCESS.  Expected
> behavior is that the process should be able to open these already
> opened filed descriptors, but I'm not sure if this is intended or not.

If a program wants to fiddle with an existing _file_descriptor_, it should 
use the dup syscalls or access the descriptor directly. From my point of 
view open() should return a new instance of what you're trying to open and 
should not return a clone of something you already have opened in the 
past. And actually cloning a file handle during open() means bypassing the 
permission checks. Yes, you already have it open, but I think this is 
wrong behaviour.

> Am I expecting too much here of /dev/std* and /proc/self/fd/* being
> kosher methods to access a process' already open file descriptors?

Don't know if the behaviour of /dev/std* and /proc/self/fd/* is 
standardized in some way. But I guess it's implementation-specific.

> (Background)
> 
> From a discussion in <http://marc.info/?t=121760392200003&r=1&w=2>
> a user was attempting to open /dev/stderr for a log file under a djb
> supervised process.  The process initially runs as root, then setuid's
> to another id.  This process is connected to another process (for
> logging) on stdout (and dup'd onto stderr) via an anonymous pipe.
> The open of /dev/stderr fails with EACCESS.
> 
> The above environment isn't necessary to replicate the problem, although
> what stdout and stderr are attached to has some effect.  The attached C
> code replicates the issue, but appears to not fail (that is, succeed) if
> /proc/self/fd/2 is a terminal (e.g. /dev/pts/X) *and* that terminal is
> owned by the same uid that the code uses (in this case, 500). In the
> case of an anonymous pipe it appears to fail consistently as the pipe is
> owned by root.

Why should it fail for the terminal? You're the owner of it. For the pipe 
you're not, it was created by root in the parent.

> So, for example:
> 
> # ls -nl /proc/self/fd/2 /dev/pts/2
> crw------- 1 1000 5 136, 2 2008-08-07 15:36 /dev/pts/2
> lrwx------ 1    0 0     64 2008-08-07 15:36 /proc/self/fd/2 -> /dev/pts/2
> # ./self_fd /proc/self/fd/2
> /proc/self/fd/2: uid: 1000, gid: 5
> open(/proc/self/fd/2) as uid 500: Permission denied
> /proc/self/fd/2: uid: 1000, gid: 5

Works as expected from my point of view. Linux uses symlinks to represent 
open files in /proc/self/fd, so when doing the open on /dev/stderr you end 
up opening the original file, which requires a permission check. And that 
fails for obvious reasons.

> I've managed to replicate this issue on several platforms - a Centos
> 5.2 machine running 2.6.18-92, an Ubuntu 8.04 x86_64 running 2.6.24-19,
> and an Ubuntu 7.04 running 2.6.20-17 (A FreeBSD 4.11 box works OK
> though :-).

Don't have a FreeBSD installation at my fingers, so can't verify. Maybe 
they just don't use symlinks to represent the open files, so they do not 
end up opening the original file. Just checked Solaris and it looks like

lrwxrwxrwx   1 root     root           6 Feb 20  2007 /dev/stdout -> ./fd/1
crw-rw-rw-   1 root     root     314,  1 Aug  7 17:10 /dev/fd/1

So you end up opening a device that is world readable and writable, which 
then gives you access to your open file descriptor. IIRC that's how it is 
implemented historically in UNIX. As said above, don't know if the 
behaviour is standardized.

Sven
