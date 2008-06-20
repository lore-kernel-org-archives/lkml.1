Return-Path: <linux-kernel-owner+w=401wt.eu-S933734AbYFTUsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933734AbYFTUsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932411AbYFTUlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:41:07 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:54446 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757910AbYFTUlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:41:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QWYt20Me1HuwYx5FYWlDINRuwM2r5WuoZyrMlEAL49JtkH1FCch/dlJDM/fH7NE+q5
         pb0y8TOZqY5ssb8/B48z85aYlZhCr6kXX7NJ0Q87rj2gb7ZVtXOVoDeHxQsy8mK3Ax3j
         qkMydZcnpd9Owm/toiHM9qwUM8Dg+4CD+WSJk=
Message-ID: <19f34abd0806201340t502ce471n578dd2498a5f1992@mail.gmail.com>
Date: Fri, 20 Jun 2008 22:40:55 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Len Brown" <lenb@kernel.org>
Subject: Re: [PATCH] ACPI: don't walk tables if ACPI was disabled
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, "Zhao Yakui" <yakui.zhao@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>
In-Reply-To: <alpine.LFD.1.10.0806201458500.3027@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080620135639.GA5073@damson.getinternet.no>
	 <alpine.LFD.1.10.0806201458500.3027@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2008 at 9:00 PM, Len Brown <lenb@kernel.org> wrote:
>> @@ -333,6 +333,9 @@ static int __init acpi_rtc_init(void)
>>  {
>>       struct device *dev = get_rtc_dev();
>>
>> +     if (acpi_disabled)
>> +             return 0;
>> +
>
> hmm, i would expect dev to be 0 for acpi=off,
> since pnp_match would fail, no?

Obviously not. Because Ingo is booting with acpi=off and he still gets
a warning about some mutex operation that originates from this very
initcall:

[    3.976213] calling  acpi_rtc_init+0x0/0xd3
[    3.980213] ACPI Exception (utmutex-0263): AE_BAD_PARAMETER, Thread
F7C50000 could not acquire Mutex [3] [20080321]


This function seems to do the discovery of the rtc device:

static int __init pnpacpi_init(void)
{
        if (acpi_disabled || pnpacpi_disabled) {
                pnp_info("PnP ACPI: disabled");
                return 0;
        }

...
subsys_initcall(pnpacpi_init);


So we have these functions:

1. acpi_early_init() - happens before any initcall. This would
initialize mutexes, but simply returns if acpi_disabled.

2. pnpacpi_init() - subsys_initcall. Does the initial discovery of
pnpacpi devices, but simply returns if acpi_disabled.

3. acpi_init() - subsys_initcall. Simply returns if acpi_disabled.

4. acpi_rtc_init() - fs_initcall (after subsys_initcall).

So I don't know. We also know that things like dock_init() are wrong
for sure (with attached patch):

------------[ cut here ]------------
WARNING: at drivers/acpi/osl.c:821 acpi_os_wait_semaphore+0x21/0xf0()
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.26-rc6-00161-g952f4a0-dirty #20
...
 [<c0222762>] acpi_os_wait_semaphore+0x21/0xf0
 [<c023ce2a>] acpi_ut_acquire_mutex+0x5e/0xc4
 [<c0233778>] acpi_walk_namespace+0x24/0x60
 [<c05d005f>] dock_init+0x0/0x48
 [<c05d008f>] dock_init+0x30/0x48
 [<c0242eb3>] find_dock+0x0/0x2f0
 [<c05bb422>] kernel_init+0x120/0x254
...
ACPI Exception (utmutex-0263): AE_BAD_PARAMETER, Thread C7820000 could
not acquire Mutex [1] [20080321]

I guess Ingo should revert my bogus changes to acpi_rtc_init() and use
your suggestion of a BUG() (or maybe just WARN()) to catch the
backtrace so we can figure out how it gets there when acpi_disabled.

The only thing I can think of now is that pnp_match() is doing
something wrong. It returns 1 when it shouldn't, or something. But I
can't really spot it :-(


Vegard


diff --git a/drivers/acpi/namespace/nsxfeval.c b/drivers/acpi/namespace/nsxfeval
index a8d5491..7c444de 100644
--- a/drivers/acpi/namespace/nsxfeval.c
+++ b/drivers/acpi/namespace/nsxfeval.c
@@ -556,6 +556,8 @@ acpi_get_devices(const char *HID,

        ACPI_FUNCTION_TRACE(acpi_get_devices);

+       WARN_ON(acpi_disabled);
+
        /* Parameter validation */

        if (!user_function) {
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 235a138..ca661e7 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -818,6 +818,8 @@ acpi_status acpi_os_wait_semaphore(acpi_handle handle, u32 u
        long jiffies;
        int ret = 0;

+       WARN_ON(acpi_disabled);
+
        if (!sem || (units < 1))
                return AE_BAD_PARAMETER;
