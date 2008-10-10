Return-Path: <linux-kernel-owner+w=401wt.eu-S1761115AbYJJP1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761115AbYJJP1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 11:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760843AbYJJP07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 11:26:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:7618 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760795AbYJJP05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 11:26:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eYDGayQ0Z3rfZ6glcBP3YSt7SHXvmPwPBwX1nFW5c+9OegBuJ4Wy/FVOnrdW5OgS3+
         K7WBZxZcSdtUnP1GxuHWBQ8y73v6y4SXYNMA8SYWiUxQxPBSuq+LjWDhKUHIxucC4gXs
         soXdNTVZjmbwAxAubP3U/yVmo//BN4ieJoSXI=
Message-ID: <19f34abd0810100826m4c075552yd7031d2cbbe54966@mail.gmail.com>
Date: Fri, 10 Oct 2008 17:26:56 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] drm: fix leak of uninitialized data to userspace (acpi_system_read_event)
Cc: "Sitsofe Wheeler" <sitsofe@yahoo.com>,
       "Vegard Nossum" <vegardno@ifi.uio.no>,
       "Dave Airlie" <airlied@redhat.com>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
In-Reply-To: <20081010143707.GC21104@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <126003.45052.qm@web38204.mail.mud.yahoo.com>
	 <20081010143707.GC21104@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 4:37 PM, Ingo Molnar <mingo@elte.hu> wrote:
> * Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
>> > Sitsofe, could you please check very latest tip/master with
>> > CONFIG_KMEMCHECK=y, does it find any other uninitialized memory access?
>>
>> No other uninitialized memory access so far (although having kmemcheck on does seem to provoke rcu stall warnings)...

Does that also mean that the DRM patch fixed the first one? :-)

>>
>> ...I take it back. This just turned up:
>> [  992.417019] WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (f2363d14)
>> [  992.417033] 000110000002200061635f61646170746572000000000000cc2c030041433000
>> [  992.417077]  i i i i i i i i i i i i i i i i i i i u u u u u u u u u i i i i
>> [  992.417117]                                          ^
>> [  992.417121]
>> [  992.417127] Pid: 1893, comm: acpid Not tainted (2.6.27-tipskw-00088-g9f41241-dirty #84) 900
>> [  992.417134] EIP: 0060:[<c025fbdd>] EFLAGS: 00000286 CPU: 0
>> [  992.417147] EIP is at acpi_bus_receive_event+0xd6/0x109
>> [  992.417153] EAX: 00054489 EBX: f2363d00 ECX: 00000006 EDX: ffffffed
>> [  992.417158] ESI: f2363d14 EDI: f6057f28 EBP: f6057f08 ESP: c0566d68
>> [  992.417164]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
>> [  992.417169] CR0: 8005003b CR2: f6671034 CR3: 360ea000 CR4: 000006c0
>> [  992.417175] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
>> [  992.417180] DR6: ffff4ff0 DR7: 00000400
>> [  992.417184]  [<c026b86f>] acpi_system_read_event+0x49/0xc5
>> [  992.417195]  [<c01b2381>] proc_reg_read+0x61/0x90
>> [  992.417206]  [<c017efb5>] vfs_read+0x95/0x120
>> [  992.417215]  [<c017f5f2>] sys_read+0x42/0x70
>> [  992.417222]  [<c010336d>] sysenter_do_call+0x12/0x35
>> [  992.417230]  [<ffffffff>] 0xffffffff
>
> this too could be a real bug i think, uncovered by kmemcheck. Vegard?

No, it looks OK.

acpi_bus_receive_event() gets an entry off the acpi_bus_event_list and
copies it to the "struct acpi_bus_event event;" found in
acpi_system_read_event. So it's a dynamic-memory-to-stack copy.

It is added to the list in acpi_bus_generate_proc_event4(), which also
allocates the event and copies some strings into it:

        strcpy(event->device_class, device_class);
        strcpy(event->bus_id, bus_id);

And these are defined as character arrays:

    typedef char acpi_device_class[20];
    typedef char acpi_bus_id[5];
...
    struct acpi_bus_event {
            struct list_head node;
            acpi_device_class device_class;
            acpi_bus_id bus_id;

It would be cool to be track the stack as well (can we tell #PF to
switch stacks?). Or maybe allow memcpy() of anything to stack, that
shouldn't be too hard. Again, it's a balance. Allowing too much in
general will throw the child out with the bathwater. Maybe the easiest
solution for now is to annotate them. We can do it with the bitfields
API in two lines of code extra.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
