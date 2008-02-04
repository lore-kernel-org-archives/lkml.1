Return-Path: <linux-kernel-owner+w=401wt.eu-S1756586AbYBDQNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbYBDQNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 11:13:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbYBDQMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 11:12:46 -0500
Received: from styx.suse.cz ([82.119.242.94]:58505 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753797AbYBDQMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 11:12:44 -0500
Date: Mon, 4 Feb 2008 17:12:43 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>
cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: brk randomization breaks columns
In-Reply-To: <Pine.LNX.4.64.0802041528470.30955@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0802041635000.30955@jikos.suse.cz>
References: <20080204122837.GA1647@elf.ucw.cz> <20080204130156.GA8730@elte.hu>
 <Pine.LNX.4.64.0802041528470.30955@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2008, Jiri Kosina wrote:

> I still don't seem to fully understand what is happening here -- 
> aparently this is triggerable only with old programs linked against 
> libc.so.5, and I am not able to trigger it with my trivial program when 
> I link it against old libc.so.5, which just basically does brk() and 
> checks whether /proc/<pid>/maps are OK. Seems to me that (at least 
> certain versions) of libc.so.5 (wrongly) assume that end of the bss is 
> the start of the heap, but I will try to investigate it more.

And I really think that (at least Pavel's version of) libc.so.5 is making 
some strange assumptions about memory layout of the process, which could 
also explain the other failures.

Pavel, could you please link the source code below against libc.so.5 with 
brk randomization turned on, and show the output, and if it segfaults, 
send the backtrace at the time of the crash? I suspect that it will crash 
somewhere in exit path when calling .dtor functions, as it will try to 
perform some cleanup in unmapped area. Thanks.

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

int main()
{
        int *curr_brk = sbrk(0);
        char command[1024];

        sprintf(command, "/bin/cat /proc/%d/maps", getpid());

        printf("brk set to %p\n", curr_brk);
        system(command);

        brk(curr_brk + 0x00001000);
        curr_brk = sbrk(0);

        printf("brk set to %p\n", curr_brk);
        system(command);
        exit(0);
}

-- 
Jiri Kosina
SUSE Labs
