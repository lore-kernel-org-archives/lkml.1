Return-Path: <linux-kernel-owner+w=401wt.eu-S1755773AbXLUQKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773AbXLUQKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 11:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbXLUQKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 11:10:38 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:21944 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbXLUQKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 11:10:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=TK5KYqaJzY9nLmNWgx6vUNMNvz//TBrL3/v1mA87QBtqYkgt98q0vktqk8f+90p+tK5VxVBK7vQcAUq+gI8l85gTcXME2oj6IIuw8BVfj+ZreVhLDjS6KUYItk9YYC5CGrpazoUePJjIpK5H4+6tv3RSPifrP9nTj0s8SfF1n9I=
Message-ID: <cb0375e10712210810p36fc9995s345d23b7dff5a3b3@mail.gmail.com>
Date: Fri, 21 Dec 2007 11:10:36 -0500
From: "Andrew Lutomirski" <luto@myrealbox.com>
To: "Phillip Susi" <psusi@cfl.rr.com>
Subject: Re: /dev/urandom uses uninit bytes, leaks user data
Cc: "Theodore Tso" <tytso@mit.edu>, "David Newall" <david@davidnewall.com>,
       "John Reiser" <jreiser@bitwagon.com>, "Matt Mackall" <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, security@kernel.org
In-Reply-To: <476ACDBE.2070600@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071214201305.GL19691@waste.org>
	 <20071214232322.GE17344@thunk.org> <47632010.6030709@BitWagon.com>
	 <20071215043208.GF17344@thunk.org> <4766A40D.4080804@BitWagon.com>
	 <20071217173623.GC7070@thunk.org> <476719E5.1010505@myrealbox.com>
	 <cb0375e10712192018l66671b34r1680077765e89fb0@mail.gmail.com>
	 <476ACDBE.2070600@cfl.rr.com>
X-Google-Sender-Auth: 55b040aa56907753
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 20, 2007 3:17 PM, Phillip Susi <psusi@cfl.rr.com> wrote:
> Andrew Lutomirski wrote:
> > I understand that there's no way that /dev/random can provide good
> > output if there's insufficient entropy.  But it still shouldn't leak
> > arbitrary bits of user data that were never meant to be put into the
> > pool at all.
>
> It doesn't leak it though, it consumes it, and it then vanishes into the
> entropy pool, never to be seen again.

No, it's there, and if there's little enough entropy around it can be
recovered by brute force.

>
> > Step 1: Boot a system without a usable entropy source.
> > Step 2: add some (predictable) "entropy" from userspace which isn't a
> > multiple of 4, so up to three extra bytes get added.
> > Step 3: Read a few bytes of /dev/random and send them over the network.
>
> Only root can do 1 and 2, at which point, it's already game over.

Again, no.  Root could do this accidentally.  Step 1 happens all the
time (see the comments on non-unique UUIDs).  Step 2 just requires a
program to put data which it things is OK to go into the pool next to
data that shouldn't be there in memory.  I'm OK with the entropy pool
being insecure in cases where it cannot possibly be secure.  But it
should not leak information that never belonged in it in the first
place.

(Remember, the entire justification for Linux's model of the entropy
pool seems to be that it should be as secure as possible even against
computationally unbounded attackers or attackers who can find SHA
preimages.  A brute force attack that works sometimes and only
requires 2^24 brute force iterations certainly fits into this threat
model.)

--Andy
