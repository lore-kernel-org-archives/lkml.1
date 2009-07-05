Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbZGETQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbZGETQJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 15:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbZGETP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 15:15:56 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:43160 "EHLO
	QMTA01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752554AbZGETP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 15:15:56 -0400
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Jul 2009 15:15:56 EDT
<To: Theodore Tso <tytso@mit.edu>
Cc: adilger@sun.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ext4 lockdep report re possible reclaim deadlock on jbd2_handle
X-Message-Flag: Warning: May contain useful information
X-Priority: 1
X-MSMail-Priority: High
References: <87prcgp19p.fsf@shaolin.home.digitalvampire.org>
	<20090705124333.GA6757@mit.edu>
From: Roland Dreier <roland@digitalvampire.org>
Date: Sun, 05 Jul 2009 12:10:00 -0700
In-Reply-To: <20090705124333.GA6757@mit.edu> (Theodore Tso's message of "Sun, 5 Jul 2009 08:43:33 -0400")
Message-ID: <87ocrzndyv.fsf@shaolin.home.digitalvampire.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > What seems to be happening here is the ecryptfs is holding the file
 > open, because of the upper dentry reference.  So that's not a normal
 > thing, and maybe that's why most people haven't noticed the problem;
 > they're not doing enough with ecryptfs to trigger things.

Makes sense -- yes, I should have mentioned that I am using the Ubuntu
"$HOME on ecryptfs" feature; and also I had to fix 3 lockdep warnings
with ecryptfs before I hit this one.  Still haven't caught the issue
with my own module code that I'm actually trying to debug :)

 > How easily can you reproduce the lockdep warning?  Does this patch
 > (not tested; sorry, am in the Berkshires for the July 4th holiday)
 > make it go away?

It's not very reproducible, I don't think; although I've just been
running with lockdep for about a week or so, and as I said I had to
work through 3 ecryptfs false positives before I got to this.  I think
I triggered this while building a new kernel, and I haven't done that
since, so it may be reproducible, but I'm not sure.

In any case, I'd be surprised if:

-	page = grab_cache_page(mapping, from >> PAGE_CACHE_SHIFT);
+	page = find_or_create_page(mapping, from >> PAGE_CACHE_SHIFT,
+				   mapping_gfp_mask(mapping) & ~__GFP_FS);

doesn't get rid of the warning, and it looks like a good fix, although
I wonder if for a real upstream patch we wouldn't want to add a new
grab_cache_page()-like wrapper that does the "& ~__GFP_FS" --
grab_cache_page_nowait() isn't quite what's wanted here I don't think,
but something like that.

Anyway, I'll add this patch to my kernel and let you know if anything
ext4-related pops up.

Thanks,
  Roland
-- 
Roland Dreier  <roland@digitalvampire.org>  GPG Key: 1024D/E0EEFAC0
Fingerprint:     A89F B5E9 C185 F34D BD50  4009 37E2 25CC E0EE FAC0

 Sending >500KB attachments is forbidden by the Geneva Convention.
        Your country may be at risk if you fail to comply.
