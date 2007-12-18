Return-Path: <linux-kernel-owner+w=401wt.eu-S1762926AbXLRDrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762926AbXLRDrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 22:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbXLRDrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 22:47:11 -0500
Received: from THUNK.ORG ([69.25.196.29]:45190 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbXLRDrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 22:47:11 -0500
Date: Mon, 17 Dec 2007 22:46:56 -0500
From: Theodore Tso <tytso@mit.edu>
To: David Newall <david@davidnewall.com>
Cc: Andy Lutomirski <luto@myrealbox.com>, John Reiser <jreiser@BitWagon.com>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       security@kernel.org
Subject: Re: /dev/urandom uses uninit bytes, leaks user data
Message-ID: <20071218034656.GR7070@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	David Newall <david@davidnewall.com>,
	Andy Lutomirski <luto@myrealbox.com>,
	John Reiser <jreiser@BitWagon.com>, Matt Mackall <mpm@selenic.com>,
	linux-kernel@vger.kernel.org, security@kernel.org
References: <20071214201305.GL19691@waste.org> <4762EB63.8070100@BitWagon.com> <20071214232322.GE17344@thunk.org> <47632010.6030709@BitWagon.com> <20071215043208.GF17344@thunk.org> <4766A40D.4080804@BitWagon.com> <20071217173623.GC7070@thunk.org> <476719E5.1010505@myrealbox.com> <20071218030533.GN7070@thunk.org> <47673AD8.9010702@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47673AD8.9010702@davidnewall.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 01:43:28PM +1030, David Newall wrote:
> On a server, keyboard and mouse are rarely used.  As you've described it, 
> that leaves only the disk, and during the boot process, disk accesses and 
> timing are somewhat predictable.  Whether this is sufficient to break the 
> RNG is (clearly) a matter of debate.

In normal operaiton, entropy is accumlated on the system, extracted
via /dev/urandom at shutdown, and then loaded back into the system
when it boots up.  So this will help in everything but the freshly
installed system case (and in that case things will get better as the
system has a chance to operate).

If you have a system with insufficent entropy inputs, you're in
trouble, of course.  There are "catastrophic reseeds" that attempt to
mitigrate some of worse attacks, but at the end of the day,
/dev/random isn't magic.

In any case, the problem if you have insufficent entropy is not
esoteric attacks that presume an attacker can break into the system
and read out kernel memory.  The problem will be /dev/random's entropy
output.  And there are techniques that cryptographic applications can
do to help.  For example, if it is about to encrypt data, it can SHA-1
hash data that it is about to be sent out encrypted, and feed the
SHA-1 hash into /dev/random.  This won't increase entropy credit
counter, but if the attacker doesn't have access to the unecrypted
plaintext, mixing in the SHA-1 hash into /dev/random can only help. 

If you have a server, the best thing you can do is use a hardware
random number generator, if it exists.  Fortunately a number of
hardware platforms, such as IBM blades and Thinkpads, come with TPM
modules that include hardware RNG's.  That's ultimately the best way
to solve these issues.

						- Ted
