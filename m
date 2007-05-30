Return-Path: <linux-kernel-owner+w=401wt.eu-S1752337AbXE3FyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbXE3FyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 01:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750950AbXE3FyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 01:54:08 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:21769 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbXE3FyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 01:54:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=CjPcDtr79Et5hDt7/4C8gu0VkZixsaejzMXXdDsecGE47kbyZCbI4vYUeQzhomKJBwchIaMIVIOpeHtGj+suImNVEEIuJ14Dr9JD3ldcqHYYF/9Tytpw/mbZk5NOOolbzVkdwnvTL+WcIhXRSSEi8kXaiUxNWdn+c96DvUjkvv0=
Message-ID: <84144f020705292254o319f6619m787bf29491c92509@mail.gmail.com>
Date: Wed, 30 May 2007 08:54:04 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Tero Roponen" <teanropo@jyu.fi>
Subject: Re: tty-related oops in latest kernel(s)?
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Andy Whitcroft" <apw@shadowen.org>
In-Reply-To: <Pine.LNX.4.64.0705300654493.5241@jalava.cc.jyu.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705271200360.4955@jalava.cc.jyu.fi>
	 <84144f020705280022lf3902caj1def02ed56e0bff@mail.gmail.com>
	 <84144f020705280234g39aa04b3hfe369f4477e6043d@mail.gmail.com>
	 <Pine.LNX.4.64.0705291900001.32656@jalava.cc.jyu.fi>
	 <84144f020705291157k465ec6c4sb81081844bb57514@mail.gmail.com>
	 <Pine.LNX.4.64.0705300654493.5241@jalava.cc.jyu.fi>
X-Google-Sender-Auth: 4e35a4621e6d359b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/07, Tero Roponen <teanropo@jyu.fi> wrote:
> Hmmm, I just found something interesting. In 2.6.21.3 the /sbin/init
> gets corrupted when I watch the video!
>
> $ cp /sbin/init init.before
> $ mplayer kiwi.flv
> $ cp /sbin/init init.after
>
> The sha1sums are here:
>
> 52c8d643057619cbe137b8e69d4709ce3bdd832d  init.after
> 8efc7864a5b535a9e336fa82e9d7f112f3d956c1  init.before
>
> It seems that something corrupts memory somewhere...

To debug this a bit further:

$ od -a -t x1 -v init.after > init.after.dump
$ od -a -t x1 -v init.before > init.before.dump
$ diff -u init.before.dump init.after.dump | less

-0011340  nul nul nul  e9  f0  fe  ff  ff  ff   %   < soh enq  bs   h  80
-           00  00  00  e9  f0  fe  ff  ff  ff  25  3c  01  05  08  68  80
+0010000    y ack nul nul   y ack nul nul   y ack nul nul   y ack nul nul
+           79  06  00  00  79  06  00  00  79  06  00  00  79  06  00  00
+0010020    y ack nul nul   y ack nul nul   y ack nul nul   y ack nul nul
+           79  06  00  00  79  06  00  00  79  06  00  00  79  06  00  00
+0011340    y ack nul nul   y ack nul nul  ff   %   < soh enq  bs   h  80
+           79  06  00  00  79  06  00  00  ff  25  3c  01  05  08  68  80

The file at offset 0010000 - 0011348 is overwritten with the byte
pattern 79 06 00 00.

Do you see anything in the logs or is this a silent corruption? Did
you see this corruption with 2.6.19 or 2.6.22-rc3?
