Return-Path: <linux-kernel-owner+w=401wt.eu-S1756346AbXLURDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346AbXLURDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 12:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbXLURDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 12:03:13 -0500
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:35342 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbXLURDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 12:03:12 -0500
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Dec 2007 12:03:12 EST
From: Junio C Hamano <gitster@pobox.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Git Mailing List <git@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.24-rc6
References: <alpine.LFD.0.9999.0712201731010.21557@woody.linux-foundation.org>
	<20071221024805.GB8535@fattire.cabal.ca>
	<20071221030152.GC8535@fattire.cabal.ca>
	<alpine.LFD.0.9999.0712201937470.21557@woody.linux-foundation.org>
	<alpine.LFD.0.9999.0712202009290.21557@woody.linux-foundation.org>
	<alpine.LFD.0.9999.0712202054350.21557@woody.linux-foundation.org>
Date: Fri, 21 Dec 2007 08:56:53 -0800
In-Reply-To: <alpine.LFD.0.9999.0712202054350.21557@woody.linux-foundation.org>
	(Linus Torvalds's message of "Thu, 20 Dec 2007 20:58:42 -0800 (PST)")
Message-ID: <7vmys49eay.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> Actually, the code to finding one '\n' is still needed to avoid the 
> (pathological) case of getting a "\No newline", so scrap that one which 
> was too aggressive, and use this (simpler) one instead.
>
> Not that it matters in real life, since nobody uses -U0, and "git blame" 
> won't care. But let's get it right anyway ;)

Actually "blame won't care" is a bit too strong.  It's only we
(you) made it not to care.  It is a different story if the
change to make it not to care was sensible.

The diff text "git blame" will see is affected with the tail
trimming optimization exactly the same way as the optimization
triggered this thread.  With the common tails trimmed, the hunks
match differently from the way they match without trimming (the
gcc changelog testcase has differences between the unoptimized
blame and the tail-trimming one --- your original to put this
logic only in blame and my rewrite to move it in xdiff-interface
produce the same result that is different from the unoptimized
version, although both are 4x faster than the original).

When there are multiple possible matches, any match among them
is a correct match, and a match with a line in a blob is a match
to the blob no matter what line the match is anyway.  The usual
workflow of checking blame to find the commit that introduced
the change and then going to "git show" to view the bigger
picture won't get affected.  But the blamed line numbers will be
different from the unoptimized blame, and it may not match the
expectation of human readers.  It won't match "git show" output
of the blamed commit.

> This whole function has had more bugs than it has lines.

I have to agree.  It started as a brilliant idea but then it was
enhanced (in an attempt to support context) and executed not so
brilliantly.
