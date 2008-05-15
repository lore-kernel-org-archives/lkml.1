Return-Path: <linux-kernel-owner+w=401wt.eu-S1756725AbYEOWNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbYEOWNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 18:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbYEOWNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 18:13:41 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:64321 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbYEOWNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 18:13:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CrU/HG22iSCANourQ+A/j5Y9Oo2msWN5t2bwP3QecIZWZExFsh4i3CTcSFO1tx7xsu8N5EDEoFGNb/nOKWIke650xHQZ8y+O6Xnf2rSq3/phIckTN9ge6G0bTZAiCf+ryQ3hjA2E/cMXy9aUjY2+zreYq4gSuQ2xJpJtErln9l4=
Message-ID: <9a8748490805151513j74f9b99dla900ebc636941636@mail.gmail.com>
Date: Fri, 16 May 2008 00:13:39 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of IRQF_SAMPLE_RANDOM
Cc: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Chris Peterson" <cpeterso@cpeterso.com>, jeff@garzik.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mpm@selenic.com
In-Reply-To: <20080515215517.GI1936@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.62.0805150009060.18303@ikari.dreamhost.com>
	 <20080515142154.0595e475@core>
	 <36D9DB17C6DE9E40B059440DB8D95F52052D71BB@orsmsx418.amr.corp.intel.com>
	 <20080515215517.GI1936@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/15 Adrian Bunk <bunk@kernel.org>:
> On Thu, May 15, 2008 at 09:07:52AM -0700, Brandeburg, Jesse wrote:
>> Alan Cox wrote:
>> > Chris Peterson <cpeterso@cpeterso.com> wrote:
>> >> I know Jeff Garzik says he's not interested in an anti-entropy
>> >> pogrom for existing net drivers, but here is the patch if anyone
>> >> else is interested..? :)
>> >>
>> >> Only 12 net drivers are affected, the last of the
>> >> theoretically-exploitable network entropy.
>> >
>> > Looks fine to me. If Jeff doesn't want to touch them then send them
>> > direct to Andrew/Linus.
>> >
>> > A more interesting alternative might be to mark things like network
>> > drivers with a new flag say IRQF_SAMPLE_DUBIOUS so that users can be
>> > given a switch to enable/disable their use depending upon the
>> > environment.
>>
>> we've been hearing rumblings of big customers wanting (maybe requiring)
>> wired network drivers from Intel to  advertise this flag.  Jeff have you
>> heard of such?
>>
>> I think the argument is that a headless system (no keyboard/mouse, no
>> soundcard, probably no video) with a libata based driver and a network
>> driver without IRQF_SAMPLE_RANDOM has *no* sources of entropy.  In this
>> case the argument is very strong for at least *some* source of entropy
>> from interrupts so that randomness can get some external input.  Just
>> try rebuilding a kernel RPM over an ssh session and you'll see what I
>> mean.
>>
>> In short, I agree with Alan's IRQF_SAMPLE_DUBIOUS, and know of Linux
>> customers who also want the same.
>
> We have two random number interfaces:
> - /dev/random
> - /dev/urandom
>
> If a customer wants to get data from /dev/random although there's not
> enough entropy that's not a problem we can solve (we can only try to
> gather more real entropy if possible).
>
> If he can live with dubious data he can simply use /dev/urandom .
>
> If a customer wants to use /dev/random and demands to get dubious data
> there if nothing better is available fulfilling his wish only moves
> the security bug from his crappy application to the Linux kernel.
>
> But what we could perhaps do with some kind of IRQF_SAMPLE_DUBIOUS would
> be to improve the quality of the data in /dev/urandom if there's not
> enough entropy available?
>
> I have seen embedded systems with zero entropy, and dubious entropy
> might there be better than no entropy at all.
> Or am I wrong on the latter?
>

Note: I'm far from being any kind of expert on this topic, but I just
had a crazy idea.

What if we use the time between syscalls being made as a source of
(very little) entropy?

My point is that the rate (and timing between) syscalls is depending
on very many factors; the kernel version (and configuration), the
software installed, the software currently executing, the state of the
software currently executing, the number of apps executing, the amount
of network traffic, the accuracy of the hardware clock, the speed of
(various) IO sources (network, disk, USB, etc), the speed (and type)
of the CPU, the speed of memory. And various other things.
I'd guess that predicting the syscall rate and interval between
syscalls would be too hard to accurately predict to predict the actual
entropy generated by that sampling in any real world scenario.
Wouldn't that make it a reasonable entropy source for machines that
have no other sources (and a fair contributor of entropy even for
machines that do have other sources) ??


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please http://www.expita.com/nomime.html
