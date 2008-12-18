Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752412AbYLRQF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbYLRQF6 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 11:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbYLRQFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 11:05:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:65078 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbYLRQFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 11:05:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bgYc8eyWxVqPVV0vnrNdlD4bgiAzoTQjGUzaFT2wtJR6yepV7A2ZeUAb0YTD/2Wqrd
         AGnoKNs99mpy86sy5GsQizACWVp5mTR8Zt/XeTodI/um51hfyZH9VLkoPmbYQmZZRoXy
         i8xxfr0E/9twWbIJjPBQcDogYQob7wxqgOB6Q=
Date: Thu, 18 Dec 2008 19:05:41 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Sam Ravnborg <sam@ravnborg.org>, Jan Beulich <jbeulich@novell.com>,
        linux-arch@vger.kernel.org,
        Alexander van Heukelum <heukelum@mailshack.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/many] PROC macro to annotate functions in assembly
	files
Message-ID: <20081218160541.GC12874@localhost>
References: <1229505475-10219-1-git-send-email-heukelum@fastmail.fm> <1229505475-10219-2-git-send-email-heukelum@fastmail.fm> <20081217172640.GB5436@uranus.ravnborg.org> <20081217173824.GF8078@localhost> <20081217180023.GA5783@uranus.ravnborg.org> <1229593918.31758.1290707307@webmail.messagingengine.com> <aa79d98a0812180403p47c6257r8e48afeff2e9b324@mail.gmail.com> <1229604055.28954.1290728947@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229604055.28954.1290728947@webmail.messagingengine.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Alexander van Heukelum - Thu, Dec 18, 2008 at 01:40:55PM +0100]
| 
| On Thu, 18 Dec 2008 15:03:25 +0300, "Cyrill Gorcunov"
| <gorcunov@gmail.com> said:
| > On Thu, Dec 18, 2008 at 12:51 PM, Alexander van Heukelum
| > <heukelum@fastmail.fm> wrote:
| > [...]
| > >> >
| > >> > Sam, I think eventually we should get something like this:
| > >> >
| > >> > - KPROBE will be eliminated and explicit section descriptions
| > >> >   are to be used
| > >> > - ENTRY could be used / or renamed for something more descriptive
| > >> >   and being used aligned jmp targets or in case of procs with
| > >> >   shared body
| > >
| > > I don't think ENTRY should be used for nested procedures. If the
| > > author wants to do something like that, he better knew something
| > > about the assembler anyhow.
| > 
| > Author anyway have to knew something. We can't bring some kind
| > of lexical machine that eliminate this needing :)
| > 
| > >
| > >> > - PROC/ENDPROC are to replace old ENTRY/END for procs being called
| > >> >   mostly from C code
| > >
| > > Currently there is many different patterns. Some functions use ENTRY
| > > without END, some use ENTRY/ENDPROC, some use ENDPROC without annotation
| > > at the start...
| > 
| > Alexander, I was just trying to say Sam about what we're planning to get
| > at the end of all this procedure. I mean I know there are some issues to
| > be fixed first.
| 
| I understood, but I wanted to avoid the meme that this procedure is
| just ebout renaming ENTRY->PROC and END->ENDPROC ;).

I wish it would be just renaming :-)

| 
| > Fix me if I'm wrong.
| > 
| > >
| > >> So what prevents us from extending ENTRY/END instead of introducing
| > >> another set?
| > >
| > > ENTRY/END alone is not enough if one wants to be able to distinguish
| > > between code (functions) and non-executed data.
| > >
| > >> Let us try to extend what we have and not introduce something new.
| > >
| > > Agreed. I vote to complement the existing ENDPROC annotation with
| > > the proposed PROC annotation. Let's call that an extension, not
| > > something new ;). As it stands it is not impossible to go with
| > > ENTRY/ENDPROC for code and ENTRY/END for data. However, ENTRY
| > > implies alignment and the prefered alignment for code and data
| > > might differ.
| > 
| > If ENTRY will be used for data objects it shouldn't contain any kind of
| > alignment since in general we could have arrays of bytes, words and so
| > on.
| 
| I would suggest using sizeof(long) alignment for data.

Maybe we could use more flexible scheme? Lets imagine we could
need to use not sizeof(long) on x86-64 for example... say in
boot/compressed/head_64.S... say for boot_heap. Should we use
DATAENTRY here? Or it's planned to use DATAENTRY for global defs
only? Alexander, don't get me wrong I'm just starting to confuse
with ENRTY/PROC/DATAENTRY :)

Letme try to classify them a bit (like they would be used in future).
If we have them classified it would be easier to distinguish their
usage and how they should be implemented

- PROC/ENDPROC for "C" callers
	- they are: aligned, .global, .size and .type and @function
- DATA/ENDDATA for data objects
	- they are: aligned as sizeof(long), .global, .size

right?

| 
| Greetings,
|    Alexander
| -- 
|   Alexander van Heukelum
|   heukelum@fastmail.fm

		- Cyrill -

