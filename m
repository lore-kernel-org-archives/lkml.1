Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbZBUAoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbZBUAoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 19:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbZBUAoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 19:44:12 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:33589 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbZBUAoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 19:44:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=Q0wXI6H+Eq8HQdJBN6xIJ0p6pAK+UE1TgiWwkosLdNZt6XFur2/SU8umqnxFb+O1Se
         gBxO57uGDUS0sOCpV0etY+qxaGDmipXboJpRrCwc+PN6jR1lPxZbtAHybEgGh/g3M5yD
         n+uFan7ankMN3wgV5SEIruSrgDdqW/moqScbY=
Message-ID: <499F4E56.4050305@gmail.com>
Date: Fri, 20 Feb 2009 18:44:06 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: "Mr. Berkley Shands" <bshands@exegy.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: AMD 8132 parity issue causes interrupt storms
References: <499F1729.9010700@exegy.com>
In-Reply-To: <499F1729.9010700@exegy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mr. Berkley Shands wrote:
> It seems that the 8132 should be blacklisted :-)
> 
> INT-A will be asserted forever if any channel sees a parity error.
> This can be blocked by several means;
> 
> 1) setpci -s <bus address of 8132> 5.b=05   /* disable interrupts from 
> the bridge */
> This is the I don't see you method.
> 
> Shouldn't the interrupt handler (is there one?) trap and clear this?
> Shouldn't the kernel at least report this error and reset those bits?

What's enabling this interrupt generation? Interrupting on parity errors 
is not part of the PCI spec. Unless there's some driver that's set up to 
handle these interrupts, whoever's enabling them shouldn't be..

> 
> All,
> 
> OK, here's what I know so far.  The interrupt storm is coming from the 
> parity error detector in the 8132.  The parity error is reported in two 
> locations using sticky bits:
> 
> 0x1c bits 31 and 24
>   Here there seems to be some differentiation between which party 
> detected the parity error.  The 8132 spec is pretty vague here (see page 
> 75) but it looks like the 8132 is detecting a parity error from the HBA 
> not the other way around.
> 0x80 bit 0
>   Here it just states that someone asserted the PERR_L signal, no 
> distinction on who did it.
> 
> All these bits are write-one-to-clear.  If 0x80 bit 0 is cleared, the 
> storm stops.  Clearly the OS does not know how to handle these 
> conditions and the error flag is left on while the interrupt is 
> continuously handled.
> 
> One way to handle this is to set 0x48 bit 19 to 0.  This prevents the 
> 8132 from interrupting when 0x80 bit 0 is set.
> 
> A much better way to handle this is to have the interrupt handler 
> actually check the error bits on the 8132 when it is called.  This would 
> slow down the interrupt handler, but actually give us a much better 
> visibility into this problem (when, where and how often this happens).  
> The irritating thing here is that this is chipset dependent.  The 
> interrupt handler would have to know what PCI-X chipset it was talking 
> through to know how to handle this (way to go AMD).
> 
> The really odd thing is that the parity error is reported through INTB 
> on the 8132.  The spec claims that fatal errors (the category they put 
> PERR in) go to INTB while hot plug conditions trigger INTA.  Masking off 
> fatal errors in the IOAPIC turns off the storm too.  I have no idea why 
> this is showing up on INTA.
> 
> Berkley
> 

