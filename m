Return-Path: <linux-kernel-owner+w=401wt.eu-S932171AbXGRDJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171AbXGRDJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 23:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbXGRDJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 23:09:29 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:57299 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbXGRDJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 23:09:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAGYhnUarR7O6/2dsb2JhbAA
X-IronPort-AV: i="4.16,548,1175497200"; 
   d="scan'208"; a="167093815:sNHT25215426"
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       chas@cmf.nrl.navy.mil, rolandd@cisco.com, dwmw2@infradead.org,
       gregkh@suse.de
Subject: Re: [git patches 1/2] warnings: attack valid cases spotted by warnings
X-Message-Flag: Warning: May contain useful information
References: <20070717214239.GF28448@devserv.devel.redhat.com>
	<ada8x9epuip.fsf@cisco.com> <469D3E66.3010502@garzik.org>
	<adamyxuo2w6.fsf@cisco.com>
	<alpine.LFD.0.999.0707171954230.27353@woody.linux-foundation.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 17 Jul 2007 20:09:27 -0700
In-Reply-To: <alpine.LFD.0.999.0707171954230.27353@woody.linux-foundation.org> (Linus Torvalds's message of "Tue, 17 Jul 2007 19:56:55 -0700 (PDT)")
Message-ID: <adaejj6o1aw.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Jul 2007 03:09:27.0477 (UTC) FILETIME=[0D05D650:01C7C8E9]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > So setting a variable to something meaningless (guaranteeing that a 
 > > garbage value is used in case of a bug) just to shut up a warning makes 
 > > no sense -- it's no safer than leaving the code as is.  
 > 
 > Wrong.
 > 
 > It's safer for two reasons:
 >  - now everybody will see the *same* behaviour
 >  - the "meaningless value" is guaranteed to not be a security leak
 > 
 > but the whole "shut up bogus warnings" is the best reason.
 > 
 > So it *is* safer than leaving the code as-is.

OK, fair enough.  What I said wasn't quite right, but in my case I
think neither of your reasons really applies, since the uninitialized
variable would be written into some hardware control block, so the
effect would probably still be random even if the value is the same
and the information leak doesn't really matter.

Anyway, I think that in this case it's not too hard to show that the
variable really can't be used uninitialized, so I prefer the smaller
generated code from uninitialized_var() (plus a comment explaining why
that's safe).

 > Of course, usually the best approach is to rewrite the code to be simpler, 
 > so that even gcc sees that something is obviously initialized. Sadly, 
 > people seldom do the right thing, and sometimes gcc just blows incredibly 
 > hard.

In this case the code is basically

	u32 x;

	for (n = 0; cond; ++n) {
		...
		if (!n)
			x = something;
		...
	}

	if (n) {
		...
		use(x);
		...
	}

and gcc still warns...

 - R.
