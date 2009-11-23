Return-Path: <linux-kernel-owner+w=401wt.eu-S1755756AbZKWT2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbZKWT2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 14:28:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbZKWT2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 14:28:08 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:35872 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbZKWT2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 14:28:07 -0500
To: Willy Tarreau <w@1wt.eu>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Matt Thrailkill <matt.thrailkill@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Avi Kivity <avi@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
References: <20091110224222.GA28648@1wt.eu> <4AF9ED78.3000106@zytor.com>
	<20091111055220.GA560@1wt.eu> <4AFA569E.9040206@zytor.com>
	<20091111063617.GD560@1wt.eu> <4AFA6E50.7030808@zytor.com>
	<20091111093258.GE560@1wt.eu>
	<a91053ef0911111823v52669d18p7e5812076a63f03e@mail.gmail.com>
	<20091112052754.GB15679@1wt.eu> <4AFB9DAE.4080601@zytor.com>
	<20091112054004.GA15925@1wt.eu>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 23 Nov 2009 11:27:58 -0800
In-Reply-To: <20091112054004.GA15925@1wt.eu> (Willy Tarreau's message of "Thu\, 12 Nov 2009 06\:40\:04 +0100")
Message-ID: <m1k4xhf3cx.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau <w@1wt.eu> writes:

> On Wed, Nov 11, 2009 at 09:31:26PM -0800, H. Peter Anvin wrote:
>> On 11/11/2009 09:27 PM, Willy Tarreau wrote:
>> > 
>> > Right. However we just noticed that with the KVM emulator, you
>> > can make it loop for a long time if you feed it with prefixes
>> > only. For instance, write a function which does zillions of 0x66
>> > (data size prefix) then return (0xC3) : 66 66 66 ... 66 C3.
>> > 
>> > This is typically the sort of things we must be very careful about
>> > in emulators, because we don't want users to steal large amounts
>> > of system CPU time doing nothing.
>> > 
>> 
>> That is a (serious) bug in the KVM interpreter, and indeed the exact
>> kind of issues interpreters tend to have... which is why I'd like one
>> piece of code with one set of bugs, and more eyeballs on that one piece
>> of code so they can be fixed.
>
> Well, I could try to work on a fix (basically the same principle as in
> mine, with prefix flags), but I simply don't know how to test the code.
> I've never experimented with KVM yet and learned it embeds an emulator
> for the first time a few days ago in this thread :-/ If it's easy to
> make use of it, I'm not opposed to try.

When working on dosemu and emulating EGA 16 color graphics we had to
unmap the frame buffer so we would cause move instructions to fault.
Trapping for each mov instruction in the loops that wrote to the frame
buffer was unusably slow.  Ultimately that was fixed by trapping on
the first instruction and then running in the emulator until we had
gone N instructions without hitting an instruction we would trap for.
The result was usable software emulated EGA graphics.

I expect the same logic will apply any time there is a trapped and
emulated instruction in an inner loop.  Emulating the entire loop
will be more efficient than trapping for each loop iteration.

Eric
