Return-Path: <linux-kernel-owner+w=401wt.eu-S1754111Ab0AYWaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab0AYWaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 17:30:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939Ab0AYWaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 17:30:13 -0500
Received: from mail-pz0-f189.google.com ([209.85.222.189]:45961 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab0AYWaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 17:30:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=arCjok4pvhAUo7qn6qmn+u+aPJFkpmFW9RtXE/Ysvp3IseWGs6zO4nykifL4gS+bMf
         KMzaIsnERJ5H773z47zyOs9sSBkb1e/OamtsHYDf+J5LDkhSBygdVRFk4qatkO78gFAv
         RFoikJpQwek4EQgij0p+q943639iQLXQbV9eQ=
Date: Mon, 25 Jan 2010 14:30:04 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vojtech Pavlik <vojtech@suse.cz>, Robert Hancock <hancockrwd@gmail.com>,
       Bastien Nocera <hadess@hadess.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, pjones@redhat.com
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
Message-ID: <20100125223004.GB30307@core.coreip.homeip.net>
References: <1264011793.1735.3683.camel@localhost.localdomain>
 <4B57A2D4.9030204@gmail.com>
 <20100121185544.GB11996@core.coreip.homeip.net>
 <51f3faa71001211339t4652700ct34659c37479cd67e@mail.gmail.com>
 <20100121221701.GA15293@core.coreip.homeip.net>
 <20100125163433.GB31957@suse.cz>
 <4B5E0DFA.8080705@zytor.com>
 <20100125221520.GA30307@core.coreip.homeip.net>
 <4B5E18C0.7060402@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5E18C0.7060402@zytor.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 02:18:40PM -0800, H. Peter Anvin wrote:
> On 01/25/2010 02:15 PM, Dmitry Torokhov wrote:
> > On Mon, Jan 25, 2010 at 01:32:42PM -0800, H. Peter Anvin wrote:
> >> On 01/25/2010 08:34 AM, Vojtech Pavlik wrote:
> >>>
> >>> Thus I believe that the right fix here is to figure out why the accesses
> >>> to the ports 0x60/0x64 take a long time or forever on a Mac. Is it just
> >>> that the kernel is timing out waiting for the i8042? Or is it something
> >>> more sinister?
> >>>
> >>
> >> In the A20 code in the setup code, I look for 0xFF coming back and
> >> terminate the "wait for ready" loop much sooner than for other values.
> >> 0xFF is a *possible* status value, but not a very *likely* one
> >> (especially for repeated reads), as it would represent:
> >>
> >> parity error + receive timeout + transmit timeout + keyboard lock +
> >> command + selftest OK + input full + output full.
> >>
> > 
> > You allow up to 32 0xFFs while i8042 driver does maximum 16 reads of
> > whatever - if OBF is still raised we assume i8042 is not there. Does
> > that mean that reads from 0x60 is what hurts on Macs?
> > 
> > Bastien, could you try modifying drivers/input/serio/i8042.c::
> > i8042_flush() to not call i8042_read_data() when str is 0xff and see if
> > it helps with lockups?
> > 
> 
> We should never read from port 0x60 unless bit 1 in port 0x64 is set.
> Do we do that?

No, we don't read of OBF is 0. Incidentially 0xff has it set ;) so we do
try reading data port.

-- 
Dmitry
