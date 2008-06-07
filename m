Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbYFGT22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbYFGT22 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 15:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbYFGT2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 15:28:17 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:42686 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751951AbYFGT2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 15:28:16 -0400
Message-ID: <484AE148.6000204@suse.de>
Date: Sat, 07 Jun 2008 23:28:08 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Justin Mattock <justinmattock@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: ACPI: EC: GPE storm detected, disabling EC GPE
References: <dd18b0c30806062321x2918f6feq7c817bde52ba0c4c@mail.gmail.com>	 <20080606235526.783acc83.akpm@linux-foundation.org> <dd18b0c30806070847t63b8dbc0x8bfcbafc359f7031@mail.gmail.com>
In-Reply-To: <dd18b0c30806070847t63b8dbc0x8bfcbafc359f7031@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Mattock wrote:
> On Sat, Jun 7, 2008 at 6:55 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> On Sat, 7 Jun 2008 06:21:54 +0000 "Justin Mattock" <justinmattock@gmail.com> wrote:
>>
>>> Well; I was hoping it was going to be just an easy fix, but unfortunately
>>> changing
>>>  if (atomic_read(&ec->irq_count) > 5) {
>>>  to
>>> if (atomic_read(&ec->irq_count) > 20) {
>>> does seem to make the message disappear, for a while, probably at
>>> around three hours,(for me at least) then the message appeared again.
>>> :-(
>>> So leaving me back to the beginning of try to have a go at this.
>>> regards;
>> I removed bugzilla from cc - that only works if there's [Bug 1234] in
>> the Subject:.
>>
>> I added linux-acpi to cc - this is an acpi problem.
>>
>> What Justin is mysteriously referring to here is:
>>
>>
>> : From: "Justin Mattock" <justinmattock@gmail.com>
>> : To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
>> : Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
>> : Subject: GPE storm detected, disabling EC GPE
>> : Date:         Thu, 5 Jun 2008 21:01:55 +0000
>> : Sender: linux-kernel-owner@vger.kernel.org
>> :
>> : FWIW I noticed a post where the person had changed 5 to 20, and it
>> : seemed to work for them;
>> : So with that in mind I decide to give that a go, here is the location:
>> : drivers/acpi/ec.c
>> : @@ -527,47 +488,51 @@ static u32 acpi_ec_gpe_handler(void *data)
>> :  {
>> :         acpi_status status = AE_OK;
>> :         struct acpi_ec *ec = data;
>> :        u8 state = acpi_ec_read_status(ec);
>> :
>> :         pr_debug(PREFIX "~~~> interrupt\n");
>> :        atomic_inc(&ec->irq_count);
>> : -       if (atomic_read(&ec->irq_count) > 5) {
>> : +       if (atomic_read(&ec->irq_count) > 20) {
>> :                pr_err(PREFIX "GPE storm detected, disabling EC GPE\n");
>> :                ec_switch_to_poll_mode(ec);
>> :                goto end;
>> :        }
>> :
>> : Now I don't know if this will work for other brands, but for
>> : me(Macbook Pro ATI chipset) I have not received the
>> : GPE storm detected, disabling EC GPE message, but it's only been an
>> : hour, maybe after two or three this might appear.
>> : Also is this good or bad to set 5 to 20 for the system?
>>
>> Could someone from acpi land please help here?
>>
>> Justin, has this machine always had this problem or is it something
>> which earlier kernels handled correctly?
>>
>> Thanks.
>>
> 
> This issue just recently started, 2.6.25-rc9 and below don't give me
> this message.
> 
Yes, the problem which we are fighting here is that almost all Acer notebooks come with
broken EC. It sends interrupts not regarding the fact that we already ACKed it.
It comes unnoticed on almost all machines (some notice laggy keyboard, because it's 
the same controller after all and it's busy with sending ACPI interrupts and then 
providing same status byte over and over), but on some machines keystrokes become 
missing, which is not tolerable (#9998).
Acer technical support does not care about the issue as they don't support Linux on these machines,
and Windows seems to be fine.
There is a similar bug report #10724, with two suggested patches, which should increase a threshold of 
stray interrupts before we shutdown them and switch to poll mode.

Regards,
Alex.







