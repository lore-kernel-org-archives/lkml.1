Return-Path: <linux-kernel-owner+w=401wt.eu-S1763431AbXLRDF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763431AbXLRDF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 22:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbXLRDFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 22:05:50 -0500
Received: from THUNK.ORG ([69.25.196.29]:36867 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbXLRDFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 22:05:48 -0500
Date: Mon, 17 Dec 2007 22:05:33 -0500
From: Theodore Tso <tytso@mit.edu>
To: Andy Lutomirski <luto@myrealbox.com>
Cc: John Reiser <jreiser@BitWagon.com>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, security@kernel.org
Subject: Re: /dev/urandom uses uninit bytes, leaks user data
Message-ID: <20071218030533.GN7070@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andy Lutomirski <luto@myrealbox.com>,
	John Reiser <jreiser@BitWagon.com>, Matt Mackall <mpm@selenic.com>,
	linux-kernel@vger.kernel.org, security@kernel.org
References: <4762DAB1.1020807@BitWagon.com> <20071214201305.GL19691@waste.org> <4762EB63.8070100@BitWagon.com> <20071214232322.GE17344@thunk.org> <47632010.6030709@BitWagon.com> <20071215043208.GF17344@thunk.org> <4766A40D.4080804@BitWagon.com> <20071217173623.GC7070@thunk.org> <476719E5.1010505@myrealbox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476719E5.1010505@myrealbox.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2007 at 07:52:53PM -0500, Andy Lutomirski wrote:
> It runs on a freshly booted machine (no 
> DSA involved, so we're not automatically hosed), so an attacker knows the 
> initial pool state.  

Not just a freshly booted system.  The system has to be a freshly
booted, AND freshly installed system.  Normally you mix in a random
seed at boot time.  And during the boot sequence, the block I/O will
be mixing randomness into the entropy pool, and as the user logs in,
the keyboard and mouse will be mixing more entropy into the pool.  So
you'll have to assume that all entropy inputs have somehow been
disabled as well. 

BUT --- if the pool state is totally known, you're really, REALLY,
REALLY hosed, since normally /dev/random might get used to initialize
a CRNG to *generate* the ephmeral key.  So the danger is not *3*
*bytes* of the empheral key accidentally getting mixed into the
entropy pool, followed by an attacker managing to crack the system so
bad that he or she has read access into kernel memory (without
managing to mix more entropy into the pool), and then doing
sophisticated cryptoanalytic attacks with an O(2**24) order time, to
try to leak the *3* *bytes* of emphemeral key.  No, the problem is
that the attacker, with access to the known initial state of the pool,
will be able to find out *THE* *ENTIRE* *EMPHERAL* *KEY*, since it was
probably generated via /dev/random --- and without needing to break
into the system with sufficient privs to be able to read kernel
memory.

So it is your argument which is absurd.  If you're going to assume a
completely known pool state, and then assume some program is using
/dev/random, the danger is not in change that some previous kernel
stack state might contain something secret that could theoretically be
revealed after an attacker manages to break into machine as root.  No,
the real danger is in what this presumably cryptographically sensitive
program did with the predictable data from /dev/random.

So the real answer is that there needs to be sufficient randomness
mixed into /dev/random.  For a typical Linux system, it's there.
There are some potential configuration (say a pure diskless system
with NFS remote filesystems and no keyboard or mouse) being used in
some kind of security-sensitive system.  Now, someone who wanted to
say, run a remote certificate signing server or IPSEC key management
system on such a system would arguably be performing security
malpractice, and the lack of entropy for /dev/random is probably the
least of such a system's security problems.  

But in any case, instead of trying to worry about these sorts of
hypothetical worries, the much better use of time and energy is the
userspace daemon that can sample entropy from a sound device, or some
other hardware entropy available to the system.  The real issue is
being able to make sure the pool is *not* knowable to an attacker.

      	      	   	    	    - Ted
