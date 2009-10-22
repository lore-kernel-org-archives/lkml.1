Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbZJVJWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbZJVJWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 05:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbZJVJWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 05:22:54 -0400
Received: from icculus.org ([67.106.77.212]:33102 "EHLO icculus.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050AbZJVJWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 05:22:53 -0400
Date: Thu, 22 Oct 2009 05:22:41 -0400 (EDT)
From: "Ryan C. Gordon" <icculus@icculus.org>
X-X-Sender: icculus@andre.icculuslan
To: Nicholas Miell <nmiell@comcast.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/2] binfmt_elf: FatELF support in the binary
 loader.
In-Reply-To: <1256196672.15558.1.camel@entropy>
Message-ID: <alpine.DEB.2.00.0910220442460.10075@andre.icculuslan>
References: <alpine.DEB.2.00.0910190418500.13303@andre.icculuslan> <1256196672.15558.1.camel@entropy>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Apple's fat binaries have the virtue of allowing redundant identical
> sections to be merged among the different included binaries, but your
> format can't do that.

Neither can Apple's. They employ a method similar to FatELF: a list of 
offsets and sizes of self-contained Mach-O binaries within a container 
file. Apple's previous attempt, for 68k+PowerPC binaries on the classic 
Mac OS, stored one architecture in the data fork and one in the resource 
fork, so they definitely couldn't overlap.

At the high level, ease of use and flexibility are primary values in 
keeping the ELF objects separate. You can easily glue arbitrary ELF 
binaries together from a simple command line tool without having to 
rewrite the actual ELF content in any of them. Also, it makes the changes 
needed to support FatELF extremely minimal: parse a simple array of 
records, adjust the file offset, and then use the heavily-tested and 
well-maintained ELF code that's been in the kernel for over a decade. This 
email is probably longer than the FatELF kernel patch.  :)

At the more technical level: there probably isn't much you could actually 
share between ELF binaries for any non-trivial program, and even if you 
could, I'm not sure the sharp increase complexity is worth it for the 
small space gains.

> Could you explain how your FatELF format is an improvement over multiple
> ELF binaries and a simple shell script that selects between them?

I'll preface my answer with a note: I am an _idiot_ at shell scripting. 
Here're two examples that prove it.

- I once shipped a game that used pushd in its shell script to choose the 
correct binary's folder. Anyone that's running Ubuntu can tell you that 
this fails when /bin/sh ceases to point to bash. That game now fails to 
start up. Human error, but still avoidable had there been a better 
solution.

- Many years ago, I shipped a game that ran on i686 and PowerPC Linux. I 
could not have predicted that one day people would be running x86_64 
systems that would be able to run the i686 version, so doing something 
like: exec $(uname -m)/mygame would fail, and there's really no good way 
to future-proof that sort of thing. As that game now fails to start on 
x86_64 systems, it would have been better to just ship for i686 and not 
try to select a CPU arch.

There are places where this sort of mentality is suboptimal anyhow: I 
consider the symlinks to /lib64 and /lib32 that you see on various distros 
to be a version of the shell script tactic. It works, but it's not 
really the cleanest approach.

I can also envision places where shell scripts aren't useful: web browser 
plugins, scripting language bindings, and other places where we want to 
load a shared library into a process that runs the risk of being 64-bit 
when the other thing is 32-bit. Were the shared library a FatELF that had 
both architectures, it would work without concern.

All of these things could have a million incompatible, one-off solutions: 
shell scripts and symlinks and a million human errors. Doing it simply and 
cleanly in one central place makes sense. I prefer that over loading an 
entire scripting language interpreter just to load the correct ELF file, 
and praying nothing ever changes to jeopardize the delicate balance.

--ryan.

