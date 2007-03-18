Return-Path: <linux-kernel-owner+w=401wt.eu-S933015AbXCRTgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015AbXCRTgM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 15:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932901AbXCRTgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 15:36:11 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:18079 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933015AbXCRTgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 15:36:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fmLPkS72k4n5muc3UY01tvSiFB6zUWqsjTi7MCYpM++3jSIc0x/RixTnXo6Uuxmt9hIRpn1k0Sb+qfoBDOJJjiTNb3uggN6+7mt8GFmzbx665neK3CKPMXhm+nXrpU2IOTIfCFdZwyOVoPJn7E0bMogbNyQ/wbUjpvZZYdaLAFo=
Message-ID: <2e59e6970703181236l3f92f105je522f2966ffb0a39@mail.gmail.com>
Date: Sun, 18 Mar 2007 14:36:08 -0500
From: "richardvoigt@gmail.com" <richardvoigt@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Cc: "Matthew Garrett" <mjg59@srcf.ucam.org>, "Pavel Machek" <pavel@ucw.cz>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Rudolf Marek" <r.marek@assembler.cz>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
In-Reply-To: <20070303105316.d51e032d.khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45D6DDCE.5050803@assembler.cz> <20070228213803.GA4877@ucw.cz>
	 <20070301152655.f232db64.khali@linux-fr.org>
	 <20070302114023.GD2163@elf.ucw.cz>
	 <20070302114747.GB1212@srcf.ucam.org>
	 <20070302151055.d2665d66.khali@linux-fr.org>
	 <20070302141840.GA3441@srcf.ucam.org>
	 <20070302220454.a0c66d04.khali@linux-fr.org>
	 <20070302211251.GA10035@srcf.ucam.org>
	 <20070303105316.d51e032d.khali@linux-fr.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/3/07, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Matthew,
>
> On Fri, 2 Mar 2007 21:12:51 +0000, Matthew Garrett wrote:
> > On Fri, Mar 02, 2007 at 10:04:54PM +0100, Jean Delvare wrote:
> > > It might be more elegant but it won't work. We don't want to prevent
> > > ACPI from accessing these I/O ports. If we need to choose only one
> > > "driver" accessing the I/O port, it must be acpi, at leat for now,
> > > despite the fact that acpi provides very weak hardware monitoring
> > > capabilities compared to the specific drivers.
> >
> > Assuming arbitration of access, what's the problem with having two
> > drivers accessing the same hardware? Do these chips generally have any
> > significant internal state other than trip points and the like?
>
> The "assuming arbitration of access" is the key part of your
> sentence ;) The problem is that currently no arbitration is done. If it
> was done, then state would probably not be a problem. Most hardware
> monitoring drivers don't assume any state is preserved between
> accesses, and those which do can easily be changed not to. The ACPI
> side is another story though, I guess we can't assume anything about
> the AML code's assumption on states, as it differs from one machine to
> the next. But we can try to be cooperative and restore the sensible
> registers (e.g. bank selector) in the same state we found them.

I recall that one of the stated drawbacks of a lock was that no ACPI
code could execute while the hwmon driver was doing its fairly lengthy
conversation with the hardware.

It seems that using transactional concepts here would solve that
problem.  For example, the hwmon driver issues a start transaction
request.  The first write request to any given location (bank register
for example) causes the previous memory value to be saved.  Then,
instead of locking AML out, AML is allowed to execute, but any access
to the memory/port ranges reserved by the driver (when the transaction
is set up) cause the hwmon transaction to be rolled back so the AML
sees the expected state.  Then AML proceeds as usual.  When hwmon
tries additional operations, they fail with some "transaction
interrupted" error message, indicating to the hwmon driver to start
over.

The only issue with this that I can see, is that if AML isn['t
executed atomically wrt hwmon, then knowing when it is safe for hwmon
to retry is going to be difficult.

This probably requires changes to every hwmon driver, but they can be
updated piecemeal, starting with the ones most commonly found in
notebooks, where ACPI is most important.
