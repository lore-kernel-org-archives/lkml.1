Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbYBJVPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbYBJVPh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 16:15:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751087AbYBJVP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 16:15:28 -0500
Received: from styx.suse.cz ([82.119.242.94]:36634 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751038AbYBJVP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 16:15:28 -0500
Date: Sun, 10 Feb 2008 22:15:26 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Abel Bernabeu <abel.bernabeu@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Bug report in the elf loader
In-Reply-To: <15577be70802081123w7df93c09l31d99a8140e7a28e@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802102150070.30955@jikos.suse.cz>
References: <15577be70802081123w7df93c09l31d99a8140e7a28e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2008, Abel Bernabeu wrote:

> What is the official forum to report bugs in the kernel?

Hi Abel,

lkml is the most official forum you can find.

> I've making some testing of the elf loader in my host system (an x86
> PC with Linux version 2.6.18)... and I have finally found a bug.
> The elf loader does not always return the correct error code when
> trying to load incorrect binaries.
> The execution with 2 badly formed elf binaries leads to different error codes:
[ ... ]
> # ls ./bb386 ./bb386nc
> ./bb386  ./bb386nc  <------ Both files exist!!
> # ./execve ./bb386
> Executing ./bb386
> The result of exec is 2    <--------- Bad!!
> # ./execve ./bb386nc
> Executing ./bb386nc
> The result of exec is 8
> Execve should return 8 in both cases.
> I attach the two binaries so anyone familiar with the elf loader can
> try to figure out the problem... I can supply some details about how I
> produced the binaries if needed.

Well, bb386nc has its e_flags set to 0x2, which means that the binary is 
of type EF_BFIN_FDPIC.

The fdpic handler returns ENOENT if the PT_INTERP field of the binary is 
malformed, which is what you are probabling hitting here:

                        retval = -ENOENT;
                        if (interpreter_name[phdr->p_filesz - 1] != '\0')
                                goto error;

The 'standard' ELF binary handler returns ENOEXEC in such cases, and this 
is the difference you are seeing here.

I basically think that both errnos are allowed here:

ENOENT The file filename or a script or ELF interpreter does not exist, or 
a shared library needed for file or interpreter cannot be found.

ENOEXEC An executable is not in a recognized format, is for the wrong 
architecture, or has some other format error that means it cannot be 
executed.

-- 
Jiri Kosina
SUSE Labs
