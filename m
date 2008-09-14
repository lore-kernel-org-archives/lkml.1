Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbYINHa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbYINHa3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 03:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYINHaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 03:30:19 -0400
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:58611 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbYINHaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 03:30:17 -0400
Message-ID: <48CCBD83.1030001@freemail.hu>
Date: Sun, 14 Sep 2008 09:30:11 +0200
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Helge Deller <deller@gmx.de>
CC: linux-input@vger.kernel.org
Subject: Re: __initdata and struct dmi_system_id?
References: <48C0C786.5020809@freemail.hu>
In-Reply-To: <48C0C786.5020809@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail02d.mail.t-online.hu 32721; Body=3 Fuz1=3
	Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Helge Deller wrote:
>Márton Németh wrote:
>> Hi,
>> 
>> I have a question about how the __initdata sections are handled
>> under Linux. As far as I understand after the init function is
>> finished all the data from the __initdata section is freed. For
>> this reason all the data which are marked as __initdata should
>> be separated to a different section by the compiler.
>> 
>> I take for example the drivers/input/keyboards/atkbd.c where we
>> can see the following dmi_system_id structure:
>> 
>> static struct dmi_system_id atkbd_dmi_quirk_table[] __initdata = {
>>         {
>>                 .ident = "Dell Latitude series",
>>                 .matches = {
>>                         DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
>>                         DMI_MATCH(DMI_PRODUCT_NAME, "Latitude"),
>>                 },
>>                 .callback = atkbd_setup_fixup,
>>                 .driver_data = atkbd_latitude_keymap_fixup,
>>         },
>>         {
>>                 .ident = "HP 2133",
>>                 .matches = {
>>                         DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
>>                         DMI_MATCH(DMI_PRODUCT_NAME, "HP 2133"),
>>                 },
>>                 .callback = atkbd_setup_fixup,
>>                 .driver_data = atkbd_hp_keymap_fixup,
>>         },
>>         { }
>> };
>> 
>> All these data should be separated to the section marked
>> with __initdata, so it can be freed. Let's see what happens
>> after compiling this with gcc 4.2.4. Here is the some part
>> of the output of "objdump -s drivers/input/keyboards/atkbd.o":
>> 
>> Contents of section .init.text:
>>  0000 558b4028 89e55da3 20000000 31c0c390  U.@(..]. ...1...
>>  0010 55b80000 000089e5 e8fcffff ffb95000  U.............P.
>>  0020 000031d2 b8200000 00e8fcff ffff5dc3  ..1.. ........].
>> Contents of section .rodata.str1.1:
>>  0000 256c750a 0025640a 00415420 53657420  %lu..%d..AT Set
>>  0010 32204578 74726120 6b657962 6f617264  2 Extra keyboard
>>  0020 00547261 6e736c61 74656400 52617700  .Translated.Raw.
>>  0030 41542025 73205365 74202564 206b6579  AT %s Set %d key
>>  0040 626f6172 64002573 2f696e70 75743000  board.%s/input0.
>>  0050 61746b62 64002628 2661746b 62642d3e  atkbd.&(&atkbd->
>>  0060 6576656e 745f776f 726b292d 3e776f72  event_work)->wor
>>  0070 6b002661 746b6264 2d3e6576 656e745f  k.&atkbd->event_
>>  0080 6d757465 78004143 4b004e41 4b007472  mutex.ACK.NAK.tr
>>  0090 616e736c 61746564 00726177 0072656c  anslated.raw.rel
>>  00a0 65617365 64007072 65737365 64006530  eased.pressed.e0
>>  00b0 00004465 6c6c204c 61746974 75646520  ..Dell Latitude
>>  00c0 73657269 65730044 656c6c20 496e632e  series.Dell Inc.
>>  00d0 004c6174 69747564 65004850 20323133  .Latitude.HP 213
>>  00e0 33004865 776c6574 742d5061 636b6172  3.Hewlett-Packar
>>  00f0 64004154 20616e64 2050532f 32206b65  d.AT and PS/2 ke
>>  0100 79626f61 72642064 72697665 72006578  yboard driver.ex
>>  0110 74726100 7363726f 6c6c0073 65740073  tra.scroll.set.s
>>  0120 6f667472 65706561 7400736f 66747261  oftrepeat.softra
>>  0130 77006572 725f636f 756e7400           w.err_count.
>> 
>> What I can see here is that some of the atkbd_dmi_quirk_table[]
>> content was stored into .init.text, but the strings like
>> "Dell Latitude series", "Dell Inc.", "Latitude", etc. were
>> combined to .rodata.str1.1 which also contain strings which
>> are NOT marked with __initdata. For example the string
>> "AT Set 2 Extra keyboard" is used in atkbd_set_device_attrs()
>> function thus the section .rodata.str1.1 cannot be freed after
>> the init is done.
>> 
>> Did I understand the situation correctly?
>
> Yes, you did.
>
>> How is it possible to also allocate the strings which
>> belongs to struct dmi_system_id go to the section .init.text?
>
> Easiest and cleanest way for the dmi_system_id arrays is probably the
> attached patch.
>
> There are two downsides though:
> 1. It makes the inital kernel image bigger than needed (even if the memory
> itself is freed later)
> 2. We have to make sure, that the string lengths fit into the given array
> limits (else you get the compiler warning "initializer-string for array of
> chars is too long")
>
> I haven't tested how much memory this really saves.

I wonder why there is a difference when declaring a string as char[] instead
of char*. So I created a bug report against gcc:
http://gcc.gnu.org/bugzilla/show_bug.cgi?id=37506

I guess the memory saving depend on several things, such as:
 - is there anyithing else in the section
 - the minimum memory length which can be allocated/freed

The other interesting question on this topic is that what about the
error message strings which are used as parameter of the printk() calls.
Those strings are combined together for a function which is marked with
__init and the functions which are normal functions. The strings which
are only used by the functions marked with __init could be freed, but
the strings of the normal functions shouldn't be.

Regards,

	Márton Németh

PS.: please also CC me
