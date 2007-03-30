Return-Path: <linux-kernel-owner+w=401wt.eu-S1945975AbXC3Lym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945975AbXC3Lym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 07:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945976AbXC3Lyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 07:54:41 -0400
Received: from smtp010.mail.ukl.yahoo.com ([217.12.11.79]:27934 "HELO
	smtp010.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1945975AbXC3Lyk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 07:54:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=bDi9J0L900q3E3FL/8OxYgjicA9hW59DuHkg+K8QW36HgGecnq5CJuWGOWXm5ujysNvVBoD5bzmldy0+Vbo5SAZYLqfO//ozLk9NoqgJuBn/ASCnTKm3KoouuSlxq/xBfjF4xMIpnuW+1QBPTWBh0uCAr6F9C3Cyk+GAVlDpD3k=  ;
X-YMail-OSG: n0rHbuoVM1lFHm6b6HBTm798H_UP5FG149cqCHbaYhoHtzBhmuEWhqud8dPbOl86tVo0Eer_WY4JpA3I2Z1P_tdqkvzUMo2KcMkSgSmcB.0K99WVkgWl_LTmgUhtKTpzX88-
From: Blaisorblade <blaisorblade@yahoo.it>
To: user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH] UML - fix I/O hang when multiple devices are in use
Date: Fri, 30 Mar 2007 13:53:14 +0200
User-Agent: KMail/1.9.6
Cc: Jeff Dike <jdike@addtoit.com>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <20070328020247.GA12299@c2.user-mode-linux.org> <200703290236.44324.blaisorblade@yahoo.it> <20070329182920.GB8065@c2.user-mode-linux.org>
In-Reply-To: <20070329182920.GB8065@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703301353.14547.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On giovedì 29 marzo 2007, Jeff Dike wrote:
> On Thu, Mar 29, 2007 at 02:36:43AM +0200, Blaisorblade wrote:
> > > Sometimes you need to. I'd probably just remove the do_ubd check and
> > > always recall the request function when handling completions, it's
> > > easier and safe.
>
> If I'm understanding this correctly, this is what happens now.  There
> is still the flag check and return if the queue is being run, but I
> don't see the advantage of removing that.
>
> > Anyway, the main speedups to do on the UBD driver are:
> > * implement write barriers (so much less fsync) - this is performance
> > killer n.1
>
> You mean preventing the upper layers from calling fsync?

No. Since we don't know when the upper layers (including the journaling layer) 
wants to fsync, we call it everytime. But they pass this information. Chris 
Lightfoot implemented write barriers just before the API was changed, 
together with much of the other stuff I'm talking about.

It's impressive to check his original mail - the scenario with create a 32M 
file + delete it, where delete takes a minute on vanilla and 1 second on his 
patched code. I've downloaded the patch for future reference, even if I don't 
know when I'll have time to look at it.

> > * possibly to use the new 2.6 request layout with scatter/gather I/O, and
> > vectorized I/O on the host
>
> Yeah, this is something I've thought about on occassion but never
> done.
>
> > * while at vectorizing I/O using async I/O
>
> I have that, but haven't merged it since I see no performance benefit
> for some reason.
>
> > * to avoid passing requests on pipes (n.2) - on fast disk I/O becomes
> > cpu-bound.
>
> Right - I cooked up a scheme a while ago that had the requests on a
> list, being removed from one end and added to the other, with some
> minimal number of bytes going across the pipe to ensure a wakeup if
> the other side was possibly asleep.  But I never implemented it.
>
> > * using futexes instead of pipes for synchronization (required for
> > previous one).
>
> Yup - for this, we either need to test the host for futuxes and use
> pipes as a fallback or give up on 2.4 as the host.
>
> > I forgot one thing: remember ubd=mmap? Something like that could have
> > been done using MAP_PRIVATE, so that write had still to be called
> > explicitly but unchanged data was shared with the host.
> >
> > Once a page gets dirty but is then cleaned, sharing it back is
> > difficult - but even without that good savings could be
> > achievable. That's to explore for the very future though.
>
> Interesting idea.  That does avoid the formerly fatal mmap problem.
> If you unmap it, the private copy goes away because it lost its last
> reference, and if you map it again, you get the shared version.
>
> That's a lot of mapping and unmapping though.  I wonder if just
> calling mmap would cause the COWed page to be dropped...
>
> 				Jeff



-- 
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade
