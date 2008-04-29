Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbYD2Kew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbYD2Kew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 06:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbYD2Kea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 06:34:30 -0400
Received: from 1wt.eu ([62.212.114.60]:3527 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679AbYD2Ke3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 06:34:29 -0400
Date: Tue, 29 Apr 2008 12:33:36 +0200
From: Willy Tarreau <w@1wt.eu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Helge Hafting <helge.hafting@aitel.hist.no>, Adrian Bunk <bunk@kernel.org>,
       "H. Peter Anvin" <hpa@kernel.org>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
Message-ID: <20080429103335.GD1473@1wt.eu>
References: <20080428154023.GU2813@cs181133002.pp.htv.fi> <20080428230524.GK8474@1wt.eu> <48167A07.4000305@kernel.org> <20080429050605.GA27875@1wt.eu> <20080429072911.GA28059@cs181133002.pp.htv.fi> <20080429081423.GD30507@1wt.eu> <4816E4FD.5060605@aitel.hist.no> <20080429100934.GB1473@1wt.eu> <20080429111014.5a065b88@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080429111014.5a065b88@core>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 11:10:14AM +0100, Alan Cox wrote:
> > Well, booting 2.6.25 with "init=/bin/bash" results in backspace
> > eating the prompt after pressing accentuated letters. Even the
> 
> Did you put the bash shell and the console into unicode mode ?

The console yes (by default until I disabled it to restore correct
behaviour). The shell no, it was the one present on my machine and
has never been compiled with UTF-8 support, and should not have to.

If we say that starting with 2.6.24, we're explicitly breaking
compatiblity with old userland, fine. But that was not explicitly
stated.

In my opinion, the problem is that when I press "é", the system sends
two chars to the bash, which itself sends two chars to the terminal,
which only displays one and moves the cursor one step ahead. Then,
pressing backspace once sends one backspace all along, resulting in
the terminal blanking one displayed char, but the shell not being
aware that only half of it was removed. But if you look at how
control chars are handled, if you display ^H then press backspace,
you remove all of it. It's the terminal which adjusts the position
depending on the character length.

So in my opinion, when we send one backspace to the terminal to
remove one character, since there are two in the buffer, we
should not get back one full char. Ideally, the console driver
should send as many backspaces as needed to fix the multiple
characters that were emitted. It's not logical at all that if
we send 3 chars to a process with one key, sending a cancellation
of those chars only sends one backspace.

You see, that's really what I hate with this encoding. Every
stage relies on the next one to do the fixup. And of course, a
lot of combinations fail.

> > Funny that you mention Windows. Windows has been using 16-bit unicode
> > for a long time without problems. It's a clean encoding. Like it or not.
> 
> I would describe the UCS-2 situation as a disaster area - embedded nuls
> causing breakage, inability to represent the full unicode space and
> awkward programming interfaces.

But at least, there is no feeling of having it working. You immediately
see if your tools are compliant or not.

> > You know why we got this encoding ? Simply because it was designed by
> > english speakers who did not want to be impacted at all by the transition.
> 
> Actually it was primarily designed to make moving encoding painless so
> that ascii still worked and C properties like \0 plus traditional
> Unixisms like "/" just worked.

I cannot imagine how one can believe that something which transcodes one
char as a series of 1-to-4 chars will be a painless move. A lot of code
is totally broken and was not before the move.

> > BTW, do you have an UTF-8 patch for the vt320 and vt510 I use as an
> > always-on console on my servers ? Clearly, the system does not have to
> 
> screen supports the needed transliteration for you.

That's a useful information, thanks. I was not aware of this.

> Alan

Willy

