Return-Path: <linux-kernel-owner+w=401wt.eu-S1761364AbYCGCui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761364AbYCGCui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 21:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbYCGCu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 21:50:28 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:57529 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbYCGCu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 21:50:27 -0500
X-Greylist: delayed 3512 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Mar 2008 21:50:27 EST
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [PATCH] locomo.c: convert strncpy(x, y, sizeof(x)) to strlcpy
Date: Fri, 7 Mar 2008 01:51:54 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <fqq73q$21t$1@taverner.cs.berkeley.edu>
References: <47CFECCB.7050909@tiscali.nl> <47D065DB.7070708@zytor.com> <47D07FDC.2010701@tiscali.nl>
Reply-To: daw-usenet@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1204854714 2109 128.32.168.222 (7 Mar 2008 01:51:54 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Fri, 7 Mar 2008 01:51:54 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin  wrote:
>As I understand it, please correct me if I'm wrong:
>
>Of the three variants: strcpy, strncpy and strlcpy.
>- strcpy does not append \0 (unless the source string already contained it)

No, that's not correct.  If the source string has no \0, then
strcpy keeps reading forever and things go horribly awry.

>In the original code strncpy was used and the size parameter was equal
>to the source string size:
>
>strncpy(dev->dev.bus_id, info->name, sizeof(dev->dev.bus_id));
>
>Since this the size was equal there was no \0 termination. To \0
>terminate using strncpy we could write:
>
>strncpy(dev->dev.bus_id, info->name, sizeof(dev->dev.bus_id) - 1);
>dev->dev.bus_id[sizeof(dev->dev.bus_id) - 1] = '\0';
>
>or using strlcpy, which does the same thing:
>
>strlcpy(dev->dev.bus_id, info->name, sizeof(dev->dev.bus_id));

No, strlcpy() does not do the same thing.  As several people have pointed
out to you, strlcpy() does not fill the rest of the buffer with \0's.
This can create an information leak in some cases, which can create a
security hole.  The difference is important in some cases.

Second, you seem to implicitly assume that it's a bug to leave
dev->dev.bus_id without any \0 termination.  You'd have to look at the API
to determine whether that assumption is accurate.  And then you'd have to
think carefully about what is the proper behavior if info->name is too
long to fit into the buffer.  Is truncating the string the appropriate
behavior?  In some cases prematurely truncating a string is bad news and
can create a security bug, and the proper thing to do in some cases may
be to return an error rather than returning a truncated string.

Rant: Blindly search-and-replacing strncpy() with strlcpy() is not safe,
in general.  You have to actually understand what the code is doing and
what it should be doing.

I'm not claiming that your patch is correct, nor that it is incorrect.
Instead, I'm suggesting that you probably need to do some analysis to
understand the specific requirements and context in each of these cases,
rather than doing a mechanically search-and-replace.
