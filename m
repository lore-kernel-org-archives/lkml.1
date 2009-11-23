Return-Path: <linux-kernel-owner+w=401wt.eu-S1756517AbZKWUDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbZKWUDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 15:03:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbZKWUDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 15:03:09 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:41599 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369AbZKWUDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 15:03:08 -0500
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Willy Tarreau <w@1wt.eu>, Matt Thrailkill <matt.thrailkill@gmail.com>,
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
	<20091112054004.GA15925@1wt.eu> <m1k4xhf3cx.fsf@fess.ebiederm.org>
	<4B0AE3E4.9020909@zytor.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 23 Nov 2009 12:03:10 -0800
In-Reply-To: <4B0AE3E4.9020909@zytor.com> (H. Peter Anvin's message of "Mon\, 23 Nov 2009 11\:35\:00 -0800")
Message-ID: <m1ws1hdn5t.fsf@fess.ebiederm.org>
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

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 11/23/2009 11:27 AM, Eric W. Biederman wrote:
>> 
>> When working on dosemu and emulating EGA 16 color graphics we had to
>> unmap the frame buffer so we would cause move instructions to fault.
>> Trapping for each mov instruction in the loops that wrote to the frame
>> buffer was unusably slow.  Ultimately that was fixed by trapping on
>> the first instruction and then running in the emulator until we had
>> gone N instructions without hitting an instruction we would trap for.
>> The result was usable software emulated EGA graphics.
>> 
>> I expect the same logic will apply any time there is a trapped and
>> emulated instruction in an inner loop.  Emulating the entire loop
>> will be more efficient than trapping for each loop iteration.
>> 
>
> Yes, this is pretty typical.  In terms of EGA/VGA it depends heavily on
> how the application is coded, since it is possible to put EGA/VGA into
> modes where the frame buffer depends mostly like memory except at
> specific I/O points, and other modes where the frame buffer behaves
> nothing like memory at all and every reference needs to be handled
> specially.  In real use, the former tends to dominate simply because
> it's the sane way to code, but the only way to make the latter perform
> sanely at all is to interpret everything.

For old applications that we were concerned about in dosemu the masked
modes where you write to multiple frame buffer pages at once with a
single write dominated because on real hardware it is faster.

As I recall if the things were setup so we did not need to trap dosemu
mapped the appropriate frame buffer page directly, so we did not need
to handle that case.

Regardless the point is that if we start emulating rare instructions
with traps I expect we will reach the point where we have inner loops
that we want to emulate entirely instead of taking a multitude of traps.

Eric
