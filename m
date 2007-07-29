Return-Path: <linux-kernel-owner+w=401wt.eu-S935186AbXG2UAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935186AbXG2UAd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 16:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933371AbXG2UA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 16:00:26 -0400
Received: from hu-out-0506.google.com ([72.14.214.237]:12422 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932961AbXG2UAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 16:00:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ZivrB+waL6UdZF1uUMniQqg8Yik/HRG0fHAvnIRzP9wknzUx5CDmNzAmANEGUELLcL/wojKKQwerLRAQb02QTqYFz3/XgmC8zKD8Q1s0mB8DI8wJSac+byxIFHNPukEQ+Ky4QVgN/lm3LiXn3e3rzxvepJ1ROU6Bg/stOyd4Cag=
Message-ID: <2c0942db0707291300k3e30e410wdd0aba7644382e3b@mail.gmail.com>
Date: Sun, 29 Jul 2007 13:00:22 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: RFT: updatedb "morning after" problem [was: Re: -mm merge plans for 2.6.23]
Cc: rene.herman@gmail.com, alan@lxorguk.ukuu.org.uk, david@lang.hm,
       dhazelton@enter.net, efault@gmx.de, akpm@linux-foundation.org,
       mingo@elte.hu, frank@kingswood-consulting.co.uk, andi@firstfloor.org,
       nickpiggin@yahoo.com.au, jesper.juhl@gmail.com, ck@vds.kolivas.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070729123353.2bfb9630.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>
	 <46AB166A.2000300@gmail.com>
	 <20070728122139.3c7f4290@the-village.bc.nu>
	 <46AC4B97.5050708@gmail.com>
	 <20070729141215.08973d54@the-village.bc.nu>
	 <46AC9F2C.8090601@gmail.com>
	 <2c0942db0707290758p39fef2e8o68d67bec5c7ba6ab@mail.gmail.com>
	 <46ACAB45.6080307@gmail.com>
	 <2c0942db0707290820r2e31f40flb51a43846169a752@mail.gmail.com>
	 <20070729123353.2bfb9630.pj@sgi.com>
X-Google-Sender-Auth: 43e9827784ae21bf
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/29/07, Paul Jackson <pj@sgi.com> wrote:
> If the problem is reading stuff back in from swap at the *same time*
> that the application is reading stuff from some user file system, and if
> that user file system is on the same drive as the swap partition
> (typical on laptops), then interleaving the user file system accesses
> with the swap partition accesses might overwhelm all other performance
> problems, due to the frequent long seeks between the two.

Ah, so in a normal scenario where a working-set is getting faulted
back in, we have the swap storage as well as the file-backed stuff
that needs to be read as well. So even if swap is organized perfectly,
we're still seeking. Damn.

On the other hand, that explains another thing that swap prefetch
could be helping with -- if it preemptively faults the swap back in,
then the file-backed stuff can be faulted back more quickly, just by
the virtue of not needing to seek back and forth to swap for its
stuff. Hadn't thought of that.

That also implies that people running with swap files rather than swap
partitions will see less of an issue. I should dig out my old compact
flash card and try putting swap on that for a week.

> In that case, swap layout and swap i/o block size are secondary.
> However, pre-fetching, so that swap read back is not interleaved
> with application file accesses, could help dramatically.

<Nod>

> Perhaps we could have a 'wake-up' command, analogous to the various sleep
> and hibernate commands.
[...]
> In case Andrew is so bored he read this far -- yes this wake-up sounds
> like user space code, with minimal kernel changes to support any
> particular lower level operation that we can't do already.

He'd suggested using, uhm, ptrace_peek or somesuch for just such a
purpose. The second half of the issue is to know when and what to
target.

Ray
