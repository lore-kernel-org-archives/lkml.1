Return-Path: <linux-kernel-owner+w=401wt.eu-S1757069AbYFSAGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069AbYFSAGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 20:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbYFSAGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 20:06:06 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:45637 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750801AbYFSAGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 20:06:05 -0400
X-Greylist: delayed 1205 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jun 2008 20:06:05 EDT
Message-Id: <1213832759.32537.1259210597@webmail.messagingengine.com>
X-Sasl-Enc: vg6HSDmTplnuyxesb3I3pgqdwm1axmNEj01e3KyRxMBq 1213832759
From: "Robert Mueller" <robm@fastmail.fm>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Bron Gondwana" <brong@fastmail.fm>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Nick Piggin" <npiggin@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Ken Murchison" <murch@andrew.cmu.edu>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1213682410.13174.1258837181@webmail.messagingengine.com>
 <1213682570.13708.1258839317@webmail.messagingengine.com>
 <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org>
 <alpine.LFD.1.10.0806171041560.25099@woody.linux-foundation.org>
 <alpine.LFD.1.10.0806171309130.2981@woody.linux-foundation.org>
 <alpine.LFD.1.10.0806171331460.2908@woody.linux-foundation.org>
 <alpine.LFD.1.10.0806171356320.2908@woody.linux-foundation.org>
 <alpine.LFD.1.10.0806171415060.2907@woody.linux-foundation.org>
 <20080618031406.GA4326@brong.net>
 <alpine.LFD.1.10.0806172057450.2907@woody.linux-foundation.org>
 <20080618051119.GA10754@brong.net>
 <alpine.LFD.1.10.0806180858250.2907@woody.linux-foundation.org>
Subject: Re: Cyrus mmap vs lseek/write usage - (WAS: BUG: mmapfile/writev
 spurious zero bytes (x86_64/not i386, bisected, reproducable))
In-Reply-To: <alpine.LFD.1.10.0806180858250.2907@woody.linux-foundation.org>
Reply-To: robm@fastmail.fm
Date: Thu, 19 Jun 2008 09:45:59 +1000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> It actually does use MAP_SHARED already, but only for reading.
>> Writing is all done with seeks and writes, followed by a map
>> "refresh", which is really just an unmmap/mmap if the file has
>> extended past the "SLOP" (between 8 and 16 k after the end of the
>> file length at last mapping).
>
> So the more traditional way would be to do an all-mmap thing, and
> extend the file with ftruncate(), not write. That's somethign that
> programs like nntpd have been doing for decades, so it's a very
> "traditional" model and thus much more likely to be safe. It also
> avoids all the aliasing issues, if all accesses are done the same way.

As noted above, one thing cyrus does which does seem to be plain "wrong"
is that it mmaps a region greater the file size (rounds to an 8k
boundary, but 8k-16k past the current end of the file) and then assumes
that when it writes to the end of the file (but less than the end of the
mmap region) that there's no need to remmap and that data is immediately
available within the previous mmaped region.

Apparently that works on most OS's (but is what this bug actually
exposed), but according to the mmap docs:

---
If the size of the mapped file changes after the call to mmap() as a
result of some other operation on the mapped file, the effect of
references to portions of the mapped region that correspond to added or
removed portions of the file is unspecified.
---

The way I read that, even if you mmap a file with a size past the end of
the file currently, if you subsequently write to the end of that file,
you shouldn't assume that written data is available in the region you
previously mmaped, which cyrus definitely does do.

Amazingly (apart from HP/UX) no OS actually seems to have a problem with
this since there would be massive cyrus bug reports otherwise.

Rob

----------
robm@fastmail.fm
Sign up at http://fastmail.fm for fast, ad free, IMAP accessible email

