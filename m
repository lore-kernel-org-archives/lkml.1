Return-Path: <linux-kernel-owner+w=401wt.eu-S1757908AbYEDTYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908AbYEDTYQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 15:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755104AbYEDTYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 15:24:00 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:58920 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602AbYEDTYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 15:24:00 -0400
Date: Sun, 4 May 2008 21:24:34 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: lkml List <linux-kernel@vger.kernel.org>,
       "linuxppc-dev@ozlabs.org list" <linuxppc-dev@ozlabs.org>
Subject: Re: How to link a .o with all modules
Message-ID: <20080504192434.GA23752@uranus.ravnborg.org>
References: <6C8AB345-2DA0-460D-B7C8-262463247DDE@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6C8AB345-2DA0-460D-B7C8-262463247DDE@kernel.crashing.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2008 at 01:22:38PM -0500, Kumar Gala wrote:
> Sam,
> 
> We have a case in powerpc in which we want to link some library  
> routines with all module objects.  The routines are intended for  
> handling out-of-line function call register save/restore so having  
> them as EXPORT_SYMBOL() is counter productive (we do also need to link  
> the same "library" code into the kernel).
> 
> Any suggestions on how to handle this?

I assume you have the .o file build somewhere as part of the
normal kernel build.

Then you in
arch/powerpc/Makefile adds the following assignment:

LDFLAGS_MODULE += arch/powerpc/lib/my_magic_file.o

kbuild will then during the modpost stage link this
file on all modules.
To add the same file to the kernel just include it
in a obj-y += my_magic_file.o

One trap is that my_magic_file.o needs to be built
for a modules build too.
I think you need to assign it to always:

   always := my_magic_file.o

to accomplish this.

So in the end we will have:

arch/powerpc/Makefile:
LDFLAGS_MODULE += arch/powerpc/lib/my_magic_file.o

arch/powerpc/lib/Makefile:
always := my_magic_file.o
obj-y += my_magic_file.o


Let me know if this does address your question.

	Sam
