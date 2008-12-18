Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752547AbYLRIzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbYLRIzm (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 03:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbYLRIz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 03:55:26 -0500
Received: from science.horizon.com ([192.35.100.1]:19150 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751269AbYLRIzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 03:55:25 -0500
Message-ID: <20081218085524.12622.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
Date: Thu, 18 Dec 2008 03:55:24 -0500
To: srostedt@redhat.com, peterz@infradead.org, linux@horizon.com
Cc: tj@kernel.org, linux@horizon.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org
Subject: Re: [RFC] globmatch() helper function
References: <20081217104247.28440.qmail@science.horizon.com>
 <87hc530w39.fsf@basil.nowhere.org> <1229526942.9487.75.camel@twins>
 <1229528856.30177.4.camel@localhost.localdomain>
 <20081218080027.27011.qmail@science.horizon.com>
In-Reply-To: <20081218080027.27011.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eureka!

Never mind all of this angst; I've figured out a non-recursive way
to do it.  Thanks for pushing me to think a bit harder and find it.
(I was actually looking for an example of the exponential pathology I
kept referring to when it dawned on me that it's actually impossible
without the additional expressive power of regexps.)

Somewhat abusing TeX's line-breaking terminology, consider a shell glob to
consist of a series of "boxes" and "glue"  A box is a run of character
classes (of which literal characters and ? are degenerate cases).  The
point is, a box has a well-defined width, the number of characters in the
string that it must match.

A *, on the other hand, is infinitely elastic "glue" between boxes that
matches an unknown number of characters.

So consider a pattern of the form box1*box2*box3*...
Assuming box1 has matched, we search forward, trying various widths of
the glue *, to find a point where box2 matches.  Then we start searching
for the width of the second *.  But!  If we can't match the tail of the
pattern box3*... at any position to the right of the end of box2, there
is no point trying to move box2 forward and search again.  Any solution
where box2*box3*... would match starting k characters later in the string
would also be a match with box2 (only) shifted k characters left, i.e.
in its original position.

So we can match boxes greedily: once we've found the leftmost place
where one matches (that is still to the right of all previous boxes),
we never need to try any other positions.  Moving a box to the right
can never produce a match which doesn't exist in its previous position.

I'll rewrite it to be non-recusrive and quadratic in the worst case.


Thanks; I feel stupid for not maving looked this up, but smart for having
thought of it myself.

(For a discussion of how to get exponential backtracking in a regular
expression, see http://swtch.com/~rsc/regexp/regexp1.html)
