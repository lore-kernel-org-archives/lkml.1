Return-Path: <linux-kernel-owner+w=401wt.eu-S1761601AbYD2WTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761601AbYD2WTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755781AbYD2WTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:19:09 -0400
Received: from 1wt.eu ([62.212.114.60]:3569 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbYD2WTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:19:07 -0400
Date: Wed, 30 Apr 2008 00:12:30 +0200
From: Willy Tarreau <w@1wt.eu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Helge Hafting <helge.hafting@aitel.hist.no>, Adrian Bunk <bunk@kernel.org>,
       "H. Peter Anvin" <hpa@kernel.org>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
Message-ID: <20080429221230.GA17360@1wt.eu>
References: <20080428230524.GK8474@1wt.eu> <48167A07.4000305@kernel.org> <20080429050605.GA27875@1wt.eu> <20080429072911.GA28059@cs181133002.pp.htv.fi> <20080429081423.GD30507@1wt.eu> <4816E4FD.5060605@aitel.hist.no> <20080429100934.GB1473@1wt.eu> <20080429111014.5a065b88@core> <20080429103335.GD1473@1wt.eu> <20080429113410.0971d071@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080429113410.0971d071@core>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Alan,

On Tue, Apr 29, 2008 at 11:34:10AM +0100, Alan Cox wrote:
> > behaviour). The shell no, it was the one present on my machine and
> > has never been compiled with UTF-8 support, and should not have to.
> 
> Bizarre, so you are using deliberately misconfigured ancient userspace to
> complain about utf-8

No I'm not using anything deliberately misconfigured. I'm trying to explain
that on the opposite, any tool which has not been explicitly adapted to those
new usages is impacted.

> > In my opinion, the problem is that when I press "é", the system sends
> > two chars to the bash, which itself sends two chars to the terminal,
> > which only displays one and moves the cursor one step ahead. Then,
> > pressing backspace once sends one backspace all along, resulting in
> > the terminal blanking one displayed char, but the shell not being
> 
> The shell puts the terminal in character by character mode and readline
> does this. If you have your shell/readline deliberately set up not to be
> doing unicode locales then it will do the wrong thing.

Please, I'm not "deliberately" setting my tools *not* to support unicode.
I have tools which have worked for years and which are now asked to behave
strangely.

> > So in my opinion, when we send one backspace to the terminal to
> > remove one character, since there are two in the buffer, we
> > should not get back one full char. Ideally, the console driver
> > should send as many backspaces as needed to fix the multiple
> 
> The console driver isn't involved - readline took over for the shell, and
> readline most definitely supports this in a utf8 locale.

OK I could reproduce the case without ever involving either a shell or
readline or anything. Using "cat" as the init program exhibited the
anomaly, though it was not much easy to analyze. Then I switched to
"init=od -An -tx1 -".

1) if I enter "A" then press backspace, I get nothing. Pressing enter 16
   times flushes the line buffer and "od" prints 16 times "0a", indicating
   nothing was remaining in the buffer.

2) if I enter Ctrl-V Ctrl-A, my display prints "^A", and when I press
   backspace, I correctly get the cursor back two chars. Once again,
   flushing the buffer with enter shows it was empty.

3) if I enter Alt-196, I get a "Ä". Flushing the buffer shows that od
   got two bytes: c3 84.

4) now if I enter Alt-196 and press backspace, my "Ä" is removed by the
   backspace, but only the second byte is flushed from the line buffer.
   Then, if I press enter 15 times, I get a line with c3 0a 0a 0a ...
   And there is no user-land involved here.

I'm really hoping you better understand the problem now. Pressing backspace
to fix input does not correct the input with multi-byte chars, it leaves
incomplete start sequences. If I press Alt-1111111, then backspace, I get
f4 8f 91 0a 0a 0a 0a because it is f4 8f 91 87 minus one byte.

Of course, pressing Backspace multiple times removes them all, but it also
removes previous characters on the display.

Another experience :

I press 01234, then Alt-255, Backspace, then 56789. On the display, I have
0123456789. od gets 30 31 32 33 34 c3 35 36 37 38 39.

Now if I want to correctly fix the input, I have to press backspace twice,
but then I have to make the '4' disappear from my display, while knowing it
still remains in the buffer. And indeed, my display shows "012356789" but
od sees 30 31 32 33 34 35 36 37 38 39.

And this is without anything on the user-land (except 'od'), just plain
stupid text console booted with "init=..."

So obviously there is something broken as the data fed into stdin does not
match what is displayed for multi-byte characters.

Hoping this clarifies the situation,
Willy

