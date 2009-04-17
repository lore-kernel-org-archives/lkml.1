Return-Path: <linux-kernel-owner+w=401wt.eu-S1759346AbZDQAol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346AbZDQAol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759495AbZDQAiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:38:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39094 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760107AbZDQAiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:38:10 -0400
Date: Fri, 17 Apr 2009 01:38:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alessio Igor Bogani <abogani@texware.it>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -tip] remove the BKL: Replace BKL in mount/umount
	syscalls with a mutex
Message-ID: <20090417003805.GI26366@ZenIV.linux.org.uk>
References: <1239892078-6039-1-git-send-email-abogani@texware.it> <20090416160645.GB17804@elte.hu> <20090416235649.GF26366@ZenIV.linux.org.uk> <20090417000142.GF21405@elte.hu> <20090417001345.GH26366@ZenIV.linux.org.uk> <20090417002744.GB29630@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417002744.GB29630@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 02:27:44AM +0200, Ingo Molnar wrote:

> Could you give an example of such a weird interaction?

If I could give you one at the moment, I'd sent patches regardless of BKL
crusades.  I _have_ run into such crap before and it had been just that -
crap.

> I fear, unless i'm misunderstanding your feedback, that you are 
> setting the purist's irrealistically high burden to get rid of the 
> BKL from the VFS here.
> 
> "Arbitrary weird ones" means all BKL using sites in the kernel - all 
> ~800 ones - up to 800x800 == close to a million interactions to 
> check.

Sigh...  How about dumping that lovely strawman?  I've exsoddingplicitly
told you that all such stuff is *within* *individual* *fs* *driver*.

Start with taking these guys down into the superblock methods in question.
Drop that junk on VFS-only side of things completely (mount --move,
mount --bind, etc.).  Then we go looking for data structures that are
	a) internal to fs driver
	b) accessed by methods in question (in that fs driver)
	c) are shared between different filesystems.

Analysis is on per-fs basis.  And getting rid of these turds doesn't have
to happen in one patch.
