Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbYHIQcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbYHIQcm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 12:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYHIQcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 12:32:33 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:47911 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbYHIQcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 12:32:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=yHSSV2Y2m0RhdnFG5pGzG718JiC3Uz67jxZWHoRwSq5h9JQy/D8Oq7T3zF+GXFSyg+
         fzZJfNxyxGuMFep4vyTrd1nz0FpubA6xQM2QeaWzTm6Lnn9HsY6aTjWqxkFL0yorEw8B
         h9hDxJMRx/IIKh5pEoy0N5SVEsc+hOwMRN/JQ=
Message-ID: <b637ec0b0808090932l4d21d973we160c145f007da7c@mail.gmail.com>
Date: Sat, 9 Aug 2008 18:32:31 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: New conflict message in latest GIT
Cc: "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Rene Herman" <rene.herman@keyaccess.nl>,
       "Andrew Morton" <akpm@osdl.org>, "Thomas Renninger" <trenn@suse.de>
In-Reply-To: <20080809181358.5c9da790@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b637ec0b0807221156x46d550a1h4180d6d624daeeb@mail.gmail.com>
	 <200807231256.42743.bjorn.helgaas@hp.com>
	 <b637ec0b0807231250g3e5b29eak8fbba41b69816351@mail.gmail.com>
	 <20080809181358.5c9da790@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean.

On Sat, Aug 9, 2008 at 6:13 PM, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Fabio,
>
> On Wed, 23 Jul 2008 21:50:24 +0200, Fabio Comolli wrote:
>> Hi.
>>
>> On Wed, Jul 23, 2008 at 8:56 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>> > On Tuesday 22 July 2008 12:56:36 pm Fabio Comolli wrote:
>> >> Linus' GIT tree 2.6.26-05752-g93ded9b shows this message:
>> >>
>> >> i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
>> >> ACPI: I/O resource 0000:00:1f.3 [0x18e0-0x18ff] conflicts with ACPI
>> >> region SMBI [0x18e0-0x18ef]
>> >> ACPI: Device needs an ACPI driver
>> >>
>> >> There is no equivalent in 2.6.26 or previous kernels.
>> >
>> > The "ACPI: I/O resource ... conflicts with ..." message was added by
>> > Thomas:
>> >  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=df92e695998e1bc6e426a840eb86d6d1ee87e2a5
>> >
>> > That conflict checking infrastructure was in 2.6.26, but Jean's
>> > change to make the i801_smbus driver use it didn't happen until
>> > about a week ago:
>> >  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=54fb4a05af0a4b814e6716cfdf3fa97fc6be7a32
>> >
>> > The message is telling us that the i801_smbus driver thinks it owns
>> > the 0x18e0-0x18ff region, but there's also an ACPI opregion that
>> > references that region.  There's no coordination between ACPI and
>> > the i801_smbus driver, so there may be issues where nearly
>> > simultaneous accesses cause incorrect behavior, e.g,. one may
>> > read the wrong value from a temperature sensor.  That, of course,
>> > can lead to more serious things like unintended machine shutdowns.
>> >
>> > I don't have any ideas about how to address this.  I think Thomas's
>> > intent was to collect better information for unreproducible bugs.
>> > (Maybe this sort of conflict should even set a taint flag?)
>
> Yes, at this point these messages are informative only and displayed as
> a hint when investigating bug reports. In the long run, we might
> decide to grant exclusive access to the shared region to either ACPI or
> the native driver, or to setup a safe concurrent access mechanism.
> That's a long way to go though, due to the diversity of BIOSes out
> there and the fact that many of them declare opregions in bogus ways.
>
>> OK, I actually didn't even know what i801_smbus (i2c_801 I suppose)
>> was. It seems that my laptop has a super-IO chip which is detected by
>> lm-sensors as `Nat. Semi. PC87591 Super IO' which doesn't have a
>> driver and never will.
>>
>> So, if I'm correct, this modules is totally useless for me and I
>> better compile it out. Am I correct?
>
> Yes you are. If you don't need i2c-i801 on this machine, best is to not
> build it or to prevent it from loading. Or you can boot with
> acpi_enforce_resources=strict to prevent the i2c-i801 driver from
> attaching to the device.
>

Ok, thanks for confirming it.

> I am a bit curious though, why ACPI would declare an opregion for a
> device that isn't used. Might be yet another case of BIOS copied from
> another machine and not cleaned up appropriately.
>

Well, you should ask HP for that :-)

Anyway, as usual linux is not supported at all on this laptop, it came
with XP. One thing that puzzles me is why bothering adding a
monitoring chip for which drivers do not exist for any OS?

> --
> Jean Delvare
>

Regards,
Fabio
