Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbXLREYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbXLREYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 23:24:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750814AbXLREXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 23:23:52 -0500
Received: from THUNK.ORG ([69.25.196.29]:39124 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbXLREXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 23:23:51 -0500
Date: Mon, 17 Dec 2007 23:23:37 -0500
From: Theodore Tso <tytso@mit.edu>
To: David Newall <david@davidnewall.com>
Cc: Andy Lutomirski <luto@myrealbox.com>, John Reiser <jreiser@BitWagon.com>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       security@kernel.org
Subject: Re: /dev/urandom uses uninit bytes, leaks user data
Message-ID: <20071218042337.GT7070@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	David Newall <david@davidnewall.com>,
	Andy Lutomirski <luto@myrealbox.com>,
	John Reiser <jreiser@BitWagon.com>, Matt Mackall <mpm@selenic.com>,
	linux-kernel@vger.kernel.org, security@kernel.org
References: <20071214232322.GE17344@thunk.org> <47632010.6030709@BitWagon.com> <20071215043208.GF17344@thunk.org> <4766A40D.4080804@BitWagon.com> <20071217173623.GC7070@thunk.org> <476719E5.1010505@myrealbox.com> <20071218030533.GN7070@thunk.org> <47673AD8.9010702@davidnewall.com> <20071218034656.GR7070@thunk.org> <476747DC.4040309@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476747DC.4040309@davidnewall.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 02:39:00PM +1030, David Newall wrote:
>
> Thus, the entropy saved at shutdown can be known at boot-time.  (You can 
> examine the saved entropy on disk.)
>

If you can examine the saved entropy on disk, you can also introduce a
trojan horse kernel that logs all keystrokes and all generated entropy
to the FBI carnivore server --- you can replace the gpg binary with
one which ships copies of the session keys to the CIA --- and you can
replace the freeswan server with one which generates emphermal keys by
encrypting the current timestamp with a key known only by the NSA.  So
if the attacker has access to your disk between shutdown and boot up,
you are *done*.   /dev/random is the least of your worries.

Really, why is it that people are so enamored about proposing these
totally bogus scenarios?  Yes, if you have direct physical access to
your machine, you can compromise it.  But there are far easier ways
that such a vulnerability can be exploited, rather than making it easy
to carry out an cryptoanalytic attack on /dev/random.

(And yes, after using the saved state to load the entropy at
boot-time, the saved state file is overwritten, and if you're
paranoid, you can scrub the disk after it is read and mixed into the
entropy pool.  And yes, the saved state is *not* the entropy pool used
during the previous boot, but entropy extracted using SHA-1 based
CRNG.)

>> If you have a server, the best thing you can do is use a hardware
>> random number generator, if it exists.  Fortunately a number of
>> hardware platforms, such as IBM blades and Thinkpads, come with TPM
>> modules that include hardware RNG's.  That's ultimately the best way
>> to solve these issues.
>
> Just how random are they?  Do they turn out to be quite predictable if 
> you're IBM?

They use a noise diode, so they are as good as any other hardware
random number generator.  Of course, you ultimately have to trust the
supplier of your hardware not to do something screwy, and Thinkpads
are now made by Lenovo, which has caused some US Government types to
get paranoid --- but that's why the best way to do things is to get
entropy from as many places as possible, and mix it all into
/dev/random.  If any one of them is unknown to the attacker, he's stuck.  

And if you are sufficiently paranoid, you obviously can't use
commodity hardware, and how do you know that some time along time ago,
someone snuck in a evil secret code into the C compiler that was
designed to survive a bootstrap process[1]?  And how do you know that
your keyboard controller hasn't been gimmicked to record your key
strokes and then send them out by adding jitter that can be read by an
attacker looking at the timing of your ssh packets[2]?

But seriously, if you are that paranoid, better build your hardware
from scratch, and then hand assemble your compiler, and then do a
line-by-line audit of all of your source code.  It's going to be the
only way to be sure....

						- Ted

[1] Ken Thompson, Reflections on Trusting Trust.
	http://cm.bell-labs.com/who/ken/trust.html

[2] Gaurav Shah, Andres Molina and Matt Blaze, Keyboards and Covert Channels.
	http://www.usenix.org/events/sec06/tech/shah/shah_html/index.html

