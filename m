Return-Path: <linux-kernel-owner+w=401wt.eu-S1759577AbYJJN0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577AbYJJN0y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 09:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756503AbYJJN0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 09:26:45 -0400
Received: from web38204.mail.mud.yahoo.com ([209.191.124.147]:23493 "HELO
	web38204.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756444AbYJJN0o convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 09:26:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=giZN5y/Jj11O6DA+J9UQK7WDm2hnLS+qlvxS1w51PEiPpcBqFD3HgZmkK4aTBXCnHduv7tvEfQYEMIQvjBliSyw/HR7/2m7Xr2wvExAujJJWyYpBXW3gqbZj7MbUyAOkPjWHadiowL2XVxVF3nO0wWFRjJDimBszONh/vjAQP0I=;
X-YMail-OSG: wdhz6u8VM1n0xiNHx7F4dA5AMV7V0PUyW6yVuZo8vYPLst0YRM5KRniESa9OAippxw--
X-Mailer: YahooMailRC/1096.40 YahooMailWebService/0.7.218.2
Date: Fri, 10 Oct 2008 06:26:43 -0700 (PDT)
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [PATCH] drm: fix leak of uninitialized data to userspace (acpi_system_read_event)
To: Ingo Molnar <mingo@elte.hu>, Vegard Nossum <vegardno@ifi.uio.no>
Cc: Dave Airlie <airlied@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <126003.45052.qm@web38204.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Ingo Molnar <mingo@elte.hu>

> 
> * Vegard Nossum wrote:
>
> > ...so it seems that dev->unique is never updated to reflect the
> > actual length of the string. The remaining bytes (20 in this case)
> > are random uninitialized bytes that are copied into userspace.
> > 
> > This patch fixes the problem by setting dev->unique_len after the
> > snprintf().
> > 
> > Completely untested.
> > 
> > Reported-by: Sitsofe Wheeler 
> > Signed-off-by: Vegard Nossum 
> 
> i've stuck it into the tip/out-of-tree quick-fixes branch.
> 
> Sitsofe, could you please check very latest tip/master with 
> CONFIG_KMEMCHECK=y, does it find any other uninitialized memory access?

No other uninitialized memory access so far (although having kmemcheck on does seem to provoke rcu stall warnings)...

...I take it back. This just turned up:
[  992.417019] WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (f2363d14)
[  992.417033] 000110000002200061635f61646170746572000000000000cc2c030041433000
[  992.417077]  i i i i i i i i i i i i i i i i i i i u u u u u u u u u i i i i
[  992.417117]                                          ^
[  992.417121] 
[  992.417127] Pid: 1893, comm: acpid Not tainted (2.6.27-tipskw-00088-g9f41241-dirty #84) 900
[  992.417134] EIP: 0060:[<c025fbdd>] EFLAGS: 00000286 CPU: 0
[  992.417147] EIP is at acpi_bus_receive_event+0xd6/0x109
[  992.417153] EAX: 00054489 EBX: f2363d00 ECX: 00000006 EDX: ffffffed
[  992.417158] ESI: f2363d14 EDI: f6057f28 EBP: f6057f08 ESP: c0566d68
[  992.417164]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  992.417169] CR0: 8005003b CR2: f6671034 CR3: 360ea000 CR4: 000006c0
[  992.417175] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  992.417180] DR6: ffff4ff0 DR7: 00000400
[  992.417184]  [<c026b86f>] acpi_system_read_event+0x49/0xc5
[  992.417195]  [<c01b2381>] proc_reg_read+0x61/0x90
[  992.417206]  [<c017efb5>] vfs_read+0x95/0x120
[  992.417215]  [<c017f5f2>] sys_read+0x42/0x70
[  992.417222]  [<c010336d>] sysenter_do_call+0x12/0x35
[  992.417230]  [<ffffffff>] 0xffffffff


      
