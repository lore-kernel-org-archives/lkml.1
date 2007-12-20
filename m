Return-Path: <linux-kernel-owner+w=401wt.eu-S1757269AbXLTETH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbXLTETH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 23:19:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbXLTESz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 23:18:55 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:14490 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbXLTESy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 23:18:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=lUKooj+fAr8bAstqsYTOSK1BQxbT3Axb0nW0EUKqKGWHgIjC3wCLqM8h2elx3wpfO/TaxuljrUj3b+b4RlqapIiX0nEGikbsOyBn0wm9DfAWgJGehUCECFn48rnmr/IIe+7gsFkRS7dPtFEAkMDbPcDFyX1le7BXvr9IKr4LJlI=
Message-ID: <cb0375e10712192018l66671b34r1680077765e89fb0@mail.gmail.com>
Date: Wed, 19 Dec 2007 23:18:54 -0500
From: "Andrew Lutomirski" <luto@myrealbox.com>
To: "Theodore Tso" <tytso@mit.edu>, "David Newall" <david@davidnewall.com>,
       "Andy Lutomirski" <luto@myrealbox.com>,
       "John Reiser" <jreiser@bitwagon.com>, "Matt Mackall" <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, security@kernel.org
Subject: Re: /dev/urandom uses uninit bytes, leaks user data
In-Reply-To: <20071218034656.GR7070@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071214201305.GL19691@waste.org>
	 <20071214232322.GE17344@thunk.org> <47632010.6030709@BitWagon.com>
	 <20071215043208.GF17344@thunk.org> <4766A40D.4080804@BitWagon.com>
	 <20071217173623.GC7070@thunk.org> <476719E5.1010505@myrealbox.com>
	 <20071218030533.GN7070@thunk.org> <47673AD8.9010702@davidnewall.com>
	 <20071218034656.GR7070@thunk.org>
X-Google-Sender-Auth: 1bad58c9921ddad0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 17, 2007 10:46 PM, Theodore Tso <tytso@mit.edu> wrote:
> If you have a system with insufficent entropy inputs, you're in
> trouble, of course.  There are "catastrophic reseeds" that attempt to
> mitigrate some of worse attacks, but at the end of the day,
> /dev/random isn't magic.
>

I understand that there's no way that /dev/random can provide good
output if there's insufficient entropy.  But it still shouldn't leak
arbitrary bits of user data that were never meant to be put into the
pool at all.

(My hypothetical attack is a lot hypothetical than I thought at first.
 An attacker does not need to break into the kernel and steal the
state of the pool.  It may be as easy as this to trigger:

Step 1: Boot a system without a usable entropy source.
Step 2: add some (predictable) "entropy" from userspace which isn't a
multiple of 4, so up to three extra bytes get added.
Step 3: Read a few bytes of /dev/random and send them over the network.

An attacker can now try all possibilities of the three extra bytes and
guess them pretty quickly.  No compromise needed.  This is, IMHO, bad.
 (It's one thing for the "random" numbers to be weak.  It's another
thing entirely for them to reveal data that never belonged in the pool
in the first place.)

Actually, perhaps there should be a policy that we try never to reseed
the pool at all until there is enough entropy around to prevent
attacks like these.  (In theory the state of the pool might contain
2^(smallish number) bits of data interesting to the attacker even
without the uninitialized data issue.)  This would make the situation
even worse for low-entropy systems, though.

--Andy
