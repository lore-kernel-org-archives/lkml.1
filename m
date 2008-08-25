Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbYHYUcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbYHYUcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 16:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbYHYUbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 16:31:53 -0400
Received: from blaine.gmane.org ([80.91.229.8]:52118 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbYHYUbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 16:31:51 -0400
Message-ID: <48B3166D.3090300@yahoo.com>
Date: Mon, 25 Aug 2008 21:30:37 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 1.5.0.7 (Macintosh/20060909)
MIME-Version: 1.0
To: Alan Cox 
	<public-alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@hugh.gmane.org>
CC: public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org,
       public-kernel-testers-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org
Subject: Re: Reproducible rRootage segfault with 2.6.25 and above (solved)
References: <g8sncp$8us$1@ger.gmane.org> <20080825131620.1d6aa87f@lxorguk.ukuu.org.uk>
In-Reply-To: <20080825131620.1d6aa87f@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Alan Cox wrote:
> For the kernel bisect if you get stuck at a point it fails remember that
> point and then lie either yes/no to it working and carry on. If need be
> you can go back the other way.

I tried this quite a few times (you can always use replay and edit out
the lie) before posting (and using gitk to pick commits to) but it seems
like huge swathes of what I was interested in were inside this USB
issue. Eventually I broke down and used a loan laptop that didn't need
to boot from USB. I narrowed the issue down to 10 or so patches (from
8a423ff0c4a0472607bbed6790fdaeec54af2ebb to
0249c9c1e7505c2b020bcc6deaf1e0415de9943e which covers patches that
randomize brk and change vDSO) but after further incorrectly bisecting
to a patch it looks like the segfault was totally legit...

> Another completely off the wall guess would be that your client code is
> causing gcc to generate something where it is using data which has ended
> up below the stack pointer and the timings have changed. Either through
> gcc bug or passing around the address of an object that is out of
> context. At that point a signal will rewrite the data in fun ways
> producing results like you describe.

After reading this I went back and stuffed a bunch of asserts into the
rRootage code to see what was going on and found what looks like a bug
rRootage. I guess valgrind can't do array bounds checking - in fact this
is what I get for not reading the FAQ -
http://valgrind.org/docs/manual/faq.html#faq.overruns . A workaround
seems to be to do capping on the value used to index the array -
https://bugs.launchpad.net/ubuntu/+source/rrootage/+bug/261189/comments/4
  . I even just tried using mudflap but that brought up so many spurious
warnings (supposedly it doesn't currently do well with C++) it wasn't
helpful.


-- 
Sitsofe | http://sucs.org/~sits/



