Return-Path: <linux-kernel-owner+w=401wt.eu-S935911AbXJQQSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935911AbXJQQSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 12:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763729AbXJQQS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 12:18:28 -0400
Received: from mail.gmx.net ([213.165.64.20]:44393 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1763327AbXJQQS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 12:18:27 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX19KZAIYpLBKANcoYT/B9H5AxXiqiG4bRlo7A2eLIG
	g0x193H60XI5oN
Date: Wed, 17 Oct 2007 18:18:21 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix adbhid mismerge
Message-ID: <20071017161821.GB15918@atjola.homenet>
References: <20071017000246.GE8181@ftp.linux.org.uk> <alpine.LFD.0.999.0710161751070.26902@woody.linux-foundation.org> <alpine.LFD.0.999.0710161907020.26902@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.0.999.0710161907020.26902@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.10.16 19:21:53 -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 16 Oct 2007, Linus Torvalds wrote:
> > 
> > I don't think you did anything wrong. You used both --full-history 
> > (implicitly: git-whatchanged) and you made sure to see the diffs for both 
> > sides of any merge (-m), and that means that you should see every single 
> > diff involved.
> 
> Btw, if anybody can come up with a better way to find these kinds of 
> mis-merges, I'd love to hear about it.
> 
[...]
> 
> What I'd actually really like would be something that shows the original 
> conflict, but that's really expensive to compute (it basically involves 
> re-doing the merge from scratch - finding the proper base commit(s) etc). 
> So we never did that.

So here's what I came up with:

git grep -l "int keycode, up_flag" \
	$(git-rev-list HEAD --parents -- drivers/macintosh/adbhid.c | \
		egrep '(.{40} ?){3}' | cut -d' ' -f1) \
	-- drivers/macintosh/adbhid.c | grep -o '^[^:]*'

Which gives: b981d8b3f5e008ff10d993be633ad00564fc22cd

Then:
git checkout b981d8b3f5e008ff10d993be633ad00564fc22cd^1
git merge b981d8b3f5e008ff10d993be633ad00564fc22cd^2

And you got your merge conflict.

The idea is, that the above ugliness searches for the last commit that
produced the bad line. The inner git-rev-list call searches for merge
commits (thanks to Ilari in #git for the egrep trick), then git-grep
looks which of these have the "bad line" and the final grep just filters
the filename out.

If the bash thing spits out more than one commit hash, you probably want
to use the last one... I guess... And if the given result doesn't
produce the request merge conflict, well, I guess you could replace HEAD
in the git-rev-list call with the sha1 you got in the first run, but I'm
not entirely sure about that.

Is that helpful?

Björn
