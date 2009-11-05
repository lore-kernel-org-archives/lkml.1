Return-Path: <linux-kernel-owner+w=401wt.eu-S1751002AbZKEAEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751002AbZKEAEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 19:04:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbZKEAEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 19:04:07 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:55763 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbZKEAEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 19:04:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qcbGfTYeP8Dy8BKvtU/63SDBOzE8mxtzkTTsfEkGpbdGAh4PC5WnzTk/OxZQXIwMgz
         kpiuN/Ml6yfnXdy4S6pYY7zELRccCwY6zm0xIbU/syvdyFBe2Q2zDN1sKE5f75/RL+hQ
         O/aJFroEkZm7RoAwmeB1Xfew4ZgfZ7u4doen8=
Message-ID: <4AF21678.5020107@gmail.com>
Date: Wed, 04 Nov 2009 18:04:08 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org
Subject: Re: Kernel Options: To use MSI-X or not?
References: <alpine.DEB.2.00.0911041151410.17867@p34.internal.lan> <14754.1257356211@turing-police.cc.vt.edu>
In-Reply-To: <14754.1257356211@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2009 11:36 AM, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 04 Nov 2009 11:53:18 EST, Justin Piszcz said:
>
>> Example, 3ware cards/Intel Audio Drivers you can use MSI-X instead of
>> having several devices use/share an interrupt.
>>
>> What are the pros/cons to using MSI-X vs. having devices share an IRQ?
>
> Cons: Sometimes, you'll find a device that claims to support MSI but in fact is
> to some extent borked...
>
> I'm the proud owner of a Dell Latitude D820, which includes this PCI:
>
> 00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 01)
>          Subsystem: Dell Device 01cc
>          Flags: bus master, fast devsel, latency 0, IRQ 30
>          Memory at efffc000 (64-bit, non-prefetchable) [size=16K]
>          Capabilities: [50] Power Management version 2
>          Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
>          Capabilities: [70] Express Root Complex Integrated Endpoint, MSI 00
>          Capabilities: [100] Virtual Channel<?>
>          Capabilities: [130] Root Complex Link<?>
>          Kernel driver in use: HDA Intel
>
> However, actually trying to enable MSI gets me this at some pseudo-random
> time after booting (one for each of 7 boots):
>
> [    4.519264] ALSA sound/pci/hda/hda_intel.c:683: No response from codec, disabling MSI: last cmd=0x00df0900
> [   22.788015] ALSA sound/pci/hda/hda_intel.c:683: No response from codec, disabling MSI: last cmd=0x008f0c00
> [    4.719263] ALSA sound/pci/hda/hda_intel.c:683: No response from codec, disabling MSI: last cmd=0x00df0900
> [   12.497263] ALSA sound/pci/hda/hda_intel.c:683: No response from codec, disabling MSI: last cmd=0x00df0900
> [  815.350265] ALSA sound/pci/hda/hda_intel.c:683: No response from codec, disabling MSI: last cmd=0x00df0900
> [  595.171267] ALSA sound/pci/hda/hda_intel.c:683: No response from codec, disabling MSI: last cmd=0x00171700
> [    4.968263] ALSA sound/pci/hda/hda_intel.c:683: No response from codec, disabling MSI: last cmd=0x00df0900
>
> (Am slightly mystified about the resets at 4 and 12 seconds - at that point,
> we're not up far enough to actually try to use the audio. I suspect udev trying
> to initialize the card - except sometimes it works and runs just fine with
> MSI for quite some time:
>
> [14267.701267] ALSA sound/pci/hda/hda_intel.c:683: No response from codec, disabling MSI: last cmd=0x00df0900
> [12841.892050] ALSA sound/pci/hda/hda_intel.c:683: No response from codec, disabling MSI: last cmd=0x00df0900
> [10647.783274] ALSA sound/pci/hda/hda_intel.c:683: No response from codec, disabling MSI: last cmd=0x001f1500
> [15091.102034] ALSA sound/pci/hda/hda_intel.c:683: No response from codec, disabling MSI: last cmd=0x00171700
> [20085.955293] ALSA sound/pci/hda/hda_intel.c:683: No response from codec, disabling MSI: last cmd=0x00df0700

This may not be an actual MSI problem (in fact I'd say it's probably 
not). Currently hda_intel disables MSI after any codec response timeout, 
so it could be it would have worked if it retried while still using MSI. 
I believe Takashi was going to change the driver to be less sensitive 
about this.
