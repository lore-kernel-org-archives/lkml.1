Return-Path: <linux-kernel-owner+w=401wt.eu-S2993085AbXEBMVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993085AbXEBMVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 08:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993082AbXEBMVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 08:21:35 -0400
Received: from ns1.suse.de ([195.135.220.2]:52850 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993078AbXEBMVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 08:21:34 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Josh Triplett <josh@freedesktop.org>, linux-sparse@vger.kernel.org,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: sparse -Wptr-subtraction-blows: still needed?
References: <4637AC3D.6000008@freedesktop.org>
	<alpine.LFD.0.98.0705011442320.3808@woody.linux-foundation.org>
	<4637D47D.7040203@freedesktop.org>
	<alpine.LFD.0.98.0705011719520.3808@woody.linux-foundation.org>
	<20070502130204.2cc2fd1a@the-village.bc.nu>
From: Andi Kleen <andi@firstfloor.org>
Date: 02 May 2007 15:19:11 +0200
In-Reply-To: <20070502130204.2cc2fd1a@the-village.bc.nu>
Message-ID: <p734pmvxt0w.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> 
> Good compilers even in the 1990's would defer the divide and try and
> propogate it out as a multiply the other side for constants, and they'll
> also use shifts when possible.

gcc has an algorithm that tends to generate a near perfect shift/add etc.
code sequence and also knows the obvious x / y ==> x*1/y

However it doesn't do that with -Os, prefering smaller code on x86
(idiv is fairly small compared to the expanded sequences for non power
of two dividends) and kernels are usually compiled with -Os these
days.

We've had a few cases in the past where this showed up as regression
against older kernels that still used -O2.
 
> Thus they'll turn
> 
> 	(ptr.element - base.element) < NELEM
> 
> into
> 	(ptr.char - base.char) < (constant) [NELEM *sizeof(element) ]
> 
> 
> at least for constant operations. Dunno if gcc is that clever

It is. However a few more complex transformations I would have liked
in the past are missing -- in particular 

x / (cond ? const1 : const2) ==> cond ? (x / const1) : (x / const2)

-Andi
