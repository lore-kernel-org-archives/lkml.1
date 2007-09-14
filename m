Return-Path: <linux-kernel-owner+w=401wt.eu-S1758172AbXINLUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172AbXINLUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 07:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755386AbXINLUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 07:20:34 -0400
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:38446 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752545AbXINLUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 07:20:33 -0400
Date: Fri, 14 Sep 2007 13:21:54 +0200
From: Andreas Herrmann <aherrman@arcor.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       dean gaudet <dean@arctic.org>
Subject: Re: [PATCH] x86_64: set cfg_size for AMD Family 10h in case MMCONFIG
Message-ID: <20070914112154.GB6727@devil>
References: <46E9A391.3000804@zytor.com> <20070914082129.GA6727@devil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E9A391.3000804@zytor.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Usually one shouldn't reply to such mails. But I cannot resist.
Because partially there was told such nonsense ...
Of course the following is just my personal view.

On 2007-09-13 20:54:41, H. Peter Anvin wrote:
> Andreas Herrmann wrote:
> > On Thu, Sep 13, 2007 at 10:20:56AM -0700, H. Peter Anvin wrote:
> >> Yinghai Lu wrote:
> >>> BIOS guys also said that fam 10h need mmconfig via eax accessing, may
> >>> need OS do sth, so it is safe to stay with MCFG entry for SB like
> >>> mcp55...
> >>>
> >>> but latest kernel already have that workaround to make mmconfig via eax...
> >>>
> >> This is actually a good point.  Since the CPU vendor managed to
> >> completely fuck up the operation of MMCONFIG itself on this CPU (it's a
> >> *MEMORY REFERENCE*, guys!), it is actually to be expected and prudent
> >> that BIOS vendors will drop the MCFG entry.  MMCONFIG doesn't actually
> >> work on this CPU for any system software which doesn't already know to
> >> work around this particular piece of severe braindamage;
> > 
> > But wait, isn't it true that Vista is using MCFG?
> > So, poor BIOS guys what should they do now?
> > If you have a special problem here why not upgrading your Linux kernel?
> > 
>
> I'm not talking about Linux here.  I'm talking about any random system
> software (which may or may not be Vista, and may nor may not even be an
> OS.)

Are you serious? You are worried about Vista compatibility issues for
new hardware? Here on LKML? I thought this is a Linux mailing list.

But if this is your worry:
Aren't you aware that most OSes have included patches in order to
support this new hardware? Making use of the new pstates stuff is one
example. And aren't you aware that even for proprietary OSes there are
updates?

But if that is not functioning for you why don't you just get rid of your
proprietary hoax?

>  If they advertise MCFG, then a random OS could try to use it, in
> accordance with the spec, without the workaround, with serious
> malfunction as a result.

Have you looked into the BKDG of that CPU?
You can download it here
http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/31116.pdf

BTW, in this version it is even recommended to set up MCFG. So why should a
BIOS vendor drop it?

As I have stated in some mail yesterday there are actually 3 ECS access methods
possible. For mmio config space accesses you have the choices that the
translation is done either by CPU/NB or by the chipset.
So if you do not enable MMIO config space access within CPU/NB, the CPU will
not convert the config accesses to config cycles on the link.

Which means that:
- your tiny "random OS" should work as usual
- you have no mmio config access to the northbridge functions.

Said that, it seems obvious that the MMIO configuration requirements
are just needed if the translation is done by the CPU/NB. Which makes
somehow sense, because I think the CPU has to intercept somehow the
MMIO traffic to decide whether config space should be accessed or not.
And maybe the hardware designers had some reason to impose those
requirements?

So here comes one funny part out of that discussion.

It seems that a workaround went into the kernel
(commit  3320ad994afb2c44ad34b3b34c3c5cf0da297331)
for a feature that is not yet switched on by the OS.

Because Yinghai's patch is rejected. Or did I miss something?
Did Andi rejected just the third patch and not the first two? Hm, ...

(And obviously Dean Gaudet must have had a system where MSR 0xc0010058
was accordingly configured  - by the BIOS or himself?)

This shows just one thing. Code in this area needs more review and testing
before it goes upstream. So maybe there is some problem with the
"development process" for x86_64?

> If they don't include MCFG, then the worst thing that can happen is that
> the OS doesn't see the extended space.  An OS that has chip-specific
> workarounds can be aware that this chip is Special and enable MMCONFIG
> and use it anyway.

Why then not add code for this "fam 10h-chip" - to decide it is special
and to set up the MmioConfigBase MSR in such a case?

> In RFC-speak:
> 
> Since this chip doesn't implement standards-conformant mmconfig, a BIOS
> MUST NOT enable MCFG in ACPI.  As a result, OSes that have chip-specific
> workarounds, like Linux has, SHOULD detect it and use ad hoc code to
> enable it anyway.


#1: So if you all think that the new mmconfig stuff (done in the CPU/NB) is a crux,
then make it right and double-check in the OS whether the MmioConfigBase MSR
is set and clear it if you like!
(And I can even imagine that you would send patches to do this ;-(

And your statement is wrong again. If #1 is done.
Then you should still have MCFG set up in the BIOS to tell the OS the config space
address range such that mmconfig can be done via the chipset.


And some final notes:

This stuff was long documented in some preliminary NDA specs. And some kernel
developer(s) had access to it. So if it is such a big deal, why didn't they speak
up earlier?

Why I didn't speak up earlier?
Because I have to admit that I didn't care about that stuff until 2-3 weeks ago.

Because I am not as standards-compliant as you are, I should say: "To err is human".
So I've done my best to verify that config space stuff with real code on real hardware
last week. But as always, it is possible that I am wrong with certain statements.

Do you think it is a good idea to discuss that MMCONFIG topic with
some designers at AMD? I could print out that mail or forward it to them.
Do you think they will be happy to listen to your words if you say that
they are "fucking up" stuff and come up with "braindamaged" ideas?
I appreciate the code you write, but not the communication style you chose.


Regards,

Andreas

