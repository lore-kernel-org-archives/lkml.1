Return-Path: <linux-kernel-owner+w=401wt.eu-S936180AbXJQBVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936180AbXJQBVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 21:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934505AbXJQBVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 21:21:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41721 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934487AbXJQBVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 21:21:45 -0400
Date: Tue, 16 Oct 2007 18:21:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ftp.linux.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix adbhid mismerge
In-Reply-To: <20071017000246.GE8181@ftp.linux.org.uk>
Message-ID: <alpine.LFD.0.999.0710161751070.26902@woody.linux-foundation.org>
References: <20071017000246.GE8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Oct 2007, Al Viro wrote:
>
> 	Something really odd has happened: the last couple of changesets
> have
> -       int up_flag;
> +       int keycode, up_flag;
> and
> -       int up_flag;
> +       int up_flag, key;
> in another, both in adb_input_keycode().  Even with -m passed to
> git-whatchanged there's no sign of anything in that area.

I don't think you did anything wrong. You used both --full-history 
(implicitly: git-whatchanged) and you made sure to see the diffs for both 
sides of any merge (-m), and that means that you should see every single 
diff involved.

Looking into it, the "key" variable was declared in the commit that 
introduced the new line

	int up_flag, key;
	..
	key = adbhid[id]->keycode[keycode];

which is commit 555ddbb4e2191c8823df2d61525218ac39481385. But then that 
declaration of "int key" goes away at some later time.

And doing a

	git whatchanged -p -m 555ddbb4e2191c8823df2d61525218ac39481385.. drivers/macintosh/adbhid.c

does actually show the culprit. It's just that the "-p -m" format is so 
damn unreadable that it's almost impossible to see.

Anyway, it's b981d8b3f5e008ff10d993be633ad00564fc22cd, which had a 
conflict in that file, and Dmitry apparently mis-merged it and edited the 
result down so that it didn't have 'key' declared any more.

So the way I found it was to just search for the line in the diffs that 
makes that thing go away, ie just look for the line in the diffs that says

	-	int up_flag, key;

and then you need to look at which of those are totally bogus and are just 
because it shows the diff against one of the earlier trees that also don't 
have that "key = adbhid[...]" line!

(And that is actually *much* less obvious than it should be, since a lot 
of the case of those lines going away is becuase I had merged Dmitry's 
tree in the first place)

You can make git help you narrow it down a bit more by using -S, ie some 
horrible command line from hell like this:

	git whatchanged -S'int up_flag, key;' -m -p 		\
		555ddbb4e2191c8823df2d61525218ac39481385..	\
		drivers/macintosh/adbhid.c

will actually show only those commits that add/remove a line like the one 
you are wondering where it went. That can cut down on the noise a bit, but 
you'll get all the same false alarms, so no, it's probably not worth it.

In general, I'm afraid that merge errors are simply not very easy to find. 
The problem in this case is in that b981d8b3f5 merge, but if you actually 
then do a "git show b981d8b3f5" you won't even see the problem spot in the 
default "--cc" format output, because Dmitry had resolved that problmatic 
place to be the same as one of the parent branches, and that makes git not 
show the diff for it (since it's "uninteresting")

			Linus
