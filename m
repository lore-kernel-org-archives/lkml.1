Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbYADWoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbYADWoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 17:44:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754744AbYADWny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 17:43:54 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:39976 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbYADWnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 17:43:53 -0500
Date: Fri, 4 Jan 2008 23:43:52 +0100
From: Andreas Mohr <andi@lisas.de>
To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
Cc: Andreas Mohr <andi@lisas.de>, Adrian Bunk <bunk@kernel.org>,
       Richard Jonsson <richie@coderworld.net>, linux-kernel@vger.kernel.org,
       Ayaz Abdulla <aabdulla@nvidia.com>, jgarzik@pobox.com,
       netdev@vger.kernel.org
Subject: Re: forcedeth: MAC-address reversed on resume from suspend
Message-ID: <20080104224352.GA7853@rhlx01.hs-esslingen.de>
References: <477BFC71.7090002@coderworld.net> <20080102214843.GA19224@rhlx01.hs-esslingen.de> <20080102234209.GA10831@does.not.exist> <20080104034357.GA2113@atjola.homenet> <20080104084517.GA21628@rhlx01.hs-esslingen.de> <20080104101740.GA4406@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080104101740.GA4406@atjola.homenet>
X-Priority: none
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 11:17:40AM +0100, Björn Steinbrink wrote:
> On 2008.01.04 09:45:17 +0100, Andreas Mohr wrote:
> > And then it needs these card I/O functions wrapped into two functions which
> > interface with driver- and OS-related MAC variables
> > (struct variables ALWAYS stored in usual system order, NOT H/W order!!!!!!)
> > which optionally reverse the address (if needed for a particular card).
> 
> Hu? The MAC address is only ever reversed when the card is not in use,
> why the hell would you want to reverse anything when the rest of the OS
> is involved? This whole reversing stuff is purely before and after the
> card is actually used. It's not that you need to reverse the address to
> communicate with the card, it's just initially wrong on the card.

Huhrmm? OK, let me ask this then:
So what you're saying is that the address is only initially wrong
(e.g. due to card EEPROM content somehow initializing the registers
in wrong order on power-on), it's not _always_ supposed to be stored
in wrong order during operation.

IOW, the default card state after power-on is _unusable_ (due to
invalidly ordered MAC address) and has to be _corrected_ by the driver,
_initially_ only?

OTOH I know that at least acx100 has a _permanently_ wrong-ordered
MAC address setup, i.e. it's required to have it in "wrong" order
_during operation_. And I wouldn't be surprised to see several examples
of other hardware having a permanently wrongly-ordered address
requirement, given the amount of MAC reversal in Linux drivers.


Couldn't it be by chance that it's _believed_ to be reversed-on-power-on only,
whereas those cards should _actually_ have it reversed-during-lifetime
instead? Such a misunderstanding might explain a lot of trouble...

Obviously I was expecting the latter case, which my code layout proposal
was supposed to support in a clean way.

> > And then there will never be any confusion about any MAC address format
> > anywhere any more, right?
> 
> At probing time, you'll have to know whether the address you read from
> the hardware is reversed or not. Unless you write it back in reversed
> order when you release the card, you need a flag that at least survives
> until nv_probe is called the next time. kexec does not write it back, so
> you do need such a flag. But the flag apparently doesn't survive a
> suspend/resume cycle, so you need to write back the reversed address
> then. But the flag will survive a rmmod + modprobe cycle, so you need to
> reset it when writing back the reversed address.

If it's indeed reversed-on-power-on only, then one probably cannot do
much about it, thus I'd give up and simply check the MAC address for
validity (should be very easy to check for a simple reversal by
checking for the manufacturer-specific fingerprint in reverse order).
Keeping _any_ sort of state to record the fact that it used to be reversed
or now is reversed is futile (or rather: catastrophic) given the complexity of
suspend / virtualisation or whichever other nice operations Linux may invent
in the future ;)

> Well, let's see if my analysis was correct and the patch works, first. I
> saw the forcedeth code before, but kexec and suspend is totally new to
> me and I just made some assumptions based on the reported behaviour and
> the commit messages... ;-)

You most likely did more analysis than me, I just said
"this very obviously must be the problem" and replied ;)

Andreas Mohr
